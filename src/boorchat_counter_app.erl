-module(boorchat_counter_app).
-author("begemot").

-behaviour(application).

%% Application callbacks
-export([
  start/2,
  stop/1
]).

-export([
  get_env/1, set_env/2
]).

-define(APP, boorchat_counter).

%%%===================================================================
%%% Application callbacks
%%%===================================================================

start(_StartType, _StartArgs) ->
  {ok, Pid } = boorchat_counter_sup:start_link(),
  { ok, Pid }.

stop(_State) ->
  ok.

get_env(Key) ->
  {ok, Value } = application:get_env(?APP, Key),
  Value.

set_env(Key, Value) ->
  ok = application:set_env(?APP, Key, Value).

%%%===================================================================
%%% Internal functions
%%%===================================================================

