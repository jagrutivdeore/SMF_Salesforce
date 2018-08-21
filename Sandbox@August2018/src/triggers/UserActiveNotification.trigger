trigger UserActiveNotification on MV_User__c (before update) {

    
    for (MV_User__c u: Trigger.new) {
    MV_User__c oldU = Trigger.oldMap.get(u.ID);

    if (u.Is_Approved__c != oldU.Is_Approved__c) {
        
        if(u.Is_Approved__c == true)
        {
        sendNotificationMsgToActivatedUser.submitdata(u.Id,'Approval Notification','You are approved');
        }
    }
	}
    
}