
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
  res.render('index.html');
});

app.listen(process.argv[2] ? process.argv[2] : 3000);
console.log("NodeChat server listening on port %d in %s mode", app.address().port, app.settings.env);

// Private Methods

var formatDate = function(date) {
	return date.getDate() + '-' + date.getMonth() + '-' + date.getFullYear() + ' ' +
		(date.getHours() < 10 ? '0' + date.getHours() : date.getHours()) + ':' + 
		(date.getMinutes() < 10 ? '0' + date.getMinutes() : date.getMinutes());
};

var randomColor = function() {
	var letters = '0123456789ABCDEF'.split('');
    var color = '#';
    for (var i = 0; i < 6; i++ ) {
        color += letters[Math.round(Math.random() * 15)];
    }
    return color;
};

// Sockets 

var io = socketio.listen(app);

var users = {};
var userClients = {};

var addUser = function(username, client) {
	users[username] = {'username':username, 'color':randomColor()};
	userClients[username] = client;
	io.sockets.emit('userlist', users);
};

var removeUser = function(username) {
	delete users[username];
	delete userClients[username];
	io.sockets.emit('userlist', users);
};

io.sockets.on('connection', function (client) {
	
	var sendError = function(errmsg) {
		client.emit('error', {'date': formatDate(new Date()), 'user':{username:'NodeChat',color:'#ff0000'}, 'msg':errmsg});
	}
	
	var sendMessage = function(msg) {
		client.get('username', function(err, username){
			
			var atUsername = /(^|\s)@(\w+)/.exec(msg);
			if(atUsername) {
				var privateClient = userClients[atUsername[0].substring(1)];
				if(privateClient) {
					privateClient.emit('msg', {'date': formatDate(new Date()), 'user':users[username], 'msg':msg});
					client.emit('msg', {'date': formatDate(new Date()), 'user':users[username], 'msg':msg});
				} else {
					sendError('Message undelivered, user does not exist.');
				}
			} else {
				io.sockets.emit('msg', {'date': formatDate(new Date()), 'user':users[username], 'msg':msg});
			}
		});
	};

	client.emit('userlist', users); 
	
	client.on('set username', function(username, fn){
		if(users[username]){
			sendError('Username already taken, please enter a username:');
		} else {
			client.set('username', username, function(){
				if(fn) fn(username);
				addUser(username, client);
				sendMessage('joined NodeChat');
			});
		}
	});
	
	client.on('msg', function(msg){
		sendMessage(msg);
	});
	
	client.on('disconnect', function () {
    	client.get('username', function(err, username){
    		if(username) {
    			sendMessage('left NodeChat');
    			removeUser(username);
    		}
    	});
 	});
});


