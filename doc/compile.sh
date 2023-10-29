#!/bin/bash
cd ..
pandoc README.md -V geometry:margin=1.5cm --variable colorlinks=true --variable urlcolor=blue -o ./doc/podjava.pdf > /dev/null 2>&1 || echo "No README.md found."
