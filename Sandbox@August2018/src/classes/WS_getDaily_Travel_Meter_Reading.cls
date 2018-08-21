@RestResource(urlMapping='/getDaily_Travel_Meter_Reading/*')
global with sharing class WS_getDaily_Travel_Meter_Reading {

    @HttpGet
    global static List<Daily_Travel_Meter_Reading__c> doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String userId = RestContext.request.params.get('userId');
        List<Daily_Travel_Meter_Reading__c> salaries = new List<Daily_Travel_Meter_Reading__c>();
        List<String> fields = new List<String>(Daily_Travel_Meter_Reading__c.SObjectType.getDescribe().fields.getMap().keySet());
        String soql = ' select ' + String.join(fields, ',')+ ' from Daily_Travel_Meter_Reading__c'+' where MDFM_User__c=\'' + userId +'\'';
         salaries = Database.query(soql);
         return salaries;
    }
}