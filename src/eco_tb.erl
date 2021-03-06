-module(eco_tb).
-compile(export_all).

oneprocsixtickdeath() ->
  Watcher = spawn(eco_watcher, watcher, [self()]),
	Pool = spawn(eco_pool, start_pool, [[1,1,1]]),
	Proc1 = spawn(eco_proc, proc, [Watcher, [1], [], Pool, 3, 3]),
	_Ticker = spawn(eco_time, ticker, [Watcher, 1000, [Proc1], 3000]),
  receive
    {error, notock, _, _} ->
      init:stop()
  end.

twoprocsbackandforth() ->
  Watcher = spawn(eco_watcher, watcher, [self()]),
	Pool = spawn(eco_pool, start_pool, [[1,2]]),
	Proc1 = spawn(eco_proc, proc, [Watcher, [1], [2], Pool, 3, 3]),
	Proc2 = spawn(eco_proc, proc, [Watcher, [2], [1], Pool, 3, 3]),
	_Ticker = spawn(eco_time, ticker, [Watcher, 1000, [Proc1, Proc2], 3000]),
  receive
    {error, notock, _, _} ->
      init:stop()
  end.
