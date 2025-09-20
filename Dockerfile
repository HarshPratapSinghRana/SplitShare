# Use Maven image to build the WAR
FROM maven:3.8.4-openjdk-8 AS build

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Build the WAR
RUN mvn clean package -DskipTests

# Use official Tomcat image for deployment
FROM tomcat:8.5-jdk8

# Set Tomcat environment
ENV CATALINA_HOME /usr/local/tomcat

# Remove default webapps (optional)
RUN rm -rf $CATALINA_HOME/webapps/*

# Copy the generated WAR file to Tomcat
COPY --from=build /app/target/*.war $CATALINA_HOME/webapps/ROOT.war

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run", "-Xmx350m", "-Xms128m"]

