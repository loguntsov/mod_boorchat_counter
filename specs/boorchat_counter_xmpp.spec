-xml(boorchat_jid_item,
    #elem{
        name = <<"item">>,
        xmlns = <<"urn:xmpp:boorchat:counter:get">>,
        module = boorchat_counter_xmpp,
        result = '$jid',
        attrs = [
            #attr{name = <<"jid">>,
                required = true,
                dec = {jid, decode, []},
                enc = {jid, encode, []}}
        ]}).
    }
).
-xml(boorchat_counter_get,
    #elem{
        name = <<"query">>,
        xmlns = <<"urn:xmpp:boorchat:counter:get">>,
        module = boorchat_counter_xmpp,
        result = {boorchat_query_get, '$items'},
        refs = [
            #ref{
                name = boorchat_jid_item,
                label = '$items'
            }]
    }
).
