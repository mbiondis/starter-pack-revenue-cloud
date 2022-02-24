/**
 * @description ToggleBillingTriggers provides an interface that
 * enables a Flow to toggle the Salesforce Billing triggers,
 * usually for deleting Invoice records
 * 
 * @author      Martin Biondi
 */
public with sharing class SetBillingConfig {

    public class BillingConfig {
        @InvocableVariable public Boolean triggerState;
    }

    @InvocableMethod(label = 'SetBillingConfig' description = 'Enable or disable the Salesforce Billing triggers')
    public static void toggleEnabled(List<BillingConfig> billingParams) {

        // Get the Salesforce Billing configuration Custom Metadata
        blng__BillingConfig__c billingConfig = [SELECT Id, Name, blng__BooleanValue__c FROM blng__BillingConfig__c WHERE Name = 'DISABLE_TRIGGERS'];

        System.debug('Billing Triggers will be set to ' + billingParams[0].triggerState);
        // Set the desired values (replace with method calls)
        billingConfig.blng__BooleanValue__c = !billingParams[0].triggerState;
        
        // Cast it into an sObject to commit it to the database
        SObject triggerSObject = (SObject)billingConfig;
        Database.SaveResult result = Database.updateImmediate(triggerSObject);
        
        // Communicate result
        if (result.isSuccess()) {
            String msg = !billingParams[0].triggerState ? 'disabled': 'enabled';
            System.debug('Successfully '+ msg +' Billing Triggers');
            //return true;
        } else {
            for (Database.Error err : result.getErrors()) {
                System.debug('The following error has occurred.');
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            throw new AuraHandledException(err.getMessage());
            }
            //return false;
        }
    }
}