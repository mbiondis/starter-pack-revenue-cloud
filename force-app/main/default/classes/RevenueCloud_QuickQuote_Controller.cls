/*

This class wraps the Flow "Create_QuickQuote", which creates an Opportunity and a Quote 
associated to the current Account.

The Apex Class is necessary because a Flow cannot return a VisualForce page reference, which is the only
way to open the Quote Line Editor directly from the Account record page.

This class is called by the VisualForce page "RevenueCloud_QuickQuote"

*/

public class RevenueCloud_QuickQuote_Controller {

public Account account { get; set; }

// This is an Extension Controller. Thus, we must invoke the standard controller.
public RevenueCloud_QuickQuote_Controller(ApexPages.StandardController controller) {
    this.account = [SELECT Id FROM Account WHERE Id =: ApexPages.CurrentPage().getparameters().get('id')];
}

// Method for creating Quote
public PageReference createQuote() {
           
    // Set up the parameters of the Flow
    Map<String, Object> params = new Map<String, Object>();
    params.put('IN_Account_ID', this.account.Id);
    
    // Pass the parameters
    Flow.Interview.RevenueCloud_Create_QuickQuote create_QuickQuote = new Flow.Interview.RevenueCloud_Create_QuickQuote(params);
    
    // Call the Flow
    create_QuickQuote.start();
    
    // Retrieve the Quote ID
    Id quoteId = (Id) create_QuickQuote.getVariableValue('OUT_Quote_ID');
    
    //Returns URL and redirects the Visualforce page
    return new PageReference('/apex/sbqq__sb?scontrolCaching=1&id=' + quoteId + '#quote/le?qId=' + quoteId);
}
}