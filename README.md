Bullet
======

Bullet is an "always connected" Cowboy handler and associated Javascript 
library for maintaining persistent connections to a server regardless 
of the browser used and/or the underlying technologies available.

Bullet defines a common interface for both client and server to easily
facilitate the handling of these connections. Bullet additionally takes 
care of reconnecting automatically whenever a connection is lost, and 
also provides an optional heartbeat which is managed on the client-side.
