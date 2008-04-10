#!/bin/bash -e

PORT=`perl -e 'print $> + 20000'`
SERVER=http://`hostname`:$PORT

PLAN_WORKSPACE="wikitests"
PLAN_SERVER=$SERVER

if $ST_CURRENT/nlw/bin/st-admin create-user --e wikitester@ken.socialtext.net >/dev/null 2>/dev/null; then
      echo "created wiki tester user"
fi

if  $ST_CURRENT/nlw/bin/st-admin add-workspace-admin --w test-data --e wikitester@ken.socialtext.net >/dev/null 2>/dev/null; then
     echo "added workspace admin"
fi

echo
echo "running $1 from $PLAN_SERVER/$PLAN_WORKSPACE"
echo
$ST_SRC_BASE/stconfig/stbin/run-wiki-tests --no-maximize --plan-server "$PLAN_SERVER"  --plan-workspace "$PLAN_WORKSPACE"  --timeout 60000 --plan-page "$1"

