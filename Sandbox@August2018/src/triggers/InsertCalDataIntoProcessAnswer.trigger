trigger InsertCalDataIntoProcessAnswer on Event_Calender__c (before insert,before update) {
    for(Event_Calender__c eventData : trigger.new)
    {
        //sendNotificationMsgOnCalEvent.submitdata(eventData.MV_User1__c,eventData.Role__c,'Event Notification','Event has been created please check');
        //
       // sendNotificationMsgOnCalEvent.submitdata(eventData.Assigned_User_Ids__c,eventData.Role__c,eventData.Name,eventData.Description__c);
    }

}