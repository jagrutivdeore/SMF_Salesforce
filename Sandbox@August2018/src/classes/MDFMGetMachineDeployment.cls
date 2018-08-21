@RestResource(urlMapping='/MDFMGetMachineDeployment/*')
global class MDFMGetMachineDeployment {
  @HttpGet
    global static List<Machine_Deployment__c> doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String userId = RestContext.request.params.get('userId');
        List<Machine_Deployment__c> machineDeployementDetail = new List<Machine_Deployment__c>();
        List<String> fields = new List<String>(Machine_Deployment__c.SObjectType.getDescribe().fields.getMap().keySet());
        String soql = ' select ' + String.join(fields, ',')+ ' from Machine_Deployment__c'+' where MDFM_User__c =\'' + userId +'\'';
         machineDeployementDetail = Database.query(soql);
         return machineDeployementDetail;
    }
}