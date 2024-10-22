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


ENTRYPOINT ["dotnet", "webapp.dll"]

