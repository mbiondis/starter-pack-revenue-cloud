# Revenue Cloud Starter Pack

This repo contains everything needed to use **Salesforce CPQ** and **Salesforce Billing** in any org. While originally intended for Scratch Org development, its components can be used to adapt any org to a Revenue Cloud expert.

## Installation
> Make sure to update the latest *{version number}* for each file in the `force-app/main/default/installedPackages` (details [here](https://install.steelbrick.com))

- Install all Packages
```
sfdx force:source:deploy -p force-app/main/default/installedPackages
```
> This process usually takes 25 minutes (10min for CPQ + 10min for Billing + 5min for Advanced Approvals)
- Push the repository metadata to the org
```
sfdx force:source:beta:push
```

## Assign the Permission Sets
The package contains some custom fields that are accessed through the Revenue Cloud Permission Set Group

- Assign the permission set group to your user
```
sfdx force:user:permset:assign --permsetname RevenueCloud_Admin --targetusername <username/alias>
```

## Manual Org Setup
Edits to the managed package are not allowed using the `push` command, so they have to be done manually.

- Go to **Setup > Installed Packages**
- Click `Configure` next to **Salesforce CPQ**

#### Authorize the Calculation Service
- Go to the `Pricing and Calculation` tab
  - Click `Authorize Calculation Service`

#### Improve Qoute Line Editor UX
- Go to the `Line Editor` tab
  - Check `Visualize Product Hierarchy`
  - Check `Enable Column Resizing`

#### Enable Usage Options
- Go to the `Pricing and Calculation` tab
  - Check `Enable Usage Based Pricing`
  - Check `Quote Line Edits for Usage Based Pricing`
  - Check `Calculate Immediately`

#### Default Order Start Date
- Go to the `Order` tab
  - Set **Default Order Start Date** to `Quote Start Date`
  - Check `Allow Multiple Orders`

#### Imrpove browser performance
- Go to the `Additional Settings` tab
  - Check `Improve Browser Performance`

- Click `Save`