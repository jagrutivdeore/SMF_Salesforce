trigger ProcessTrigger on MV_Process__c (After insert) {
    set<Id> IdList = new set<Id>();
    Map<Id,String> prcIdToStrMap = new Map<Id,String>();
    List<MV_Task__c> tskList = new List<MV_Task__c>();
    Map<String,Integer> strToIntMap = new Map<String,Integer>();
    strToIntMap.put('State',0);
    strToIntMap.put('District',1);
    strToIntMap.put('Taluka',2);
    strToIntMap.put('Cluster',3);
    strToIntMap.put('Village',4);
    strToIntMap.put('School',5);
    
    List<String> locationList =  new List<String>();
    locationList.add('State');
    locationList.add('District');
    locationList.add('Taluka');
    locationList.add('Cluster');
    locationList.add('Village');
    locationList.add('School');

    
    for(MV_Process__c prc: Trigger.New){
        if(prc.Location_Required__c){
            for(Integer i=0; i<=strToIntMap.get(prc.Location_Level__c); i++){
                MV_Task__c tsk = new MV_Task__c();
                tsk.MV_Process__c = prc.Id;
                tsk.Task_Text__c = locationList[i];
                tsk.Task_type__c = 'Location';
                tsk.Location_Level__c = locationList[i];
                tsk.Position__c = strToIntMap.get(locationList[i]);
                tskList.add(tsk);
            }
        }
    }   
    
    if(tskList.size() > 0){
        insert tskList;
    }
}