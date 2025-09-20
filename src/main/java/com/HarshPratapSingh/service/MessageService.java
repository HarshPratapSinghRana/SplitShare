package com.Harsh Pratap Singh.service;

import com.Harsh Pratap Singh.dto.MessageDTO;
import com.Harsh Pratap Singh.models.Message;

import java.util.List;

public interface MessageService {
    void saveMessage(MessageDTO messageDTO);

    List<MessageDTO> getChatHistory(String receiverId, String senderId);

    Message getLastMessage(String id, String id1);
}
