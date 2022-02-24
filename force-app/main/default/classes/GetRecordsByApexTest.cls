/**
 * @description Used to test the class "GetRecordsByApex"
 * @author      Salesforce Binge
 * @website     https://salesforcebinge.com/
 */
@isTest 
public with sharing class GetRecordsByApexTest {
    private static Account account;

    @TestSetup
    private static void setup() {
        account = new Account (Name='Mock Test');
        insert account;
    }

    private static void loadSetup() {
        account = [SELECT Id, Name FROM Account ORDER BY CreatedDate DESC LIMIT 1];
    }


    @isTest
    private static void testQueryRecordsWithValidInputsOne() {
        loadSetup();
        Test.startTest();

        List<String> accountIds = new List<String> {account.Id};
        List<GetRecordsFilter> filters = new List<GetRecordsFilter>();

        GetRecordsFilter filterOne = new GetRecordsFilter();
        filterOne.filterField = 'Id';
        filterOne.operator = 'IN';
        filterOne.fieldCollectionValue = accountIds;
        filters.add(filterOne);

        GetRecordsCriteria criteria = new GetRecordsCriteria();
        criteria.objectApiName = 'Account';
        criteria.fieldsToQuery = 'Id, Name';
        criteria.filterOperator = 'AND';
        criteria.filters = filters;

        List<GetRecordsCriteria> criteriaInputs = new List<GetRecordsCriteria>();
        criteriaInputs.add(criteria);

        List<List<SObject>> result = GetRecordsByApex.getRecords(criteriaInputs);
        System.assertEquals(1, result.size());

        Test.stopTest();
    }

    @isTest
    private static void testQueryRecordsWithValidInputsTwo() {
        loadSetup();

        Test.startTest();
        List<GetRecordsFilter> filters = new List<GetRecordsFilter>();

        GetRecordsFilter filterOne = new GetRecordsFilter();
        filterOne.filterField = 'Id';
        filterOne.operator = '=';
        filterOne.fieldValue = account.Id;
        filters.add(filterOne);

        GetRecordsCriteria criteria = new GetRecordsCriteria();
        criteria.objectApiName = 'Account';
        criteria.fieldsToQuery = 'Id, Name';
        criteria.filterOperator = 'AND';
        criteria.filters = filters;

        List<GetRecordsCriteria> criteriaInputs = new List<GetRecordsCriteria>();
        criteriaInputs.add(criteria);

        List<List<SObject>> result = GetRecordsByApex.getRecords(criteriaInputs);
        System.assertEquals(1, result.size());

        Test.stopTest();
    }

    @isTest
    private static void testQueryRecordsWithInvalidInputsOne() {
        loadSetup();

        Test.startTest();
        String errorMessage;
        try {
            List<GetRecordsFilter> filters;

            GetRecordsCriteria criteria = new GetRecordsCriteria();
            criteria.objectApiName = 'Account';
            criteria.fieldsToQuery = 'Id, Name';
            criteria.filterOperator = 'AND';
            criteria.filters = filters;

            List<GetRecordsCriteria> criteriaInputs = new List<GetRecordsCriteria>();
            criteriaInputs.add(criteria);

            List<List<SObject>> result = GetRecordsByApex.getRecords(criteriaInputs);
        } catch (StringException e) {
            errorMessage = e.getMessage();
        }
        Test.stopTest();
        system.assert(errorMessage.contains('No filters are specified to query records'));
    }
}