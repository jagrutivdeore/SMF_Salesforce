@RestResource(urlMapping='/getUserContactData/*')
global with sharing class WS_getUserContactData {

    @HttpGet
    global static List<Contact__c> doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String userId = RestContext.request.params.get('userId');
        List<Contact__c> salaries = new List<Contact__c>();
        List<String> fields = new List<String>(Contact__c.SObjectType.getDescribe().fields.getMap().keySet());
        String soql = ' select ' + String.join(fields, ',')+ ' from Contact__c'+' where MDFM_User__c=\'' + userId +'\'';
         salaries = Database.query(soql);
         return salaries;
    }
}