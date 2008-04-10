#!/bin/bash -e

if [ "$1" == "" ]
then
    echo "Usage: $0 PLAN_PAGE [BRANCH [1]] means run plan page, update branch BRANCH, fdefs if 1"
    exit
fi

BRANCH=""
BRANCH_PATH=""

PLAN_WORKSPACE="regression-test"
PLAN_SERVER="http://www2.socialtext.net"

if [ "$2" != "" ]
then
    BRANCH="$2"
    BRANCH_PATH="branches/$2"
fi

if [ "$SELENIUM_PLAN_WORKSPACE" != "" ]
then
    PLAN_WORKSPACE="$SELENIUM_PLAN_WORKSPACE"
fi

if [ "$SELENIUM_PLAN_SERVER" != "" ]
then
    PLAN_SERVER="$SELENIUM_PLAN_SERVER"
fi

if [ "$BRANCH" != "" ]
then
    # check out control
    echo Importing Control from $BRANCH
    cd $ST_SRC_BASE/control/
    svn co https://repo.socialtext.net:8999/svn/control/$BRANCH_PATH $BRANCH_PATH
    
    # check out console
    echo Importing Console from $BRANCH
    cd $ST_SRC_BASE/appliance/
    svn co https://repo.socialtext.net:8999/svn/appliance/$BRANCH_PATH $BRANCH_PATH
    
    # check out reports
    echo Importing Reports from $BRANCH
    cd $ST_SRC_BASE/socialtext-reports/
    svn co https://repo.socialtext.net:8999/svn/socialtext-reports/$BRANCH_PATH $BRANCH_PATH
    
    # link it in the right place in the working copy
    cd $ST_SRC_BASE/current/nlw
    ##### $ST_SRC_BASE/socialtext-reports/$BRANCH_PATH/setup-dev-env
    
    # check out skins
    echo Importing Socialtext Skins from $BRANCH
    cd $ST_SRC_BASE/socialtext-skins/
    svn co https://repo.socialtext.net:8999/svn/socialtext-skins/$BRANCH_PATH $BRANCH_PATH
    
fi

if [ ! -e ~/.nlw  ] || [ "$3"  != "" ]
then
    $ST_SRC_BASE/current/nlw/dev-bin/fresh-dev-env-from-scratch
fi

cd $ST_SRC_BASE/current/nlw/
$ST_SRC_BASE/current/nlw/dev-bin/link-control-panel $BRANCH
$ST_SRC_BASE/current/nlw/dev-bin/link-console  $BRANCH
$ST_SRC_BASE/current/nlw/dev-bin/create-skinlink $BRANCH

echo Removing all ceqlotron tasks to stop unnecessary indexing
$ST_SRC_BASE/current/nlw/bin/ceq-rm /.+/

echo Retrieving test data
$ST_SRC_BASE/current/nlw/dev-bin/create-test-data-workspace

echo Restarting apache server for control to take effect
$ST_SRC_BASE/current/nlw/dev-bin/nlwctl  start


cd $ST_SRC_BASE/current/
echo plan-page is $1
echo plan-workspace is $PLAN_WORKSPACE

$ST_SRC_BASE/stconfig/stbin/run-wiki-tests --no-maximize --plan-server "$PLAN_SERVER" --plan-workspace "$PLAN_WORKSPACE" --timeout 60000 --plan-page "$1" >& testcases.out&
echo RUNNING ... tail testcases.out to monitor progress
