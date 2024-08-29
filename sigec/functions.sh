# Fonction pour remplacer les espaces par des soulignements
replace_spaces() {
    # echo "$1" | tr ' ' '_'
    local input="$1"
    # Supprimer les espaces en début et en fin
    input=$(echo "$input" | sed 's/^[ \t]*//;s/[ \t]*$//')
    # Remplacer les espaces restants par des blancs soulignés
    input=$(echo "$input" | tr ' ' '_')
    echo "$input"
}
