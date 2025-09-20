package com.Harsh Pratap Singh.repo;

import com.Harsh Pratap Singh.models.Account;
import com.Harsh Pratap Singh.models.Profile;

import javax.persistence.criteria.CriteriaBuilder;
import java.util.HashSet;
import java.util.List;

public interface AccountRepo {
    Account findUser(String userId);

    boolean save(Account account);

    boolean checkForEmail(String email);

    boolean checkForId(String id);

    List<Account> findProfiles(String query);

    List<Account> getAccountsForFriends(Integer a);

    void update(Account account);

    void merge(Account account);
}
