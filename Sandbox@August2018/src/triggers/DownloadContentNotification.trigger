trigger DownloadContentNotification on Download_Content__c (after insert) {
    
    for (Download_Content__c DC: Trigger.new){ 
    
     
    set<String> rolelist = new set<String>();
     if(DC.Role__c !=null)
     { 
            for(String s : DC.Role__c.split(';'))
            {
               rolelist.add(s);
            }
     }
      if(rolelist.size()>0)
      {
         List<MV_User__c> mvUserList = [Select  Id from  MV_User__c where Role_Name__c IN : rolelist];
         List<String> userApprovalList = new List<String>();
         
         if(mvUserList.size()>0) 
         {     
          for(MV_User__c mvUser: mvUserList)
          {
            userApprovalList.add(mvUser.Id);   
          }
         if(!Test.isRunningTest() )
         {
          sendMultipleNotificationMsg.submitdata(userApprovalList,'Mulyavardhan Content ','New Mulyavardhan content is available - '+DC.Name);
   
        }  
      }
     }
    }
   
}