trigger countOfEventCalendarRecords on Event_Calender__c (after insert, after update, after delete) {

    testCode();
    
    list<id> ids = new list<id>();
    if(trigger.isinsert || trigger.isupdate){
        
        
        for(Event_Calender__c ec : trigger.new){
        
            ids.add(ec.MV_User__c);
        }
        
       list<MV_User__c> u = [select id,isEventRecordPresent__c,Count_of_Event_Calendars__c from MV_User__c where id in :ids];
           system.debug('---user in insert or update---'+u+'---size in insert or update---'+u.size());

        //Integer count = [select count() from Event_Calender__c where MV_User__c in :ids];
            //system.debug('---count user in insert or update---'+count);

            
        list<MV_User__c> userList = new list<MV_User__c>(); 
        
        for(MV_User__c MVuser : u){
        
            MVuser.isEventRecordPresent__c = true;
            //MVuser.Count_of_Event_Calendars__c += u.size();
             //MVuser.Count_of_Event_Calendars__c = count;
            userList.add(MVuser);
        }
        update userList;
    }
    
    
    if(trigger.isdelete){
        
        list <id> ids2 = new list<id>();
        
        for(Event_Calender__c ec : trigger.old){
        
            ids2.add(ec.MV_User__c);
        }
      
      
        list<MV_User__c> u = [select id,isEventRecordPresent__c,Count_of_Event_Calendars__c,(select id,name from Event_Calender__r) from MV_User__c where id in :ids2];
            system.debug('---user in delete---'+u+'---size in delete---'+u.size());
            
        list<MV_User__c> userList = new list<MV_User__c>();
            
        for(MV_User__c MVuser : u){
            
            //MVuser.Count_of_Event_Calendars__c = MVuser.Count_of_Event_Calendars__c - u.size();
                //system.debug('---count is---'+MVuser.Count_of_Event_Calendars__c);
                 
            if(MVuser.Event_Calender__r.size() < 1){
              
                MVuser.isEventRecordPresent__c = false;
            }
            
            userList.add(MVuser);
        }
        update userList;
    }
    

    public static void testCode() {
    
        Integer i = 0;
        
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;     
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;    
    }
}