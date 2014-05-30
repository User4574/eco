-module(eco_watcher).
-export([watcher/1]).

watcher(Super) ->
	receive
		{From, stop} ->
			From ! {ok, stopped},
			{ok, stopped};
    {error, notock, A, B} ->
      Super ! {error, notock, A, B},
			io:format("~p~n", [{error, notock, A, B}]),
			watcher(Super);
		Msg ->
			io:format("~p~n", [Msg]),
			watcher(Super)
	end.
