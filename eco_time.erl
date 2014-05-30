-module(eco_time).
-export([ticker/4]).

ticker(Watcher, Interval, ProcList, Timeout) ->
	receive
		{From, stop} ->
			From ! {ok, stopped},
			{ok, stopped}
	after Interval ->
		handle_tick(self(), ProcList, Timeout),
		receive
			{ok, endtick} ->
				Watcher ! {endtick, self()},
				ticker(Watcher, Interval, ProcList, Timeout);
			{error, notock, Proc} ->
				Watcher ! {error, notock, Proc, self()},
				{error, notock, Proc}
		end
	end.

handle_tick(Ticker, [], _) ->
	Ticker ! {ok, endtick};
handle_tick(Ticker, [This | Next], Timeout) ->
	This ! {self(), tick},
	receive
		{This, tock} ->
			handle_tick(Ticker, Next, Timeout)
	after Timeout ->
		Ticker ! {error, notock, This}
	end.
