-module(boorchat_counter_storage).
-author("begemot").

-compile({no_auto_import, [ get/1 ]}).

%% API
-export([
  init/0,
  child_specs/0,
  increment/1,
  get/1
]).

-export([
  cleaner_start_link/0
]).

-define(ETS, chat_counter).

-include("xmpp.hrl").
-include("ejabberd_sql_pt.hrl").

init() ->
  ?ETS = ets:new(?ETS, [ set, named_table, public, { read_concurrency, true }, { write_concurrency, true }]).

cleaner_start_link() ->
  Pid = proc_lib:spawn_link(fun() ->
    (fun Loop() ->
      Sleep = boorchat_counter_app:get_env(save_interval),
      timer:sleep(Sleep*1000),
      ets:safe_fixtable(?ETS, true),
      List = ets:foldl(fun(Element, Acc) -> [ Element | Acc ] end, [], ?ETS),
      ets:safe_fixtable(?ETS, false),
      ets:delete_all_objects(?ETS),
      lists:foreach(fun({Jid, Counter}) ->
        Str = jid:encode(Jid),
        SQL = ?SQL("INSERT INTO boorchat_counters (jid, counter) VALUES( %(Str)s, %(Counter)d) ON DUPLICATE KEY UPDATE counter=counter + %(Counter)d"),
        LServer = Jid#jid.lserver,
        {updated, _ } = ejabberd_sql:sql_query(LServer, SQL)
      end, List),
      Loop()
    end)()
  end),
  { ok, Pid }.

child_specs() ->
  [{ cleaner, { ?MODULE, cleaner_start_link, []}, permanent, 2000, worker, [?MODULE]}].

get(Jid) when is_binary(Jid) ->
  get(jid:decode(Jid));
get(Jid = #jid{}) ->
  LServer = Jid#jid.lserver,
  Str = jid:encode(jid:remove_resource(Jid)),
  case ejabberd_sql:sql_query(LServer, ?SQL("SELECT @(counter)d FROM boorchat_counters WHERE jid = %(Str)s")) of
    { selected, []} -> { ok, 0 };
    { selected, [{Counter}]} when is_integer(Counter) ->
      { ok, Counter};
    { error, _ } = Error -> Error
  end.

increment(Jid) ->
  J = jid:remove_resource(Jid),
  ets:update_counter(?ETS, J, { 2, 1 }, {J, 0}),
  ok.
