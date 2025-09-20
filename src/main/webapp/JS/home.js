// Accept Friend Request

        let selectedTransactions = [];
        let totalAmount = 0;
        let accountId = null;
        let resultsContainer = document.getElementById("searchResults");
        function acceptRequest(requestId, button) {
            let url = "/acceptRequest?id="+requestId;
            console.log("Accepting friend request from:", requestId);
            fetch(url, {
                method: 'POST',
            })
            .then(response => {
                if (response.ok) {
                    // Remove the request from the list
                    const listItem = button.closest('li');
                    listItem.parentNode.removeChild(listItem);
                } else {
                    alert("Failed to accept friend request. Try again.");
                }
            })
            .catch(err => console.error(err));
        }

        // Reject Friend Request
        function rejectRequest(requestId, button) {
            let url = "/rejectRequest?id="+requestId;
            console.log("Rejecting friend request from:", requestId);
            fetch(url, {
                method: 'POST',
            })
            .then(response => {
                if (response.ok) {
                    // Remove the request from the list
                    const listItem = button.closest('li');
                    listItem.parentNode.removeChild(listItem);
                } else {
                    alert("Failed to reject friend request. Try again.");
                }
            })
            .catch(err => console.error(err));
        }
        window.sendFriendRequest = function(friendId, button) {
            let url = "/addFriend?id="+friendId;
            console.log("Sending friend request to:", friendId);
            fetch(url, {
                method: 'POST',
            })
                .then(response => {
                    if (response.ok) {
                        // Hide "Add Friend" button and show "Withdraw" button
                        button.style.display = "none";
                        const withdrawButton = button.nextElementSibling;
                        withdrawButton.style.display = "inline-block";
                    } else {
                        alert("Failed to send friend request. Try again.");
                    }
                })
                .catch(err => console.error(err));
        }

        window.withdrawFriendRequest = function(friendId, button) {
            console.log("withdrawing friend request from:", friendId);
            let url = "/withdrawFriendRequest?id="+friendId;
            fetch(url, {
                method: 'POST',
            })
                .then(response => {
                    if (response.ok) {
                        // Hide "Withdraw" button and show "Add Friend" button
                        button.style.display = "none";
                        const addFriendButton = button.previousElementSibling;
                        addFriendButton.style.display = "inline-block";
                    } else {
                        alert("Failed to withdraw friend request. Try again.");
                    }
                })
                .catch(err => console.error(err));
        }

        function searchProfiles() {
            const inputElement = document.getElementById("searchInput");
            if (!inputElement) {
                console.error("Search input element not found!");
                return;
            }

            const query = inputElement.value.trim();

            // If the query length is less than 3, hide the search results
            const resultsContainer = document.getElementById("searchResults");
            if (!resultsContainer) {
                console.error("Search results container not found!");
                return;
            }

            if (query.length < 3) {
                resultsContainer.innerHTML = '';
                resultsContainer.style.display = 'none'; // Hide the results container
                return;
            }

            let url = "/searchProfiles?query=";
            if (query) {
                url += encodeURIComponent(query);
            }

            fetch(url)
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    return response.json();
                })
                .then(data => {
                    resultsContainer.innerHTML = '';
                    resultsContainer.style.display = 'block'; // Show the results container

                    data.forEach(account1 => {
                        const li = document.createElement("li");
                        const imageSrc = `data:image/jpeg;base64,${account1.profile.base64photo}`;
                        li.className = "list-group-item account-banner";
                        li.innerHTML = `
                            <img src="${imageSrc}" alt="Profile Photo" class="profile-photo-search">
                            <div class="account-info">
                                <p class="profile-name">${account1.profile.name}</p>
                                <p class="profile-id">${account1.id}</p>
                            </div>
                        `;
                        li.onclick = () => window.location.href = '/profile/' + account1.id;
                        resultsContainer.appendChild(li);
                    });
                })
                .catch(error => {
                    console.error("Error fetching profiles:", error);
                });
        }

        // Hide the search results list when clicking outside
        document.addEventListener('click', function (event) {
            const searchResults = document.getElementById("searchResults");
            const searchInput = document.getElementById("searchInput");
            if (
                searchResults &&
                !searchResults.contains(event.target) &&
                event.target !== searchInput
            ) {
                searchResults.style.display = 'none'; // Hide the results container
            }
        });



        function fetchAccountData() {
            fetch('/getAccountId')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Account not found in session');
                    }
                    return response.json();
                })
                .then(data => {
                    accountId = data.account;
                    console.log("session of: "+accountId);
                })
                .catch(error => {
                    console.error('Error fetching account data:', error);
                });
        }


