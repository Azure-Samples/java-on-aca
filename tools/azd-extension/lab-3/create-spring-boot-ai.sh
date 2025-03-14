#!/bin/bash

AZURE_CONFIG_FILE="../config/azure-resource.profile"
source $AZURE_CONFIG_FILE

SPRING_PETCLINIC_CHAT_SERVICE="../../spring-petclinic-chat-service"

POM=$SPRING_PETCLINIC_CHAT_SERVICE/pom.xml
SPRING_AI_VERSION="1.0.0-M6"

# update the spring-ai.version in the pom.xml
if grep -q "<spring-ai.version>" $POM; then
  sed -i "s|<spring-ai.version>.*</spring-ai.version>|<spring-ai.version>$SPRING_AI_VERSION</spring-ai.version>|" $POM
else
  sed -i "/<properties>/a \    <spring-ai.version>$SPRING_AI_VERSION</spring-ai.version>" $POM
fi

{ 
  echo "## AI VERSION"
  echo "SPRING_AI_VERSION=$SPRING_AI_VERSION" 
} >> $AZURE_CONFIG_FILE

TEST_FILE="https://raw.githubusercontent.com/spring-projects/spring-ai/refs/heads/$SPRING_AI_VERSION/models/spring-ai-azure-openai/src/test/java/org/springframework/ai/azure/openai/AzureOpenAiChatClientIT.java"
curl $TEST_FILE -o $SPRING_PETCLINIC_CHAT_SERVICE/src/main/resources/AzureOpenAiChatClientIT.java

CHAT_CONFIGURE_JAVA="ChatConfigure.java"
CHAT_CONTROLLER_JAVA="ChatController.java"

cp $CHAT_CONFIGURE_JAVA $SPRING_PETCLINIC_CHAT_SERVICE/src/main/resources
cp $CHAT_CONTROLLER_JAVA $SPRING_PETCLINIC_CHAT_SERVICE/src/main/resources

cd $SPRING_PETCLINIC_CHAT_SERVICE
mvn clean package -DskipTests

export AZURE_OPENAI_API_KEY="$AZURE_OPENAI_API_KEY"
export AZURE_OPENAI_ENDPOINT="$AZURE_OPENAI_ENDPOINT"

mvn spring-boot:run