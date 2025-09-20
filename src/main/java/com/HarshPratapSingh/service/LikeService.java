package com.Harsh Pratap Singh.service;

import com.Harsh Pratap Singh.models.Likes;

import java.util.TreeSet;

public interface LikeService {
    TreeSet<Likes> getLikesFor(Long id);
}
