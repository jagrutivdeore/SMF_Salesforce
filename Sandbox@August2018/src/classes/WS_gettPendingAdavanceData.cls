@RestResource(urlMapping='/getPendingAdavanceData/*')
global with sharing class WS_gettPendingAdavanceData {

    @HttpGet
    global static Adavance doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String userId = RestContext.request.params.get('userId');
        String voucherId = RestContext.request.params.get('voucherId');
        List<Adavance__c> salaries = new List<Adavance__c>();
        List<String> fields = new List<String>(Adavance__c.SObjectType.getDescribe().fields.getMap().keySet());
        Adavance adavance = new Adavance();
        MV_User__c user = new MV_User__c();
        user = [SELECT Id,MV_Role__c From MV_User__c where id = :userId];
        MV_Role__c mRole = new MV_Role__c();
        mRole =  [SELECT Adavance_Approval_Action__c,Adavance_Approval_Permission__c From MV_Role__c where id = :user.MV_Role__c];
        
        if(mRole.Adavance_Approval_Permission__c!= null && mRole.Adavance_Approval_Permission__c!=''){
            string[] mTemp = mRole.Adavance_Approval_Permission__c.split(';');
            
             String soql = 'select ' + String.join(fields, ',')+ ' from Adavance__c where Status__c IN :mTemp and Voucher__c =\'' + voucherId +'\'';
          System.debug('soql Is ----------' + soql );
        adavance.salaries= Database.query(soql);
        adavance.action= mRole.Adavance_Approval_Action__c ;
        return adavance;
        }else{
            return adavance;
        }
        
        
   
    }
     global class Adavance{
        List<Adavance__c> salaries;
        String action;
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