var cfenv = require('cfenv');
var express = require('express'), router = express.Router(),
	http = require('http'), path = require('path'),
	fs = require('fs'), bodyParser = require('body-parser');;

var app = express();
var db; // placeholder for database

// all environments
app.set('port', process.env.PORT || 3000);
app.use(bodyParser.urlencoded({ extended: true }));
app.use(router);
app.use(express.static(path.join(__dirname, 'public')));


var cloudant;

var dbCredentials = {
	dbName: 'tasks'
};

if (process.env.VCAP_SERVICES) {
		  // Running on Bluemix. Parse for  the port and host that we've been assigned.
		  var env = JSON.parse(process.env.VCAP_SERVICES);
		  var host = process.env.VCAP_APP_HOST;
		  var port = process.env.VCAP_APP_PORT;

		  console.log('VCAP_SERVICES: %s', process.env.VCAP_SERVICES);

		  // Also parse out Cloudant settings.
		  var cloudant = env['cloudantNoSQLDB'][0]['credentials'];
	 }

function initDBConnection() {

	if(process.env.VCAP_SERVICES) {
		var vcapServices = JSON.parse(process.env.VCAP_SERVICES);
		if(vcapServices.cloudantNoSQLDB) {
			dbCredentials.host = vcapServices.cloudantNoSQLDB[0].credentials.host;
			dbCredentials.port = vcapServices.cloudantNoSQLDB[0].credentials.port;
			dbCredentials.user = vcapServices.cloudantNoSQLDB[0].credentials.username;
			dbCredentials.password = vcapServices.cloudantNoSQLDB[0].credentials.password;
			dbCredentials.url = vcapServices.cloudantNoSQLDB[0].credentials.url;
		}
		console.log('VCAP Services: '+JSON.stringify(process.env.VCAP_SERVICES));
	}else // Define Cloudant db info from appDef.json
	{
    //This code is for your local environment to connect to the bluemix Cloudant db
	  //NOTE you will need to get these settings from the Cloudant settings in your Bluemix console.
    
		dbCredentials.host = "03533600-d642-4cbf-8fa1-68abe670ddc3-bluemix.cloudant.com";
		dbCredentials.port = 443;
		dbCredentials.user = "03533600-d642-4cbf-8fa1-68abe670ddc3-bluemix";
		dbCredentials.password = "260ee2e4fb9f70c682fdf7f33c47ad7b163ccdccd616b4622f425c3d831a91b8";
		dbCredentials.url = "https://03533600-d642-4cbf-8fa1-68abe670ddc3-bluemix:260ee2e4fb9f70c682fdf7f33c47ad7b163ccdccd616b4622f425c3d831a91b8@03533600-d642-4cbf-8fa1-68abe670ddc3-bluemix.cloudant.com";
  }

	cloudant = require('cloudant')(dbCredentials.url);

	//check if DB exists if not create
	cloudant.db.create(dbCredentials.dbName, function (err, res) {
		if (err) { console.log('could not create db ', err); }
    });
	db = cloudant.use(dbCredentials.dbName);
}

initDBConnection();

// setup CRUD services
// replace the file name with created Service name
var dbServices = require('./routes/taskservices.js');
dbServices(app, db);

// get the app environment from Cloud Foundry
var appEnv = cfenv.getAppEnv();

// start server on the specified port and binding host
app.listen(appEnv.port, '0.0.0.0', function() {

	// print a message when the server starts listening
  console.log("server starting on " + appEnv.url);
});
