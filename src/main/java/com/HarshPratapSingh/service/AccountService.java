package com.Harsh Pratap Singh.service;

import com.Harsh Pratap Singh.models.Account;
import com.Harsh Pratap Singh.models.Profile;

import java.util.List;

public interface AccountService {
    Account findUser(String userId);
    boolean save(Account account);
    boolean checkForEmail(String email);
    boolean checkForId(String id);
    List<Account> searchProfiles(String query);

    void update(Account account);

    void merge(Account account);
}
