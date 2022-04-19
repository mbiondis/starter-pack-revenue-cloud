#!/bin/sh

# First argument is the org alias
orgAlias=$1

echo " "
echo "******* Pushing source code..."
sfdx force:source:push -u "${orgAlias}" -f

echo " "
echo "******* Assigning permisission sets..."

# Managed Package
#sfdx force:user:create -f config/admin-user-def.json -u "${orgAlias}"
sfdx force:user:permsetlicense:assign -n "Salesforce CPQ License" -u "${orgAlias}"
sfdx force:user:permsetlicense:assign -n "Salesforce CPQ AA License" -u "${orgAlias}"
sfdx force:user:permset:assign -n "SteelBrickCPQAdmin" -u "${orgAlias}"
sfdx force:user:permset:assign -n "SalesforceBillingAdmin" -u "${orgAlias}"
sfdx force:user:permset:assign -n "AdvancedApprovalsAdmin" -u "${orgAlias}"

# Starter Pack
sfdx force:user:permset:assign -n "RevenueCloud_Admin" -u "${orgAlias}"

# Sample Data
sfdx sfdmu:run -s csvfile -p data/csv -u "${orgAlias}"

echo " "
echo "******* Opening the environment..."
sfdx force:org:open -u "${orgAlias}" -p "/lightning/setup/ImportedPackage/home"