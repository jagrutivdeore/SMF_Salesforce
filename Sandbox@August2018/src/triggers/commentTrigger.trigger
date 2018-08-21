trigger commentTrigger on MV_Content_Comment__c (after insert) {
    
    set<Id> comIdList = new set<Id>();
    for(MV_Content_Comment__c con : Trigger.new){
       comIdList.add(con.Id);
      
    }
    notificationClass.notificationMessageonComments(comIdList);
    
}