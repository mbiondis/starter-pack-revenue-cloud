# Revenue Cloud Starter Pack

This repo contains everything needed to use **Salesforce CPQ** and **Salesforce Billing** in any org.
> Make sure to update the latest *{version number}* for each file in the `force-app/main/default/installedPackages` (details [here](https://install.steelbrick.com))
## Installation
You can either create a brand new Scratch Org to test out the functionality, or push the repo to a previously created org.
### New Scratch Org
> Make sure you defined a default Dev Hub
- Run the setup shell script
```
sh org_init.sh
```
- Choose a name for the scratch org

### Existing Org
- Run the setup shell script
```
sh org_setup.sh <org alias>
```

## Manual Org Setup
> Edits to the managed package are not allowed using the `push` command, so they have to be done manually.

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