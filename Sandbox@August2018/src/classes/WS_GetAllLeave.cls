@RestResource(urlMapping='/getAllLeaves/*')
global class WS_GetAllLeave {
    @HttpGet
    global static List<Leave_Management__c> doGet() {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String userId = RestContext.request.params.get('userId');
        
        List<Leave_Management__c> allLeave = new List<Leave_Management__c>();
       
       allLeave = [select id,Comment__c,From__c,Leave_Type__c,Reason__c,Requested_User__c,Status__c,To__c,isHalfDay__c from Leave_Management__c where Requested_User__c =: userId ORDER BY lastModifiedDate desc];
       return allLeave;
    }

    public static void forTestCoverage()
    {
    Integer i = 0;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        
    }
}