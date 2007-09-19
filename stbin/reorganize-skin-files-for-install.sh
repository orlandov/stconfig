#!/bin/bash
set -e

# Location of the package-to-be-built's files 
pkg_dir=$1

# Validate the command line
if [ -z "$pkg_dir" ]; then
    echo "Usage: $0 directory"
    exit 1
else
    # Qualify the pkg_dir, since the data we care about is in ./usr/share/nlw
    skin=$(basename "$pkg_dir")
    pkg_dir="${pkg_dir}/usr/share/nlw"
    if [ ! -d "$pkg_dir" ]; then
        echo "Directory ${pkg_dir} does not exist.  It should!"
        exit 1
    fi
fi

# In Subversion a skin is stored as follows:
#
#       skin-name/info.yaml
#       skin-name/css/*
#       skin-name/javascript/*
#       skin-name/images/*
#
# When packaging the skin we want the files installed on the system to look
# like this:
#
#       css/skin-name/*
#       javascript/skin-name/*
#       images/skin-name/*
#
# The dir2deb utility will take a directory, an optional root, and create a
# package which will install everything in the given directory into the given
# root directory (defaults to /).  dir2deb just does a file copy, copying the
# directory contents into the package (optionally rerooting the files). 
#
# Since our files are not laid out in Subversion the way we want them
# installed we have to munge them first.  Luckily dir2deb has a
# --transform-script option which is useful here.  The script is called with
# the directory containing the package's contents *right* before the package
# is created, giving the script one last chance to reorganize the data.  This
# is what we do below:

rm -f "${pkg_dir}/info.yaml"  # Don't need this installed .. yet
for kind in css images javascript; do
    kind_dir="${pkg_dir}/${kind}"
    if [ -e "$kind_dir" ]; then
        # Rename "css" to "css/$skin"
        mv "$kind_dir" "${kind_dir}.backup"
        mkdir -p "$kind_dir"
        mv "${kind_dir}.backup" "${kind_dir}/${skin}"
    fi
done
