nvargus-daemon &
export LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libgomp.so.1
fallocate -l 4G /var/swapfile
chmod 700 /var/swapfile
mkswap /var/swapfile
swapon /var/swapfile
bash -c 'echo "/var/swapfile swap swap defaults 0 0" >> /etc/fstab'
jupyter lab --port=80 --ip=0.0.0.0 --no-browser --allow-root
