defmodule ExampleFsmServer do


use ExActor.GenServer, export: {:global, :global_registered_name}

defstart start() do
  # runs in init/1 callback
    initial_state(ExampleFsm.new() )
end

    # defines and export start_link/2
defstart start_link(_,_)do
      # runs in init/1 callback
   initial_state(ExampleFsm.new() )
end

defcall run(num), state: state, timeout: 10, do: (upd =state |> ExampleFsm.run(num) ;   set_and_reply(upd,upd))
defcall stop(), state: state, timeout: 10, do: (upd =state |> ExampleFsm.stop() ;   set_and_reply(upd,upd))
defcall speedup(num), state: state, timeout: 10, do: (upd =state |> ExampleFsm.speedup(num) ;   set_and_reply(upd,upd))
defcall data(), state: state, timeout: 10, do: set_and_reply(state, state)

end

defmodule ExampleFsm do
use ExActor.GenServer
  use Fsm, initial_state: :stopped, initial_data: %{speed: 0}

#use ExActor.Responders


  defstate stopped do
    defevent run(speed), data: data do  
      {_,next_data} = Map.get_and_update(data, :speed, fn x -> {x,x+speed} end)
      next_state(:running, next_data)
    end

    defevent _, state: state, data: data, event: event, do: IO.puts "undefined transition : #{inspect {state,data,event}}" 
  end

  defstate running do
    defevent slowdown(by), data: data do 
      {_,next_data} = Map.get_and_update(data, :speed, fn 
                    x when x-by >= 0 -> {x,x-by} 
                    x  -> {x,0} 
                    end)
      case next_data[:speed] do
        0 -> next_state(:stopped, next_data)
        _ -> next_state(:running, next_data)
      end
    end

    defevent speedup(by), data: data do 
      {_,next_data} = Map.get_and_update(data, :speed, fn x -> {x,x+by} end)
      next_state(:running, next_data)
    end

    defevent stop(), data: data do
      {_,next_data} = Map.get_and_update(data, :speed, fn x -> {x,0} end)
      next_state(:stopped, next_data)
    end

    #defevent _, state: state, data: data, event: event, do: IO.puts "undefined transition : #{inspect {state,data,event}}" 
  end


end

