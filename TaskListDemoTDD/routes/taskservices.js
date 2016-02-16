module.exports = function(app, db) {

// Global variable for response object
var resJson = [];

// get list of sample documents
app.get('/api/task/mock',function(req, res){

	var mockData = [
		  {
		    "name": "test task 1"
		  },
		  {
		    "name": "test task 2"
		  },
		  {
		    "name": "test task 3"
		  },
		  {
		    "name": "test task 4"
		  },
		  {
		    "name": "test task 5"
		  }
		];
	  	return res.send(mockData);

});

// insert task document
app.post('/api/task/list', function (req, res){

	//var id = request.body.id;
	var task = req.body.task;
	//var value = req.body.value;
  	console.log("POST /api/data/list: " + task);

	//Generated random id
	var id = '';

  //db.insert(req.body, id, function(err, body, header) {
  	db.insert({
		task : task
	}, id, function(err, doc) {
		if(err) {
			console.log(err);
			res.send(500);
		} else
			res.send(doc);
		res.end();
	});
});


// get list of sample documents
app.get('/api/task/list',function(req, res){


	db.list(function(err, body) {

	  if (!err) {
	    resJson = [];
	    var count = 0;

	    body.rows.forEach(function(doc) {

      		// Review each document
      		console.log("response: " + JSON.stringify(doc));
      		db.get(doc.id, function(err, item) {

      			console.log("item: " + JSON.stringify(item));
      			if (!err && item.task)
      			{
    				console.log("Get Item Name: " + item.task);
    				resJson.push({"task": item.task, "id" : item._id});
    			}
			if (++count >= body.rows.length) {
				console.log("resJson: " + resJson);
				res.send(resJson);
				console.log("response sent");
			}
	    	});

    	});

	  }else{
	  	console.log('[get]', err);
	  	return res.send({"error":err.error, "reason": err.reason});
	  }
	});

});

// update a document
app.put('/api/task/list/:id',function(req, res){
	console.log("put: /api/data/list/:id");
	//first get copy of document
	db.get(req.params.id, function(err, data) {
    	console.log("Error:", err);
    	console.log("Data:", data);
    	// keep a copy of the doc so we know its revision token
    	data.task = req.body.task;
    	var doc = data;
    	db.insert(doc,  function(err, body) {
		      if (err) {
		        console.log('[update failed] ', err.message);
		        return res.send(err.message);
		      }else{
		      	console.log('[update succeeded] ', body);
		      	return res.send(body);
		      }
  		});
  	});
});

// delete a document
app.delete('/api/task/list/:id',function(req, res){
	console.log("delete: /api/data/list/:id");
	req.params._deleted = true;
	console.log(req.body);
	db.get(req.params.id, function(err, data) {
    	console.log("Error:", err);
    	console.log("Data:", data);
    	var doc = data;

		db.destroy(doc._id, doc._rev, function(err, body) {
		    if (err) {
		        console.log('[delete failed] ', err.message);
		        return res.send(err.message);
		      }else{
		      	console.log('[delete succeeded] ', body);
		      	return res.send(body);
		      }

	  	});
  	});
});


};
