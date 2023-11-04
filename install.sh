#!/bin/bash

function check_for_podman(){
if ! command -v podman &> /dev/null; then
    sudo apt update > /dev/null 2>&1
    echo "Podman not found. Installing..."
    sudo apt -y install podman
    if [ $? -eq 0 ]; then
        echo "Podman installation successful."
    else
        echo "Error installing Podman. Adding ppa"
        return 1
    fi
else
    echo "Podman is already installed."
fi
}

function add_podman_ppa_and_podman() {
    . /etc/os-release
    echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
    curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key" | sudo apt-key add -
    sudo apt update &> /dev/null
    sudo apt -y install podman &> /dev/null
}

function ensure_executeables() {
    executablepathjava="/usr/local/bin/podjava"
    echo 'podman run -it -v "$PWD":/usr/src/myapp -w /usr/src/myapp docker.io/library/openjdk:18 $@' | sudo tee $executablepathjava > /dev/null
    sudo chmod +x $executablepathjava

    executablepathjupyter="/usr/local/bin/podpod"

    # Füge die Zeilen zur Datei hinzu
    sudo tee "$executablepathjupyter" > /dev/null <<EOF
TOKEN=\$(openssl rand -hex 32)
xdg-open  "http://localhost:8888/?token=\$TOKEN" &
podman pull ghcr.io/tna76874/schoolnotebookjava:stable
podman run -it -p 127.0.0.1:8888:8888  ghcr.io/tna76874/schoolnotebookjava:stable jupyter notebook --NotebookApp.default_url=/lab/ --ip=0.0.0.0 --port=8888 --NotebookApp.token="\$TOKEN"
EOF

    sudo chmod +x $executablepathjupyter
}

check_for_podman || add_podman_ppa_and_podman && ensure_executeables