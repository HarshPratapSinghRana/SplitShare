package com.Harsh Pratap Singh.service;

import com.Harsh Pratap Singh.models.Account;
import com.Harsh Pratap Singh.models.Profile;
import com.Harsh Pratap Singh.repo.AccountRepo;
import com.Harsh Pratap Singh.repo.AccountRepoImpl;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;


@Service
public class AccountServiceImpl implements AccountService {
    private static final Logger logger = LogManager.getLogger(AccountRepoImpl.class.getName());
    @Autowired
    private AccountRepo accountRepo;

    @Override
    public Account findUser(String userId) {
        Account account = accountRepo.findUser(userId);
        account.getProfile().setBase64photo(Base64.getEncoder().encodeToString(account.getProfile().getPhotobytes()));
        return account;
    }

    @Override
    public boolean save(Account account) {
        return accountRepo.save(account);
    }
    @Override
    public void update(Account account){
        accountRepo.update(account);
    }

    @Override
    public void merge(Account account) {
        accountRepo.merge(account);
    }

    @Override
    public boolean checkForEmail(String email) {
        return accountRepo.checkForEmail(email);
    }

    @Override
    public boolean checkForId(String id) {
        return accountRepo.checkForId(id);
    }

    @Override
    public List<Account> searchProfiles(String query) {
        List<Account> list = accountRepo.findProfiles(query);
        for(Account account: list){
            account.getProfile().setBase64photo(Base64.getEncoder().encodeToString(account.getProfile().getPhotobytes()));
        }
        return list;
    }


}
