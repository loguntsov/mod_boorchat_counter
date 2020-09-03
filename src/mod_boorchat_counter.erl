-module(mod_boorchat_counter).


-behavior(gen_mod).
-export([
  start/2, stop/1,
  mod_opt_type/1, depends/2,
  mod_options/1
]).

%% Hooks

-export([
  user_send_packet/1,
  process_iq_counter_get/1
]).


-define(LAGER, true).
-include("logger.hrl").

-include("xmpp.hrl").
-include("boorchat_counter_xmpp.hrl").

-define(NS_BOORCHAT_COUNTER_GET, <<"urn:xmpp:boorchat:counter:get">>).
-define(XMPP_CODEC, boorchat_counter_xmpp).

%% gen_mod callbacks

start(Host, Opts) ->
  ok = xmpp:register_codec(?XMPP_CODEC),
  ok = application:load(boorchat_counter),
  boorchat_counter_app:set_env(save_interval, maps:get(save_interval, Opts)),
  { ok, _ } = application:ensure_all_started(boorchat_counter),
  ejabberd_hooks:add(user_send_packet, Host, ?MODULE, user_send_packet, 50),

  gen_iq_handler:add_iq_handler(ejabberd_local, Host, ?NS_BOORCHAT_COUNTER_GET,
    ?MODULE, process_iq_counter_get),
  gen_iq_handler:add_iq_handler(ejabberd_sm, Host, ?NS_BOORCHAT_COUNTER_GET,
    ?MODULE, process_iq_counter_get),

  ok.

stop(Host) ->
  ejabberd_hooks:delete(user_send_packet, Host, ?MODULE, user_send_packet, 50),
  gen_iq_handler:remove_iq_handler(ejabberd_local, Host, ?NS_BOORCHAT_COUNTER_GET),
  gen_iq_handler:remove_iq_handler(ejabberd_sm, Host, ?NS_BOORCHAT_COUNTER_GET),
  proc_lib:spawn(fun() ->
    ok = application:stop(boorchat_counter)
  end),
  xmpp:unregister_codec(?XMPP_CODEC),
  ok.

depends(_Host, _Opts) ->
  [].

mod_opt_type(save_interval) ->
  fun (SaveInterval) when is_integer(SaveInterval), SaveInterval > 0 -> SaveInterval end;

mod_opt_type(_) ->
  [save_interval].

mod_options(_Host) -> [
  {save_interval, 10}
].


-spec user_send_packet({stanza(), ejabberd_c2s:state()}) -> {stanza(), ejabberd_c2s:state()} | {stop, {stanza(), ejabberd_c2s:state()}}.
user_send_packet({Packet = #message{ type = Type }, C2SState} = Args) when Type =:= chat; Type =:= groupchat ->
  ?INFO_MSG("Message ~p:~p", [C2SState, Packet]),
  From = xmpp:get_from(Packet),
  boorchat_counter_storage:increment(From),
  Args;

user_send_packet(Any) -> Any.

% user_send_packet(_From, _To, _) -> ok.

process_iq_counter_get(#iq{ type = get, sub_els = [#boorchat_query_get{ items=Jids } = Q ]} = IQ) ->
  Results = lists:map(fun(J) ->
    { ok, Counter } = boorchat_counter_storage:get(J),
    #xmlel{
      name = <<"item">>,
      attrs = [
        { <<"jid">>, jid:encode(J)}
      ],
      children = [
        {xmlcdata, integer_to_binary(Counter)}
      ]
    }
  end, Jids),
  xmpp:make_iq_result(IQ, #xmlel{ name = <<"results">>, children = Results});

process_iq_counter_get(IQ) ->
  ?INFO_MSG("IQ ~p", [ IQ ]),
  xmpp:make_iq_result(IQ, []).

