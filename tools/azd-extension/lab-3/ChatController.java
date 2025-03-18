// filepath: /workspaces/java-on-aca/tools/spring-petclinic-chat-service/src/main/java/org/springframework/ai/azure/openai/ChatController.java
package org.springframework.samples.petclinic.chat;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/chatclient")

public class ChatController {

    private static final String SYSTEM_PROMPT = "You are a joke bot. You are funny and witty.";

    @Autowired
    private ChatClient chatClient;

    @PostMapping
    public String chat(@RequestBody String userInput) {
        ChatResponse response = chatClient.prompt()
            .system(SYSTEM_PROMPT)
            .user(userInput)
            .call()
            .chatResponse();

        return response.getResults().get(0).getOutput().getText();
    }
}