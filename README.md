# Build your docker image
# syntax: docker build -t <image-tag> <dockerfile-location>
docker build -t app:latest .

# If you want to test your local image
docker run -d -p 80:80 app:latest

# If you want to test your local image and map volume
docker volume create data_volume 
docker run --name=mysite -d -v data_volume:/var/www/html -p 80:80 app:latest
# or
docker run --name=mysite -d -v /source_path:/var/www/html -p 80:80 app:latest


# once you run above command go to http://localhost