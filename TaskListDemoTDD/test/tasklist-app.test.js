var assert = require('chai').assert;
var request = require('request');
var expect = require('chai').expect;
var cfenv = require('cfenv');
// get the app environment from Cloud Foundry
var appEnv = cfenv.getAppEnv();

describe('TDD Node Web API', function() {

	var serviceBaseUrl = appEnv.url;
	if (process.env.test_env == 'cloud') {
		serviceBaseUrl = 'http://' + appEnv.name + '.mybluemix.net';
	}

	describe('when requested mock data at /api/task/mock', function() {
		it('should return an array of 5 tasks', function(done) {

			var endPoint = serviceBaseUrl + '/api/task/mock';
			request(endPoint, function (error, response, body) {

			    var bodyJson = JSON.parse(body);

			    assert.isNull(error, "should return no error");
			    assert.propertyVal(response, 'statusCode', 200);
			    assert.isArray(bodyJson, 'returned proper array');
			    assert.lengthOf(bodyJson, 5, 'mock array has length of 5');

			    done();

			});
		});
	});

	// test the insert API
	describe('when post task data at /api/task/list', function() {
		it('should insert the record to cloudant and return the doc', function(done) {

			var endPoint = serviceBaseUrl + '/api/task/list';
			var postData = 'task=test insert task item';

			request.post({
				  headers: {
				  	'content-type' : 'application/x-www-form-urlencoded',
				  	'accept' : 'application/json'
				  },
				  url:     endPoint,
				  body:    postData
				}, function(error, response, body){

				  //console.log(body);
				  var bodyJson = JSON.parse(body);

				  expect(error).to.not.be.ok;
				  expect(response).to.have.property('statusCode', 200);
				  expect(bodyJson).to.have.property('ok', true);
				  done();
			});
		});
	});



	// test the get task list API
	describe('when requested tasklist at /api/task/list', function() {
		it('should return all tasklist data', function(done) {

			var endPoint = serviceBaseUrl + '/api/task/list';

			request(endPoint, function(error, response, body){

				  var bodyJson = JSON.parse(body);

				  expect(error).to.not.be.ok;
				  expect(response).to.have.property('statusCode', 200);
				  expect(bodyJson).to.be.an('array');
				  done();
			});
		});
	});

	//test the update task list API

	describe('when requested tasklist at /api/task/list', function() {
		it('should return update the specific task', function(done) {

			var endPoint = serviceBaseUrl + '/api/task/list';

			request(endPoint, function(error, response, body){

				  var bodyJson = JSON.parse(body);

					//Grab the ID of the first document returned in the response

					var id = bodyJson[0].id;
					var postData = 'task=this will be the value of the updated task';
					var newEndPoint = serviceBaseUrl + '/api/task/list/' + id;

					request.put({
						  headers: {
						  	'content-type' : 'application/x-www-form-urlencoded',
						  	'accept' : 'application/json'
						  },
						  url:     newEndPoint,
						  body:    postData
						}, function(error, response, body){

						  var bodyJson = JSON.parse(body);

						  expect(error).to.not.be.ok;
						  expect(response).to.have.property('statusCode', 200);
						  expect(bodyJson).to.have.property('ok', true);
						  done();
					});

			});
		});
	});

	//test the delete task list API

	describe('when requested tasklist at /api/task/list', function() {
		it('should return delete the specified task', function(done) {

			var endPoint = serviceBaseUrl + '/api/task/list';

			request(endPoint, function(error, response, body){

				  var bodyJson = JSON.parse(body);

					//Grab the ID of the first document returned in the response

					var id = bodyJson[0].id;
					var newEndPoint = serviceBaseUrl + '/api/task/list/' + id;

					request.del({
						  headers: {
						  	'content-type' : 'application/x-www-form-urlencoded',
						  	'accept' : 'application/json'
						  },
						  url:     newEndPoint
						}, function(error, response, body){

						  var bodyJson = JSON.parse(body);

						  expect(error).to.not.be.ok;
						  expect(response).to.have.property('statusCode', 200);
						  expect(bodyJson).to.have.property('ok', true);
						  done();
					});

			});
		});
	});

});
