#!/bin/bash -e
    if [ -e $ST_CURRENT/nlw/share/workspaces/wikitests/wikitests.1.tar.gz ]; then
        echo IMPORTING wikitests.1.tar.gz
        $ST_CURRENT/nlw/bin/st-admin delete-workspace --w wikitests --no-export || true
        $ST_CURRENT/nlw/bin/st-admin import-workspace --t  $ST_CURRENT/nlw/share/workspaces/wikitests/wikitests.1.tar.gz
    else
        echo NO wikitests tarball to import
    fi
    
    if [ -e $ST_CURRENT/nlw/share/workspaces/calctests/calctests.1.tar.gz ]; then
        echo IMPORTING calctests.1.tar.gz
        $ST_CURRENT/nlw/bin/st-admin delete-workspace --w calctests --no-export || true
        $ST_CURRENT/nlw/bin/st-admin import-workspace --t  $ST_CURRENT/nlw/share/workspaces/calctests/calctests.1.tar.gz
    else
        echo NO calctests tarball to import
    fi

