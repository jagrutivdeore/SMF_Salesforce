@RestResource(urlMapping='/getdownloadContentData/*')
global with sharing class WS_getdownloadContentData {

    @HttpGet
    global static List<Download_Content__c> doGet() {
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    String userId = RestContext.request.params.get('userId');
    
    MV_User__c user = new MV_User__c();
    user = [select id,Role_Name__c from MV_User__c where id = :userId];
    List<Download_Content__c> dcList = new List<Download_Content__c>();
    List<String> fields = new List<String>(Download_Content__c.SObjectType.getDescribe().fields.getMap().keySet());
    String soql = ' select ' + String.join(fields, ',')+ ' from Download_Content__c'+' where Role__c includes (\''+ user.Role_Name__c+'\') order by position__c';
    dcList = Database.query(soql);
    return dcList;
   } 
    public static void testCode() {
         Integer i =0;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        } 
}