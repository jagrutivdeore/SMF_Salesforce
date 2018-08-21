@RestResource(urlMapping='/MDFMGetMachineFinalPaymentRequest/*')
global class MDFMGetMachineFinalPaymentRequest {
@HttpGet
    global static List<Machine_Final_Payment_Request__c> doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String userId = RestContext.request.params.get('userId');
        List<Machine_Final_Payment_Request__c> machineDeployementDetail = new List<Machine_Final_Payment_Request__c>();
        List<String> fields = new List<String>(Machine_Final_Payment_Request__c.SObjectType.getDescribe().fields.getMap().keySet());
        String soql = ' select ' + String.join(fields, ',')+ ' from Machine_Final_Payment_Request__c'+' where MDFM_User__c =\'' + userId +'\'';
        System.debug('SOQL query is' + soql); 
        machineDeployementDetail = Database.query(soql);
         return machineDeployementDetail;
    }
}