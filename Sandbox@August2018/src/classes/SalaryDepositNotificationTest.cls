@isTest
public class SalaryDepositNotificationTest
{ 
  public static testMethod void test1()
  {
  
     MV_Role__c role = new MV_Role__c();
     role.Name = 'TC';
     insert role;
    
     MV_User__c user = new MV_User__c();
     user.Name = 'Test';
     user.MV_Role__c = role.Id;
     insert user; 
     
     Salary__c SObj = new Salary__c();
     SObj.MV_User__c = user.id;
     insert SObj;
  }
}