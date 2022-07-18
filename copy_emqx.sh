#!/bin/bash

set -xe

rm -rf emqx*

emqx_src="../emqx-v4.3/_build/emqx/rel/emqx"

for emqx in emqx1 emqx2 emqx3; do

    cp -r "$emqx_src" "$emqx"
    cp -f "./confs/emqx.conf" "$emqx/etc/emqx.conf"

done


