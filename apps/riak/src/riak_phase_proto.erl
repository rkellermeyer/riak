-module(riak_phase_proto).

-export([send_inputs/2, mapexec_result/2, mapexec_error/2, error/2]).
-export([die/1, die_all/1, propagate_done/1, done/1, phase_done/1]).
-export([phase_results/2]).

send_inputs(PhasePid, Inputs) ->
    gen_fsm:send_event(PhasePid, {input, Inputs}).

mapexec_result(PhasePid, Result) ->
    gen_fsm:send_event(PhasePid, {mapexec_reply, Result, self()}).

mapexec_error(PhasePid, Error) ->
    gen_fsm:send_event(PhasePid, {mapexec_error, self(), Error}).

error(Coord, Error) ->
    gen_fsm:send_event(Coord, {error, self(), Error}).

propagate_done(PhasePid) ->
    gen_fsm:send_event(PhasePid, {done, self()}).

done(PhasePid) ->
    gen_fsm:send_event(PhasePid, done).

phase_results(Coord, Results) ->
    gen_fsm:send_event(Coord, {acc, {list, Results}}).

phase_done(Coord) ->
    gen_fsm:send_event(Coord, {done, self()}).

die(PhasePid) ->
    gen_fsm:send_event(PhasePid, die).

die_all(Pids) when is_list(Pids) ->
    lists:foreach(fun(Pid) -> die(Pid) end, Pids).