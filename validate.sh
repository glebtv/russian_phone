#!/bin/bash
 
if ! which md5sum > /dev/null; then
echo Install md5sum
exit 1
fi
 
if ! which curl > /dev/null; then
echo Install curl
exit 1
fi
 
home=$(gem env GEM_HOME)
cache=$home/cache
 
echo This will take a while...
 
for gem in $cache/*.gem; do
gemfile=$(basename $gem)
 
local=$(md5sum $gem | awk '{print $1}')
remote=$(curl -s -D - -X HEAD -H 'Connection:close' http://production.cf.rubygems.org/gems/$gemfile | grep 'ETag' | cut -d '"' -f 2)

# echo $gemfile local: $local, remote: $remote
 
if [[ ! $local = $remote ]]; then
echo $gemfile mismatch. local: $local, remote: $remote
fi


done
 
echo All done.
