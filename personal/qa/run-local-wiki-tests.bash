#!/bin/bash -e

if [ "$1" == "" ] ; then
    echo Usage: run-local-wiki-tests.bash PLAN_PAGE  --maximize
    exit
fi

PORT=`perl -e 'print $> + 20000'`
PLAN_SERVER=http://`hostname`:$PORT
PLAN_WORKSPACE="wikitests"
NOMAXIMIZE="--no-maximize"
WITH_NOMAXIMIZE=" with --no-maximize"

USERNAME="wikitester@ken.socialtext.net"
USEREMAIL=$USERNAME

if $ST_CURRENT/nlw/bin/st-admin create-user --e $USERNAME  >/dev/null 2>/dev/null; then
      echo "created wiki tester user"
fi

if  $ST_CURRENT/nlw/bin/st-admin add-workspace-admin --w test-data --e $USERNAME  >/dev/null 2>/dev/null; then
     echo "added workspace admin"
fi

if  $ST_CURRENT/nlw/bin/st-admin give-accounts-admin  --e $USERNAME  >/dev/null 2>/dev/null; then
     echo "rave accounts admin"
fi

# any non-empty $2 will turn off no-maximize
if [ $2 ] ; then
    NOMAXIMIZE=""
    WITH_NOMAXIMIZE=""
fi


echo
echo running $1 from $PLAN_SERVER/$PLAN_WORKSPACE $WITH_NOMAXIMIZE
echo
$ST_SRC_BASE/stconfig/stbin/run-wiki-tests $NOMAXIMIZE  --test-username $USERNAME --test-email $USEREMAIL --plan-server "$PLAN_SERVER"  --plan-workspace "$PLAN_WORKSPACE"  --timeout 60000 --plan-page "$1"

