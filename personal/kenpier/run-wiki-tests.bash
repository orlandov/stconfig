#!/bin/bash -e

echo Removing all ceqlotron tasks to stop unnecessary indexing
~/src/st/current/nlw/bin/ceq-rm /.+/

echo Retrieving test data
~/src/st/current/nlw/dev-bin/create-test-data-workspace

# check out the control repository
echo Importing Control from trunk
cd ~/src/st/
svn co https://repo.socialtext.net:8999/svn/control

# link it in the right place in the working copy
cd ~/src/st/current/nlw
~/src/st/current/nlw/dev-bin/link-control-panel

echo Restarting apache server for control to take effect
~/src/st/current/nlw/dev-bin/nlwctl  start

cd ~/src/st/current/
echo plan-page is $1
~/stbin/run-wiki-tests --timeout 60000 --plan-page "$1" >& testcases.out&
echo RUNNING ...
