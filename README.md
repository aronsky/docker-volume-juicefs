# Docker Volume Plugin for Juicefs

Modified from https://github.com/vieux/docker-volume-sshfs

## Usage

``` shell
$ docker plugin install juicedata/juicefs
Plugin "juicedata/juicefs" is requesting the following privileges:
 - network: [host]
 - device: [/dev/fuse]
 - capabilities: [CAP_SYS_ADMIN]
Do you grant the above permissions? [y/N]

$ docker volume create -d juicedata/juicefs:next -o name=$JFS_VOL -o token=$JFS_TOKEN -o accesskey=$ACCESS_KEY -o secretkey=$SECRET_KEY jfsvolume
$ docker run -it -v jfsvolume:/opt busybox ls /opt
```

## Development

Boot up vagrant environment

``` shell
vagrant up
vagrant ssh
```

Inside vagrant

``` shell
export WORKDIR=~/go/src/docker-volume-juicefs
mkdir -p $WORKDIR
rsync -avz --exclude plugin --exclude .git --exclude .vagrant /vagrant/ $WORKDIR/
cd $WORKDIR
make
make enable
docker volume create -d juicedata/juicefs:next -o name=$JFS_VOL -o token=$JFS_TOKEN -o accesskey=$ACCESS_KEY -o secretkey=$SECRET_KEY jfsvolume
docker run -it -v jfsvolume:/opt busybox ls /opt
```

Enable debug information

``` shell
docker plugin set juicedata/juicefs:next DEBUG=1
```
