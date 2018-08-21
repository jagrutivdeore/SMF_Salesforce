@RestResource(urlMapping='/getTravel_Form/*')
global class WS_getTravel_Form {

    @HttpGet
    global static List<Travel_Form__c> doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String userId = RestContext.request.params.get('userId');
        List<Travel_Form__c> salaries = new List<Travel_Form__c>();
        List<String> fields = new List<String>(Travel_Form__c.SObjectType.getDescribe().fields.getMap().keySet());
        String soql = ' select ' + String.join(fields, ',')+ ' from Travel_Form__c'+' where MDFM_User__c =\'' + userId +'\'';
         salaries = Database.query(soql);
         return salaries;
    }
}