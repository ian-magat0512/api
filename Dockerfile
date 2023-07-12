FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5000

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["./testAPI.csproj", "testAPI/"]
RUN dotnet restore "testAPI/testAPI.csproj"

WORKDIR "/src/testAPI"
COPY . .
RUN dotnet build "./testAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "./testAPI.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "testAPI.dll"]