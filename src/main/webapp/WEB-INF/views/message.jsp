<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Messenger</title>
    <link rel="icon" type="image/png" href="../../images/favicon.png">
    <link rel="stylesheet" href="..\..\CSS\chat.css">
    <style>

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #121212; /* Dark background for compatibility */
            color: #fff; /* Light text for contrast */
        }

        .messenger-container {
            display: flex;
            flex-direction: row;
            height: 100vh;
        }

        .friends-list {
            width: 25%;
            background-color: #1e1e1e;
            padding: 10px;
            overflow-y: auto;
            color: #ddd;
        }

        .friends-list h3 {
            margin-top: 0;
            color: #fff;
        }

        .friends-list ul {
            list-style: none;
            padding: 0;
        }

        .friends-list li {
            display: flex;
            align-items: center;
            padding: 10px;
            margin-bottom: 5px;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .friends-list li:hover,
        .friends-list li.active {
            background-color: #333;
        }

        .friend-photo {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 10px;
        }

        .friend-info {
            flex: 1;
        }

        .friend-name {
            font-weight: bold;
            margin: 0;
            color: #fff;
        }

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.9); /* Modal background */
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }

        .modal-content {
            width: 80%;
            height: 80%;
            background-color: #292929;
            border-radius: 8px;
            display: flex;
            flex-direction: column;
            padding: 10px;
        }
        .terminal-input {
            display: flex;
            padding: 10px;
            align-items: center;
            gap: 10px;
        }

        .terminal-input input {
            flex: 1;
            padding: 8px;
            border-radius: 5px;
            border: none;
            outline: none;
        }

        .terminal-input button {
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 8px 12px;
            cursor: pointer;
        }

        .default-icon {
            text-align: center;
            color: #ccc;
        }

        .default-chat-photo {
            width: 80px;
            margin-bottom: 10px;
        }


        /* Container for the chat messages */
        #chatMessages {
            max-height: 400px;
            overflow-y: auto;
            padding: 10px;
            background-color: #000;
            color: white;
            font-family: monospace;
            border: 1px solid #333;
        }

        /* Styling for each message */
        .message-wrapper {
            margin: 10px 0;
        }

        /* Common styling for both sent and received messages */
        .message-header {
            font-weight: bold;
            font-size: 0.9em;
            color: #aaa;
            margin-bottom: 2px;
        }

        .message-content {
            padding: 5px;
            margin-top: 5px;
            font-size: 1.1em;
        }

        /* Styling for sent messages */
        .sent {
            text-align: right;
        }

        .sent-message {
            color : green;
            padding: 5px;
            border-radius: 5px;
        }

        /* Styling for received messages */
        .received {
            text-align: left;
        }

        .received-message {
            color: #FFFFE0;
            padding: 5px;
            border-radius: 5px;
        }

        /* Styling for the input field */
        .terminal-input {
            display: flex;
            margin-top: 10px;
        }

        .terminal-input input {
            flex-grow: 1;
            padding: 5px;
            background-color: #333;
            color: white;
            border: none;
            border-radius: 5px;
        }

        .terminal-input button {
            padding: 5px 10px;
            margin-left: 10px;
            background-color: green;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .terminal-input button:hover {
            background-color: darkgreen;
        }

        /* Terminal-like Chat Styling */
        .terminal-chat {
            font-family: monospace;
            color: #ddd;
            background-color: #292929;
            padding: 10px;
            height: calc(100% - 60px); /* Adjust for input section */
            overflow-y: auto;
            flex: 1;
            overflow-y: auto;
            border-bottom: 1px solid #444;
        }

        .message-wrapper {
            display: flex;
            flex-direction: column;
            margin-bottom: 5px;
            margin: 10px 0;
        }

        .message.sent .message-content {
            color: #4caf50; /* Green for sent messages */
            white-space: pre-wrap;
            color: green;
            padding: 10px;
            border-radius: 5px;
            margin-left: auto;
            max-width: 60%;
        }

        .message.received .message-content {
            color: #ffffff; /* White for received messages */
            white-space: pre-wrap;
            color: white;
            padding: 10px;
            border-radius: 5px;
            margin-right: auto;
            max-width: 60%;
        }

    </style>
</head>
<body>
    <div class="messenger-container">
        <!-- Left Sidebar -->
        <div class="friends-list">
            <h3>Your Friends</h3>
            <ul>
                <c:forEach var="friend" items="${friends}">
                    <li data-friend-id="${friend.id}">
                        <img src="data:image/jpeg;base64,${friend.base64photo}" alt="Profile Picture" class="friend-photo">
                        <div class="friend-info">
                            <p class="friend-name">${friend.name}</p>
                            <p class="last-message-content">${friend.lastMessage.content}</p>
                        </div>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </div>

    <div id="terminalModal" class="modal">
        <div class="modal-content">
            <div id="chatMessages" class="terminal-chat"></div>
            <div class="terminal-input">
                <input type="text" id="messageInput" placeholder="Type your message..." />
                <button id="sendMessageButton">Send</button>
            </div>
        </div>
    </div>

    <template id="message-template">
        <div class="message-wrapper">
            <div class="message-header">
                <span class = "sender-name"></span>
                <span class = "timestamp"></span>
            </div>
            <div class="message-content"></div>
        </div>
    </template>

    <script>
        const userId = "${sessionScope.account.id}";

        const hostname = window.location.hostname;
        const portno = window.location.port;
        const socketUrl = "wss://"+hostname+":"+portno+"/chat/" + userId;
        let socket = null;
        let selectedFriendId = null;
        const chatMessages = document.getElementById('chatMessages');
        const messageInput = document.getElementById('messageInput');
        const modal = document.getElementById('terminalModal');

        // WebSocket initialization
        function initSocket() {
            socket = new WebSocket(socketUrl);

            socket.onopen = () => console.log("WebSocket connected.");
            socket.onmessage = event => {
                const message = JSON.parse(event.data);
                if (message.senderId === selectedFriendId || message.receiverId === selectedFriendId) {
                    displayMessage(message, 'received');
                }
            };
            socket.onclose = () => {
                console.log("WebSocket closed. Reconnecting...");
                setTimeout(initSocket, 3000);
            };
            socket.onerror = error => console.error("WebSocket error:", error);
        }

        initSocket();

        // Send Message
        document.getElementById('sendMessageButton').addEventListener('click', sendMessage);
        function sendMessage() {
            const content = messageInput.value.trim();
            if (content && selectedFriendId) {
                const message = { senderId: userId, receiverId: selectedFriendId, content, timestamp: new Date().toISOString() };
                socket.send(JSON.stringify(message));
                displayMessage(message, 'sent');
                messageInput.value = '';
            } else {
                alert("Please select a friend first.");
            }
        }

        function formatTimestamp(timestamp) {
            // Split the timestamp string into an array
            const parts = timestamp.split(',');

            // Extract the necessary components
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
            return '['+year+'/'+month+'/'+day+', '+hour+':'+minute+':'+sec+'] :~';
        }
        function formatTimestamp2(timestamp) {
            // Create a new Date object from the ISO string
            const date = new Date(timestamp);

            // Get the date parts
            const year = date.getFullYear();
            const month = date.getMonth() + 1; // Months are 0-based, so add 1
            const day = date.getDate();

            // Get the time parts (hours, minutes, seconds)
            const hours = date.getHours();
            const minutes = date.getMinutes().toString().padStart(2, '0'); // Ensure two digits
            const seconds = date.getSeconds().toString().padStart(2, '0'); // Ensure two digits

            // Format the output
            return '['+year+'/'+month+'/'+day+', '+hours+':'+minutes+':'+seconds+'] :~';;
        }


        // Display Message
        function displayMessage(message, type) {
            const template = document.getElementById('message-template');
            const messageNode = template.content.cloneNode(true);
            const messageWrapper = messageNode.querySelector('.message-wrapper');
            const messageHeader = messageNode.querySelector('.message-header');
            const messageContent = messageNode.querySelector('.message-content');
            const senderNameElement = messageNode.querySelector('.sender-name');
            const timestampElement = messageNode.querySelector('.timestamp');

            messageWrapper.classList.add(type);

            const senderName = type === 'sent' ? 'You' : message.senderId || 'Unknown';
            let timestamp = null;
            if(typeof message.timestamp === 'object') timestamp = formatTimestamp((message.timestamp).toString());
            else timestamp = formatTimestamp2(message.timestamp);
            senderNameElement.textContent = senderName;
            timestampElement.textContent = timestamp;

            messageContent.textContent = message.content || "No content";

            if (type === 'sent') {
                messageWrapper.classList.add('sent');
                messageContent.classList.add('sent-message');
            } else {
                messageWrapper.classList.add('received');
                messageContent.classList.add('received-message');
            }
            chatMessages.appendChild(messageNode);
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }


        // Load Chat History
        function loadChatHistory(friendId) {
            if (!friendId) return;
            selectedFriendId = friendId;
            chatMessages.innerHTML = '';
            modal.style.display = 'flex';
            fetch("/fetchChatHistory/" + friendId)
                .then(response => response.json())
                .then(messages => {
                    messages.forEach(msg => displayMessage(msg, msg.senderId === userId ? 'sent' : 'received'));
                })
                .catch(error => console.error("Error fetching chat history:", error));

            setTimeout(() => messageInput.focus(), 1000);
        }

        // Friend Selection
        document.querySelectorAll('.friends-list li').forEach(friend => {
            friend.addEventListener('click', function () {
                document.querySelectorAll('.friends-list li').forEach(li => li.classList.remove('active'));
                this.classList.add('active');
                loadChatHistory(this.dataset.friendId);
            });
        });

        // Close Modal on Outside Click
        window.addEventListener('click', event => {
            if (event.target === modal) modal.style.display = 'none';
        });

        messageInput.addEventListener("keypress", function (event) {
            if (event.key === "Enter") {
                event.preventDefault(); // Prevents adding a new line
                sendMessage();
            }
        });


    </script>
</body>
</html>
