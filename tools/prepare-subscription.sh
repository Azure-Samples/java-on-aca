#!/usr/bin/env bash

echo "Registering providers ..."

az provider register --namespace Microsoft.ContainerRegistry

az provider register --namespace Microsoft.Network

az provider register --namespace Microsoft.App

az provider register --namespace Microsoft.DBforMySQL

az provider register --namespace Microsoft.CognitiveServices
