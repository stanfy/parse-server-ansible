require('newrelic');


// Includes

var express     = require('express');
var ParseServer = require('parse-server').ParseServer;
var S3Adapter   = require('parse-server').S3Adapter;

var path        = require('path');

// DB setup
var databaseUri = process.env.parse_database_uri;
if (!databaseUri) {
  console.log('DATABASE_URI not specified, falling back to localhost.');
}

global.IS_PRODUCTION = ('true' == process.env.is_production);
global.IS_DEBUG = !IS_PRODUCTION;
console.log('process.env.is_production = ', process.env.is_production);
console.log('global.IS_PRODUCTION = ', global.IS_PRODUCTION);
console.log('global.IS_DEBUG = ', global.IS_DEBUG);

// // region APNS
// var apnsSetup;
// if (IS_PRODUCTION) {
//     console.info('Using PRODUCTION APNS config.');
//     apnsSetup = {
//         bundleId: 'com.bundleId',
//         developmentKeyPath: '/parse/cloud/apns/bundle.p12',
//         productionKeyPath: '/parse/cloud/apns/bundle.p12'
//     };
// } else {
//     // Dev.
//     console.info('Using development APNS config.');
//     apnsSetup = {
//         bundleId: 'com.bundleId',
//         developmentKeyPath: '/parse/cloud/apns/bundle.p12',
//         productionKeyPath: '/parse/cloud/apns/bundle.p12'
//     };
// }


// endregion

var api = new ParseServer({
    serverURL: 'http://localhost:1337/parse',
    databaseURI: databaseUri,
    cloud: process.env.parse_cloud_code_main,
    appId: process.env.parse_application_id,
    clientKey: process.env.parse_client_key,
    masterKey: process.env.parse_master_key,

    // TODO: Move keys to app.yaml
    fileKey: process.env.parse_file_key,

    // push: {
    //     ios: [
    //         {
    //             pfx: apnsSetup.developmentKeyPath,
    //             bundleId: apnsSetup.bundleId,
    //             production: false
    //         },
    //         {
    //             pfx: apnsSetup.productionKeyPath,
    //             bundleId: apnsSetup.bundleId,
    //             production: true
    //         }
    //     ]
    // }
});

// Serve static assets from the /public folder
var app = express();
app.use('/public', express.static(path.join(__dirname, '/public')));

// Serve the Parse API on the /parse URL prefix
var mountPath = process.env.PARSE_MOUNT || '/parse';
app.use(mountPath, api);

app.get('/', function(req, res) {
    res.redirect(301, '/');
});

var port = process.env.PORT || 1337;
var httpServer = require('http').createServer(app);
httpServer.listen(port, function() {
    console.log('info', 'parse-server-example running on port ' + port + '.');
});

// This will enable the Live Query real-time server
ParseServer.createLiveQueryServer(httpServer);
