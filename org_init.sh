#!/bin/sh

while [ ! -n "${orgAlias}"  ]
do
    echo "Please enter a name for your scratch org: "
    read orgAlias
done

sh org_create.sh "${orgAlias}"
sh org_setup.sh "${orgAlias}" -s