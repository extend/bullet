%% Feel free to use, reuse and abuse the code in this file.

%% @doc Main page of the chat application.
-module(toppage_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

init(_Transport, Req, []) ->
	{ok, Req, undefined}.

handle(Req, State) ->
	Body = <<"
<!DOCTYPE html>
<html lang=\"en\">
<head>
	<meta charset=\"utf-8\">
	<title>Bullet Chat</title>
</head>

<body>
	<script
		src=\"http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js\">
	</script>
	<script src=\"/static/bullet.js\"></script>
	<script type=\"text/javascript\">
// <![CDATA[
$(document).ready(function(){
    var bullet = $.bullet('ws://localhost:8080/bullet');
	bullet.onmessage = function(e){
		if (e.data != 'pong'){
            $(\"#chats\").append(\"<p>\" + e.data + \"</p>\"); 
            
		}
	};
	
    $(\"#send\").click( function () { 
        bullet.send($(\"#says\").val());
    })
});
// ]]>
	</script>
    <div id=\"chats\"><p>Chats!</p></div>
    <input type=\"text\" id=\"says\"/><button id=\"send\">send</button>
</body>
</html>
">>,
	{ok, Req2} = cowboy_req:reply(200, [{<<"content-type">>, <<"text/html">>}],
		Body, Req),
	{ok, Req2, State}.

terminate(_Reason, _Req, _State) ->
	ok.
