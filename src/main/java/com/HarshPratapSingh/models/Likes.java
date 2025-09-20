package com.Harsh Pratap Singh.models;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
public class Likes implements Comparable<Likes> {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String accountId;
    private Long postId;
    private LocalDate date;


    public String getAccountId() {
        return accountId;
    }

    public void setAccountId(String accountId) {
        this.accountId = accountId;
    }

    public Long getPostId() {
        return postId;
    }

    public void setPostId(Long postId) {
        this.postId = postId;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public Likes(Long id, String account, LocalDate date, Long post) {
        this.id = id;
        this.postId = post;
        this.accountId = account;
        this.date = date;
    }

    public Likes() {
    }

    @Override
    public int compareTo(Likes o) {
        return o.date.compareTo(this.date);
    }
}
