package com.Harsh Pratap Singh.repo;

import com.Harsh Pratap Singh.models.Post;

import java.util.List;

public interface PostRepo {
    List<Post> fetchPosts(String id);

    void save(Post post);

    List<Post> fetchPostsByAccounts(List<String> accountIds, int size, int i);
}
