package com.Harsh Pratap Singh.service;

import com.Harsh Pratap Singh.models.Comments;
import com.Harsh Pratap Singh.repo.CommentRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.TreeSet;

@Service
public class CommentServiceImpl implements CommentService{
    @Autowired
    private CommentRepo commentRepo;

    @Override
    public TreeSet<Comments> getCommentsFor(Long id) {
        return new TreeSet<>(commentRepo.getCommentsFor(id));
    }
}
