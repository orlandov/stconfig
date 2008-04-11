#!/bin/bash -e

PORT=`perl -e 'print $> + 20000'`
PLAN_SERVER=http://`hostname`:$PORT
PLAN_WORKSPACE="wikitests"
NOMAXIMIZE=""

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

if [ "$2" == "" ] ; then
    NOMAXIMIZE="--no-maximize"
fi


echo
echo running $1 from $PLAN_SERVER/$PLAN_WORKSPACE with $NOMAXIMIZE
echo
$ST_SRC_BASE/stconfig/stbin/run-wiki-tests $NOMAXIMIZE  --test-username $USERNAME --test-email $USEREMAIL --plan-server "$PLAN_SERVER"  --plan-workspace "$PLAN_WORKSPACE"  --timeout 60000 --plan-page "$1"

