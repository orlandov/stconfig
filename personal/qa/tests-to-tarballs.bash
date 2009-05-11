#!/bin/bash -e
    if [ -e ~/.nlw/root/data/wikitests ]; then
        echo CREATING NEW wikitests.1.tar.gz
        rm $ST_CURRENT/nlw/share/workspaces/wikitests/wikitests.1.tar.gz || true
        $ST_CURRENT/nlw/bin/st-admin export-workspace --w wikitests --dir $ST_CURRENT/nlw/share/workspaces/wikitests
    fi

