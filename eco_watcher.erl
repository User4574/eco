-module(eco_watcher).
-export([watcher/0]).

watcher() ->
	receive
		{From, stop} ->
			From ! {ok, stopped},
			{ok, stopped};
		Msg ->
			io:format("~p~n", [Msg]),
			watcher()
	end.
