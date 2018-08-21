@isTest
public class DownloadContentNotificationTest
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
     
     Download_Content__c DcObj = new Download_Content__c();
     DcObj.Name = 'NewContent';
     DcObj.Role__c = 'TC';
     insert DcObj; 
     
  }
}