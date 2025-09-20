package com.Harsh Pratap Singh.repo;

import com.Harsh Pratap Singh.models.Likes;

import java.util.List;

public interface LikeRepo {
    List<Likes> getLikesFor(Long id);
}
