-module(boorchat_counter_sup).
-author("begemot").

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================

start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

init([]) ->
  RestartStrategy = one_for_one,
  MaxRestarts = 1000,
  MaxSecondsBetweenRestarts = 3600,

  SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},
  boorchat_counter_storage:init(),
  {ok, {SupFlags,
    boorchat_counter_storage:child_specs()
  }}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
