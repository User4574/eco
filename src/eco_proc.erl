-module(eco_proc).
-export([proc/6]).

proc(Watcher, _, _, _, 0, _) ->
	Watcher ! {died, self()};
proc(Watcher, Gets, Puts, Pool, Life, MaxLife) ->
	receive
		{From, stop} ->
			From ! {ok, stopped, self()},
			Watcher ! {stopped, self()},
			{ok, stopped};
		{From, tick} ->
			From ! {self(), tock},
			Watcher ! {tick, self()},
			Pool ! {self(), get, Gets},
			receive
				{ok, get, Gets} ->
					Pool ! {self(), put, Puts},
					receive
						{ok, put, Puts} ->
							proc(Watcher, Gets, Puts, Pool, MaxLife, MaxLife)
					end;
				{error, get, Gets} ->
					proc(Watcher, Gets, Puts, Pool, Life - 1, MaxLife)
			end
	end.
