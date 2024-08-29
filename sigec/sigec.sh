#!/bin/bash

# Importation du checker
. ./checker.sh
. ./functions.sh

# URL de l'API
url="https://sigec.ipnetp.cloud/api/quiz"

# Token d'authentification (si nécessaire)
token=""

# Données à envoyer (format JSON)
data='{"key1":"valeur1", "key2":"valeur2"}'

# Effectuer la requête POST avec authentification
response=$(curl -s -X GET -H "Authorization: Bearer $token" -H "Content-Type: application/json" -d "$data" "$url")

# Afficher la réponse
# echo "Réponse de l'API : $response"

# Lire le nom principal
base_name=$(echo $response | jq -r '.data.start')
base_name=$(replace_spaces "$base_name")

# Créer le dossier principal
mkdir -p "$base_name"
# echo "Dossier de base : $base_name"

# Lire les niveaux
echo "$response" | jq -c '.data.levels[]' | while read -r level; do
    level_name=$(echo "$level" | jq -r '.name')
    level_name=$(replace_spaces "$level_name")
    
    # Créer le sous-dossier pour chaque niveau
    level_path="$base_name/$level_name"
    mkdir -p "$base_name/$level_path"

    # Lire les examens dans le niveau
    echo "$level" | jq -c '.exams[]' | while read -r exam; do
        exam_name=$(echo "$exam" | jq -r '.specialty_name')
        exam_name=$(replace_spaces "$exam_name")
        
        # Créer le sous-dossier pour chaque examen
        mkdir -p "$base_name/$level_path/$exam_name"
    done
done