// Module dependencies

var express = require('express');
var fs = require('fs');

// Local variables

var app;

// Boot functions

function bootModels(app, next) {
  fs.readdir(__dirname + '/models', function(err, files){
    if(err) throw err;
    files.forEach(function(file){
      var name = file.replace('.js', '');
      var model = __dirname + '/models' + name;
      require(model)(app);
      next();
    });
  });
}

function bootControllers(app, next) {
  fs.readdir(app.path + '/controllers', function(err, files){
    if(err) throw err;
    files.forEach(function(file){
      var name = file.replace('js', '');
      var controller = __dirname + '/controllers' + name;
    });
  });
}

function bootApplication(app, next) {
  app.set('views', app.path + '/views');
  app.set('view engine', 'jade');
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(app.path + '/public'));
  
  bootModels(app, function() {
    bootControllers(app, next);
  });
}

// Initialize bootstrapping

exports.boot = function(next){
  app = express.createServer();
  app.path = __dirname;

  bootApplication(app, function() {
    next(app);
  });
};

// Start application

exports.boot(function(app){
  app.listen(3000);
  console.log("Express server listening on port %d in %s mode", app.address().port, global.process.env.NODE_ENV || 'development');
});
