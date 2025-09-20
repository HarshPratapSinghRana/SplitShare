package com.Harsh Pratap Singh.dto;

import org.springframework.web.multipart.MultipartFile;

import javax.persistence.Lob;
import javax.persistence.Transient;

public class PostDto {
    private String type;
    private String caption;
    private String image;

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getCaption() {
        return caption;
    }

    public void setCaption(String caption) {
        this.caption = caption;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }
}
