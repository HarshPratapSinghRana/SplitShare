package com.Harsh Pratap Singh.service;

import com.Harsh Pratap Singh.models.Comments;

import java.util.TreeSet;

public interface CommentService {
    TreeSet<Comments> getCommentsFor(Long id);
}
