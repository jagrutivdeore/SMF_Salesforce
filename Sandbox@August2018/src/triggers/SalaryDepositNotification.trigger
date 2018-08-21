trigger SalaryDepositNotification on Salary__c (after insert) {
    for(Salary__c s : Trigger.new)
    {
         List<String> userApprovalList = new List<String>();
        userApprovalList.add(s.MV_User__c);
        if(s.notification_Msg__c != null && s.notification_Msg__c != '')
         if(!Test.isRunningTest() )
         {
          sendMultipleNotificationMsg.submitdata(userApprovalList,'Salary Deposite',+s.notification_Msg__c);
         }
    }

    
}