
/**
 * Module dependencies.
 */

var express = require('express'),
	socketio = require('socket.io');

var app = module.exports = express.createServer();

// Configuration

app.configure(function(){
  app.set('views', __dirname + '/views');
  app.set('view options', {layout:false});
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(__dirname + '/public'));
  
  app.register('.html', {
  	compile:function(str, options){
  		return function(local){
  			return str;
  		};
  	}
  });
});

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true })); 
});

app.configure('production', function(){
  app.use(express.errorHandler()); 
});

// Routes

app.get('/', function(req, res){
	
	var ua = req.header('user-agent');
	if(/mobile/i.test(ua)) {
		res.render('mobile.html');
	} else {
		res.render('desktop.html');
	}
});

app.listen(3000);
console.log("Server listening on port %d in %s mode", app.address().port, app.settings.env);

// private methods

randomCodeNumber = function() {
	return Math.round(Math.random() * 9000) + 1000;
};

// Sockets 

var io = socketio.listen(app);

var users = {};

var desktop = io.of('/desktop');
var mobile = io.of('/mobile');

desktop.on('connection', function(client){
	
	var code = randomCodeNumber();
	users[code] = {'desktop':client, 'mobile':null};
	client.emit('code', code);
});

mobile.on('connection', function(client){
	
	client.on('set code', function(code, fn){

		if (users[code]) {
			console.log(code);
			client.set('code', code, function(){
				users[code].mobile = client;
				users[code].desktop.emit('mobile connected');
				if(fn) fn();
			});
			
		} else {
			
		};
	});
	
	client.on('touchEvent', function(data){
		client.get('code', function(err, code){
			users[code].desktop.emit('touchEvent', data);
		});
	});
	
});

