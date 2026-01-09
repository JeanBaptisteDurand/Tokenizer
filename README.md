# MyToken42 (MTK42)

## Description

**MyToken42** est un token compatible avec le standard BEP-20, déployé sur le **BNB Testnet**. Ce projet a été développé en utilisant **Solidity**, la bibliothèque **OpenZeppelin**, et déployé via **Remix**. Le projet inclut des fonctionnalités standards des tokens BEP-20 ainsi que des améliorations telles que le mint, le burn, et un système multisignature pour les actions critiques.

## Imports OpenZeppelin

Le contrat utilise les 4 bibliothèques suivantes d'OpenZeppelin :

1. **`@openzeppelin/contracts/token/ERC20/ERC20.sol`** - Contrat de base ERC-20/BEP-20
2. **`@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol`** - Extension pour brûler des tokens
3. **`@openzeppelin/contracts/access/Ownable.sol`** - Gestion du propriétaire du contrat
4. **`@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol`** - Extension pour mettre le contrat en pause (pause automatique des fonctions ERC20)

---

## Fonctionnalités principales

| **Nom de la fonction**               | **Import OpenZeppelin** | **Description**                                                                                   |
|--------------------------------------|-------------------------|---------------------------------------------------------------------------------------------------|
| **totalSupply()**                    | ERC20                   | Retourne l'offre totale de tokens.                                                              |
| **balanceOf(address account)**       | ERC20                   | Retourne la balance de tokens d'une adresse donnée.                                              |
| **transfer(address recipient, uint256 amount)** | ERC20       | Permet de transférer des tokens d'une adresse à une autre.                                       |
| **approve(address spender, uint256 amount)**   | ERC20       | Autorise une adresse à dépenser un montant spécifique de tokens au nom du propriétaire.          |
| **allowance(address owner, address spender)**  | ERC20       | Retourne le montant que `spender` est autorisé à dépenser au nom de `owner`.                     |
| **transferFrom(address sender, address recipient, uint256 amount)** | ERC20 | Permet de transférer des tokens via une adresse autorisée.                                       |
| **_transfer(address sender, address recipient, uint256 amount)** | ERC20 (Interne) | Transfert interne utilisé par `transfer` et `transferFrom`.                                      |
| **_approve(address owner, address spender, uint256 amount)** | ERC20 (Interne) | Gestion interne des autorisations via `approve`.                                                 |
| **burn(uint256 amount)** | ERC20Burnable       | Détruit une quantité de tokens appartenant à l'appelant.                             |
| **burnFrom(address account, uint256 amount)** | ERC20Burnable       | Détruit une quantité spécifique de tokens appartenant à une adresse (avec autorisation).                             |
| **owner()** | Ownable       | Retourne l'adresse du propriétaire du contrat.                                           |
| **pause()** | ERC20Pausable       | Met le contrat en pause, suspendant toutes les opérations ERC20 (owner uniquement).                                           |
| **unpause()** | ERC20Pausable       | Réactive le contrat après une pause (owner uniquement).                                           |
| **submitTransaction(address to, uint256 amount)** | Bonus (Custom)              | Propose une transaction à valider par un système multisignature avant exécution.                 |
| **confirmTransaction(uint256 txIndex)**        | Bonus (Custom)              | Ajoute une confirmation d'un signataire pour atteindre le seuil requis dans le multisignature.   |
| **executeTransaction(uint256 txIndex)**        | Bonus (Custom)              | Exécute une transaction validée par le nombre requis de signataires dans le système multisignature. |

---

## Instructions de déploiement

### 1. Pré-requis
- **Wallet** : Configurez [Metamask](https://metamask.io/) pour le réseau **BNB Testnet** :
  - RPC URL : `https://data-seed-prebsc-1-s1.binance.org:8545/`
  - ID de chaîne : `97`.
- **Faucet TBNB** : Obtenez des tokens de test (TBNB) via le [BNB Testnet Faucet](https://testnet.binance.org/faucet-smart).

### 2. Développement
- **IDE** : Utilisez [Remix IDE](https://remix.ethereum.org/).
- **Bibliothèque** : Le contrat utilise **OpenZeppelin** pour garantir la conformité avec les standards BEP-20.

### 3. Déploiement
1. Ouvrez le fichier `MyToken42.sol` dans Remix.
2. Sélectionnez le compilateur Solidity (version `0.8.x`).
3. Connectez Metamask au réseau **BNB Testnet** via `Injected Web3`.
4. Déployez le contrat en fournissant le paramètre `_requiredConfirmations` (ex. : `1` pour le multisig).

### 4. Publication
1. Copiez l'adresse du contrat déployé depuis Remix.
2. Ajoutez le contrat sur [BscScan Testnet](https://testnet.bscscan.com/).
3. Vérifiez et publiez le code source du contrat via l'option **"Verify and Publish"**.

---

## Informations du contrat

- **Nom du token** : MyToken42
- **Ticker** : MTK42
- **Supply Initiale** : 42 000 000 (créés dans le constructeur)
- **Supply Max** : 42 000 000
- **Adresse du contrat** : `[à remplir après déploiement]`
- **Réseau** : BNB Testnet
- **Explorateur Blockchain** : [BscScan Testnet](https://testnet.bscscan.com)

---

## Bonus : Multisignature

Le contrat intègre un système de multisignature pour sécuriser les transactions sensibles (ex. : minting). Une transaction doit être confirmée par un certain nombre de signataires avant exécution.

- **Proposer une transaction** : `submitTransaction(address to, uint256 amount)`
- **Confirmer une transaction** : `confirmTransaction(uint256 txIndex)`
- **Exécuter une transaction** : `executeTransaction(uint256 txIndex)`

---

## Structure du projet

```
.
├── README.md                       # Documentation principale du projet
├── code/                           # Contient le code source du contrat
│   └── MyToken42.sol               # Contrat Solidity pour le token MyToken42
├── deployment/                     # Contient les instructions pour le déploiement
│   └── instructions.md             # Guide pour déployer le contrat sur le testnet
└── documentation/                  # Documentation complémentaire
    ├── architecture.md             # Détails sur l'architecture et les fonctionnalités
    └── fonctionnalités.md          # Explications des fonctionnalités implémentées
```

---

## Notes supplémentaires

1. Ce projet est déployé uniquement sur le **BNB Testnet** pour des raisons de tests et de développement.
2. Aucun argent réel n'est utilisé pour ce projet. Utilisez uniquement des tokens de test.
3. Pour toute question ou aide, n'hésitez pas à demander !