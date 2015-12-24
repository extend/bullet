# See LICENSE for licensing information.

PROJECT = bullet

# Dependencies.

DEPS = cowboy
dep_cowboy = git git://github.com/extend/cowboy.git 1.0.3

# Standard targets.

include erlang.mk
