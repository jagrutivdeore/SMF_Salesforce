@isTest
public class HoSupportEmailTest
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
     
     MV_Community__c comm = new MV_Community__c();
     comm.Name = 'HO Support';
     insert comm;
     
     Contact cont = new Contact();
     cont.LastName = 'abc';
     cont.Issue_Type__c = 'HR related';
     cont.email = 'abc@gmail.com';
     insert cont;
     
     MV_Content__c conObj = new MV_Content__c();
     conObj.Title__c = 'test';
     conObj.Description__c = 'Test Description';
     conObj.MV_User__c = user.Id;
     conObj.MV_Community__c = comm.Id;
     conObj.Issue_Type__c = 'HR related';
     insert conObj;
  }
}