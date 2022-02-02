#!/bin/sh

echo "> Run this script from the package root and make sure the path is correct in sfdx-project.json file"
echo " "
echo "------------------------------------------"
echo " "
while [ ! -n "${ORG_ALIAS}"  ]
do
    echo "Please enter a name for your scratch org: "
    read ORG_ALIAS
done

sh org_create.sh "${ORG_ALIAS}"
sh org_setup.sh "${ORG_ALIAS}"