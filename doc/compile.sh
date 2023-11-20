#!/bin/bash
SCRIPT=$(readlink -f "$0")
DIR=$(dirname "$SCRIPT")
cd ${DIR}/..

# Dynamisch generiere den LaTeX-Code für den Header
HEADER_CODE=$(cat << 'EOF'
---
header-includes: |
    \\usepackage{fancyhdr}
    \\pagestyle{fancy}
    \\fancyfoot[LO,LE]{Lukas Meyer-Hilberg}
    \\fancyfoot[CO,CE]{\\thepage}
    \\fancyfoot[LE,RO]{\\today}
...
EOF
)

echo -e "$HEADER_CODE\n\n$(cat README.md)" > ./README_tmp.md


pandoc README_tmp.md -V geometry:margin=1.5cm --variable colorlinks=true --variable urlcolor=blue -o ./doc/podjava.pdf #> /dev/null 2>&1 || echo "No README_tmp.md found."

rm ./README_tmp.md