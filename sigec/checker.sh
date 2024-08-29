# Fonction pour vérifier si jq est installé
check_jq_installed() {
    if ! command -v jq &> /dev/null; then
        echo "jq n'est pas installé."
        install_jq
    else
        echo "jq est déjà installé."
    fi
}

# Fonction pour installer jq
install_jq() {
    echo "Installation de jq..."

    # Déterminer le gestionnaire de paquets et installer jq
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt-get &> /dev/null; then
            sudo apt-get update
            sudo apt-get install -y jq
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y jq
        elif command -v yum &> /dev/null; then
            sudo yum install -y jq
        elif command -v pacman &> /dev/null; then
            sudo pacman -S jq
        else
            echo "Gestionnaire de paquets non reconnu. Installez jq manuellement."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            brew install jq
        else
            echo "Homebrew n'est pas installé. Veuillez installer jq manuellement."
            exit 1
        fi
    else
        echo "Système d'exploitation non pris en charge. Installez jq manuellement."
        exit 1
    fi

    echo "jq a été installé avec succès."
}

# Vérifier si jq est installé
check_jq_installed

