package com.Harsh Pratap Singh.repo;

import com.Harsh Pratap Singh.models.PendingTransaction;

import java.util.List;

public interface TransactionRepo {
    List<PendingTransaction> findPendingTransactions(String id);

    void save(PendingTransaction pt);

    PendingTransaction findTransaction(Long transactionId);

    void remove(PendingTransaction pt);

    List<PendingTransaction> findSettledTransactions(String id);
}
