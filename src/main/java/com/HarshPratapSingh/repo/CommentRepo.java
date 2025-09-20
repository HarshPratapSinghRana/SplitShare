package com.Harsh Pratap Singh.repo;

import com.Harsh Pratap Singh.models.Comments;

import java.util.List;
import java.util.TreeSet;

public interface CommentRepo {
    List<Comments> getCommentsFor(Long id);
}
