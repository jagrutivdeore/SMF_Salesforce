@RestResource(urlMapping='/MDFMGetMachineOperatorContact/*')
global class MDFMGetMachineOperatorContact {
    @HttpGet
    global static List<Contact__c> doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String tal = RestContext.request.params.get('taluka');
        String des = 'Machine operator';
        
        System.debug('Taluka is:' + tal);
        
        // tal = 'aa';
        List<Contact__c> con = new List<Contact__c>();
        List<String> fields = new List<String>(Contact__c.SObjectType.getDescribe().fields.getMap().keySet());
        String soql = 'select ' + String.join(fields, ',')+ ' from Contact__c where designation__c =\'' + des +'\' AND Taluka__c =\''+tal+'\'';
        
         //String soql = 'select ' + String.join(fields, ',')+ ' from Contact__c where designation__c = :des AND Taluka__c = :taluka';
        
        System.debug('Query is' + soql);
        
        con = Database.query(soql);
        
        System.debug('Con is' + con);
         return con;
    }
}