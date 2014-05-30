-module(eco_pool).
-export([start_pool/1, start_random_pool/2]).

start_pool(Data) ->
	pool_loop(Data).

start_random_pool(Size, Max) ->
	random:seed(now()),
	Data = [random:uniform(Max) || _ <- lists:seq(1, Size)],
	pool_loop(Data).

pool_loop(PoolData) ->
	receive
		{From, stop} ->
			From ! {ok, stopped},
			{ok, stopped};
		{From, drain} ->
			From ! {ok, drained},
			pool_loop([]);
		{From, set, Data} ->
			From ! {ok, set, Data},
			pool_loop(Data);
		{From, put, Data} ->
			From ! {ok, put, Data},
			pool_loop(PoolData ++ Data);
		{From, get, Data} ->
			New = PoolData -- Data,
			Test = PoolData -- New,
			if
				Test =:= Data ->
					From ! {ok, get, Data},
					pool_loop(New);
				true ->
					From ! {error, get, Data},
					pool_loop(PoolData)
			end;
		{From, look} ->
			From ! {ok, look, PoolData},
			pool_loop(PoolData);
		Msg ->
			{error, invalid_message, Msg}
	end.
