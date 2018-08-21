@RestResource(urlMapping='/getDailyUpdate/*')
global with sharing class WS_getDailyUpdate {

    @HttpGet
    global static List<DailyUpdate__c> doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String userId = RestContext.request.params.get('userId');
        List<DailyUpdate__c> salaries = new List<DailyUpdate__c>();
        List<String> fields = new List<String>(DailyUpdate__c.SObjectType.getDescribe().fields.getMap().keySet());
        String soql = ' select ' + String.join(fields, ',')+ ' from DailyUpdate__c'+' where MDFM_User__c=\'' + userId +'\'';
         salaries = Database.query(soql);
         return salaries;
    }
}