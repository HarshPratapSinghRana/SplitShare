package com.Harsh Pratap Singh.repo;

import com.Harsh Pratap Singh.models.Likes;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate5.LocalSessionFactoryBean;
import org.springframework.stereotype.Repository;

import javax.persistence.NoResultException;
import javax.transaction.Transactional;
import java.util.List;
import java.util.TreeSet;

@Repository
public class LikeRepoImpl implements LikeRepo{
    @Autowired
    private LocalSessionFactoryBean localSessionFactoryBean;
    private static final Logger logger = LogManager.getLogger(CommentRepoImpl.class.getName());

    private Session getCurrentSession(){
        return localSessionFactoryBean.getObject().getCurrentSession();
    }

    @Override
    @Transactional
    public List<Likes> getLikesFor(Long id) {
        try {
            Session session = getCurrentSession();
            Query query = session.createNativeQuery("select * From Likes where postid = :id", Likes.class);
            query.setParameter("id", id);
            return (List<Likes>) query.getResultList();
        }
        catch (NoResultException e1){
            logger.error(e1.getMessage());
            return null;
        } catch (Exception e) {
            logger.error("Error in getLikesFor in LikeRepo while retrieving Likes for a particular post.");
            logger.error(e.getMessage());
            return null;
        }
    }
}
