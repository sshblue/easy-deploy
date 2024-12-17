# Easy Deploy Tool 🚀

A simple and configurable deployment tool for your GitHub projects.

## 📋 Fonctionnalités

- Interface interactive en ligne de commande
- Détection automatique des fichiers modifiés
- Sélection des fichiers à déployer
- Messages de statut colorés
- Configuration externalisée
- Compatible avec GitHub Actions

## 🛠️ Installation

1. Clonez ce dépôt :
```bash
git clone https://github.com/votre-username/easy-deploy.git
```

2. Configurez le fichier `config.json` avec vos paramètres :
```json
{
    "projectSettings": {
        "projectPath": "chemin/vers/votre/projet",
        "projectName": "Nom de votre projet",
        "deploymentTool": "GitHub Actions"
    }
}
```

## 💻 Utilisation

### Commande simple
```bash
.\deploy.bat
```

### Avec message de commit
```bash
.\deploy.bat -m "votre message de commit"
```

### Avec fichiers spécifiques
```bash
.\deploy.bat -f fichier1.txt fichier2.js
```

### Avec message et fichiers spécifiques
```bash
.\deploy.bat -m "votre message" -f fichier1.txt fichier2.js
```

## ⚙️ Configuration

Le fichier `config.json` permet de personnaliser :

- `projectSettings`
  - `projectPath`: Chemin vers votre projet
  - `projectName`: Nom de votre projet
  - `deploymentTool`: Outil de déploiement utilisé

- `display.colors`: Couleurs pour différents types de changements
  - `modified`: Fichiers modifiés
  - `added`: Nouveaux fichiers
  - `deleted`: Fichiers supprimés
  - `renamed`: Fichiers renommés
  - `untracked`: Fichiers non suivis

## 📝 Structure du projet

```
easy-deploy/
├── deploy.bat       # Script batch d'entrée
├── deploy.ps1       # Script PowerShell principal
├── config.json      # Configuration du déploiement
└── README.md        # Documentation
```

## 🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :

1. Fork le projet
2. Créer une branche (`git checkout -b feature/amelioration`)
3. Commit vos changements (`git commit -m 'Ajout d'une fonctionnalité'`)
4. Push vers la branche (`git push origin feature/amelioration`)
5. Ouvrir une Pull Request


