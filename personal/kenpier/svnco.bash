# cd ~/
svn co https://repo.socialtext.net:8999/svn/socialtext/branches/$1  $2
cd $2
./nlw/dev-bin/fresh-dev-env-from-scratch
pushd nlw/share/js-test
make
popd

