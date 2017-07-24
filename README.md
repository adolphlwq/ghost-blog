# Ghost blog run on Docker

## Change log
1. 2017.7.25 Ghost 1.0.0

## Usage
### Quickstart
1. run ghost container
    ```shell
    docker run -d -P adolphlwq/docker-ghost
    or:
    docker run -d -p host_port:2368 adolphlwq/docker-ghost
    ```
2. browser [localhost:2368](localhost:2368) default.

### Customed Config
1. download repo:
    ```
    git clone https://github.com/adolphlwq/ghost-blog.git
    ```
2. change **config.development.json** for your own config
    ```
    vim config.development.json
    change/add some config
    :wq
    ```
    **More config plz see [ghost config](https://docs.ghost.org/docs/configuring-ghost#section-custom-configuration-files)**
3. rebuild docker image
    ```
    docker build -t repo/image_name:tag .
    # OR use command make
    make build-dev (build a image for dev and test env)
    # OR
    make build-prod (build a image for prod env)
    ```
4. run your image
    ```
    docker run -d -p host_port:2368 image_name
    # OR use make
    make dev (setup ghost on dev env)
    # OR
    make prod (setup ghost on prod env)
    ```

### Volumn your blog database
I suggest you map a volumn from container to host when run ghost image.
```
docker run -d --name ghost -p 2368:2368 -v host_path_to_data:/var/www/ghost/content/data ghost
```

### Backup your volumn data
**Note:** It is useful on Linux
1. backup script
    ```shell
    #!/bin/bash
    DATA_DIR=$1    #data dir to backup
    STORE_DIR=$2   #data dir to store backup date
    tar zcvf ${STORE_DIR}/ghost_content_data_`date "+%Y_%m_%d_%H_%M_%S"`.tar.gz ${DATA_DIR}
    ```
2. `crontab -e`
    ```shell
    # m   h  dom mon dow   command
    30  3   *   *   *    path/to/ghost_blog_data_backup.sh path/to/DATA_DIR path/to/STORE_DIR
    ```
3. done!

### Reobtain Let's Encrypt certificates
edit `crontab -e` on Linux
```shell
 0  0   1   */2   *    letsencrypt renew
```

## Let's Encrypt on Ubuntu Xenial
In this section,I will set up a SSL by `[Let's Encrypt](https://letsencrypt.org/)` and `[Nginx](http://nginx.org)`.

1. install Nginx and letsencrypt on Ubuntu 16.04
    ```
    It is easy, I skip
    ```
2. config Nginx
    ```
    server {
        listen 80;
        server_name example.com www.example.com;

        location / {
            index index.html;
        }
    }
    ```
detail info [See Here](https://github.com/adolphlwq/lwqBlog/blob/master/SSL/nginx_ssl_for_ghost.conf)

3. obtain SSL CA from `Let's Encript CA`
    ```
    [sudo] letsencrypt certonly --webroot -w /var/www/ghost -d example.com -s www.example.com
    ```
[click here](https://certbot.eff.org) to learn more from **certbot** ACME client.

4. add Nginx SSL and domain config
    ```
    server {
        listen 80;
        server_name example.com www.example.com;
        root path/to/root;

        ssl on;
        listen 443 ssl;
        ssl_certificate       path/to/cert;
        ssl_certificate_key   path/to/cert_key;
        ssl_session_timeout  30m;
        
        if ($scheme = http) {
        return 301 https://$server_name$request_uri;
        }
        
        location / {
            proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header  Host $http_host;
            proxy_set_header  X-Forwarded-Proto $scheme;
            proxy_set_header  X-Real-IP $remote_addr;
            proxy_set_header  Host      $host;
            proxy_pass        http://127.0.0.1:2368;
        }
        
        location ~ /.well-known {
            allow all;
        }
    }
    ```

## Reference
- [Ghost docs](https://ghost.org/developer/)
- [Docker docs](http://docs.docker.com/)

## TODOs
- [X] Support port mapping between Docker container and host.
- [X] Support SSL via [Let's Encrypt](https://letsencrypt.org/).
- [X] Support Google Analytics......[Refer this post](https://www.ghostforbeginners.com/how-to-add-google-analytics-to-ghost/).
- [X] SUpport Makefile to test and build Docker image**(Linux Only)**.
- [X] Set cron job to reobtain certificates from `Let's Encrypt`.
- [X] Set cron job to backup data from container's volumn.
- [X] Support data volumn.
- [X] Ghost Theme hacking, plz see [adolphlwq/ghost-theme-kd](https://github.com/adolphlwq/ghost-theme-kd)
- [ ] try using [Caddy](https://github.com/mholt/caddy) to replace nginx
