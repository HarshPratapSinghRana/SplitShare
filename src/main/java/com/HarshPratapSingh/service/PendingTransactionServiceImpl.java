package com.Harsh Pratap Singh.service;

import com.Harsh Pratap Singh.dto.PaidDTO;
import com.Harsh Pratap Singh.models.Account;
import com.Harsh Pratap Singh.models.PendingTransaction;
import com.Harsh Pratap Singh.models.enums.TransactionStatus;
import com.Harsh Pratap Singh.repo.AccountRepo;
import com.Harsh Pratap Singh.repo.TransactionRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.PreDestroy;
import javax.transaction.Transactional;
import java.time.LocalDate;
import java.util.*;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

@Service
public class PendingTransactionServiceImpl implements PendingTransactionService{
    @Autowired
    private AccountRepo accountRepo;
    @Autowired
    private TransactionRepo transactionRepo;
    private static final ExecutorService executorService = Executors.newCachedThreadPool(); // Handles scaling dynamically


    private PendingTransaction getNewTransaction(double amount, String fromId, String toId, String byId, String reason){
        PendingTransaction transaction = new PendingTransaction();

        Account byAccount = accountRepo.findUser(byId);
        Account toAccount = accountRepo.findUser(toId);
        Account fromAccount = accountRepo.findUser(fromId);
        if(byAccount == null || toAccount == null || fromAccount == null){
            throw new RuntimeException("Account not found while creating Transactions for the record you entered. In PendingTransaction Service.");
        }
        transaction.setDate(LocalDate.now());
        transaction.setAmount(amount);
        transaction.setByAccount(byAccount);
        transaction.setFromAccount(fromAccount);
        transaction.setToAccount(toAccount);
        transaction.setStatus(TransactionStatus.PENDING);
        transaction.setReason(reason);
        return transaction;
    }
    @Override
    public List<PendingTransaction> findPendingTransactions(Account account) {
        try {
            return executorService.submit(() -> transactionRepo.findPendingTransactions(account.getId())).get();
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        } catch (ExecutionException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public List<PendingTransaction> createTransactions(List<Map<String, Object>> payers, String reason, List<String> participants, String id) {
        System.out.println("payers: " +payers.size() + " other : " +participants.size());
        List<PendingTransaction> list = new ArrayList<>();
        List<PaidDTO> allParticipants = new ArrayList<>();
        int total = 0, cnt = 0;
        for(Map<String, Object> mp: payers){
            Integer val = (Integer) mp.get("amount");
            String id1 = (String) mp.get("id");
            total += val; cnt++;
            allParticipants.add(new PaidDTO(id1, 1.0*val));
        }
        for(String s: participants){
            allParticipants.add(new PaidDTO(s, 0.0));
            cnt++;
        }
        Collections.sort(allParticipants);
        double equalSection = 1.0*total/cnt;

        int it1 = 0, it2 = allParticipants.size()-1;
        while(it1 < it2){
//            System.out.println(it1 + " " + it2);
            PaidDTO paidDTO2 = allParticipants.get(it2);
            PaidDTO paidDTO1 = allParticipants.get(it1);
            double paid = paidDTO2.getAmount();
            if(paid < equalSection){
                double toPay = equalSection-paid;
                if(paidDTO1.getAmount()-toPay >= equalSection){
                    PendingTransaction transaction = getNewTransaction(equalSection-paid, paidDTO2.getId(), paidDTO1.getId(), id, reason);
                    list.add(transaction);
                    it2--;
                    paidDTO1.setAmount(paidDTO1.getAmount()-(equalSection-paid));
//                    System.out.println(transaction);
                }else{
                    PendingTransaction transaction = getNewTransaction(paidDTO1.getAmount()-equalSection, paidDTO2.getId(), paidDTO1.getId(), id, reason);
                    list.add(transaction);
                    it1++;
                    paidDTO2.setAmount(paid+paidDTO1.getAmount()-equalSection);
                    paidDTO1.setAmount(equalSection);
//                    System.out.println(transaction);
                }
            }else{
                it2--;
            }
        }
        return list;
    }

    @Override
    @Transactional
    public void saveTransactions(List<PendingTransaction> transactions) {
        for(PendingTransaction pt: transactions){
            transactionRepo.save(pt);
        }
    }

    @Override
    @Transactional
    public boolean settleTransaction(Long transactionId, String comment, String id) {
        PendingTransaction pt = transactionRepo.findTransaction(transactionId);
        if(pt != null) {
            transactionRepo.remove(pt);
            pt.setStatus(TransactionStatus.SETTLED);
            pt.setSettleCommet(comment);
            pt.setSettleDate(LocalDate.now());
            pt.setSettledBy(id);
            transactionRepo.save(pt);
            return true;
        }
        return false;
    }

    @Override
    public List<PendingTransaction> getSettledTransactions(String id) {
        try {
            return executorService.submit(() -> transactionRepo.findSettledTransactions(id)).get();
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        } catch (ExecutionException e) {
            throw new RuntimeException(e);
        }
    }

    @PreDestroy
    public void shutdownExecutor() {
        try {
            executorService.shutdown();
            if (!executorService.awaitTermination(60, TimeUnit.SECONDS)) {
                executorService.shutdownNow();
            }
        } catch (InterruptedException e) {
            executorService.shutdownNow();
        }
    }
}