/////////////////////////////creating posts/////////////////////////////


        // Open modals
        function openUploadPhotoModal() {
            const modal = new bootstrap.Modal(document.getElementById('uploadPhotoModal'));
            modal.show();
        }
        function openCreatePostModal() {
          const modal = new bootstrap.Modal(document.getElementById('createPostModal'));
          modal.show();
        }

        function openTransactionModal() {
            const modal = new bootstrap.Modal(document.getElementById('transactionModal'));
            modal.show();
            fetchTransactions();
        }

        //close modals
        function closeModals() {
            document.getElementById('createPostModal').style.display = 'none';
            document.getElementById('transactionModal').style.display = 'none';
            document.getElementById('uploadPhotoModal').style.display = 'none';
            document.getElementById('generatedImageModal').style.display = 'none';
            document.getElementById('generatedImageModal').style.display = 'none';
            document.querySelectorAll('.modal-backdrop').forEach(backdrop => backdrop.remove());
        }


        // Photo upload and preview
        function previewPhoto() {
            const fileInput = document.getElementById('photoInput');
            const file = fileInput.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    document.getElementById('photoPreview').src = e.target.result;
                    document.getElementById('photoPostButton').disabled = false;
                };
                reader.readAsDataURL(file);
            }
        }


        // Fetch and select transactions
        function fetchTransactions() {
            fetchAccountData();
            fetch('/getPendingTransactions')
                .then(response => response.json())
                .then(data => {
                    const transactionList = document.getElementById('transactionList');
                    transactionList.innerHTML = '';
                    totalAmount = 0;

                    data.forEach(transaction => {
                      if(transaction.toId === accountId){
                        const item = document.createElement('div');
                        item.className = 'list-group-item';
                        item.textContent = `${transaction.reason} - $${transaction.amount} (${transaction.date}) from ${transaction.fromId}`;
                        item.onclick = () => {
                            item.classList.toggle('active');
                            if (item.classList.contains('active')) {
                                selectedTransactions.push(transaction);
                                totalAmount += transaction.amount;
                            } else {
                                selectedTransactions = selectedTransactions.filter(t => t.id !== transaction.id);
                                totalAmount -= transaction.amount;
                            }
                            document.getElementById('totalAmount').textContent = totalAmount.toFixed(2);
                        };
                        transactionList.appendChild(item);
                      }
                    });
                });
        }

         function generateTransactionSummary() {
             const canvas = document.createElement('canvas');
             const ctx = canvas.getContext('2d');
             canvas.width = 600;
             canvas.height = 400;

             // Draw background color
             ctx.fillStyle = '#f0f0f0';
             ctx.fillRect(0, 0, canvas.width, canvas.height);

             // Add a border
             ctx.strokeStyle = '#000';
             ctx.lineWidth = 2;
             ctx.strokeRect(10, 10, canvas.width - 20, canvas.height - 20);

             // Add a photo to the canvas
             const image = new Image();
             image.src = '../../images/transactionPost.png'; // Replace with your image URL
             image.onload = function () {
                 // Draw the image to cover the entire canvas
                 ctx.drawImage(image, 0, 0, canvas.width, canvas.height);

                 // Add a semi-transparent overlay for better text readability
                 ctx.fillStyle = 'rgba(255, 255, 255, 0.7)';
                 ctx.fillRect(0, 0, canvas.width, canvas.height);

                 // Add the title
                 ctx.fillStyle = '#000';
                 ctx.font = '24px Arial';
                 ctx.fillText('Transaction Summary', 20, 40);

                 // List transactions
                 let y = 80;
                 ctx.font = '16px Arial';
                 selectedTransactions.forEach(transaction => {
                     ctx.fillText(`${transaction.reason} - $${transaction.amount} (${transaction.date}) : ${transaction.fromId}`, 20, y);
                     y += 30;
                 });
                 y += 30;

                 // Display total amount
                 ctx.font = '18px Arial';
                 ctx.fillText(`Total Amount: $${totalAmount.toFixed(2)}`, 20, y);

                 // Update the image source
                 document.getElementById('generatedImage').src = canvas.toDataURL();

                 // Show the modal
                 const modal = new bootstrap.Modal(document.getElementById('generatedImageModal'));
                 modal.show();
             };

             // Close any other open modals (if necessary)
             closeModals();
         }



        function postTransactionSummary() {
            const caption = document.getElementById('transactionCaption').value;
            const imageData = document.getElementById('generatedImage').src;

            const postData = {
                type: 'transactionSummary',
                caption: caption,
                image: imageData,
            };

            fetch('/createPost', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(postData)
            })
            .then(response => response.json())
            .then(data => {
                    // Show success message
                    const alertBox = document.createElement('div');
                    alertBox.classList.add('alert', 'alert-success', 'alert-dismissible', 'fade', 'show', 'fixed-top');
                    alertBox.setAttribute('role', 'alert');
                    alertBox.innerHTML = 'Posted Successfully! <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>';

                    // Append the alert box to the body or any other container
                    document.body.appendChild(alertBox);

                    // Automatically hide the alert after 1 second
                    setTimeout(() => {
                        alertBox.classList.remove('show');
                        alertBox.classList.add('fade');
                    }, 1000);
            })
            .catch(error => console.error('Error posting transaction summary:', error));


            closeModals();

        }

        function postPhoto() {
            const caption = document.getElementById('photoCaption').value;
            const imageData = document.getElementById('photoPreview').src;

            const postData = {
                type: 'photo',
                caption: caption,
                image: imageData
            };

            fetch('/createPost', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(postData)
            })
            .then(response => response.json())
            .then(data => {
                    // Show success message
                    const alertBox = document.createElement('div');
                    alertBox.classList.add('alert', 'alert-success', 'alert-dismissible', 'fade', 'show', 'fixed-top');
                    alertBox.setAttribute('role', 'alert');
                    alertBox.innerHTML = 'Posted Successfully! <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>';

                    // Append the alert box to the body or any other container
                    document.body.appendChild(alertBox);

                    // Automatically hide the alert after 1 second
                    setTimeout(() => {
                        alertBox.classList.remove('show');
                        alertBox.classList.add('fade');
                    }, 1000);
            })
            .catch(error => console.error('Error posting photo:', error));

            closeModals();
        }


