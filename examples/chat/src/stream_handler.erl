%% Feel free to use, reuse and abuse the code in this file.

%% @doc Stream handler for chatting.
-module(stream_handler).

-export([init/4]).
-export([stream/3]).
-export([info/3]).
-export([terminate/2]).

init(_Transport, Req, _Opts, _Active) ->
       whereis(chatty) ! {add, self()},
	   {ok, Req, self()}.

stream(<<"ping: ", Name/binary>>, Req, State) ->
       io:format("ping ~p received~n", [Name]),
       {reply, <<"pong">>, Req, State};

stream(Message, Req, State) ->
    whereis(chatty) ! { send, Message },
	{ok, Req, State}.

info(Info, Req, State) ->
	{reply, Info, Req, State}.

terminate(_Req, _) ->
	ok.
