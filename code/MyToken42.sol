// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MyToken42
 * @dev Token BEP-20 simple avec fonctionnalités de base
 * 
 * Ce contrat implémente un token avec :
 * - 42 millions de tokens créés dans le constructeur
 * - Fonctionnalité de burn (destruction de tokens)
 * - Gestion du propriétaire avec Ownable
 * - Système de pause pour la sécurité
 * - Système multisignature simple pour les actions critiques (bonus)
 * 
 * @notice Déployé sur BNB Testnet
 */

// Imports OpenZeppelin
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";

/**
 * @dev Contrat principal MyToken42
 * 
 * Hérite de :
 * - ERC20 : Fonctions standards du token (transfer, approve, etc.)
 * - ERC20Burnable : Permet de brûler des tokens
 * - Ownable : Gestion du propriétaire du contrat
 * - ERC20Pausable : Permet de mettre le contrat en pause (pause automatique des fonctions ERC20)
 */
contract MyToken42 is ERC20, ERC20Burnable, Ownable, ERC20Pausable {
    
    // ============ Variables d'état ============
    
    /**
     * @dev Supply maximale de tokens (42 millions)
     */
    uint256 public constant MAX_SUPPLY = 42_000_000 * 10**18;
    
    /**
     * @dev Nombre minimum de confirmations requises pour exécuter une transaction multisig
     */
    uint256 public requiredConfirmations;
    
    /**
     * @dev Liste des signataires autorisés pour le système multisignature
     */
    mapping(address => bool) public isSigner;
    
    /**
     * @dev Structure pour stocker les transactions proposées dans le multisig
     */
    struct Transaction {
        address to;           // Adresse destinataire
        uint256 amount;       // Montant de tokens
        bool executed;        // Si la transaction a été exécutée
        uint256 confirmations; // Nombre de confirmations reçues
    }
    
    /**
     * @dev Tableau des transactions proposées
     */
    Transaction[] public transactions;
    
    /**
     * @dev Mapping pour suivre quels signataires ont confirmé quelles transactions
     * transactionIndex => signer => confirmed
     */
    mapping(uint256 => mapping(address => bool)) public confirmations;
    
    // ============ Événements ============
    
    /**
     * @dev Émis lorsqu'un nouveau signataire est ajouté
     */
    event SignerAdded(address indexed signer);
    
    /**
     * @dev Émis lorsqu'un signataire est retiré
     */
    event SignerRemoved(address indexed signer);
    
    /**
     * @dev Émis lorsqu'une transaction est proposée
     */
    event TransactionSubmitted(uint256 indexed txIndex, address indexed to, uint256 amount);
    
    /**
     * @dev Émis lorsqu'une transaction est confirmée
     */
    event TransactionConfirmed(uint256 indexed txIndex, address indexed signer);
    
    /**
     * @dev Émis lorsqu'une transaction est exécutée
     */
    event TransactionExecuted(uint256 indexed txIndex);
    
    // ============ Modificateurs ============
    
    /**
     * @dev Vérifie que l'appelant est un signataire autorisé
     */
    modifier onlySigner() {
        require(isSigner[msg.sender], "MyToken42: caller is not a signer");
        _;
    }
    
    /**
     * @dev Vérifie qu'une transaction existe
     */
    modifier txExists(uint256 _txIndex) {
        require(_txIndex < transactions.length, "MyToken42: transaction does not exist");
        _;
    }
    
    /**
     * @dev Vérifie qu'une transaction n'a pas déjà été exécutée
     */
    modifier notExecuted(uint256 _txIndex) {
        require(!transactions[_txIndex].executed, "MyToken42: transaction already executed");
        _;
    }
    
    /**
     * @dev Vérifie qu'une transaction n'a pas déjà été confirmée par ce signataire
     */
    modifier notConfirmed(uint256 _txIndex) {
        require(!confirmations[_txIndex][msg.sender], "MyToken42: transaction already confirmed");
        _;
    }
    
    // ============ Constructeur ============
    
    /**
     * @dev Constructeur du contrat
     * 
     * Crée 42 millions de tokens et les attribue au déployeur (owner)
     * Le propriétaire peut ensuite transférer ces tokens à d'autres wallets
     * 
     * @param _requiredConfirmations Nombre de confirmations requises pour le multisig (minimum 1)
     */
    constructor(uint256 _requiredConfirmations) 
        ERC20("MyToken42", "MTK42") 
        Ownable(msg.sender)
    {
        require(_requiredConfirmations > 0, "MyToken42: required confirmations must be > 0");
        
        // Créer 42 millions de tokens et les attribuer au propriétaire (déployeur)
        _mint(msg.sender, MAX_SUPPLY);
        
        // Configurer le système multisignature
        requiredConfirmations = _requiredConfirmations;
        isSigner[msg.sender] = true;
        
        emit SignerAdded(msg.sender);
    }
    
    // ============ Fonctions de gestion (Owner uniquement) ============
    
    /**
     * @dev Met le contrat en pause
     * 
     * Suspend toutes les opérations de transfert, approve, transferFrom et burn
     * Utile en cas de vulnérabilité détectée ou de maintenance
     */
    function pause() public onlyOwner {
        _pause();
    }
    
    /**
     * @dev Réactive le contrat après une pause
     */
    function unpause() public onlyOwner {
        _unpause();
    }
    
    // ============ Fonctions multisignature (Bonus) ============
    
    /**
     * @dev Ajoute un nouveau signataire au système multisignature
     * 
     * @param signer Adresse du nouveau signataire
     */
    function addSigner(address signer) public onlyOwner {
        require(signer != address(0), "MyToken42: invalid signer address");
        require(!isSigner[signer], "MyToken42: signer already exists");
        
        isSigner[signer] = true;
        emit SignerAdded(signer);
    }
    
    /**
     * @dev Retire un signataire du système multisignature
     * 
     * @param signer Adresse du signataire à retirer
     */
    function removeSigner(address signer) public onlyOwner {
        require(isSigner[signer], "MyToken42: signer does not exist");
        
        isSigner[signer] = false;
        emit SignerRemoved(signer);
    }
    
    /**
     * @dev Modifie le nombre de confirmations requises
     * 
     * @param _requiredConfirmations Nouveau nombre de confirmations requises
     */
    function setRequiredConfirmations(uint256 _requiredConfirmations) public onlyOwner {
        require(_requiredConfirmations > 0, "MyToken42: required confirmations must be > 0");
        requiredConfirmations = _requiredConfirmations;
    }
    
    /**
     * @dev Propose une nouvelle transaction à valider par le multisig
     * 
     * @param to Adresse destinataire
     * @param amount Montant concerné
     * @return txIndex Index de la transaction créée
     */
    function submitTransaction(address to, uint256 amount) 
        public 
        onlySigner 
        returns (uint256) 
    {
        require(to != address(0), "MyToken42: invalid destination address");
        require(amount > 0, "MyToken42: amount must be > 0");
        
        uint256 txIndex = transactions.length;
        
        transactions.push(Transaction({
            to: to,
            amount: amount,
            executed: false,
            confirmations: 0
        }));
        
        emit TransactionSubmitted(txIndex, to, amount);
        
        // Auto-confirmer la transaction par le proposant
        confirmTransaction(txIndex);
        
        return txIndex;
    }
    
    /**
     * @dev Confirme une transaction proposée
     * 
     * @param txIndex Index de la transaction à confirmer
     */
    function confirmTransaction(uint256 txIndex) 
        public 
        onlySigner 
        txExists(txIndex) 
        notExecuted(txIndex) 
        notConfirmed(txIndex) 
    {
        confirmations[txIndex][msg.sender] = true;
        transactions[txIndex].confirmations++;
        
        emit TransactionConfirmed(txIndex, msg.sender);
    }
    
    /**
     * @dev Exécute une transaction une fois qu'elle a reçu suffisamment de confirmations
     * 
     * @param txIndex Index de la transaction à exécuter
     */
    function executeTransaction(uint256 txIndex) 
        public 
        onlySigner 
        txExists(txIndex) 
        notExecuted(txIndex) 
    {
        Transaction storage transaction = transactions[txIndex];
        
        require(
            transaction.confirmations >= requiredConfirmations,
            "MyToken42: not enough confirmations"
        );
        
        transaction.executed = true;
        
        // Exécuter le transfert via multisig
        _transfer(owner(), transaction.to, transaction.amount);
        
        emit TransactionExecuted(txIndex);
    }
    
    // ============ Fonctions de lecture ============
    
    /**
     * @dev Retourne le nombre total de transactions proposées
     * 
     * @return count Nombre de transactions
     */
    function getTransactionCount() public view returns (uint256) {
        return transactions.length;
    }
    
    /**
     * @dev Retourne les détails d'une transaction
     * 
     * @param txIndex Index de la transaction
     * @return to Adresse destinataire
     * @return amount Montant
     * @return executed Si la transaction a été exécutée
     * @return confirmations Nombre de confirmations
     */
    function getTransaction(uint256 txIndex) 
        public 
        view 
        returns (
            address to,
            uint256 amount,
            bool executed,
            uint256 confirmations
        ) 
    {
        require(txIndex < transactions.length, "MyToken42: transaction does not exist");
        
        Transaction storage transaction = transactions[txIndex];
        return (
            transaction.to,
            transaction.amount,
            transaction.executed,
            transaction.confirmations
        );
    }
    
    /**
     * @dev Vérifie si un signataire a confirmé une transaction
     * 
     * @param txIndex Index de la transaction
     * @param signer Adresse du signataire
     * @return confirmed true si le signataire a confirmé
     */
    function isConfirmed(uint256 txIndex, address signer) 
        public 
        view 
        returns (bool) 
    {
        return confirmations[txIndex][signer];
    }
}

