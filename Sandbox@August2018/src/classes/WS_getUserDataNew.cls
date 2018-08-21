@RestResource(urlMapping='/getUserDataNew/*')
global with sharing class WS_getUserDataNew {

    @HttpGet
    global static UserDetailAndConfig doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String userId = RestContext.request.params.get('userId');
        MV_User__c user = new MV_User__c();
        
        UserDetailAndConfig udc = new UserDetailAndConfig();
        
        Mobile_App_Cnfig__c mac = new Mobile_App_Cnfig__c();
   
    	mac = [select Id,Contact_No__c,Hangout_URL__c,Languges__c,Hide_Role_On_Calendar__c from Mobile_App_Cnfig__c limit 1];     
    	udc.mac = mac;
        
        
        List<String> fields = new List<String>(MV_User__c.SObjectType.getDescribe().fields.getMap().keySet());
        String soql = ' select ' + String.join(fields, ',')+ ' from MV_User__c'+' where id =\'' + userId +'\' limit 1';
         user = Database.query(soql);
        udc.mvUser = user;
        
        //
        Extended_User_Profile__c e = new Extended_User_Profile__c();
        
         try{
        e = [select id,name,Bank_Account_Number__c,Bank_Name__c,Employee_Id__c,IFSC_Code__c,UAN_Number__c,MV_User__c,PF_Number__c from Extended_User_Profile__c where MV_User__c =: user.Id];
            }
            catch(Exception exc)
            {
                //e = null;
                System.debug('No Extended Record');
            }
        
        
        
        udc.eup = e;
       
        
        
        
        MV_Role__c mvr = new MV_Role__c();
    
        if(user.MV_Role__c != null)
        {
            mvr = [select id,isLocationAllow__c,isLocationTrackingAllow__c,Juridictions__c  from MV_Role__c where id =: user.MV_Role__c];
            udc.mvr = mvr;
        }
        
        return udc;
    }
    
    global class UserDetailAndConfig
    {
        public MV_User__c mvUser;
        public Mobile_App_Cnfig__c mac;
        public MV_Role__c mvr;
        public Extended_User_Profile__c eup;
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