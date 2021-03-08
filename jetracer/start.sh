swapoff -a
nvargus-daemon &
jupyter lab --port=80 --ip=0.0.0.0 --no-browser --allow-root
