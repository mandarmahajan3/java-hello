FROM maven:3.5-jdk-8-alpine as builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests
FROM openjdk:21-slim-buster
RUN apt update -y && apt install -y curl wget
COPY --from=builder /app/target/helloWorld-*.jar /helloWorld.jar
EXPOSE 3333
RUN mkdir -p /opt/cprof && \
  wget -q -O- https://storage.googleapis.com/cloud-profiler/java/latest/profiler_java_agent.tar.gz \
  | tar xzv -C /opt/cprof
CMD ["java","-Dserver.port=3333","-agentpath:/opt/cprof/profiler_java_agent.so=-cprof_service=prof6,-cprof_service_version=1.0.0","-jar","/helloWorld.jar"]