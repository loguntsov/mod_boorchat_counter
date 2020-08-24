all: compile

compile: lib xmpp_spec
	rebar3 compile
	cp mod_boorchat_counter.spec _build/default/lib/boorchat_counter/mod_boorchat_counter.spec

lib: lib/ejabberd

xmpp_spec: src/boorchat_counter_xmpp.erl

src/boorchat_counter_xmpp.erl: specs/boorchat_counter_xmpp.spec scripts/compile_xmpp_spec.sh
	./scripts/compile_xmpp_spec.sh

lib/ejabberd:
	mkdir -p lib && cd lib && \
	git clone https://github.com/processone/ejabberd.git && \
	cd ejabberd && \
	git checkout 20.07 && \
	./rebar get-deps compile

upload: compile
	rsync -rltxSRzv \
	    --exclude .git \
	    --exclude *.log* \
	    --exclude *.pid \
	    --exclude .idea \
	    --exclude .rebar \
	    --exclude *.beam \
	    --exclude _build \
	    --exclude lib \
		. loguntsov@boorchat.ru:~/ejabberd/counter

