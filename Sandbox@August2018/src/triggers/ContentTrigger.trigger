trigger ContentTrigger on MV_Content__c (after insert,after update) {
    
    set<Id> comIdList = new set<Id>();
    for(MV_Content__c con : Trigger.new){
        //if(con.Is_Broadcast__c == false){
            comIdList.add(con.Id);
       //}
    }
   notificationClass.notificationMessage(comIdList);
   broadcastnotificationClass.notificationMessage(comIdList);
   broadcastnotificationClass.TheatnotificationMessage(comIdList);
}