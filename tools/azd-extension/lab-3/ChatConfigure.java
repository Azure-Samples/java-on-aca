// filepath: /workspaces/java-on-aca/tools/spring-petclinic-chat-service/src/main/java/org/springframework/ai/azure/openai/ChatConfigure.java
package org.springframework.ai.azure.openai;

import com.azure.ai.openai.OpenAIClientBuilder;
import com.azure.ai.openai.OpenAIServiceVersion;
import com.azure.core.credential.AzureKeyCredential;
import com.azure.core.http.policy.HttpLogOptions;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ChatConfigure {

    @Bean
    public OpenAIClientBuilder openAIClientBuilder() {
        return new OpenAIClientBuilder()
            .credential(new AzureKeyCredential(System.getenv("AZURE_OPENAI_API_KEY")))
            .endpoint(System.getenv("AZURE_OPENAI_ENDPOINT"))
            .serviceVersion(OpenAIServiceVersion.V2024_02_15_PREVIEW)
            .httpLogOptions(new HttpLogOptions().setLogLevel(com.azure.core.http.policy.HttpLogDetailLevel.BODY_AND_HEADERS));
    }

    @Bean
    public AzureOpenAiChatModel azureOpenAiChatModel(OpenAIClientBuilder openAIClientBuilder) {
        return AzureOpenAiChatModel.builder()
            .openAIClientBuilder(openAIClientBuilder)
            .defaultOptions(AzureOpenAiChatOptions.builder().deploymentName("gpt-4o").maxTokens(1000).build())
            .build();
    }

    @Bean
    public ChatClient chatClient(AzureOpenAiChatModel azureOpenAiChatModel) {
        return ChatClient.builder(azureOpenAiChatModel).build();
    }
}