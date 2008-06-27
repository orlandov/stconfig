#!/bin/bash -e

    if [ -e $ST_CURRENT/nlw/share/workspaces/wikitests/wikitests.1.tar.gz ]; then
        if [ -e ~/.nlw/root/data/wikitests ]; then
            echo DELETING existing wikitests workspace
            $ST_CURRENT/nlw/bin/st-admin delete-workspace --w wikitests --no-export || true
        fi    
        echo IMPORTING wikitests.1.tar.gz
        $ST_CURRENT/nlw/bin/st-admin import-workspace --t  $ST_CURRENT/nlw/share/workspaces/wikitests/wikitests.1.tar.gz
    else
        echo NO wikitests tarball to import
    fi

