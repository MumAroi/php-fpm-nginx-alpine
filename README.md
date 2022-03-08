# Build your docker image
# syntax: docker build -t <image-tag> <dockerfile-location>
docker build -t app:latest .

# If you want to test your local image
docker run -d -p 80:80 app:latest

# once you run above command go to http://localhost