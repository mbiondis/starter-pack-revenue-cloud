#!/bin/sh

# inspired by 
# https://intelliforce.wordpress.com/2020/03/21/automate-sfdx-cli-using-shell-script/
# https://gist.github.com/metadaddy/c0ba89a47c5b2c8c955b3b9bdcca6076

# First argument is the org alias
orgAlias=$1

# Create the new scratch org
echo " "
echo "******* Building your org, please wait..."
created="$(sfdx force:org:create -f config/project-scratch-def.json -d 30 -a "${orgAlias}" --json)"

# Org variable is the output .json that contains all info
org="$(sfdx force:user:display -u ${orgAlias} --json)"

# Extract the necessary variables
accessToken="$(echo ${org} | fx .result.accessToken)"
instanceUrl="$(echo ${org} | fx .result.instanceUrl)"
orgId="$(echo ${org} | fx .result.orgId)"
loginUrl="$(echo ${org} | fx .result.loginUrl)"
username="$(echo ${org} | fx .result.username)"

# Wait until new instance resolves
until host ${instanceUrl} > /dev/null
do
  sleep 10
done

# Generate user password
password="$(sfdx force:user:password:generate -u ${username} --json | fx .result.password)"

# Print login details
echo " "
echo "************ Login details ************"
echo "login url: ${loginUrl}"
echo "username: ${username}"
echo "password: ${password}"
echo "***************************************"

# Set IP range
echo " "
echo "******* Expanding IP ranges..."

# Get my IP address
myip="$(curl -s http://ipinfo.io/ip)"

opened="$(curl -s ${instanceUrl}/services/Soap/m/39.0/${orgId} \
  -H "Content-Type: text/xml; charset=UTF-8" \
  -H "SOAPAction: updateMetadata" \
  -d '<?xml version="1.0" encoding="UTF-8"?>
<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <env:Header>
    <SessionHeader xmlns="http://soap.sforce.com/2006/04/metadata">
      <sessionId>'${accessToken}'</sessionId>
    </SessionHeader>
  </env:Header>
  <env:Body>
    <m:updateMetadata xmlns:m="http://soap.sforce.com/2006/04/metadata" xmlns:sobj="null">
      <m:metadata xsi:type="m:SecuritySettings">
        <m:networkAccess>
          <m:ipRanges>
            <m:start>'${myip}'</m:start>
            <m:end>'${myip}'</m:end>
          </m:ipRanges>
        </m:networkAccess>
      </m:metadata>
    </m:updateMetadata>
  </env:Body>
</env:Envelope>')"

echo "Done"

# Password might have characters that need to be escaped for XML!
esc_password="$(echo ${password} | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&#39;/g')"

# Test login with username and password
login="$(curl -s https://test.salesforce.com/services/Soap/u/39.0 \
  -H "Content-Type: text/xml; charset=UTF-8" \
  -H "SOAPAction: login" \
  -d '<?xml version="1.0" encoding="utf-8" ?>
<env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">
  <env:Body>
    <n1:login xmlns:n1="urn:partner.soap.sforce.com">
      <n1:username>'${username}'</n1:username>
      <n1:password>'${esc_password}'</n1:password>
    </n1:login>
  </env:Body>
</env:Envelope>')"

if [[ $(echo ${login} | xpath '/soapenv:Envelope/soapenv:Body/loginResponse' 2> /dev/null) ]]; then
  # All is good
  echo "All good"
fi

echo " "
echo "******* Scratch org created successfully..."

# Install packages
echo " "
echo "******* Installing packages (this might take up to 30min)..."
sfdx force:source:deploy -p installedPackages -u "${orgAlias}"