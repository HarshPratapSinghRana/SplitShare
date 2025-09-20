package com.Harsh Pratap Singh.service;

import com.Harsh Pratap Singh.dto.PostDto;
import com.Harsh Pratap Singh.models.Account;
import com.Harsh Pratap Singh.models.Post;

import java.util.List;

public interface PostService {
    List<Post> fetchPosts(String id);

    void save(PostDto postData, String accountId);

    List<Post> fetchPosts(List<Account> list, int page, int size);
}
