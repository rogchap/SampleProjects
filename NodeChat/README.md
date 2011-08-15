# NodeChat
## Chat application by Roger Chapman

This small chat application, created using Node.js and Socket.IO; other dependencies include the express framework.

* node v0.4.10
* express v2.4.3
* socket.io v0.7.8

All dependencies should be included in the `node_modules` folder, however if there are any issues with dependencies they can be installed by running:

	$ npm install -d
       
To execute the server application:

	$ node app.js <PORT>
	
If no `<PORT>` is specified a default port of 3000 is used.

The client can then be accessed at:

	http://localhost:<PORT>
	
### Core Features

#### Terminal style design

The design mimics the terminal style. The user is first asked for a username, and once entered (press ENTER) the user will join the chat room. Subsequent entries/messages will be posted to all online users.

The current user's username will always appear bold for easy recognition.

#### User assigned color

When a user joins NodeChat they are assigned a random color for the length of their session. This color is then used whenever there username is displayed. This is helpful to pick out an individual's message when there is a large amount of users online.

#### Private messages

As well as broadcasting a message to all online users, the user can also send a private message to any online user.

This is achieved by prefixing your message with `@username`. For example:

	> @roger This message will only be recived by roger
	
Private messages will only send messages to online users. If a user is not online a error message is displayed.

#### Automatic reconnect

Should the server restart at anytime the client will automatically reconnect to the server (if possible). The user will re-join the chat with there current username, however they will be assigned a new color representation.