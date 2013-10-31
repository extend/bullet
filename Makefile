# See LICENSE for licensing information.

PROJECT = bullet

# Dependencies.

DEPS = cowboy
dep_cowboy = https://github.com/extend/cowboy.git 0.8.4

# Standard targets.

all: erlang.mk

erlang.mk:
	git clone https://github.com/extend/erlang.mk.git erlang.mk.git
	mv erlang.mk.git/erlang.mk $@
	rm -rf erlang.mk.git

include erlang.mk
