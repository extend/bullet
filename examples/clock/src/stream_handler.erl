%% Feel free to use, reuse and abuse the code in this file.

%% @doc Stream handler for clock synchronizing.
-module(stream_handler).

-export([init/4]).
-export([stream/3]).
-export([info/3]).
-export([terminate/2]).

-define(PERIOD, 1000).

init(_Transport, Req, _Opts, _Active) ->
	io:format("bullet init~n"),
	_ = erlang:send_after(?PERIOD, self(), refresh),
	{ok, Req, undefined}.

stream(<<"ping">>, Req, State) ->
	io:format("ping received~n"),
	{reply, <<"pong">>, Req, State};
stream(Data, Req, State) ->
	io:format("stream received ~s~n", [Data]),
	{ok, Req, State}.

info(refresh, Req, State) ->
	_ = erlang:send_after(?PERIOD, self(), refresh),
	Body = cowboy_clock:rfc1123(),
	%% handling jsonp
	{Vals, _} = cowboy_req:qs_vals(Req),
	case lists:keyfind(<<"callback">>, 1, Vals) of
		{_, Value} ->
			%% wraps it in callback and also in an array since content-type of the arg has to be json
			Body2 = [Value, <<"([\"">>, Body, <<"\"]);">>]; 
		_ -> 
			Body2 = Body
	end,
	io:format("clock refresh timeout:~p~n", [Body2]),
	{reply, Body2, Req, State};
info(Info, Req, State) ->
	io:format("info received ~p~n", [Info]),
	{ok, Req, State}.

terminate(_Req, _State) ->
	io:format("bullet terminate~n"),
	ok.
