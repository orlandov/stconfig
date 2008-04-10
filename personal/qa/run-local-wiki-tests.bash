#!/bin/bash -e

PORT=`perl -e 'print $> + 20000'`
SERVER=http://`hostname`:$PORT

PLAN_WORKSPACE="wikitests"
PLAN_SERVER=$SERVER

echo
echo "running $1 from $PLAN_SERVER/$PLAN_WORKSPACE"
echo
~/stbin/run-wiki-tests --plan-server "$PLAN_SERVER"  --plan-workspace "$PLAN_WORKSPACE"  --timeout 60000 --plan-page "$1"

