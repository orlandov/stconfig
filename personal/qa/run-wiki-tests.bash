#!/bin/bash -e

if [ "$1" == "" ]; then
    echo ""
    echo "Usage: run-wiki-tests.bash  PLAN_PAGE [BRANCH [1]]"
    echo "means run plan page, optional [update BRANCH [fdefs if 1]]"
    echo Wikitests are run from the local wikitests wiki
    echo "Export SELENIUM_PLAN_WORKSPACE and/or SELENIUM_PLAN_SERVER to run from external places"
    echo ""
    exit
fi

BRANCH=""
BRANCH_PATH=""

PORT=`perl -e 'print $> + 20000'`
PLAN_SERVER=http://`hostname`:$PORT
PLAN_WORKSPACE="wikitests"
USERNAME="wikitester@ken.socialtext.net"

if [ "$2" != "" ]; then
    if [ "$2" == "trunk" ]; then
        BRANCH="trunk"
        BRANCH_PATH="trunk"
    else
        BRANCH="$2"
        BRANCH_PATH="branches/$2"
    fi
fi

if [ "$SELENIUM_PLAN_WORKSPACE" != "" ]; then
    PLAN_WORKSPACE="$SELENIUM_PLAN_WORKSPACE"
fi

if [ "$SELENIUM_PLAN_SERVER" != "" ]; then
    PLAN_SERVER="$SELENIUM_PLAN_SERVER"
fi

if [ "$BRANCH" != "" ]; then
    # check out control
    echo Importing Control from $BRANCH
    mkdir -p  $ST_SRC_BASE/control
    cd $ST_SRC_BASE/control/
    svn co https://repo.socialtext.net:8999/svn/control/$BRANCH_PATH $BRANCH_PATH
    
    # check out console
    echo Importing Console from $BRANCH
    mkdir -p $ST_SRC_BASE/appliance
    cd $ST_SRC_BASE/appliance/
    svn co https://repo.socialtext.net:8999/svn/appliance/$BRANCH_PATH $BRANCH_PATH
    
    # check out reports
    echo Importing Reports from $BRANCH
    mkdir -p $ST_SRC_BASE/socialtext-reports
    cd $ST_SRC_BASE/socialtext-reports/
    svn co https://repo.socialtext.net:8999/svn/socialtext-reports/$BRANCH_PATH $BRANCH_PATH
    
    # check out skins
    echo Importing Socialtext Skins from $BRANCH
    mkdir -p $ST_SRC_BASE/socialtext-skins
    cd $ST_SRC_BASE/socialtext-skins/
    svn co https://repo.socialtext.net:8999/svn/socialtext-skins/$BRANCH_PATH $BRANCH_PATH

    # check out guanxi
    echo Importing guanxi from $BRANCH
    mkdir -p $ST_SRC_BASE/guanxi
    cd $ST_SRC_BASE/guanxi/
    svn co https://repo.socialtext.net:8999/svn/guanxi/$BRANCH_PATH $BRANCH_PATH
    
    # check out plugins
    echo Importing plugins from $BRANCH
    mkdir -p $ST_SRC_BASE/plugins
    cd $ST_SRC_BASE/plugins/
    svn co https://repo.socialtext.net:8999/svn/plugins/$BRANCH_PATH $BRANCH_PATH
fi

if [ ! -e ~/.nlw  ] || [ "$3"  != "" ]; then
    refresh-branch
    $ST_SRC_BASE/current/nlw/dev-bin/fresh-dev-env-from-scratch
    $ST_SRC_BASE/current/nlw/dev-bin/create-test-data-workspace
    $ST_CURRENT/nlw/bin/st-admin create-user --e $USERNAME >/dev/null 2>/dev/null || true
    $ST_CURRENT/nlw/bin/st-admin add-workspace-admin --w test-data --e $USERNAME >/dev/null 2>/dev/null || true
    $ST_CURRENT/nlw/bin/st-admin give-accounts-admin  --e $USERNAME  >/dev/null 2>/dev/null || true
    
    echo ""
    read -p  "Build wikitests wiki from scratch? y/n " wikitest
    if [ "$wikitest" == "y" ]; then
        $ST_CURRENT/nlw/dev-bin/wikitests-to-wiki
    else
        echo ""
        read -p  "Build wikitests wiki from tarball? y/n " wikitest
        [ "$wikitest" == "y" ] && $ST_CURRENT/nlw/bin/st-admin import-workspace --tarball $ST_CURRENT/nlw/share/workspaces/wikitests/wikitests.1.tar.gz  
    fi
else
    if [ "$BRANCH" != "trunk" ]; then
        LINK=$BRANCH
    else
        LINK=""
    fi

    echo Creating symbolic links
    echo ""
    cd $ST_CURRENT/nlw/
    $ST_CURRENT/nlw/dev-bin/link-control-panel $LINK
    echo ""
    $ST_CURRENT/nlw/dev-bin/link-console  $LINK
    echo ""
    $ST_CURRENT/nlw/dev-bin/create-skinlink $LINK
fi

echo Removing all ceqlotron tasks to stop unnecessary indexing
$ST_SRC_BASE/current/nlw/bin/ceq-rm /.+/

echo Restarting apache server for control to take effect
$ST_CURRENT/nlw/dev-bin/nlwctl  start

cd $ST_CURRENT
echo plan-page is $1
echo plan-workspace is $PLAN_WORKSPACE
echo plan-server is $PLAN_SERVER

$ST_SRC_BASE/stconfig/stbin/run-wiki-tests --no-maximize --test-username "$USERNAME" --test-email "$USERNAME" --plan-server "$PLAN_SERVER" --plan-workspace "$PLAN_WORKSPACE" --timeout 60000 --plan-page "$1" >& testcases.out&
echo RUNNING ... tail -f testcases.out to monitor progress
