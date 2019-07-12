# nginx-with-prometheus
Make nginx docker provide Prometheus capture data interface
### run
```
docker run -itd -p 80:80 -p 9145:9145 xusenme/nginx-with-prometheus:1.16
```
### check
http://localhost:9145/metrics

### build docker image
```
sh build.sh
```
