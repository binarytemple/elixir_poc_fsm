# elixir_poc_fsm

Messing with [exactor](https://github.com/sasa1977/exactor) and [fsm](https://github.com/sasa1977/fsm) Elixir packages

```
 % mix deps.get
Running dependency resolution...
Dependency resolution completed:
  exactor 2.1.2
  fsm 0.2.0
* Getting fsm (Hex package)
  Checking package (https://repo.hex.pm/tarballs/fsm-0.2.0.tar)
  Fetched package
* Getting exactor (Hex package)
  Checking package (https://repo.hex.pm/tarballs/exactor-2.1.2.tar)
  Fetched package
```

```
[-]/elixir_poc_fsm
 % iex -S mix
Erlang/OTP 19 [erts-8.0.2] [source] [64-bit] [smp:8:8] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

==> exactor
Compiling 10 files (.ex)
Generated exactor app
==> fsm
Compiling 1 file (.ex)
Generated fsm app
==> ci_fsm
Compiling 4 files (.ex)
Generated ci_fsm app
Interactive Elixir (1.3.2) - press Ctrl+C to exit (type h() ENTER for help)
```

```
iex(1)> ExampleFsm.new
%ExampleFsm{data: %{speed: 0}, state: :stopped}

iex(3)> ExampleFsm.new |> ExampleFsm.slowdown(1) |> ExampleFsm.run(2)
undefined transition : {:stopped, %{speed: 0}, :slowdown}

iex(4)> ExampleFsm.new |> ExampleFsm.speedup(100)
undefined transition : {:stopped, %{speed: 0}, :speedup}

iex(5)> ExampleFsm.new |> ExampleFsm.speedup(100)
undefined transition : {:stopped, %{speed: 0}, :speedup}

iex(7)> ExampleFsm.new |> ExampleFsm.run(10)
%ExampleFsm{data: %{speed: 10}, state: :running}

iex(8)> ExampleFsm.new |> ExampleFsm.run(10) |> ExampleFsm.speedup(2)
%ExampleFsm{data: %{speed: 12}, state: :running}

iex(9)> ExampleFsm.new |> ExampleFsm.run(10) |> ExampleFsm.speedup(2) |> ExampleFsm.stop()
%ExampleFsm{data: %{speed: 0}, state: :stopped}
```

```
iex(95)> ExampleFsmServer.start
{:ok, #PID<0.28832.1>}

iex(96)> ExampleFsmServer.data
%ExampleFsm{data: %{speed: 0}, state: :stopped}

iex(97)> ExampleFsmServer.start
{:error, {:already_started, #PID<0.28832.1>}}
iex(98)> ExampleFsmServer.run(1)

%ExampleFsm{data: %{speed: 1}, state: :running}
iex(99)> ExampleFsmServer.speedup(1)

%ExampleFsm{data: %{speed: 2}, state: :running}
 
iex(107)> ExampleFsmServer.start
{:error, {:already_started, #PID<0.28832.1>}}

iex(110)> ExampleFsmServer.data
%ExampleFsm{data: %{speed: 0}, state: :stopped}

iex(111)> ExampleFsmServer.run(1)
%ExampleFsm{data: %{speed: 1}, state: :running}

iex(112)> ExampleFsmServer.data
%ExampleFsm{data: %{speed: 1}, state: :running}

iex(113)> ExampleFsmServer.speedup(1)
%ExampleFsm{data: %{speed: 2}, state: :running}

iex(114)> ExampleFsmServer.data
%ExampleFsm{data: %{speed: 2}, state: :running}

iex(103)> ExampleFsmServer.stop
%ExampleFsm{data: %{speed: 0}, state: :stopped}

iex(104)> ExampleFsmServer.stop
undefined transition : {:stopped, %{speed: 0}, :stop}
```

