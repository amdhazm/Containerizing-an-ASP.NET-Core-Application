# Containerizing-an-ASP.NET-Core-Application
This guide outlines the steps to containerize an ASP.NET Core application using Docker.

## Prerequisites

- [.NET Core SDK 3.1](https://dotnet.microsoft.com/download/dotnet/3.1) installed
- [Docker](https://www.docker.com/get-started) installed

## Dockerfile

We will use a multi-stage Dockerfile to build and publish the application. Here is the Dockerfile:

```dockerfile
# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /source

# Copy the project file and restore dependencies
COPY *.csproj .
RUN dotnet restore

# Copy the remaining files and build the project
COPY . .
RUN dotnet publish -c Release -o /app

# Stage 2: Create the runtime image
FROM mcr.microsoft.com/dotnet/aspnet:3.1
WORKDIR /app

# Copy the build output from the build stage
COPY --from=build /app .

# Add a health check to ensure the container is running correctly
HEALTHCHECK CMD curl --fail http://localhost:80 || exit 1

# Set environment variables if needed
# ENV ASPNETCORE_URLS=http://+:80

ENTRYPOINT ["dotnet", "webapp.dll"]
