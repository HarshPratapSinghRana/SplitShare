package com.Harsh Pratap Singh.dto;

import com.Harsh Pratap Singh.models.enums.TransactionStatus;

import java.util.Date;

public class TransactionDTO {
    private Long id;
    private String fromId;
    private String byId;
    private String toId;
    private double amount;
    private String date;
    private String status;
    private String reason;
    private String settleDate;
    private String settleComment;
    private String settledBy;

    public String getSettledBy() {
        return settledBy;
    }

    public void setSettledBy(String settledBy) {
        this.settledBy = settledBy;
    }

    public String getSettleDate() {
        return settleDate;
    }

    public void setSettleDate(String settleDate) {
        this.settleDate = settleDate;
    }

    public String getSettleComment() {
        return settleComment;
    }

    public void setSettleComment(String settleComment) {
        this.settleComment = settleComment;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getFromId() {
        return fromId;
    }

    public void setFromId(String fromId) {
        this.fromId = fromId;
    }

    public String getById() {
        return byId;
    }

    public void setById(String byId) {
        this.byId = byId;
    }

    public String getToId() {
        return toId;
    }

    public void setToId(String toId) {
        this.toId = toId;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public TransactionDTO(Long id, String reason, String fromId, String byId, String toId, double amount, String date, String status, String settleDate, String settleComment, String settledBy) {
        this.id = id;
        this.fromId = fromId;
        this.byId = byId;
        this.toId = toId;
        this.amount = amount;
        this.date = date;
        this.status = status;
        this.reason = reason;
        this.settleComment = settleComment;
        this.settleDate = settleDate;
        this.settledBy = settledBy;
    }

    public TransactionDTO() {
    }
}
