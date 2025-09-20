package com.Harsh Pratap Singh.repo;


import com.Harsh Pratap Singh.models.FriendRequests;

import java.util.List;

public interface FriendRequestsRepo {
    List<FriendRequests> findPendingRequestsBy(String id);

    void save(FriendRequests friendRequests);

    FriendRequests findRequest(String id, String id1);

    void remove(FriendRequests friendRequests);

    List<Object[]> findFriendSuggestions(String id);

    List<FriendRequests> findPendingRequestsTo(String id);

    List<FriendRequests> findAcceptedRequests(String id);
}
