@echo off
REM Initialisiere Podman-Maschine
podman machine init

REM Starte Podman-Maschine
podman machine start

REM Starte Podman-Maschine
podman pull ghcr.io/tna76874/schoolnotebookjava:stable

REM Führe den Jupyter Notebook-Container aus
podman run -it -p 127.0.0.1:8888:8888 ghcr.io/tna76874/schoolnotebookjava:stable jupyter notebook --NotebookApp.default_url=/lab/ --ip=0.0.0.0 --port=8888 --NotebookApp.token=""
