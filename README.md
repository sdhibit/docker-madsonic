docker-madsonic
===============

Docker Container for [Madsonic](https://madsonic.org/) Media Server

### Build Dockerfile

```
git glone https://github.com/sdhibit/docker-madsonic.git
cd docker-madsonic
docker build -t madsonic .
```

### Run Docker Container

```
docker run -d --net="host" -v /etc/localtime:/etc/localtime:ro -v ${config_dir_path}:/config -v ${media_dir_path}:/media -p 4040:4040 -p 4050:4050 madsonic
```
