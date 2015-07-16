#!/Users/sdhillon/erlang/R16B03-1/bin/escript
-export([main/1]).

-define(TCP_OPTIONS, [binary, {active, true}, {reuseaddr, true}]).
-define(PORT, 9090).

main(_) ->
  {ok, LS} = gen_tcp:listen(0, [{fd, 3}]),
  accept(LS).

% Wait for incoming connections and spawn a process that will process incoming packets.
accept(LSocket) ->
    {ok, Socket} = gen_tcp:accept(LSocket),
    Pid = spawn(fun() ->
        io:format("Connection accepted ~n", []),
        loop(Socket)
    end),
    gen_tcp:controlling_process(Socket, Pid),
    accept(LSocket).

% Echo back whatever data we receive on Socket.
loop(Sock) ->
    inet:setopts(Sock, [{active, true}]),
    receive
    {tcp, Socket, Data} ->
        io:format("Got packet: ~p~n", [Data]),
        gen_tcp:send(Socket, Data),
        loop(Socket);
    {tcp_closed, Socket}->
        io:format("Socket ~p closed~n", [Socket]);
    {tcp_error, Socket, Reason} ->
        io:format("Error on socket ~p reason: ~p~n", [Socket, Reason])
    end.
