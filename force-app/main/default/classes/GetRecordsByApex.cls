/**
 * @description GetRecordsByApex class provides a convenient facade to
 * the custom Get Records logic, e.g. Get records from an Object 
 * ‘WHERE <fieldname> IN :<collection>’, since this cannot be directly done in the 
 * flows as of today
 * 
 * This class is capable of having extra filters (Single/Collection) in addition to the
 * actual purpose stated above.
 * 
 * The class is bulkified but has it's own drawbacks. If there are more than 100 inputs, 
 * it will violate the SOQL 101 governor limits since the query is dynamic with different objects. 
 * 
 *
 * @author      Salesforce Binge
 * @website     https://salesforcebinge.com/
 */
public with sharing class GetRecordsByApex {
    private static final String IN_FILTER = 'IN';
    private static final String OPEN_PARANTHESES = '(';
    private static final String CLOSE_PARANTHESES = ')';
    private static final String COMMA = ',';
    private static final String STR_SELECT = 'SELECT ';
    private static final String STR_FROM = ' FROM ';
    private static final String STR_WHERE = ' WHERE ';

    private static final String LOGGER = 'GetRecordsByApex';

    @InvocableMethod(label = 'GetRecordsByApex' description = 'This APEX class serves as entry point from the flow')
    public static List<List<SObject>> getRecords(List<GetRecordsCriteria> inputParams) {

        try {
            List<List<SObject>> result = new List<List<SObject>>();

            Boolean isInvalidParameter = inputParams.isEmpty();

            if (isInvalidParameter) {
                return result;
            }

            System.debug('objectApiName = ' + inputParams[0].objectApiName);
            for (GetRecordsCriteria criteriaEntry : inputParams) {
                List<SObject> partialResult = queryRecords(criteriaEntry);
                result.add(partialResult);
            }

            System.debug('result = ' + result);
            
            if(result.get(0).isEmpty()){
                result = null;
            }
            
            return result;
        } catch (Exception e) {
            throw e;
        }
    }

    /**
     * @description This function queries records dynamically
     * @author      Salesforce Binge
     * @website     https://salesforcebinge.com/
     * 
     * @param  criteriaEntry  GetRecordsCriteria
     * @return List<SObject>
     */
    public static List<SObject> queryRecords(GetRecordsCriteria criteriaEntry) {
        List<String> queryFilters = new List<String>();
        String filters = '';
        String filterOperatorWithSpace = ' ' + criteriaEntry.filterOperator + ' ';

        if (criteriaEntry.filters != null) {
            queryFilters = constructQueryFilters(criteriaEntry.filters);
        } else {
            throw new StringException ('No filters are specified to query records');
        }

        String queryString = STR_SELECT + criteriaEntry.fieldsToQuery + STR_FROM + criteriaEntry.objectApiName + STR_WHERE;

        if (! queryFilters.isEmpty()) {
            filters = String.join(queryFilters, filterOperatorWithSpace);
            queryString += filters;
        }

        System.debug('queryString = ' + queryString);

        List<SObject> recordList = database.query(queryString);
        return recordList;
    }

    /**
     * @description This function constructs the query filters
     * @author      Salesforce Binge
     * @website     https://salesforcebinge.com/
     * 
     * @param  filters  List<GetRecordsFilter>
     * @return List<String>
     */
    public static List<String> constructQueryFilters(List<GetRecordsFilter> filters) {
        List<String> queryFilters = new List<String>();

        for (GetRecordsFilter filter : filters) {
            queryFilters.add(processRecordFilter(filter));
        }

        return queryFilters;
    }

    /**
     * @description This function extracts and constructs the query filter
     * @author      Salesforce Binge
     * @website     https://salesforcebinge.com/
     * 
     * @param  filter  GetRecordsFilter
     * @return String
     */
    public static String processRecordFilter(GetRecordsFilter filter) {
        String filterString = filter.filterField + ' ' + filter.operator + ' ' ;
        if (filter.operator.contains(IN_FILTER)) {
            List<String> quotedValues = getQuotedCollection(filter.fieldCollectionValue);
            String collection = OPEN_PARANTHESES;
            collection += String.join(quotedValues, COMMA);
            collection += CLOSE_PARANTHESES;
            filterString += collection;
        } else {
            if(filter.fieldValue == 'TRUE' || filter.fieldValue == 'FALSE' || filter.fieldValue.contains('__c') || filter.operator == '<' || filter.operator == '>'){
                filterString += filter.fieldValue;
            }
            else {
                filterString += getQuotedValue(filter.fieldValue);
            }
                
        }
        return filterString;
    }

    /**
     * @description This function returns a string value enclosed by single quotes (')
     * @author      Salesforce Binge
     * @website     https://salesforcebinge.com/
     * 
     * @param  filter  GetRecordsFilter
     * @return String
     */
    public static String getQuotedValue(String fieldValue) {
        String quotedValue ='\''+ fieldValue +'\'';
        return quotedValue;
    }

    /**
     * @description This function returns a string collection enclosed by single quotes (')
     * @author      Salesforce Binge
     * @website     https://salesforcebinge.com/
     * 
     * @param  filter  GetRecordsFilter
     * @return String
     */
    public static List<String> getQuotedCollection(List<String> fieldCollectionValue) {
        List<String> quotedValues = new List<String>();

        for (String fieldValue : fieldCollectionValue) {
            String quotedValue ='\''+ fieldValue +'\'';
            quotedValues.add(quotedValue);
        }
        return quotedValues;
    }
}