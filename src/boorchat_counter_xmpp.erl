%% Created automatically by XML generator (fxml_gen.erl)
%% Source: xmpp_codec.spec

-module(boorchat_counter_xmpp).

-compile(export_all).

do_decode(<<"query">>,
          <<"urn:xmpp:boorchat:counter:get">>, El, Opts) ->
    decode_boorchat_counter_get(<<"urn:xmpp:boorchat:counter:get">>,
                                Opts,
                                El);
do_decode(<<"item">>,
          <<"urn:xmpp:boorchat:counter:get">>, El, Opts) ->
    decode_boorchat_jid_item(<<"urn:xmpp:boorchat:counter:get">>,
                             Opts,
                             El);
do_decode(Name, <<>>, _, _) ->
    erlang:error({xmpp_codec, {missing_tag_xmlns, Name}});
do_decode(Name, XMLNS, _, _) ->
    erlang:error({xmpp_codec, {unknown_tag, Name, XMLNS}}).

tags() ->
    [{<<"query">>, <<"urn:xmpp:boorchat:counter:get">>},
     {<<"item">>, <<"urn:xmpp:boorchat:counter:get">>}].

do_encode({boorchat_query_get, _} = Query, TopXMLNS) ->
    encode_boorchat_counter_get(Query, TopXMLNS).

do_get_name({boorchat_query_get, _}) -> <<"query">>.

do_get_ns({boorchat_query_get, _}) ->
    <<"urn:xmpp:boorchat:counter:get">>.

pp(boorchat_query_get, 1) -> [items];
pp(_, _) -> no.

records() -> [{boorchat_query_get, 1}].

decode_boorchat_counter_get(__TopXMLNS, __Opts,
                            {xmlel, <<"query">>, _attrs, _els}) ->
    Items = decode_boorchat_counter_get_els(__TopXMLNS,
                                            __Opts,
                                            _els,
                                            []),
    {boorchat_query_get, Items}.

decode_boorchat_counter_get_els(__TopXMLNS, __Opts, [],
                                Items) ->
    lists:reverse(Items);
decode_boorchat_counter_get_els(__TopXMLNS, __Opts,
                                [{xmlel, <<"item">>, _attrs, _} = _el | _els],
                                Items) ->
    case xmpp_codec:get_attr(<<"xmlns">>,
                             _attrs,
                             __TopXMLNS)
        of
        <<"urn:xmpp:boorchat:counter:get">> ->
            decode_boorchat_counter_get_els(__TopXMLNS,
                                            __Opts,
                                            _els,
                                            [decode_boorchat_jid_item(<<"urn:xmpp:boorchat:counter:get">>,
                                                                      __Opts,
                                                                      _el)
                                             | Items]);
        _ ->
            decode_boorchat_counter_get_els(__TopXMLNS,
                                            __Opts,
                                            _els,
                                            Items)
    end;
decode_boorchat_counter_get_els(__TopXMLNS, __Opts,
                                [_ | _els], Items) ->
    decode_boorchat_counter_get_els(__TopXMLNS,
                                    __Opts,
                                    _els,
                                    Items).

encode_boorchat_counter_get({boorchat_query_get, Items},
                            __TopXMLNS) ->
    __NewTopXMLNS =
        xmpp_codec:choose_top_xmlns(<<"urn:xmpp:boorchat:counter:get">>,
                                    [],
                                    __TopXMLNS),
    _els =
        lists:reverse('encode_boorchat_counter_get_$items'(Items,
                                                           __NewTopXMLNS,
                                                           [])),
    _attrs = xmpp_codec:enc_xmlns_attrs(__NewTopXMLNS,
                                        __TopXMLNS),
    {xmlel, <<"query">>, _attrs, _els}.

'encode_boorchat_counter_get_$items'([], __TopXMLNS,
                                     _acc) ->
    _acc;
'encode_boorchat_counter_get_$items'([Items | _els],
                                     __TopXMLNS, _acc) ->
    'encode_boorchat_counter_get_$items'(_els,
                                         __TopXMLNS,
                                         [encode_boorchat_jid_item(Items,
                                                                   __TopXMLNS)
                                          | _acc]).

decode_boorchat_jid_item(__TopXMLNS, __Opts,
                         {xmlel, <<"item">>, _attrs, _els}) ->
    Jid = decode_boorchat_jid_item_attrs(__TopXMLNS,
                                         _attrs,
                                         undefined),
    Jid.

decode_boorchat_jid_item_attrs(__TopXMLNS,
                               [{<<"jid">>, _val} | _attrs], _Jid) ->
    decode_boorchat_jid_item_attrs(__TopXMLNS,
                                   _attrs,
                                   _val);
decode_boorchat_jid_item_attrs(__TopXMLNS, [_ | _attrs],
                               Jid) ->
    decode_boorchat_jid_item_attrs(__TopXMLNS, _attrs, Jid);
decode_boorchat_jid_item_attrs(__TopXMLNS, [], Jid) ->
    decode_boorchat_jid_item_attr_jid(__TopXMLNS, Jid).

encode_boorchat_jid_item(Jid, __TopXMLNS) ->
    __NewTopXMLNS =
        xmpp_codec:choose_top_xmlns(<<"urn:xmpp:boorchat:counter:get">>,
                                    [],
                                    __TopXMLNS),
    _els = [],
    _attrs = encode_boorchat_jid_item_attr_jid(Jid,
                                               xmpp_codec:enc_xmlns_attrs(__NewTopXMLNS,
                                                                          __TopXMLNS)),
    {xmlel, <<"item">>, _attrs, _els}.

decode_boorchat_jid_item_attr_jid(__TopXMLNS,
                                  undefined) ->
    erlang:error({xmpp_codec,
                  {missing_attr, <<"jid">>, <<"item">>, __TopXMLNS}});
decode_boorchat_jid_item_attr_jid(__TopXMLNS, _val) ->
    case catch jid:decode(_val) of
        {'EXIT', _} ->
            erlang:error({xmpp_codec,
                          {bad_attr_value, <<"jid">>, <<"item">>, __TopXMLNS}});
        _res -> _res
    end.

encode_boorchat_jid_item_attr_jid(_val, _acc) ->
    [{<<"jid">>, jid:encode(_val)} | _acc].
