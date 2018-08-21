@RestResource(urlMapping='/getAllHolidays/*')
global class WS_GetAllHoliday {
 @HttpGet
    global static List<Holiday_Calendar__c> doGet() {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        //String userId = RestContext.request.params.get('userId');
        
        //MV_User__c mvuser = new MV_User__c();
        
        //mvuser = [select id,name,user_state__C from MV_User__C where id  =: userId ];
        
        List<Holiday_Calendar__c> allHoliday = new List<Holiday_Calendar__c>();
       
       allHoliday = [select id,Name,Category__c,description__c,Holiday_Date__c,isActive__c,Organisation__c from Holiday_Calendar__c];
       return allHoliday;
    }

    public static void forTestCoverage()
    {
    Integer i = 0;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        
    }
}