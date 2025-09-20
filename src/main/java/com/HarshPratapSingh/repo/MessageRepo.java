package com.Harsh Pratap Singh.repo;

import com.Harsh Pratap Singh.models.Message;

import java.util.List;

public interface MessageRepo{
    List<Message> findBySenderAndReceiver(String receiverId, String senderId);

    void save(Message message);

    Message getLastMessage(String id, String id1);
}
