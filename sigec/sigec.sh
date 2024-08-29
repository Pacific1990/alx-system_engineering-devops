#!/bin/bash

# Importation du checker
. ./checker.sh
. ./functions.sh

# Demander à l'utilisateur de saisir son nom
echo "Saisissez l'année souhaitée: (ex: 2023) :"
read year
echo "Réponse : $year	"

# URL de l'API
url="https://sigec.ipnetp.cloud/api/quiz"

# Token d'authentification (si nécessaire)
token=""

# Données à envoyer (format JSON)
data='{"year":"$year"}'

# Effectuer la requête POST avec authentification
response=$(curl -s -X GET -H "Authorization: Bearer $token" -H "Content-Type: application/json" -d "$data" "$url")

# Vérifier si la réponse contient des données
if [ -z "$response" ]; then
    echo "Erreur : La réponse de l'API est vide."
    exit 1
fi

# Afficher la réponse
# echo "Réponse de l'API : $response"

# Lire le nom principal
base_name=$(echo $response | jq -r '.data.start')
base_name=$(replace_spaces "$base_name")

# Créer le dossier principal
mkdir -p "./$base_name"
# echo "Dossier de base : $base_name"

# Lire les niveaux
echo "$response" | jq -c '.data.levels[]' | while read -r level; do
    level_name=$(echo "$level" | jq -r '.name')
    level_name=$(replace_spaces "$level_name")
    # Créer le sous-dossier pour chaque niveau
    level_path="$base_name/$level_name"
    mkdir -p "$level_path"

    # Lire les examens dans le niveau
    echo "$level" | jq -c '.exams[]' | while read -r exam; do
        exam_name=$(echo "$exam" | jq -r '.specialty_name')
        exam_name=$(replace_spaces "$exam_name")
        # Créer le sous-dossier pour chaque examen
        exam_path="$level_path/$exam_name"
        mkdir -p "$exam_path"

        # Lire les salles dans l'examen
        echo "$exam" | jq -c '.rooms[]' | while read -r room; do
            room_name=$(echo "$room" | jq -r '.salle')
            room_name=$(replace_spaces "$room_name")
            # Créer le sous-dossier pour chaque salle
            room_path="$exam_path/$room_name"
            mkdir -p "$room_path"
            
            # Nom du fichier CSV de sortie
        	output_csv="$room_path/output.csv"
         
        	# Extraire les en-têtes à partir des clés des candidats
        	headers=$(echo "$response" | jq -r '.data.levels[].exams[].rooms[].candidates[0] | keys_unsorted | @csv')
        	
            # Ajouter les en-têtes au fichier CSV
        	echo "$headers" > "$output_csv"
         
        	# Extraire les données des candidats et les ajouter au CSV
        	# echo "$response" | jq -r '.data.levels[].exams[].rooms[].candidates[] | [.[]] | @csv' >> "$output_csv"
        	
            # Extraire les valeurs des candidats en utilisant les en-têtes
            echo "$response" | jq -r '.data.levels[].exams[].rooms[].candidates[] | to_entries | map(.value) | @csv' >> "$output_csv"
        	echo "Le fichier CSV a été créé avec succès : $output_csv"
        done
    done
done
