# Xサーバーへのアクセスを現在のユーザーに限定して許可する
xhost +

# Dockerコンテナを起動し、現在のユーザーのDISPLAY環境変数とX11のソケットを渡す
sudo docker run --gpus all -it -d \
  --shm-size=2g \
  -e DISPLAY=$DISPLAY \
  -v $(pwd):/workdir \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v $HOME/.Xauthority:/root/.Xauthority \
  --net host \
  octo:latest
