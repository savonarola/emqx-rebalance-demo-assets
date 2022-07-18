-module(rebalance_clients).

-export([connect_many/2]).

connect_many(N, NeedReconnect) ->
    process_flag(trap_exit, true),
    lists:map(
      fun(I) ->
              ClientId = clientid(I, NeedReconnect),
              emqtt_connect(ClientId, NeedReconnect)
      end,
      lists:seq(1, N)).

clientid(I, NeedReconnect) ->
    RandomId = erlang:unique_integer([positive]),
    iolist_to_binary(io_lib:format("client-~p-~p~p", [NeedReconnect, I, RandomId])).

emqtt_connect(ClientId, false) ->
    {ok, C} = emqtt:start_link(
                [{clientid, ClientId},
                 {clean_start, false},
                 {proto_ver, v5},
                 {properties, #{'Session-Expiry-Interval' => 86400}}
                ]),
    case emqtt:connect(C) of
        {ok, _} -> C;
        {error, Error} -> error(Error)
    end;

emqtt_connect(ClientId, true) ->
    timer:sleep(3),
    spawn_link(
      fun() ->
              process_flag(trap_exit, true),
              reconnect(ClientId)
      end).

reconnect(ClientId) ->
    try
        _C = emqtt_connect(ClientId, false)
    catch C:E ->
           io:format("Error connecting: ~p~n", [{C,E}]),
           timer:sleep(1000 + rand:uniform(1000)),
           reconnect(ClientId)
    end,
    receive
        {disconnected, Code, _} ->
           io:format("Disconnected with code ~p~n", [Code]),
           timer:sleep(5000 + rand:uniform(5000)),
           reconnect(ClientId) 
    end.
