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
	{JsonpCallbackName, Req2} = cowboy_req:qs_val(<<"callback">>, Req),
	TRef = erlang:send_after(?PERIOD, self(), refresh),
	{ok, Req2, {TRef, JsonpCallbackName}}.

stream(<<"ping: ", Name/binary>>, Req, State) ->
	io:format("ping ~p received~n", [Name]),
	{reply, <<"pong">>, Req, State};
stream(Data, Req, State) ->
	io:format("stream received ~s~n", [Data]),
	{ok, Req, State}.

info(refresh, Req, {_, Cb}) ->
	TRef = erlang:send_after(?PERIOD, self(), refresh),
	
	DateTime = cowboy_clock:rfc1123(),
	io:format("clock refresh timeout: ~s~n", [DateTime]),
	case Cb of
		undefined ->
			{reply, DateTime, Req, {TRef, Cb}};
		_ -> 
			% just for demo, a hand-encoded json:
			{reply, [Cb, <<"(\"">>, DateTime, <<"\");">>],
				cowboy_req:set_resp_header(
				<<"content-type">>,<<"application/javascript">>,Req), {TRef, Cb}}
	end;
info(Info, Req, State) ->
	io:format("info received ~p~n", [Info]),
	{ok, Req, State}.

terminate(_Req, {TRef, _}) ->
	io:format("bullet terminate~n"),
	erlang:cancel_timer(TRef),
	ok.
