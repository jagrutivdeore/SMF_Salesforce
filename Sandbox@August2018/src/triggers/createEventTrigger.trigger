trigger createEventTrigger on Task_Answer__c(after insert, after update) {
    if (Trigger.isafter) {
        if (Trigger.isinsert) {
            map<string,string> mobileToUniqueIdmap = new map<string,string>();
            map<string,string> mobileTotaIdmap = new map<string,string>();
            
            for (Task_Answer__c ta : Trigger.new) {
                if (ta.Is_Event_Process__c == true && ta.Task_Type__c == 'Event Mobile' && ta.Answer__c != '' && ta.Answer__c != null) {
                    mobileToUniqueIdmap.put(ta.Answer__c, ta.Unique_Id__c);
                    mobileTotaIdmap.put(ta.Answer__c, ta.Id);
                } 
            }
            set<String> uniqueset = new set<string>();
            for(String mobile : mobileToUniqueIdmap.keyset()){
                uniqueset.add(mobileToUniqueIdmap.get(mobile));
            }
            
            if(uniqueset.size() > 0){
                List<Task_Answer__c> tskList = new List<Task_Answer__c>();
                tskList = [select id,Answer__c,Task_Type__c,Unique_Id__c,MV_User__c from Task_Answer__c where Unique_Id__c IN :uniqueset AND (Task_Type__c = 'Event Date' OR Task_Type__c = 'Event Description') AND Answer__c != '' AND Answer__c != null];
                
                map<string,List<Task_Answer__c>> idTotaMap= new map<string,List<Task_Answer__c>>();
                
                List<MV_User__c> userList = new List<MV_User__c>();
                map<string,string> mobileToIdMap = new map<string, string>();
                userList = [SELECT Id,User_Mobile_No__c from MV_User__c where User_Mobile_No__c IN :mobileToUniqueIdmap.keyset()];
                if(userList.size() > 0){
                    for(MV_User__c user : userList){
                        mobileToIdMap.put(user.User_Mobile_No__c, user.Id);
                    }
                    
                    for(Task_Answer__c ta : tskList ){
                        List<Task_Answer__c> tskList1 = new List<Task_Answer__c>();
                        if(idTotaMap.get(ta.Unique_Id__c) != null){
                            tskList1 = idTotaMap.get(ta.Unique_Id__c);
                            tskList1.add(ta);
                            idTotaMap.put(ta.Unique_Id__c,tskList1 );
                        }else{
                            List<Task_Answer__c> tskList2 = new List<Task_Answer__c>();
                            tskList2.add(ta);
                            idTotaMap.put(ta.Unique_Id__c,tskList2 );
                            
                        }
                    }
                    List<Event_Calender__c> ecList = new List<Event_Calender__c>();
                    system.debug('-mobileToUniqueIdmap--------' + mobileToUniqueIdmap);
                    
                    
                    for(string str : mobileToUniqueIdmap.keyset()){
                        list<Task_Answer__c> talist2 = new list<Task_Answer__c>();
                        talist2 = idTotaMap.get(mobileToUniqueIdmap.get(str));
                        set<Task_Answer__c> taskAnswerSet = new set<Task_Answer__c>();
                        String description = '';
                        for(Task_Answer__c ta : talist2){
                            if(ta.Task_Type__c == 'Event Date' && ta.Answer__c != null && ta.Answer__c != ''){
                                taskAnswerSet.add(ta);
                            }
                            if(ta.Task_Type__c == 'Event Description'){
                                description = ta.Answer__c;
                            }
                        }
                        for(Task_Answer__c ta3 : taskAnswerSet){
                            Event_Calender__c ec = new Event_Calender__c();
                            ec.MV_User1__c = mobileToIdMap.get(str);
                            ec.Mobile_No__c = str;
                            ec.Task_Answer_Id__c = mobileTotaIdmap.get(str);
                            ec.MV_User__c = talist2[0].MV_User__c;
                            if(ta3.Answer__c != null || ta3.Answer__c != ''){
                                List<String> dates = new list<String>();
                                system.debug('--date------' + ta3.Answer__c);
                                dates = ta3.Answer__c.split('/');
                                string dt = dates[1]+'/'+dates[0]+'/'+dates[2];
                                ec.Date__c = Date.parse(dt);
                             }
                             ec.Description__c = description;
                             ecList.add(ec);
                        }
                      
                    }
                    system.debug('------number-------'+ ecList);
                    system.debug('------number-------'+ ecList.size());
                    insert ecList;
                }
                
            }
        } 
    }
    
    if (Trigger.isafter) {
        if (Trigger.isinsert) {
            map<string,string> dateToUniqueIdmap = new map<string,string>();
            map<string,Task_Answer__c> idTotaskmap = new map<string,Task_Answer__c>();
            map<string,string> uniqueIdToMVUserIdMap = new map<string,string>();
            map<string, string> idToDateMap = new map<string, string>();
            map<string,string> idToUniqueIdmap = new map<string,string>();
            
            for (Task_Answer__c ta : Trigger.new) {
                if (ta.Is_Event_Process__c == true && ta.Task_Type__c == 'Event Date' && ta.Answer__c != '' && ta.Answer__c != null) {
                    idToUniqueIdmap.put(ta.Id, ta.Unique_Id__c);
                    idTotaskmap.put(ta.Id, ta);
                    uniqueIdToMVUserIdMap.put(ta.Unique_Id__c, ta.MV_User__c);
                    idToDateMap.put(ta.Id,ta.Answer__c);
                } 
            }
            if(idToUniqueIdmap.values().size() > 0){
                List<Task_Answer__c> taList = new List<Task_Answer__c>();
                taList = [select id,Answer__c,Task_Type__c,Unique_Id__c from Task_Answer__c where Unique_Id__c IN :idToUniqueIdmap.values() AND (Task_Type__c = 'Event Mobile' OR Task_Type__c ='Event Description') AND Answer__c != '' AND Answer__c != null];
                map<string,string> idtomobileMap = new map<string,string>();
                map<string,string> idtouniqueIdMap1 = new map<string,string>();
                
                map<string,List<Task_Answer__c>> idTotaMap= new map<string,List<Task_Answer__c>>();
                for(Task_Answer__c ta : taList){
                    List<Task_Answer__c> tskList1 = new List<Task_Answer__c>();
                    if(idTotaMap.get(ta.Unique_Id__c) != null){
                        tskList1 = idTotaMap.get(ta.Unique_Id__c);
                        tskList1.add(ta);
                        idTotaMap.put(ta.Unique_Id__c,tskList1 );
                    }else{
                        List<Task_Answer__c> tskList2 = new List<Task_Answer__c>();
                        tskList2.add(ta);
                        idTotaMap.put(ta.Unique_Id__c,tskList2 );
                        
                    }
                }
                
                for(Task_Answer__c ta : taList){
                    if(ta.Task_Type__c == 'Event Mobile'){
                        idtomobileMap.put(ta.Id, ta.Answer__c);
                        idtouniqueIdMap1.put(ta.Id, ta.Unique_Id__c);
                        
                    }
                }
                List<Event_Calender__c> ecList = new List<Event_Calender__c>();
                ecList = [select id,Task_Answer_Id__c from Event_Calender__c where Task_Answer_Id__c IN :idtomobileMap.keyset()];
                
                for(Event_Calender__c ec : ecList){
                    idtomobileMap.remove(ec.Task_Answer_Id__c);
                    idtouniqueIdMap1.remove(ec.Task_Answer_Id__c);
                }
                List<MV_User__c> userListNew = new List<MV_User__c>();
                map<string, string> mobileToIdMap = new map<string, string>();
                userListNew = [select id,User_Mobile_No__c from MV_User__c where User_Mobile_No__c IN :idtomobileMap.values()];
                for(MV_User__c user : userListNew){
                    mobileToIdMap.put(user.User_Mobile_No__c, user.Id);
                }
                List<Event_Calender__c> ecList1 = new List<Event_Calender__c>();
                system.debug('-idtomobileMap--------' + idtomobileMap);
                for(string str : idtomobileMap.keySet()){
                    list<Task_Answer__c> talist2 = new list<Task_Answer__c>();
                    talist2 = idTotaMap.get(idtouniqueIdMap1.get(str));
                    Event_Calender__c ec = new Event_Calender__c();
                    ec.MV_User1__c = mobileToIdMap.get(idtomobileMap.get(str));
                    ec.Mobile_No__c = idtomobileMap.get(str);
                    ec.Task_Answer_Id__c = str;
                    ec.MV_User__c = uniqueIdToMVUserIdMap.get(idtouniqueIdMap1.get(str));
                    for(Task_Answer__c ta : talist2){
                            if(ta.Task_Type__c == 'Event Description'){
                                ec.Description__c = ta.Answer__c;
                            }else if(ta.Task_Type__c == 'Event Date'){
                                if(ta.Answer__c != null || ta.Answer__c != ''){
                                    List<String> dates = ta.Answer__c.split('/');
                                    string dt = dates[1]+'/'+dates[0]+'/'+dates[2];
                                    ec.Date__c = Date.parse(dt);
                                }
                            }
                            
                        }
                    ecList1.add(ec);
                }
                system.debug(ecList1);
                 system.debug('------number-------'+ ecList1);
                    system.debug('------number-------'+ ecList1.size());
                if(ecList1.size() > 0){
                    insert ecList1;
                }
        }
    }
}
}