#!/bin/bash

./collect-user-info.sh
./create-aca-env.sh
./create-mysql.sh
./create-container-registry.sh
./create-java-components.sh
./deploy-component-apps.sh