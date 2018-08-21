@RestResource(urlMapping='/MDFM_getMachineMou/*')
global class MDFM_getMachineMou{
    @HttpGet
    global static List<Machine_MOU__c> doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String tal = RestContext.request.params.get('taluka');
        String des = 'Machine owners';
        
        System.debug('Taluka is:' + tal);
        
        // tal = 'aa';
        List<Machine_MOU__c> con = new List<Machine_MOU__c>();
        List<String> fields = new List<String>(Machine_MOU__c.SObjectType.getDescribe().fields.getMap().keySet());
        String soql = 'select ' + String.join(fields, ',')+ ' from Machine_MOU__c where Taluka__c =\''+tal+'\'';
        
         //String soql = 'select ' + String.join(fields, ',')+ ' from Machine_MOU__c where designation__c = :des AND Taluka__c = :taluka';
        
        System.debug('Query is' + soql);
        
        con = Database.query(soql);
        
        System.debug('Con is' + con);
         return con;
    }
}