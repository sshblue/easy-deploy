# Easy Deploy Tool 🚀

A simple and configurable deployment tool for your GitHub projects.

## 📋 Features

- Interactive command-line interface
- Automatic detection of modified files
- Selective file deployment
- Colored status messages
- Externalized configuration
- GitHub Actions compatible

## 🛠️ Installation

1. Clone this repository:
```bash
git clone https://github.com/sshblue/easy-deploy.git
```

2. Configure the `config.json` file with your settings:
```json
{
    "projectSettings": {
        "projectPath": "path/to/your/project",
        "projectName": "Your Project Name",
        "deploymentTool": "GitHub Actions"
    }
}
```

## 💻 Usage

### Simple command
```bash
.\deploy.bat
```

### With commit message
```bash
.\deploy.bat -m "your commit message"
```

### With specific files
```bash
.\deploy.bat -f file1.txt file2.js
```

### With message and specific files
```bash
.\deploy.bat -m "your message" -f file1.txt file2.js
```

## ⚙️ Configuration

The `config.json` file allows you to customize:

- `projectSettings`
  - `projectPath`: Path to your project
  - `projectName`: Your project name
  - `deploymentTool`: Deployment tool used

- `display.colors`: Colors for different types of changes
  - `modified`: Modified files
  - `added`: New files
  - `deleted`: Deleted files
  - `renamed`: Renamed files
  - `untracked`: Untracked files

## 📝 Project Structure

```
easy-deploy/
├── deploy.bat       # Entry batch script
├── deploy.ps1       # Main PowerShell script
├── config.json      # Deployment configuration
└── README.md        # Documentation
```

## 🤝 Contributing

Contributions are welcome! Feel free to:

1. Fork the project
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Commit your changes (`git commit -m 'Add a feature'`)
4. Push to the branch (`git push origin feature/improvement`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License. See the `LICENSE` file for details.
