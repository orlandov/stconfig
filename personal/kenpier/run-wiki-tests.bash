#!/bin/bash -e

echo Retrieving test data
cd ~/src/st/current/nlw
dev-bin/create-test-data-workspace

# ?? I don't think you should be using this.
# nlw/dev-bin/link-control-panel
# Fix this later
/home/kenpier/import-control $2

cd ~/src/st/current

nlw/dev-bin/nlwctl restart

echo plan-page is $1
~/stbin/run-wiki-tests --timeout 30000 --plan-page "$1" >& testcases.out&
echo RUNNING ...
