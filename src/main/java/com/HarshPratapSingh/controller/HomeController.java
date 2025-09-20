package com.Harsh Pratap Singh.controller;



import com.Harsh Pratap Singh.dto.FriendDTO;
import com.Harsh Pratap Singh.dto.PostDto;
import com.Harsh Pratap Singh.dto.TransactionDTO;
import com.Harsh Pratap Singh.models.*;
import com.Harsh Pratap Singh.repo.AccountRepoImpl;
import com.Harsh Pratap Singh.service.*;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sun.org.apache.xpath.internal.operations.Mod;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import javax.transaction.Transactional;
import java.util.*;

@Controller
public class HomeController {

    private static final Logger logger = LogManager.getLogger(HomeController.class.getName());
    @Autowired
    private AccountService accountService;
    @Autowired
    private PostService postService;
    @Autowired
    private FriendRequestsService friendRequestsService;

    private List<Account> postAccounts = null;
    @GetMapping("/searchProfiles")
    @ResponseBody()
    public ResponseEntity<List<Account>> searchProfiles(@RequestParam String query) {
        System.out.println("Received query: " + query);
        if (query == null || query.trim().isEmpty()) {
            System.out.println("Query is empty or null");
            return ResponseEntity.badRequest().body(Collections.emptyList());
        }
        List<Account> profiles = accountService.searchProfiles(query);
        if (profiles.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok().header(HttpHeaders.CONTENT_TYPE, "application/json").body(profiles);
    }


    @RequestMapping(value = "/createPost", method = RequestMethod.POST, consumes = "application/json", produces = "application/json")
    public ResponseEntity<String> createPost(@RequestBody PostDto postData, HttpSession session) {
        Account account = (Account) session.getAttribute("account");
        if(account == null) {
            return ResponseEntity.status(500).body("{\"message\":\"Error posting...\"}");
        }
        postService.save(postData, account.getId());
        return ResponseEntity.ok("{\"message\":\"Posted successfully!\"}");
    }

    @RequestMapping("/logout")
    public String createPost(HttpSession session, Model model){
        model.addAttribute("logoutMessage", "Logged out successfully!");
        session.invalidate();
        return "login";
    }



    @GetMapping("/posts")
    public ResponseEntity<List<Post>> getPosts(@RequestParam int page, @RequestParam int size, HttpSession session) {
        Account account = (Account) session.getAttribute("account");
        if(account == null) return ResponseEntity.badRequest().build();
        if(postAccounts == null){
            postAccounts = friendRequestsService.findFriends(account.getId());
            postAccounts.add(account);
        }
        List<Post> posts = postService.fetchPosts(postAccounts, page, size); // Paginated posts
        return ResponseEntity.ok().header(HttpHeaders.CONTENT_TYPE,"application/json").body(posts);
    }


//    @PostMapping("/posts/{postId}/like")
//    public ResponseEntity<Void> likePost(@PathVariable Long postId, HttpSession session) {
//        Account account = (Account) session.getAttribute("account");
//        if(account == null) return ResponseEntity.notFound().build();
//        postService.likePost(postId, account.getId());
//        return ResponseEntity.ok().build();
//    }
//
//    @PostMapping("/{postId}/comment")
//    public ResponseEntity<Void> replyToPost(@PathVariable Long postId, @RequestBody ReplyDto replyDto, HttpSession session) {
//        Account account = (Account) session.getAttribute("account");
//        if(account == null) return ResponseEntity.notFound().build();
//        postService.commentToPost(postId, replyDto, account.getId());
//        return ResponseEntity.ok().build();
//    }


}
