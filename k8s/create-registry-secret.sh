#!/bin/bash
# Script para crear manualmente el secret de registro en Kubernetes
# Ejecutar este script si necesitas configurar las credenciales manualmente

# Reemplaza estos valores con tus credenciales reales
GITHUB_USERNAME="tu-usuario-github"
GITHUB_TOKEN="tu-personal-access-token"

# Crear el secret de registro
kubectl create secret docker-registry ghcr-login-secret \
  --docker-server=ghcr.io \
  --docker-username=$GITHUB_USERNAME \
  --docker-password=$GITHUB_TOKEN \
  --docker-email=$GITHUB_USERNAME@users.noreply.github.com \
  --namespace=default

echo "Secret 'ghcr-login-secret' creado exitosamente"