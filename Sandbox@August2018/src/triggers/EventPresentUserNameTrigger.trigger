trigger EventPresentUserNameTrigger on Event_Calender__c (before insert, before update) {
   for(Event_Calender__c eventObj : Trigger.new)
   {
      if(eventObj.Present_User__c != null)
      {
         List<String> userIdList = eventObj.Present_User__c.split(',');
         List<MV_User__c> userList = [Select Full_Name__c from MV_User__c where Id IN : userIdList];
         System.debug('------------------------'+userList );
         
            String userName = '';
            Integer i = 0 ;
             for(MV_User__c user : userList )
             {
               i = i+1;
               if(i==userList.size() )
                userName =userName + user.Full_Name__c;
               else
                userName =userName + user.Full_Name__c+',';  
             }
          eventObj.Present_Name__c = userName;
          eventObj.Present_User_Count__c = userList.Size();
      }
   }
   
}