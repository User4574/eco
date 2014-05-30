-module(eco_tb).
-export([start/0]).

start() ->
	Watcher = spawn(eco_watcher, watcher, []),
	Pool = spawn(eco_pool, start_pool, [[1,1,1]]),
	Proc1 = spawn(eco_proc, proc, [Watcher, [1], [], Pool, 3, 3]),
	_Ticker = spawn(eco_time, ticker, [Watcher, 1000, [Proc1], 3000]).
