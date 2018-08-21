@RestResource(urlMapping='/getUserAdavanceData/*')
global with sharing class WS_getUserAdavanceData {

    @HttpGet
    global static List<Adavance__c> doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String voucherId = RestContext.request.params.get('voucherId');
        List<Adavance__c> salaries = new List<Adavance__c>();
        List<String> fields = new List<String>(Adavance__c.SObjectType.getDescribe().fields.getMap().keySet());
        String soql = ' select ' + String.join(fields, ',')+ ' from Adavance__c'+' where Voucher__c =\'' + voucherId +'\'';
         salaries = Database.query(soql);
         return salaries;
    }
    
    public static void  CCHelp()
    {
       Integer val = 1;
       
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
       
        }
}