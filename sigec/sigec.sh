#!/bin/bash

# Importation du checker
. ./checker.sh

# URL de l'API
url="https://sigec.ipnetp.cloud/api/quiz"

# Token d'authentification (si nécessaire)
token=""

# Données à envoyer (format JSON)
data='{"key1":"valeur1", "key2":"valeur2"}'

# Effectuer la requête POST avec authentification
response=$(curl -s -X GET -H "Authorization: Bearer $token" -H "Content-Type: application/json" -d "$data" "$url")

# Afficher la réponse
echo "Réponse de l'API : $response"

year = $(echo $response | jq -r '.data.start')
echo "Ann�e scolaire : $year"
