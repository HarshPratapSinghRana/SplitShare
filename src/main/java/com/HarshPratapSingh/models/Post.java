package com.Harsh Pratap Singh.models;



import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;
import java.util.List;
import java.util.TreeSet;

@Entity
public class Post implements Comparable<Post> {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String accountId; // foreign key
    @Lob
    private byte[] photobytes;
    @Transient
    private String base64photo;
    @NotNull
    private LocalDateTime dateTime;
    private String caption;
    @Transient
    private List<Comments> comments;
    @Transient
    private List<Likes> likes;




    public String getCaption() {
        return caption;
    }

    public void setCaption(String caption) {
        this.caption = caption;
    }

    public String getBase64photo() {
        return base64photo;
    }

    public void setBase64photo(String base64photo) {
        this.base64photo = base64photo;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getAccountId() {
        return accountId;
    }

    public void setAccountId(String accountId) {
        this.accountId = accountId;
    }

    public byte[] getPhotobytes() {
        return photobytes;
    }

    public void setPhotobytes(byte[] photobytes) {
        this.photobytes = photobytes;
    }

    public LocalDateTime getDateTime() {
        return dateTime;
    }

    public void setDateTime(LocalDateTime dateTime) {
        this.dateTime = dateTime;
    }

    public List<Comments> getComments() {
        return comments;
    }

    public void setComments(List<Comments> comments) {
        this.comments = comments;
    }

    public List<Likes> getLikes() {
        return likes;
    }

    public void setLikes(List<Likes> likes) {
        this.likes = likes;
    }

    public Post(Long id, String accountId, String caption, byte[] image, String photo, LocalDateTime dateTime, List<Comments> comments, List<Likes> likes) {
        this.id = id;
        this.accountId = accountId;
        this.base64photo = photo;
        this.photobytes = image;
        this.dateTime = dateTime;
        this.comments = comments;
        this.likes = likes;
        this.caption = caption;
    }

    public Post() {
    }

    @Override
    public int compareTo(Post o) {
        return o.dateTime.compareTo(this.dateTime);
    }
}
