# Instructions de déploiement - MyToken42

Ce guide détaille les étapes pour déployer le contrat MyToken42 sur le BNB Testnet via Remix IDE.

---

## Prérequis

### 1. Configuration de MetaMask

1. **Installer MetaMask** : Téléchargez l'extension [MetaMask](https://metamask.io/) pour votre navigateur.

2. **Ajouter le réseau BNB Testnet** :
   - Ouvrez MetaMask
   - Cliquez sur le menu réseau (en haut)
   - Sélectionnez "Ajouter un réseau" ou "Add Network"
   - Remplissez les informations suivantes :
     - **Nom du réseau** : `BNB Smart Chain Testnet`
     - **RPC URL** : `https://data-seed-prebsc-1-s1.binance.org:8545/`
     - **ID de chaîne** : `97`
     - **Symbole de la devise** : `tBNB`
     - **URL de l'explorateur de blocs** : `https://testnet.bscscan.com`

3. **Obtenir des tBNB (tokens de test)** :
   - Visitez le [BNB Testnet Faucet](https://testnet.binance.org/faucet-smart)
   - Connectez votre wallet MetaMask
   - Demandez des tBNB (gratuit, pour les tests uniquement)
   - Attendez quelques secondes pour recevoir les tokens

---

## Déploiement via Remix IDE

### Étape 1 : Accéder à Remix

1. Ouvrez votre navigateur et allez sur [Remix IDE](https://remix.ethereum.org/)
2. Remix s'ouvre directement dans votre navigateur (pas besoin d'installation)

### Étape 2 : Importer le contrat

1. Dans le panneau de gauche (File Explorer), créez un nouveau dossier `contracts` si nécessaire
2. Créez un nouveau fichier `MyToken42.sol` dans le dossier `contracts`
3. Copiez-collez le code de votre contrat depuis le dossier `code/` de votre projet local

**Note** : Si vous utilisez OpenZeppelin, vous devez également importer les contrats OpenZeppelin :

#### Option A : Utiliser le gestionnaire de plugins Remix (Recommandé)

1. Dans Remix, allez dans l'onglet "Plugin Manager" (icône en bas à gauche)
2. Recherchez et installez le plugin "OpenZeppelin"
3. Les contrats OpenZeppelin seront automatiquement disponibles

#### Option B : Importer manuellement via GitHub

1. Dans Remix, créez un dossier `@openzeppelin` dans `contracts/`
2. Utilisez l'URL GitHub d'OpenZeppelin pour importer les fichiers nécessaires :
   - Exemple : `https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/token/ERC20/ERC20.sol`
   - Dans Remix, faites clic droit sur le dossier → "Import from GitHub"
   - Collez l'URL et importez

#### Option C : Utiliser npm (si vous avez un projet local)

Si vous travaillez en local avec Hardhat/Truffle, vous pouvez utiliser :
```bash
npm install @openzeppelin/contracts
```

Puis dans Remix, importez depuis votre système de fichiers local.

### Étape 3 : Compiler le contrat

1. Allez dans l'onglet **"Solidity Compiler"** (icône en bas à gauche)
2. Sélectionnez la version du compilateur Solidity correspondant à votre contrat (ex: `0.8.20` ou `0.8.x`)
3. Vérifiez que le contrat `MyToken42.sol` est sélectionné dans le menu déroulant
4. Cliquez sur **"Compile MyToken42.sol"**
5. Vérifiez qu'il n'y a pas d'erreurs de compilation (icône verte avec ✓)

**En cas d'erreur** :
- Vérifiez que tous les imports OpenZeppelin sont corrects
- Vérifiez la version de Solidity dans le `pragma`
- Vérifiez que tous les fichiers nécessaires sont présents

### Étape 4 : Configurer l'environnement de déploiement

1. Allez dans l'onglet **"Deploy & Run Transactions"** (icône en bas à gauche)
2. Dans la section **"Environment"**, sélectionnez **"Injected Provider - MetaMask"**
   - Cela connectera Remix à votre wallet MetaMask
3. MetaMask s'ouvrira automatiquement pour vous demander de connecter votre compte
4. **Important** : Vérifiez que MetaMask est configuré sur le réseau **"BNB Smart Chain Testnet"** (Chain ID: 97)
   - Si ce n'est pas le cas, changez de réseau dans MetaMask avant de continuer

### Étape 5 : Déployer le contrat

1. Dans la section **"Deploy"**, vous verrez le nom de votre contrat `MyToken42`
2. Si votre constructeur nécessite des paramètres, vous verrez des champs pour les remplir :
   - Exemple : `initialSupply` : entrez `4200000` (ou la valeur que vous souhaitez)
   - Exemple : `name` : entrez `"MyToken42"`
   - Exemple : `symbol` : entrez `"MTK42"`
3. Cliquez sur le bouton **"Deploy"**
4. MetaMask s'ouvrira pour confirmer la transaction :
   - Vérifiez les frais de gas (devraient être très faibles sur le testnet)
   - Cliquez sur **"Confirm"** ou **"Confirmer"**
5. Attendez la confirmation de la transaction (quelques secondes)

### Étape 6 : Vérifier le déploiement

1. Une fois déployé, votre contrat apparaîtra dans la section **"Deployed Contracts"** en bas de l'onglet
2. Vous pouvez interagir avec votre contrat directement depuis Remix :
   - Cliquez sur la flèche pour déplier les fonctions disponibles
   - Testez les fonctions : `totalSupply()`, `balanceOf()`, `transfer()`, etc.
3. **Copiez l'adresse du contrat** :
   - L'adresse s'affiche juste en dessous du nom du contrat déployé
   - Exemple : `0x1234567890123456789012345678901234567890`
   - **Sauvegardez cette adresse**, vous en aurez besoin pour la vérification

---

## Vérification et publication sur BscScan

### Étape 1 : Accéder à BscScan Testnet

1. Allez sur [BscScan Testnet](https://testnet.bscscan.com/)
2. Dans la barre de recherche, collez l'adresse de votre contrat déployé
3. Cliquez sur "Search"

### Étape 2 : Vérifier le code source

1. Sur la page de votre contrat, cliquez sur l'onglet **"Contract"**
2. Cliquez sur **"Verify and Publish"**
3. Remplissez le formulaire :
   - **Compiler Type** : `Solidity (Single file)` ou `Solidity (Standard JSON Input)` selon votre cas
   - **Compiler Version** : Sélectionnez la même version que celle utilisée dans Remix (ex: `v0.8.20+commit.a1b79de6`)
   - **License** : `MIT` (ou la licence que vous utilisez)
4. Dans le champ **"Enter the Solidity Contract Code"**, copiez-collez le code complet de votre contrat
   - **Important** : Si vous utilisez OpenZeppelin, vous devez utiliser l'option "Standard JSON Input" et inclure tous les fichiers
5. Cliquez sur **"Verify and Publish"**
6. Attendez quelques secondes pour la vérification

### Étape 3 : Vérifier le succès

1. Si la vérification réussit, vous verrez un message de confirmation
2. Le code source sera maintenant visible publiquement sur BscScan
3. Les utilisateurs pourront voir et vérifier votre contrat

---

## Tests après déploiement

### Tests de base recommandés

1. **Vérifier le totalSupply** :
   - Dans Remix, appelez `totalSupply()` et vérifiez qu'il correspond à votre supply initiale

2. **Vérifier la balance du propriétaire** :
   - Appelez `balanceOf()` avec l'adresse de votre wallet
   - Devrait correspondre au totalSupply si tous les tokens ont été mintés au propriétaire

3. **Tester un transfert** :
   - Utilisez `transfer()` pour envoyer des tokens à une autre adresse
   - Vérifiez la balance de l'adresse destinataire

4. **Tester le système de pause** (si implémenté) :
   - Appelez `setPaused(true)` (en tant que owner)
   - Essayez d'appeler une fonction protégée, elle devrait échouer
   - Appelez `setPaused(false)` pour réactiver

5. **Tester le multisig** (bonus) :
   - Proposez une transaction avec `submitTransaction()`
   - Confirmez avec `confirmTransaction()`
   - Exécutez avec `executeTransaction()`

---

## Dépannage

### Problème : "Insufficient funds"
- **Solution** : Assurez-vous d'avoir assez de tBNB dans votre wallet pour payer les frais de gas

### Problème : "Contract creation failed"
- **Solution** : Vérifiez que le code compile sans erreurs, et que tous les paramètres du constructeur sont corrects

### Problème : "Network error" ou "Transaction failed"
- **Solution** : Vérifiez que MetaMask est bien connecté au BNB Testnet (Chain ID: 97)

### Problème : Erreurs d'import OpenZeppelin dans Remix
- **Solution** : Utilisez le plugin OpenZeppelin de Remix ou importez manuellement depuis GitHub

### Problème : Impossible de vérifier sur BscScan
- **Solution** : Assurez-vous d'utiliser la même version du compilateur et les mêmes paramètres d'optimisation que lors du déploiement

---

## Informations importantes

- ⚠️ **Ce contrat est déployé sur le TESTNET uniquement** - Aucun argent réel n'est utilisé
- 📝 **Sauvegardez l'adresse du contrat** et l'URL BscScan pour votre documentation
- 🔒 **Ne partagez jamais votre clé privée** ou votre seed phrase
- ✅ **Testez toutes les fonctionnalités** avant de considérer le déploiement comme terminé

---

## Ressources utiles

- [Remix IDE Documentation](https://remix-ide.readthedocs.io/)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)
- [BSC Testnet Faucet](https://testnet.binance.org/faucet-smart)
- [BscScan Testnet](https://testnet.bscscan.com/)
- [BNB Chain Documentation](https://docs.bnbchain.org/)

---

**Bon déploiement ! 🚀**

