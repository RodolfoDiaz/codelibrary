# https://hub.docker.com/_/openjdk
FROM openjdk:8
COPY ./source /usr/src/myapp
WORKDIR /usr/src/myapp
RUN javac HelloWorld.java
CMD ["java", "HelloWorld"]
# You can then run and build the Docker image:
# $ docker build --rm -t my-java-app .
# $ docker run -it --rm --name my-running-app my-java-app
