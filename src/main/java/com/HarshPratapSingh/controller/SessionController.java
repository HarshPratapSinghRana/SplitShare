package com.Harsh Pratap Singh.controller;

import com.Harsh Pratap Singh.models.Account;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;


@RestController
public class SessionController {

    @GetMapping("/getAccountId")
    public ResponseEntity<Map<String, String>> getAccount(HttpSession session) {
        Account account = (Account) session.getAttribute("account");
        Map<String, String> map = new HashMap<>();
        map.put("account", account.getId());
        if (account != null) {
            System.out.println("Account of this sesssion returned to client...");
            return ResponseEntity.ok().header(HttpHeaders.CONTENT_TYPE, "application/json").body(map);
        } else {
            System.out.println("Account not found in this session...");
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(map);
        }
    }
}
