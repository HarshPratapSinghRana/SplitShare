package com.Harsh Pratap Singh.models;

import javax.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
public class Comments implements Comparable<Comments> {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String fromAccountId;
    private String toAccountId;
    private Long postId;  // foreign key
    private String content;
    private LocalDateTime date;

    public String getToAccountId() {
        return toAccountId;
    }

    public void setToAccountId(String toAccountId) {
        this.toAccountId = toAccountId;
    }

    public String getFromAccountId() {
        return fromAccountId;
    }

    public void setFromAccountId(String fromAccountId) {
        this.fromAccountId = fromAccountId;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getPostId() {
        return postId;
    }

    public void setPostId(Long post) {
        this.postId = post;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public LocalDateTime getDate() {
        return date;
    }

    public void setDate(LocalDateTime date) {
        this.date = date;
    }

    public Comments(Long id, Long post, String content, LocalDateTime date, String fromAccountId, String toAccountId) {
        this.id = id;
        this.fromAccountId = fromAccountId;
        this.postId = post;
        this.content = content;
        this.date = date;
        this.toAccountId = toAccountId;
    }

    public Comments() {
    }


    @Override
    public int compareTo(Comments other) {
        return other.date.compareTo(this.date);
    }
}
