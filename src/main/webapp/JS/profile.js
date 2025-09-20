         function openModal(postId) {
            // Fetch post details dynamically (using AJAX if needed)
            const post = posts.find(p => p.id === postId);
            document.getElementById('modalImage').src = `data:image/jpeg;base64,${post.base64photo}`;
            document.getElementById('modalLikes').textContent = `${post.likes} Likes`;

            const commentsSection = document.getElementById('modalComments');
            commentsSection.innerHTML = '';
            post.comments.forEach(comment => {
                const p = document.createElement('p');
                p.innerHTML = `<strong>${comment.accountId}:</strong> ${comment.text}`;
                commentsSection.appendChild(p);
            });

            // Show modal
            document.getElementById('postModal').style.display = 'flex';
        }

        function closeModal() {
            document.getElementById('postModal').style.display = 'none';
        }

        function submitComment() {
            const comment = document.getElementById('commentInput').value;
            // Send the comment to the backend via AJAX (implement this)
            alert(`Comment submitted: ${comment}`);
        }

        // Close modal on clicking outside
        window.onclick = function (event) {
            const modal = document.getElementById('postModal');
            if (event.target === modal) {
                closeModal();
            }
        };
        window.addEventListener("pageshow", function (event) {
            if (event.persisted) {
                location.reload();
            }
        });