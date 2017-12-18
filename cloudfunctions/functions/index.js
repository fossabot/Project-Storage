const functions = require('firebase-functions');
const admin = require('firebase-admin')
admin.initializeApp(functions.config().firebase)
const paypal = require('paypal-rest-sdk');

paypal.configure({
  'mode': 'sandbox', //sandbox or live
  'client_id': 'ATfLEWNy7qrB8XwFXc0JkSdFsHhD_n5od8XldGau63r0Cyh65o4dJC7VVpMQBImzJV-OSSy0RBs5nZjs',
  'client_secret': 'EDfDjjFqplMyYh7ev_uNSCxbdWNS9ocI0C3znlQMxSxja4jRxHxbAt4Sv5gODWjxneG3PWsO5dPYKQbA'
});


exports.generatePaypalURL = functions.https.onRequest((request, response) => {
   
   const uid = request.query.uid;
   const amount = parseFloat(request.query.amount).toFixed(2);
   const email = request.query.email;
   
   const ref = admin.database().ref();
   
    const create_payment_json = {
    "intent": "sale",
    "payer": {
        "payment_method": "paypal"
    },
    "redirect_urls": {
        "return_url": "https://us-central1-projectfilestore.cloudfunctions.net/paymentSuccess",
        "cancel_url": "https://us-central1-projectfilestore.cloudfunctions.net/paymentCancelled"
    },
    "transactions": [{
        "item_list": {
            "items": [{
                "name": "Project: Storage Credit",
                "sku": "001",
                "price": amount,
                "currency": "USD",
                "quantity": 1
            }]
        },
        "amount": {
            "currency": "USD",
            "total": amount
        },
        "description": "Project: Storage Credit for account under the login " + email
    }]
	};
	
	console.log("Payment JSON = ");
	console.log(create_payment_json);
	
	

	return paypal.payment.create(create_payment_json, function (error, payment)
	{
		if (error)
		{
			throw error;
			response.send("Error.");
		}
		else
		{
			for(var i = 0;i < payment.links.length;i++)
			{
				if(payment.links[i].rel == 'approval_url')
				{
					
					const paymentLog = ref.child("internal").child("pendingTransactions").child(payment.id);
					return paymentLog.set({
						amt: amount,
						stat: "pending",
						user: uid
					}).then(() => {
						response.send('<meta http-equiv="refresh" content="0; url=' + payment.links[i].href + '" /> <p><a href="' + payment.links[i].href + '">');
					});
				}
			}
		}
	});
   
});

exports.paymentSuccess = functions.https.onRequest((request, response) => {
	
	const ref = admin.database().ref();
	
	
	
	const payerID = request.query.PayerID;
	const paymentID = request.query.paymentId;
	var uid = "";
	var totalAmount = 0;
	
	console.log(payerID);
	console.log(paymentID);	
	
	return ref.child("internal/pendingTransactions/" + paymentID).once("value").then(data =>
	{
		const returnData = data.val();
		totalAmount = returnData.amt;
		uid = returnData.user;
		
		return execute_payment_json = {
			"payer_id": payerID,
			"transactions": [{
				"amount": {
					"currency": "USD",
					"total": totalAmount
				}
			}]
		  };
	}).then(paymentData =>
	{
		paypal.payment.execute(paymentID, paymentData,
		function (error, payment)
		{
			if (error != null)
			{
				console.log(error.response);
				return response.send("Error.");
			}
			else
			{
				console.log(JSON.stringify(payment));
				const userCreditRef = ref.child("user").child(uid).child("credit");
				userCreditRef.transaction(
				function(currentValue)
				{
					console.log("transaction run attempt.");
					return (currentValue || 0) + totalAmount
				});
				
				ref.child("internal").child("pendingTransactions").child(paymentID).update({stat:'success'}).then(data =>
				{
					return response.send('Success! Your balance has been updated. You may now use your new credits in the application.');
				});
			}
		});
	}).catch(reason => {
		console.log(reason);
		response.send("Error");
	});
	
	
	
})

exports.paymentCancelled = functions.https.onRequest((request, response) => {
	
	response.send("Payment canceled.");
	console.log(request);
	
});