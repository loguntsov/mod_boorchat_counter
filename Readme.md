# Ejabberd's sent messages counter

This plugin makes counter which calculates every chat message from user.

It calculates this message (type is chat and groupchat):
```
<message lang='ru' to='test2@boorchat.ru/1' from='test1@boorchat.ru/1' type='chat' id='purplea2ac2add'>
....
</message>
```

It allows get counter by this IQ:

```
<iq id="id_of_message" type="get"><query xmlns="urn:xmpp:boorchat:counter:get"><item jid="test1@boorchat.ru"/></query></iq>
```

Result of this IQ is:

```
<iq id="id_of_message" type="result" xml:lang="ru" to="test1@boorchat.ru/Psi+" from="test1@boorchat.ru">
<results>
<item jid="test1@boorchat.ru">72</item>
</results>
</iq>
```

## Requirements

* installed ejabbberd

Tested with Ejabberd 20.07

* make 

    ```sudo apt-get install make```
* rebar3 

```
    wget https://rebar3.s3.amazonaws.com/rebar3
    ./rebar3 local install
    export PATH=/home/loguntsov/.cache/rebar3/bin:$PATH    
```
* git
    
    ```sudo apt-get install git```
    
   
## Compilation

Just use make command to build everything.    

## Installation

Launch sql script from sql/initial.sql

### Ejabberd 20

To install module check please this link: https://docs.ejabberd.im/developer/extending-ejabberd/modules/

**Please check this path also:** ```/var/lib/ejabberd/.ejabberd-modules```


## Configuration

Just add to ejabberd.yml these lines:

```
## This example forces plugin to save data every 10 seconds
mod_boorchat_counter:
  save_interval: 10
```


# Installation Ejabberd from sources

## Installation dependencies

```
apt install gcc libssl-dev libexpat1-dev libyaml-dev g++ zlib1g-dev
```

# Author

Sergey Loguntsov mailto: [loguntsov][gmail.com]

# License

MIT

