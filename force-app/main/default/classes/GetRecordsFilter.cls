/**
 * @description This APEX class is used to construct the GetRecordsFilter
 * @author      Salesforce Binge
 * @website     https://salesforcebinge.com/
 */
public with sharing class GetRecordsFilter {
    @AuraEnabled
    public String filterField;

    @AuraEnabled
    public String operator;  // =, !=, <, >, <=, >=, IN, NOT IN

    @AuraEnabled
    public String fieldValue;

    @AuraEnabled
    public List<String> fieldCollectionValue;
}