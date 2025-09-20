package com.Harsh Pratap Singh.service;

import com.Harsh Pratap Singh.dto.TransactionDTO;
import com.Harsh Pratap Singh.models.Account;
import com.Harsh Pratap Singh.models.PendingTransaction;

import java.util.List;
import java.util.Map;

public interface PendingTransactionService {
    static TransactionDTO getTransactionDTO(PendingTransaction pt){
        TransactionDTO transactionDTO = new TransactionDTO();
        transactionDTO.setId(pt.getId());
        transactionDTO.setById(pt.getByAccount().getId());
        transactionDTO.setFromId(pt.getFromAccount().getId());
        transactionDTO.setToId(pt.getToAccount().getId());
        transactionDTO.setAmount(pt.getAmount());
        transactionDTO.setReason(pt.getReason());
        transactionDTO.setDate(pt.getDate().toString());
        transactionDTO.setStatus(pt.getStatus().toString());
        if(pt.getSettleCommet()!= null) transactionDTO.setSettleComment(pt.getSettleCommet());
        if(pt.getSettleDate() !=null) transactionDTO.setSettleDate(pt.getSettleDate().toString());
        if(pt.getSettledBy()!=null) transactionDTO.setSettledBy(pt.getSettledBy());
        return transactionDTO;
    }

    List<PendingTransaction> findPendingTransactions(Account account);

    List<PendingTransaction> createTransactions(List<Map<String, Object>> payers, String reason, List<String> participants, String id);

    void saveTransactions(List<PendingTransaction> transactions);

    boolean settleTransaction(Long transactionId, String comment, String id);

    List<PendingTransaction> getSettledTransactions(String id);
}
