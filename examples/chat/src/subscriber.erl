-module(subscriber).

-compile(export_all).

doit(Subscribers) ->
    receive 
        {add, Pid} ->
            io:format("add pid ~p ~n", [Pid]),
            NewSubscribers = [Pid| Subscribers],
            doit(NewSubscribers);
        {send, Message } ->
            io:format("Sending message ~p to ~p ~n", [Message, Subscribers]),
            lists:map( fun (Pid) ->  Pid ! Message end, Subscribers),
            doit(Subscribers);
        {who, Sender} ->
            io:format("Responsing with subscribers ~p to pid ~p", [Subscribers, Sender]),
            Sender ! Subscribers,
            doit(Subscribers);
         terminate ->
            ok
   end.
