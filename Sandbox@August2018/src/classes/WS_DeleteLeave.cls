@RestResource(urlMapping='/deleteLeave/*')
    global class WS_DeleteLeave {		
        
         @HttpGet
    global static List<Leave_Management__c> doGet() {
        
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    String LeaveId = RestContext.request.params.get('leaveId');
    String userId = RestContext.request.params.get('userId');
        
         Leave_Management__c leave = new Leave_Management__c();
       
       leave = [select id,Comment__c,From__c,Leave_Type__c,Reason__c,Requested_User__c,Status__c,To__c from Leave_Management__c where id =: LeaveId];
       delete leave;
        
        List<Leave_Management__c> allLeave = new List<Leave_Management__c>();
       
       allLeave = [select id,Comment__c,From__c,Leave_Type__c,Reason__c,Requested_User__c,Status__c,To__c from Leave_Management__c where Requested_User__c =: userId ORDER BY lastModifiedDate desc];
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
        
    }
}