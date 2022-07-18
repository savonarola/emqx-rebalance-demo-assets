#!/bin/bash

set -xe

sleep 12;

for emqx in emqx2 emqx3; do

    "$emqx/bin/emqx_ctl" cluster join emqx1@127.0.0.1

done

while true; do
    sleep 86400
done
