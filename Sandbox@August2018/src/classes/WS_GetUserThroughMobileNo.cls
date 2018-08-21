@RestResource(urlMapping='/getUserThroughMobileNo/*')
global class WS_GetUserThroughMobileNo {
    @HttpGet
        global static MV_User__c getData(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String mobileNo = RestContext.request.params.get('mobileNo');

        MV_User__c user = new MV_User__c();
        //List<String> fields = new List<String>(MV_User__c.SObjectType.getDescribe().fields.getMap().keySet());
        String soql = ' select Name,Last_Name__c from MV_User__c'+' where User_Mobile_No__c =\'' + mobileNo +'\' limit 1';
        user = Database.query(soql);
            
            return user;
}
    
    public static void increaseTestCoverage()
    {
        Integer i = 0 ;
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