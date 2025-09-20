package com.Harsh Pratap Singh.service;

import com.Harsh Pratap Singh.dto.PostDto;
import com.Harsh Pratap Singh.models.Account;
import com.Harsh Pratap Singh.models.Post;
import com.Harsh Pratap Singh.repo.CommentRepo;
import com.Harsh Pratap Singh.repo.LikeRepo;
import com.Harsh Pratap Singh.repo.PostRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Service;

import java.awt.print.Pageable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class PostServiceImpl implements PostService{
    @Autowired
    private PostRepo postRepo;
    @Autowired
    private CommentRepo commentRepo;
    @Autowired
    private LikeRepo likeRepo;

    @Override
    public List<Post> fetchPosts(String id) {
        List<Post> list = postRepo.fetchPosts(id);
        for(Post post: list){
            post.setBase64photo(Base64.getEncoder().encodeToString(post.getPhotobytes()));
            post.setComments(commentRepo.getCommentsFor(post.getId()));
            post.setLikes(likeRepo.getLikesFor(post.getId()));
        }
        list.sort(Comparator.comparing(Post::getDateTime).reversed());
        return list;
    }

    @Override
    public void save(PostDto postData, String accountId) {
        byte[] photobytes = Base64.getDecoder().decode(postData.getImage().split(",")[1]);
        Post post = new Post();
        post.setAccountId(accountId);
        post.setCaption(postData.getCaption());
        post.setPhotobytes(photobytes);
        post.setDateTime(LocalDateTime.now());
        post.setBase64photo(postData.getImage());
        postRepo.save(post);
    }


    @Override
    public List<Post> fetchPosts(List<Account> list, int page, int size) {
        List<String> accountIds = list.stream().map(Account::getId).collect(Collectors.toList());
        List<Post> postList = postRepo.fetchPostsByAccounts(accountIds, size, page*size);
        for(Post post: postList){
            post.setBase64photo(Base64.getEncoder().encodeToString(post.getPhotobytes()));
            post.setComments(commentRepo.getCommentsFor(post.getId()));
            post.setLikes(likeRepo.getLikesFor(post.getId()));
        }
        return postList;
    }
}
