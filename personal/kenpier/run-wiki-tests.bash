#!/bin/bash -e

BRANCH=""
BRANCH_PATH=""
PLAN_WORKSPACE="feb22-test"

if [ $2!="" ]
then
    BRANCH="$2"
    BRANCH_PATH="branches/$2"
fi

if [ "$SELENIUM_PLAN_WORKSPACE" != "" ]
then
    PLAN_WORKSPACE="$SELENIUM_PLAN_WORKSPACE"
fi

echo Removing all ceqlotron tasks to stop unnecessary indexing
~/src/st/current/nlw/bin/ceq-rm /.+/

echo Retrieving test data
~/src/st/current/nlw/dev-bin/create-test-data-workspace

if [ "$BRANCH" != "" ]
then
    # check out control
    echo Importing Control from $BRANCH
    cd ~/src/st/control/
    svn co https://repo.socialtext.net:8999/svn/control/$BRANCH_PATH $BRANCH_PATH
    
    # link it in the right place in the working copy
    cd ~/src/st/current/nlw
    ~/src/st/current/nlw/dev-bin/link-control-panel $BRANCH
    
    # check out console
    echo Importing Console from $BRANCH
    cd ~/src/st/appliance/
    svn co https://repo.socialtext.net:8999/svn/appliance/$BRANCH_PATH $BRANCH_PATH
    
    # link it in the right place in the working copy
    cd ~/src/st/current/nlw
    ~/src/st/current/nlw/dev-bin/link-console  $BRANCH
    
    # check out reports
    echo Importing Reports from $BRANCH
    cd ~/src/st/socialtext-reports/
    svn co https://repo.socialtext.net:8999/svn/socialtext-reports/$BRANCH_PATH $BRANCH_PATH
    
    # link it in the right place in the working copy
    cd ~/src/st/current/nlw
    ##### ~/src/st/socialtext-reports/$BRANCH_PATH/setup-dev-env
    
    # check out skins
    echo Importing Socialtext Skins from $BRANCH
    cd ~/src/st/socialtext-skins/
    svn co https://repo.socialtext.net:8999/svn/socialtext-skins/$BRANCH_PATH $BRANCH_PATH
    
    # link it in the right place in the working copy
    cd ~/src/st/current/nlw
    ~/src/st/current/nlw/dev-bin/create-skinlink $BRANCH
    
fi

echo Restarting apache server for control to take effect
~/src/st/current/nlw/dev-bin/nlwctl  start

cd ~/src/st/current/
echo plan-page is $1
echo plan-workspace is $PLAN_WORKSPACE

~/stbin/run-wiki-tests --plan-workspace "$PLAN_WORKSPACE"  --timeout 60000 --plan-page "$1" >& testcases.out&
echo RUNNING ...
