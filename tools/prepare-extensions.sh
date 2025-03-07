#!/usr/bin/env bash

echo "Install or Update az extensions ..."

for name in containerapp serviceconnector-passwordless application-insights amg; do
    az extension add --name $name --upgrade --yes
done