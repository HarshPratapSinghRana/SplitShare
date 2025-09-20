<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home</title>
    <link rel="icon" type="image/png" href="../../images/favicon.png">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
    <!-- Cropper.js CSS -->
     <link href="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.css" rel="stylesheet">

    <link rel = "stylesheet" href="../../CSS/home.css">
    <script src="../../JS/home.js?v=1.0"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.js"></script>

 </head>
<body>
<div class="container-fluid">
    <div class="row mt-4">
        <!-- Left Sidebar -->
        <div class="col-md-3">
            <div class="card">
                <div class="card-body">
                    <div class="text-center mb-4">
                                    <c:set var="account" value="${sessionScope.account}" />
                                    <c:choose>
                                        <c:when test="${not empty account.profile.base64photo}">
                                            <img class="rounded-circle mb-3" src="data:image/jpeg;base64,${account.profile.base64photo}" alt="Profile Photo" style="width: 150px; height: 150px; object-fit: cover;">
                                        </c:when>
                                        <c:otherwise>
                                            <img class="rounded-circle mb-3" src="../../images/default-profile-photo.png" alt="Default Profile Photo" style="width: 150px; height: 150px; object-fit: cover;">
                                        </c:otherwise>
                                    </c:choose>
                    </div>

                    <!-- Navigation Links -->
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item"><a href="/profile/${sessionScope.account.id}" class="text-decoration-none">Profile</a></li>
                        <li class="list-group-item"><a href="/chat" class="text-decoration-none">Chats</a></li>
                        <li class="list-group-item"><a href="/friends" class="text-decoration-none">Friends</a></li>
                        <li class="list-group-item"><a href="/sentRequests" class="text-decoration-none">Sent Requests</a></li>
                        <li class="list-group-item"><a href="/ledger" class="text-decoration-none">Ledger</a></li>
                        <li class="list-group-item"><a href="/logout" class="text-decoration-none">Logout</a></li>
                    </ul>
                </div>
            </div>
        </div>


        <!-- Main Content -->
        <div class="col-md-6">
                    <!-- Search Bar -->
                    <div class="position-relative search-bar">
                        <input
                            type="text"
                            id="searchInput"
                            class="form-control"
                            placeholder="Search Profiles...(>2 characters)"
                            oninput="searchProfiles()"
                        />
                        <ul
                            id="searchResults"
                            class="search-results list-group position-absolute w-100 shadow-lg"
                            style="display: none; z-index: 1050; max-height: 200px; overflow-y: auto;"
                        ></ul>
                    </div>
                    <!-- Create Post Button -->
                    <div class="d-flex justify-content-end">
                        <button id="create-post-section" class="btn btn-primary" onclick="openCreatePostModal()">Create Post</button>
                    </div>

                    <!-- Bootstrap Modal for Create Post -->
                    <div class="modal fade" id="createPostModal" tabindex="-1" aria-labelledby="createPostModalLabel" aria-hidden="true">
                      <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                          <div class="modal-header">
                            <h5 class="modal-title" id="createPostModalLabel">Create Post</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                          </div>
                          <div class="modal-body">
                            <!-- Post Options -->
                            <div class="d-flex justify-content-between">
                              <button class="btn btn-outline-primary" onclick="openUploadPhotoModal()">Upload Photo</button>
                              <button class="btn btn-outline-primary" onclick="openTransactionModal()">Use Pending Transactions</button>
                            </div>
                          </div>
                          <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                          </div>
                        </div>
                      </div>
                    </div>

                    <div class="modal fade" id="uploadPhotoModal" tabindex="-1" aria-labelledby="uploadPhotoLabel" aria-hidden="true">
                                <div class="modal-dialog modal-lg">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="uploadPhotoLabel">Upload Photo</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <input type="file" id="photoInput" accept="image/*" class="form-control mb-3" onchange="previewPhoto()">
                                            <div id="photoPreviewContainer" class="text-center">
                                                <img id="photoPreview" class="img-fluid" style="max-height: 300px;">
                                            </div>
                                            <textarea id="photoCaption" class="form-control mt-3" rows="3" placeholder="Add a caption..."></textarea>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                            <button id="photoPostButton" class="btn btn-success" onclick="postPhoto()" data-bs-dismiss="modal" disabled>Post</button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Transaction Modal -->
                            <div class="modal fade" id="transactionModal" tabindex="-1" aria-labelledby="transactionModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-lg">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="transactionModalLabel">Select Transactions</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <div id="transactionList" class="list-group"></div>
                                            <div class="mt-3">
                                                <strong>Total Amount: </strong> $<span id="totalAmount">0</span>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                            <button class="btn btn-primary" onclick="generateTransactionSummary()">Generate Summary</button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Display Generated Image -->
                            <div class="modal fade" id="generatedImageModal" tabindex="-1" aria-labelledby="imageModalLabel" aria-hidden="true">
                              <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                  <div class="modal-header">
                                    <h5 class="modal-title" id="imageModalLabel">Generated Image</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                  </div>
                                  <div class="modal-body text-center">
                                    <img id="generatedImage" class="img-fluid" alt="Generated Summary">
                                    <textarea
                                      id="transactionCaption"
                                      class="form-control mt-3"
                                      rows="3"
                                      placeholder="Add a caption..."
                                    ></textarea>
                                  </div>
                                  <div class="modal-footer">
                                    <button class="btn btn-success" onclick="postTransactionSummary()">Post</button>
                                    <button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                  </div>
                                </div>
                              </div>
                            </div>
                    </div>



            <!-- Posts -->
            <div id="postContainer" class="container-fluid py-4">
                <div id="postDisplay" class="d-flex flex-column align-items-center"></div>
                <button id="loadMoreButton" class="btn btn-primary mt-3">Load More</button>
            </div>
        </div>


        <!-- Right Sidebar -->
        <div class="col-md-3">
            <!-- Friend Suggestions -->
            <c:if test="${not empty friendSuggestions}">
                <h5>Friend Suggestions</h5>
                <ul class="list-group">
                    <c:forEach var="friend" items="${friendSuggestions}">
                        <li class="list-group-item d-flex align-items-center justify-content-between">
                            <div class = "d-flex align-items-center">
                                <c:choose>
                                    <c:when test="${friend.profile.photobytes != null}">
                                        <img src="data:image/jpeg;base64,${friend.profile.base64photo}"
                                             alt="Friend Photo"
                                             class="rounded-circle me-2"
                                             style="width: 40px; height: 40px; object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="../../images/default-profile-photo.png"
                                             alt="Default Avatar"
                                             class="rounded-circle me-2"
                                             style="width: 40px; height: 40px; object-fit: cover;">
                                    </c:otherwise>
                                </c:choose>
                                <span>${friend.profile.name}</span>
                            </div>
                            <button class = "friend-action-btn add-friend-btn"
                                    data-friend-id ="${friend.id}"
                                    onclick = "sendFriendRequest('${friend.id}', this)">
                                    Add Friend
                            </button>
                            <button class = "friend-action-btn withdraw-friend-btn"
                                    data-friend-id ="${friend.id}"
                                    style="display: none;"
                                    onclick = "withdrawFriendRequest('${friend.id}', this)">
                                    Withdraw
                            </button>
                        </li>
                    </c:forEach>
                </ul>
            </c:if>

            <!-- Pending Requests Section -->
            <c:if test="${not empty pendingRequests}">
                <h5>Pending Requests</h5>
                <ul class="list-group">
                    <c:forEach var="request" items="${pendingRequests}">
                        <li class="list-group-item d-flex align-items-center justify-content-between">
                            <div class="d-flex align-items-center">
                                <c:choose>
                                    <c:when test="${request.profile.photobytes != null}">
                                        <img src="data:image/jpeg;base64,${request.profile.base64photo}"
                                             alt="Request Photo"
                                             class="rounded-circle me-2"
                                             style="width: 40px; height: 40px; object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="../../images/default-profile-photo.png"
                                             alt="Default Avatar"
                                             class="rounded-circle me-2"
                                             style="width: 40px; height: 40px; object-fit: cover;">
                                    </c:otherwise>
                                </c:choose>
                                <span>${request.profile.name}</span>
                            </div>
                            <button class="friend-action-btn accept-request-btn"
                                    data-request-id="${request.id}"
                                    onclick="acceptRequest('${request.id}', this)">
                                Accept
                            </button>
                            <button class="friend-action-btn reject-request-btn"
                                    data-request-id="${request.id}"
                                    onclick="rejectRequest('${request.id}', this)">
                                <i class="fas fa-trash"></i>
                            </button>
                        </li>
                    </c:forEach>
                </ul>
            </c:if>
        </div>

    </div>
</div>


<!-- Bootstrap CSS -->
<link href="https://unpkg.com/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Bootstrap Bundle with Popper -->
<script src="https://unpkg.com/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
