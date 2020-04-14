# Contents

- ubuntu:18.04
- php:7.2
- instantclient:12.2
- oci8

## Requirements

- docker: https://docs.docker.com/engine/install/ubuntu/
- docker-compose: https://docs.docker.com/compose/install/

## Usage

### First way (Terminal)

Open terminal and run command:
`docker run --name php-oci8 -d -p 80:80 -t ocnascimento/php7.2-apache-oci8:latest`

### Second way (Docker-compose)

Create file `docker-compose.yaml`:

```yaml
version: "3"
services:
  app:
    build: .
    ports:
      - 80:80
```

Create file `Dockerfile`:

```Dockerfile
FROM ocnascimento/php7.2-apache-oci8:latest
```

## License

[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://badges.mit-license.org)

- **[MIT license](https://mit-license.org/)**
- Copyright 2020 © <a href="javascript:;" target="_blank">OCN</a>.