////////////////////////////////////////////////////////////
//                POSTS
//////////////////////////////////////////////////////////////////

let currentPage = 0;
const pageSize = 5; // Number of posts per page

document.addEventListener("DOMContentLoaded", () => {
    const postDisplay = document.getElementById("postDisplay");
    const loadMoreButton = document.getElementById("loadMoreButton");

    // Load initial posts
    loadPosts();

    // Event: Load more posts
    loadMoreButton.addEventListener("click", loadPosts);


    function formatTimestamp(timestamp) {
                const parts = timestamp.split(',');
                const year = parts[0];
                const month = parts[1];
                const day = parts[2];
                const hour = parts[3];
                const minute = parts[4];
                const second = parts[5];
                let sec = null;
                if(parts[5] < 10) sec = '0'+parts[5];
                else sec = second;
                // Format the output as required
                return '['+year+'/'+month+'/'+day+', '+hour+':'+minute+':'+sec+']';
    }

    // Fetch posts from the server
    function loadPosts() {
        fetch(`/posts?page=${currentPage}&size=${pageSize}`)
            .then(response => {
                if (!response.ok) throw new Error("Failed to fetch posts");
                return response.json();
            })
            .then(data => {
                if (data.length === 0) {
                    loadMoreButton.style.display = "none";
                    return;
                }

                data.forEach(post => renderPost(post));
                currentPage++;
            })
            .catch(error => console.error("Error loading posts:", error));
    }

    // Render a single post
    function renderPost(post) {
        const postElement = document.createElement("div");
        postElement.className = "post";

        const commentsHTML = post.comments.map(comment => `
            <div class="comments">
                <p><strong>${comment.accountId}:</strong> ${comment.text}</p>
                ${comment.replies.map(reply => `
                    <div class="replies">
                        <p><strong>${reply.accountId}:</strong> ${reply.text}</p>
                    </div>
                `).join('')}
            </div>
        `).join('');
        postElement.innerHTML = `
            <img src="data:image/jpeg;base64,${post.base64photo}" alt="Post Photo">
            <div class="content">
                <p><strong>${post.accountId}</strong> ${post.caption}</p>
                <p class="text-muted"><i><small>${formatTimestamp((post.dateTime).toString())}</small></i></p>
                <button class="btn btn-sm btn-outline-primary like-button">Like (${post.likes.length})</button>
                <div>${commentsHTML}</div>
                <textarea class="form-control mt-2 reply-box" placeholder="Reply..."></textarea>
                <button class="btn btn-sm btn-primary mt-2 submit-reply">Submit Reply</button>
            </div>
        `;

        // Handle like and reply
        const likeButton = postElement.querySelector(".like-button");
        likeButton.addEventListener("click", () => handleLike(post.id));

        const replyButton = postElement.querySelector(".submit-reply");
        replyButton.addEventListener("click", () => handleComment(post.id, postElement));

        postDisplay.appendChild(postElement);
    }

    // Handle Like
    function handleLike(postId) {
        fetch(`/posts/${postId}/like`, { method: "POST" })
            .then(response => {
                if (!response.ok) throw new Error("Failed to like the post");
                alert("Post liked!");
            })
            .catch(error => console.error("Error liking post:", error));
    }

    // Handle Reply
    function handleComment(postId, postElement) {
        const replyBox = postElement.querySelector(".reply-box");
        const replyText = replyBox.value.trim();
        if (!replyText) {
            alert("Reply cannot be empty!");
            return;
        }
        fetch(`/posts/${postId}/comment`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ text: replyText })
        })
            .then(response => {
                if (!response.ok) throw new Error("Failed to submit reply");
                alert("Reply submitted!");
                replyBox.value = ""; // Clear reply box
            })
            .catch(error => console.error("Error submitting reply:", error));
    }
});


window.addEventListener("pageshow", function (event) {
    if (event.persisted) {
        location.reload();
    }
});

