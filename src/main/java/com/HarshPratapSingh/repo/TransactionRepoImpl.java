package com.Harsh Pratap Singh.repo;


import com.Harsh Pratap Singh.mappers.FriendRequestMapper;
import com.Harsh Pratap Singh.models.FriendRequests;
import com.Harsh Pratap Singh.models.PendingTransaction;
import com.Harsh Pratap Singh.models.enums.RequestStatus;
import com.Harsh Pratap Singh.models.enums.TransactionStatus;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate5.LocalSessionFactoryBean;
import org.springframework.stereotype.Repository;

import javax.persistence.NoResultException;
import javax.persistence.Tuple;
import javax.transaction.Transactional;
import java.util.Collections;
import java.util.List;

@Repository
public class TransactionRepoImpl implements TransactionRepo{
    @Autowired
    private LocalSessionFactoryBean localSessionFactoryBean;
    private static final Logger logger = LogManager.getLogger(TransactionRepoImpl.class.getName());

    private Session getCurrentSession(){
        return localSessionFactoryBean.getObject().getCurrentSession();
    }

    @Override
    @Transactional
    public List<PendingTransaction> findPendingTransactions(String id) {
        try {
            Session session = getCurrentSession();
            String s = "select * from pendingtransaction where (fromaccount_id = :id OR toaccount_id = :id) AND status = :stts";
            Query query = session.createNativeQuery(s, PendingTransaction.class);
            query.setParameter("id", id);
            query.setParameter("stts", TransactionStatus.PENDING.ordinal());
            return (List<PendingTransaction>) query.getResultList();
        }
        catch (NoResultException e1){
            logger.error(e1.getMessage());
            return null;
        }
        catch (RuntimeException e){
            logger.error("Error in findPendingTransaction in Transaction Repo.");
            logger.error(e.getMessage());
            throw new RuntimeException(e);
        }
    }

    @Override
    @Transactional
    public void save(PendingTransaction pt) {
        try{
            Session session = getCurrentSession();
            session.save(pt);
        }catch (RuntimeException e){
            logger.error(e.getMessage());
            throw new RuntimeException(e);
        }
    }

    @Override
    @Transactional
    public PendingTransaction findTransaction(Long transactionId) {
        try{
            Session session = getCurrentSession();
            return session.get(PendingTransaction.class, transactionId);
        }catch (RuntimeException e){
            logger.error(e.getMessage());
            throw new RuntimeException(e);
        }
    }

    @Override
    @Transactional
    public void remove(PendingTransaction pt) {
        try {
            Session session = getCurrentSession();
            session.remove(pt);
        }
        catch (RuntimeException e){
            logger.error(e.getMessage());
            throw new RuntimeException(e);
        }
    }

    @Override
    @Transactional
    public List<PendingTransaction> findSettledTransactions(String id) {
        try {
            Session session = getCurrentSession();
            String s = "select * from pendingtransaction where (fromaccount_id = :id OR toaccount_id = :id) AND status = :stts";
            Query query = session.createNativeQuery(s, PendingTransaction.class);
            query.setParameter("id", id);
            query.setParameter("stts", TransactionStatus.SETTLED.ordinal());
            return (List<PendingTransaction>) query.getResultList();
        }
        catch (NoResultException e1){
            logger.error(e1.getMessage());
            return null;
        }
        catch (RuntimeException e){
            logger.error("Error in findSettledTransaction in Transaction Repo.");
            logger.error(e.getMessage());
            throw new RuntimeException(e);
        }
    }
}
