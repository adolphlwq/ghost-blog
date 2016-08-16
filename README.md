# Ghost blog run on Docker

## Why yet another container for Ghost
As known, there are many awesome Ghost docker images.For example:
1. [Ghost image from Docker library](https://github.com/docker-library/ghost)
2. [gold/ghost](https://hub.docker.com/r/gold/ghost/)
3. [ptimof/ghost](https://hub.docker.com/r/ptimof/ghost/)

Although above images have few point to improve.

For `1` above,
>The official container for Ghost is fine for running in development mode, but it has the `wrong
permissions` for running in production. That, and the config file doesn't have any easy way to tweak
it.                   --from https://hub.docker.com/r/ptimof/ghost/

For `2` and `3`, they neither support `SSL`.

## Usage
### Quickstart
```shell
docker run -d -P adolphlwq/docker-ghost
```
or:
```shell
docker run -d -p host_port:2368 adolphlwq/docker-ghost
```

### Customed Config
1. download repo:
```
git clone
```
2. change `config.js` for your own config
```
vim config.js
do sth
:wq
```
3. rebuild docker image
```
docker build -t repo/image_name:tag .
```
4. run your image


## Reference
- [Ghost docs](https://ghost.org/developer/)
- [Docker docs](http://docs.docker.com/)

## TODOs
- [X] Support port mapping between Docker container and host
- [ ] Ghost Theme hacking
- [ ] Support SSL
- [ ] Support data volumn
- [ ] Support Google Analytics
