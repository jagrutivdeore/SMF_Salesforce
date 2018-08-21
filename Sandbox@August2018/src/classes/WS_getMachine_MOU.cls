@RestResource(urlMapping='/getMachine_MOU/*')
global with sharing class WS_getMachine_MOU {

    @HttpGet
    global static List<Machine_MOU__c> doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String userId = RestContext.request.params.get('userId');
        List<Machine_MOU__c> machineMOU = new List<Machine_MOU__c>();
        List<String> fields = new List<String>(Machine_MOU__c.SObjectType.getDescribe().fields.getMap().keySet());
        String soql = ' select ' + String.join(fields, ',')+ ' from Machine_MOU__c'+' where MDFM_User__c=\'' + userId +'\'';
         machineMOU = Database.query(soql);
         return machineMOU;
    }
}