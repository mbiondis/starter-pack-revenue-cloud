#!/bin/sh

# Function arguments
orgAlias=$1
dataLoad=$2

echo " "
echo "******* Pushing source code..."
#sfdx force:source:push -u "${orgAlias}"

echo " "
echo "******* Assigning permisission sets..."

# Assign Standard Permission Sets and Permission Set Licenses
#sfdx force:user:create -f config/admin-user-def.json -u "${orgAlias}"
sfdx force:user:permsetlicense:assign -n "Salesforce CPQ License" -u "${orgAlias}"
sfdx force:user:permsetlicense:assign -n "Salesforce CPQ AA License" -u "${orgAlias}"
sfdx force:user:permset:assign -n "SteelBrickCPQAdmin" -u "${orgAlias}"
sfdx force:user:permset:assign -n "SalesforceBillingAdmin" -u "${orgAlias}"
sfdx force:user:permset:assign -n "AdvancedApprovalsAdmin" -u "${orgAlias}"

# Assign Starter Pack Permission Set Group
sfdx force:user:permset:assign -n "RevenueCloud_Admin" -u "${orgAlias}"

# Load Sample Data (only in scratch org)
if [-n "${dataLoad}"]
then
    echo "******* Loading data..."
    sfdx sfdmu:run -s csvfile -p data/csv -u "${orgAlias}"
fi

#echo " "
#echo "******* Opening the environment..."
#sfdx force:org:open -u "${orgAlias}" -p "/lightning/setup/ImportedPackage/home"