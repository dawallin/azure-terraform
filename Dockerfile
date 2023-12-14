# Use the official ASP.NET Core runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Use the official .NET SDK image to build the project
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["BlazorTest/BlazorTest.csproj", "BlazorTest/"]
RUN dotnet restore "BlazorTest/BlazorTest.csproj"
COPY . .
WORKDIR "/src/BlazorTest"
RUN dotnet build "BlazorTest.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "BlazorTest.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BlazorTest.dll"]