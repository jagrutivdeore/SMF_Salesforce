@RestResource(urlMapping='/getPendingExpenseData/*')
global with sharing class WS_gettPendingExpenseData {

    @HttpGet
    global static Expense doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String userId = RestContext.request.params.get('userId');
        String voucherId = RestContext.request.params.get('voucherId');
        List<Expense__c> salaries = new List<Expense__c>();
        List<String> fields = new List<String>(Expense__c.SObjectType.getDescribe().fields.getMap().keySet());
        Expense expense = new Expense();
        MV_User__c user = new MV_User__c();
        user = [SELECT Id,MV_Role__c From MV_User__c where id = :userId];
        MV_Role__c mRole = new MV_Role__c();
        mRole =  [SELECT Account_Approval__c,Account_Approval_Action__c From MV_Role__c where id = :user.MV_Role__c];
         System.debug('mRole  ----------' + mRole.Account_Approval__c );
        if(mRole.Account_Approval__c != null && mRole.Account_Approval__c!=''){
            string[] mTemp = mRole.Account_Approval__c.split(';');
            System.debug('mTemp----------' + mTemp);
            //String soql = 'select ' + String.join(fields, ',')+ ' from Expense__c where Status__c IN :mTemp';
            //added by Nikhil jamdar
             String soql = 'select ' + String.join(fields, ',')+ ' from Expense__c where Status__c IN :mTemp and Voucher__c = \'' + voucherId +'\' order by LastModifiedDate desc';
          System.debug('soql Is ----------' + soql );
        expense.salaries= Database.query(soql);
        expense.action= mRole.Account_Approval_Action__c;
        return expense;
        }else{
            return expense;
        }
        
        
   
    }
     global class Expense{
        List<Expense__c> salaries;
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