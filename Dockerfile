# Utiliser l'image .NET Core SDK
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["nopCommerce.sln", "./"]
COPY ["src/Presentation/Nop.Web/Nop.Web.csproj", "src/Presentation/Nop.Web/"]
COPY ["src/Libraries/Nop.Core/Nop.Core.csproj", "src/Libraries/Nop.Core/"]
COPY ["src/Libraries/Nop.Data/Nop.Data.csproj", "src/Libraries/Nop.Data/"]
COPY ["src/Libraries/Nop.Services/Nop.Services.csproj", "src/Libraries/Nop.Services/"]
COPY ["src/Libraries/Nop.Web.Framework/Nop.Web.Framework.csproj", "src/Libraries/Nop.Web.Framework/"]
RUN dotnet restore "nopCommerce.sln"
COPY . .
WORKDIR "/src/src/Presentation/Nop.Web"
RUN dotnet build "Nop.Web.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Nop.Web.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Nop.Web.dll"]
