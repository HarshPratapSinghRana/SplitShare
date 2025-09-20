<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ledger</title>
    <link rel="icon" type="image/png" href="../../images/favicon.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

    <script src="https://cdn.jsdelivr.net/npm/vue@2.6.14/dist/vue.js"></script>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            padding: 20px;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
        }
        input, select, textarea, button {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        textarea {
            resize: none;
        }
        .btn {
            background-color: #007bff;
            color: #fff;
            border: none;
            cursor: pointer;
            margin-top: 20px;
            padding: 10px;
        }
        .btn:disabled {
            background-color: #aaa;
            cursor: not-allowed;
        }
        .selected-list {
            list-style: none;
            padding: 0;
        }
        .selected-list li {
            margin: 5px 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .remove-btn {
            background-color: #ff0000; /* Red background */
            color: #fff; /* White icon color */
            border: none; /* No border */
            cursor: pointer; /* Pointer cursor on hover */
            padding: 0; /* No extra padding */
            border-radius: 50%; /* Circular button */
            font-size: 12px; /* Smaller icon size */
            display: flex;
            justify-content: center; /* Center the icon horizontally */
            align-items: center; /* Center the icon vertically */
            width: 20px; /* Small width */
            height: 20px; /* Small height */
            text-align: center; /* Align text */
        }
        .remove-btn i {
            font-size: 10px; /* Adjust icon size */
            margin: 0; /* No margin */
        }
        .remove-btn:hover {
            background-color: #cc0000;
        }
        .amount-display {
            position: absolute;
            top: 10px;
            right: 10px;
            font-size: 24px;
            font-weight: bold;
            color: #0000FF; /* Blue color for amount */
            background-color: #ADD8E6; /* Light blue background */
            padding: 5px 10px;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        }
        .created-by-display {
            position: relative;
            bottom: 10px;
            right: 10px;
            font-size: 14px;
            color: #0000FF;
            padding: 5px 10px;
            border-radius: 5px;
        }
        .poster {
            position: relative;
            border: 1px solid #ccc;
            border-radius: 5px;
            padding: 10px;
            margin-bottom: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .poster-expect{
            background-color: #ADD8E6;
        }
        .poster-owe{
            background-color: #D2B48C;
        }
        .poster button {
            margin-top: 10px;
        }

        .poster-button:hover {
            background-color: white;
        }

        .transaction-container {
            display: flex;
            justify-content: space-between;
            gap: 20px; /* Space between the sections */
        }

        .section {
            flex: 1; /* Ensure sections take equal space */
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 10px;
            background-color: #f9f9f9;
        }
        .summary {
            margin-bottom: 20px;
            padding: 10px;
            background-color: #f1f1f1;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .summary p {
            margin: 0;
            font-size: 16px;
        }
        /* Button to fetch settled transactions */
        .fetch-settled-btn {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            font-size: 16px;
            transition: background-color 0.3s;
        }

        .fetch-settled-btn:hover {
            background-color: #388E3C;
        }

        /* Modal Overlay */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }

        /* Modal Content */
        .modal-content {
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            width: 50%;
            max-height: 80%;
            overflow-y: auto; /* Enables scrolling for content */
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            position: relative;
        }

        /* Close button inside modal */
        .close-modal-btn {
            background: none; /* No background */
            border: none; /* No border */
            color: #f44336; /* Red color for the cross */
            font-size: 1.5rem; /* Adjust font size */
            font-weight: bold; /* Boldens the "X" */
            cursor: pointer;
            position: absolute;
            top: 10px;
            right: 10px;
            padding: 0; /* No padding */
            line-height: 1; /* Ensures no extra spacing */
            width: auto; /* Ensures it doesn’t stretch */
            height: auto; /* Ensures it doesn’t stretch */
            transition: color 0.3s;
            display: inline-block; /* Prevents it from behaving as a block element */
        }

        .close-modal-btn:hover {
            background-color: #d32f2f;
        }

        /* Transaction List Styling */
        .transaction-item {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            margin-bottom: 10px;
        }

        .transaction-item strong {
            font-weight: bold;
        }

        /* Add some margin to the modal header */
        .modal-content h3 {
            margin-bottom: 20px;
        }




    </style>
</head>
<body>
    <div id="app" class="container">
        <h2>Ledger Entry</h2>
        <form id="ledgerForm" @submit.prevent="submitForm">
            <!-- Reason -->
            <div class="form-group">
                <label for="reason">Reason & Place:</label>
                <textarea v-model="reason" placeholder="Mention the reason and place of expenditure" rows="3" required></textarea>
            </div>

            <!-- Payers -->
            <div class="form-group">
                <label for="payer">Add Payer:</label>
                <select v-model="selectedPayer" :disabled="availablePayers.length === 0">
                    <option value="" disabled>Select a payer</option>
                    <option v-for="friend in availablePayers" :key="friend.id" :value="friend.id">
                        {{ friend.name }}
                    </option>
                </select>
                <button type="button" @click="addPayer" :disabled="!selectedPayer">Add Payer</button>
                <ul class="selected-list">
                    <li v-for="payer in payers" :key="payer.id">
                        {{ payer.name }}
                        <input type="number" v-model.number="payer.amount" placeholder="Enter amount" required />
                        <button type="button" class="remove-btn" @click="removePayer(payer.id)">
                            <i class="fas fa-trash-alt"></i>
                        </button>
                    </li>
                </ul>
            </div>

            <!-- Participants -->
            <div class="form-group">
                <label for="participant">Add Non Paying Participants:</label>
                <select v-model="selectedParticipant" :disabled="availableParticipants.length === 0">
                    <option value="" disabled>Select a participant</option>
                    <option v-for="friend in availableParticipants" :key="friend.id" :value="friend.id">
                        {{ friend.name }}
                    </option>
                </select>
                <button type="button" @click="addParticipant" :disabled="!selectedParticipant">Add Participant</button>
                <ul class="selected-list">
                    <li v-for="participant in participants" :key="participant.id">
                        {{ participant.name }}
                        <button type="button" class="remove-btn" @click="removeParticipant(participant.id)">
                            <i class="fas fa-trash-alt"></i>
                        </button>
                    </li>
                </ul>
            </div>

            <!-- Submit -->
            <button type="submit" class="btn" :disabled="payers.length === 0">Create Transactions</button>
        </form>
        <ul v-if ="transactions.length > 0">
            <h5> This Expense will Create: </h5>
            <li v-for="transaction in transactions" :key="transaction.id">
                        From: {{ transaction.fromAccount.id }} <br />
                        To: {{ transaction.toAccount.id }} <br />
                        By: {{ transaction.byAccount.id }} <br />
                        Reason: {{ transaction.reason }} <br />
                        Amount: {{ transaction.amount }} <br />
                        Date: {{ transaction.date }} <br />
                        <hr />
            </li>

        </ul>
        <div v-if="transactions.length > 0">
                <button class="btn btn-primary" @click="confirmTransactions">Confirm</button>
                <button class="btn btn-secondary" @click="cancelTransactions">Cancel</button>
        </div>

    </div>

    <div id="app1">
        <!-- Button to fetch settled transactions -->
        <button @click="fetchSettledTransactions" class="fetch-settled-btn">Fetch Settled Transactions</button>

        <!-- Modal for displaying settled transactions -->
        <div v-if="showModal" class="modal-overlay" @click="closeModal">
            <div class="modal-content" @click.stop>
                <button class="close-modal-btn" @click="closeModal">&times;</button>
                <h3>Settled Transactions</h3>
                <ul v-if="settledTransactions.length > 0">
                    <li v-for="(transaction, index) in settledTransactions" :key="transaction.id" class="transaction-item">
                        <strong>Transaction ID:</strong> {{ transaction.id }}<br />
                        <strong>From:</strong> {{ transaction.fromId }}<br />
                        <strong>To:</strong> {{ transaction.toId }}<br />
                        <strong>Amount:</strong> ₹{{ transaction.amount }}<br />
                        <strong>Reason:</strong> {{ transaction.reason }}<br />
                        <strong>Created On:</strong> {{ transaction.date }}<br />
                        <strong>Comment:</strong> {{ transaction.settleComment }}<br />
                        <strong>Settled On:</strong> {{ transaction.settleDate }}<br />
                        <strong>Settled By:</strong> {{ transaction.settledBy }}<br />
                        <hr />
                    </li>
                </ul>
                <p v-else>No settled transactions found.</p>
            </div>
        </div>
    </div>


    <div id="app2">
        <h3>Pending Transactions</h3>

        <div v-if="pendingTransactions.length > 0" class="transaction-container">
            <div class = "section">
                <h4>I Owe</h4>
                <div class="summary">
                                <p><strong>Total I Owe:</strong> {{ totalOwe }}</p>
                </div>
                <div class="poster poster-owe" v-for="transaction in oweTransactions" :key="transaction.id">
                    <div class="amount-display">
                            ₹{{ transaction.amount }}
                    </div>
                    <div class="created-by-display">
                            author: {{ transaction.byId }}
                    </div>
                    <strong>To:</strong> {{ transaction.toId }} <br />
                    <strong>Reason:</strong> {{ transaction.reason }} <br />
                    <strong>Date:</strong> {{ transaction.date }} <br />
                    <strong>Status:</strong> {{ transaction.status }} <br />
                    <button class = "poster-button" @click="settleTransaction(transaction.id)">Settle</button>
                    <div v-if="settleTransactionId === transaction.id">
                        <input
                            type="text"
                            v-model="settleComment"
                            placeholder="Enter comment"
                        />
                        <button class = "poster-button" @click="sendComment(transaction.id)">Submit</button>
                    </div>
                    <hr />
                </div>
            </div>
            <div class = "section">
                <h4>I Expect</h4>
                <div class="summary">
                                <p><strong>Total I Expect:</strong> {{ totalExpect }}</p>
                </div>
                <div class="poster poster-expect" v-for="transaction in expectTransactions" :key="transaction.id">
                    <div class="amount-display">
                            ₹{{ transaction.amount }}
                    </div>
                    <div class="created-by-display">
                            author: {{ transaction.byId }}
                    </div>
                    <strong>From:</strong> {{ transaction.fromId }} <br />
                    <strong>Reason:</strong> {{ transaction.reason }} <br />
                    <strong>Date:</strong> {{ transaction.date }} <br />
                    <strong>Status:</strong> {{ transaction.status }} <br />
                    <button class = "poster-button" @click="settleTransaction(transaction.id)">Settle</button>
                    <div v-if="settleTransactionId === transaction.id">
                        <input
                            type="text"
                            v-model="settleComment"
                            placeholder="Enter comment"
                        />
                        <button class = "poster-button" @click="sendComment(transaction.id)">Submit</button>
                    </div>
                    <hr />
                </div>
            </div>
        </div>

        <p v-else>All Settled.</p>
    </div>



    <script>


        window.addEventListener("pageshow", function (event) {
            if (event.persisted) {
                location.reload();
            }
        });


        // Use server-side variables to initialize Vue.js app
        const friendsJson = ${friendsJson};
        const accountJson = ${accountJson};
        const userId = accountJson.id;
        const pendingTransactionsJson = ${pendingTransactionsJson};
        const hostname = window.location.hostname;
        const portno = window.location.port;
        const socketUrl = "wss://"+hostname+":"+portno+"/chat/" + userId;
        let socket;

        function initSocket() {
            socket = new WebSocket(socketUrl);

            socket.onopen = () => console.log("WebSocket connected.");
            socket.onmessage = event => {
                console.log("Message received:", event.data); // Optional: Handle received messages if needed
            };
            socket.onclose = () => {
                console.log("WebSocket closed. Reconnecting...");
                setTimeout(initSocket, 3000);
            };
            socket.onerror = error => console.error("WebSocket error:", error);
        }

        initSocket();


        new Vue({
            el: "#app",
            data: {
                reason: "",
                friends: [accountJson, ...friendsJson], // Friends data passed from the server
                account: accountJson,  // Current account data passed from the server
                payers: [],
                participants: [],
                selectedPayer: "",
                selectedParticipant: "",
                transactions: []
            },
            mounted() {
                        // Log friends data when the component is mounted

            },
            computed: {
                availablePayers() {

                    if(!this.friends || !this.payers){
                        console.log("no data");
                        return [];
                    }
                    const available = this.friends.filter(friend =>
                        !this.payers.some(payer => payer.id === friend.id)
                    );
                    return available;
                },
                availableParticipants() {
                    if(!this.friends || !this.payers){
                         console.log("no data");
                         return [];
                    }
                    return this.friends.filter(friend =>
                        !this.participants.some(participant => participant.id === friend.id) &&
                        !this.payers.some(payer => payer.id === friend.id)
                    );
                }
            },
            methods: {
                addPayer() {
                    const selected = this.friends.find(friend => friend.id === this.selectedPayer);
                    if (selected) {
                        this.payers.push({ ...selected, amount: 0 });
                        this.selectedPayer = "";
                    }
                },
                removePayer(id) {
                    this.payers = this.payers.filter(payer => payer.id !== id);
                },
                addParticipant() {
                    const selected = this.friends.find(friend => friend.id === this.selectedParticipant);
                    if (selected) {
                        this.participants.push(selected);
                        this.selectedParticipant = "";
                    }
                },
                removeParticipant(id) {
                    this.participants = this.participants.filter(participant => participant.id !== id);
                },
                submitForm() {
                    const data = {
                        reason: this.reason,
                        payers: this.payers.map(payer => ({ id: payer.id, amount: payer.amount })),
                        participants: this.participants.map(participant => participant.id)
                    };

                    fetch('/createTransactions',{
                        method: 'POST',
                        headers: {
                            'Content-Type' : 'application/json'
                        },
                        body : JSON.stringify(data)
                    })
                        .then(response => {
                            if(!response.ok){
                                console.log("Error creating Transactions");
                                throw new Error(`HTTP error! status: ${response.status}`);
                            }
                            return response.json();
                        })
                        .then(result =>{
                            console.log("Transactions created! Please, Confirm.");
                            this.transactions = result;

                        })
                        .catch(error=>{
                            console.error("Error creating transactions:", error);
                        });

                },

                confirmTransactions(){
                    fetch('/saveTransactions', {
                        method : 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify(this.transactions)
                    })
                        .then(response => {
                            if(!response.ok){
                                console.error("Error saving Transactions.");
                                throw new Error(`HTTP error! status : ${response.status}`);
                            }
                            console.log("Transactions saved successfully,");


                            this.transactions.forEach((transaction, index) => {
                                        // Construct the message
                                        const message = {
                                            senderId: accountJson.id,
                                            receiverId: transaction.toAccount.id === this.account.id ? transaction.fromAccount.id : transaction.toAccount.id,
                                            content:     'Transaction created by: ' + this.account.id +
                                                         ' for ' + transaction.reason + '.\n' +
                                                         'Amount Details: ' + transaction.amount + ' needs to be paid to '+transaction.toAccount.id+'.',
                                        };

                                        // Send the message via WebSocket
                                        if (socket && socket.readyState === WebSocket.OPEN) {
                                            socket.send(JSON.stringify(message));
                                        } else {
                                            console.error("WebSocket is not connected. Alert about Transaction Settlement not sent.");
                                        }
                            });

                            this.resetForm();
                            window.location.reload()


                        })
                        .catch(error=>{
                            console.error("Error saving Transactions.", error);
                        });
                },

                cancelTransactions(){
                    this.transactions = [];
                    this.resetForm();
                },

                resetForm(){
                    this.reason = "";
                    this.payers = [];
                    this.participants = [];
                    this.selectedPayer = "";
                    this.selectedParticipant = "";
                    this.transactions = [];
                },
            }
        });

        new Vue({
            el: '#app2',
            data: {
                pendingTransactions: pendingTransactionsJson,
                accountId: accountJson.id, // Pass account ID from backend
                settleTransactionId: null,
                settleComment: '',
            },
            computed: {
                oweTransactions() {
                    return this.pendingTransactions.filter(
                        (transaction) => transaction.fromId === this.accountId
                    );
                },
                expectTransactions() {
                    return this.pendingTransactions.filter(
                        (transaction) => transaction.toId === this.accountId
                    );
                },
                totalOwe() {
                    return this.oweTransactions.reduce(
                        (total, transaction) => total + transaction.amount,
                        0
                    );
                },
                totalExpect() {
                    return this.expectTransactions.reduce(
                        (total, transaction) => total + transaction.amount,
                        0
                    );
                },
            },
            methods: {
                settleTransaction(transactionId) {
                    this.settleTransactionId =
                        this.settleTransactionId === transactionId ? null : transactionId;
                },
                sendComment(transactionId) {
                    if (this.settleComment.trim()) {
                        // Send data to controller using fetch or Axios
                        fetch('/settleTransaction', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json',
                            },
                            body: JSON.stringify({
                                transactionId: transactionId,
                                comment: this.settleComment,
                            }),
                        })
                            .then((response) => {
                                if (response.ok) {
                                    console.log('Transaction settled successfully!');

                                    const transactionIndex = this.pendingTransactions.findIndex(transaction => transaction.id === transactionId);
                                    if (transactionIndex !== -1) {
                                        const transaction = this.pendingTransactions[transactionIndex];
                                        let transactionInfo = accountJson.id !== transaction.fromId ? 'Received' : 'Sent';
                                        // Construct the message
                                        const message = {
                                            senderId: accountJson.id,
                                            receiverId: transaction.toId === accountJson.id ? transaction.fromId : transaction.toId,
                                            content:     'The transaction with id: ' + this.settleTransactionId +
                                                         ' has been settled by ' + this.accountId + '.\n' +
                                                         'Comment: ' + this.settleComment + '.\n' +
                                                         'Amount Details: ' + transaction.amount + ' ' + transactionInfo + '.',
                                        };

                                        // Send the message via WebSocket
                                        if (socket && socket.readyState === WebSocket.OPEN) {
                                            socket.send(JSON.stringify(message));
                                        } else {
                                            console.error("WebSocket is not connected. Alert about Transaction Settlement not sent.");
                                        }

                                        // Remove the transaction from the posters
                                        this.pendingTransactions.splice(transactionIndex, 1);

                                        // Reset the comment box
                                        this.settleTransactionId = null;
                                        this.settleComment = '';

                                    }
                                } else {
                                    alert('Failed to settle transaction.');
                                }
                            })
                            .catch((error) => {
                                console.error('Error:', error);
                                alert('Error while settling transaction.');
                            });


                    } else {
                        alert('Please enter a comment.');
                    }
                },
            },
        });
        new Vue({
            el: '#app1',
            data: {
                showModal: false,
                settledTransactions: []
            },
            methods: {
                fetchSettledTransactions() {
                    fetch('/getSettledTransactions', {
                        method: 'GET',
                        headers: {
                            'Content-Type': 'application/json'
                        }
                    })
                    .then(response => response.json())
                    .then(data => {
                        this.settledTransactions = data;
                        this.showModal = true;
                        console.log(data);
                    })
                    .catch(error => {
                        console.error("Error fetching settled transactions:", error);
                    });
                },
                closeModal() {
                    this.showModal = false;
                }
            }
        });

    </script>
</body>
</html>
