#!/bin/bash

set -xe

n="$1"

export EMQX_NODE__NAME="emqx${n}@127.0.0.1"
export EMQX_LISTENER__TCP__INTERNAL="$((3000 + $n))"
export EMQX_DASHBOARD__LISTENER__HTTP="$((4000 + $n))"
export EMQX_MANAGEMENT__LISTENER__HTTP="$((5000 + $n))"
export EMQX_NODE__DIST_LISTEN_MIN="$((6000 + $n))"
export EMQX_NODE__DIST_LISTEN_MAX="$((6000 + $n))"

"./emqx${n}/bin/emqx" console

