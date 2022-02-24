/**
 * @description This APEX class is used to construct the GetRecordsCriteria
 * @author      Salesforce Binge
 * @website     https://salesforcebinge.com/
 */
public with sharing class GetRecordsCriteria {
    @InvocableVariable(required=true)
    public String objectApiName;

    @InvocableVariable(required=true)
    public String fieldsToQuery;

    @InvocableVariable(required=true)
    public String filterOperator;  //OR, AND

    @InvocableVariable(required=true)
    @AuraEnabled
    public List<GetRecordsFilter> filters;
}