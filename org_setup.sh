#!/bin/sh

# First argument is the org alias
orgAlias=$1

# Configure the org
echo " "
echo "******* Installing packages (this might up to 30min)..."
sfdx force:source:deploy -p installedPackages -u "${orgAlias}"

echo " "
echo "******* Pushing source code..."
sfdx force:source:push -u "${orgAlias}" -f

echo " "
echo "******* Assigning permisission sets..."

# Managed Package
sfdx force:user:permsetlicense:assign -n "Salesforce CPQ License" -u "${orgAlias}"
sfdx force:user:permsetlicense:assign -n "Salesforce CPQ AA License" -u "${orgAlias}"
sfdx force:user:permset:assign -n "SteelBrickCPQAdmin" -u "${orgAlias}"
sfdx force:user:permset:assign -n "SalesforceBillingAdmin" -u "${orgAlias}"

# Starter Pack
sfdx force:user:permset:assign -n "StarterPack_RevenueCloud_Admin" -u "${orgAlias}"

echo " "
echo "******* Opening the environment..."
sfdx force:org:open -u "${orgAlias}" -p "/lightning/setup/ImportedPackage/home"