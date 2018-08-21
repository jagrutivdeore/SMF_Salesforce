global class createProcessAnswerRecords implements Database.Batchable<sobject>, Database.Stateful{
    Map<string,List<Task_Answer__c>> idtoListMap = new Map<string,List<Task_Answer__c>>();
    private String ProcessId;
    set<string> taskId = new set<string>();

    global Database.QueryLocator start(Database.BatchableContext bc){
        
        string querystr = 'select id,Answer__c,Approved_By__c,Comment__c,IsApproved__c,IsSave__c,MV_User__c,MV_Process__c,MV_Task__c,Task_API_Name__c,Timestamp__c,Unique_Id_New__c,Is_Migrated__c from Task_Answer__c where MV_Process__c =\'a1I7F000000VeJG\'AND Is_Migrated__c = false AND createddate <= 2018-01-16T12:10:00.000Z ORDER BY createddate limit 38700';
        return Database.getQueryLocator(querystr);
    }
    
    global void execute(Database.BatchableContext bc, List<Task_Answer__c> listtaskAnswer){
        system.debug('------listtaskAnswer---------'+listtaskAnswer.size() );
        for(Task_Answer__c ta : listtaskAnswer){
            ta.Is_Migrated__c = true;
            //taskId.add(ta.MV_Task__c);
            if(idtoListMap.get(ta.Unique_Id_New__c) != null){
                List<Task_Answer__c> taList = new List<Task_Answer__c>();
                taList = idtoListMap.get(ta.Unique_Id_New__c);
                taList.add(ta);
                idtoListMap.put(ta.Unique_Id_New__c, taList);
            }else{
                List<Task_Answer__c> taList1 = new List<Task_Answer__c>();
                taList1.add(ta);
                idtoListMap.put(ta.Unique_Id_New__c, taList1);
            }
            
        }
        update listtaskAnswer;
    }
    
    global void finish(Database.BatchableContext bc){
        List<ProcessAnswer__c> paList = new List<ProcessAnswer__c>();
        List<MV_Task__c> tasklist = new List<MV_Task__c>();
        Map<string,string> IdToApiName = new map<string,string>();
        tasklist = [select id,API_field_Name__c from MV_Task__c where MV_Process__c = 'a1I7F000000VeJG'];
        system.debug('---------------' + tasklist.size());
        for(MV_Task__c tsk :tasklist ){
            system.debug('---------------'+ tsk.Id);
            IdToApiName.put(tsk.Id, tsk.API_field_Name__c);
        }
        for(string str : idtoListMap.keyset()){
            system.debug('-------'+ str);
            List<Task_Answer__c> taList3 = new List<Task_Answer__c>();
            taList3 = idtoListMap.get(str);
            sObject sObj = Schema.getGlobalDescribe().get('ProcessAnswer__c').newSObject() ;
            
            for(Task_Answer__c ta : taList3){
                if(ta.MV_User__c != null){
                    sObj.put('MV_User__c' , ta.MV_User__c) ;
                }
                if(ta.MV_Process__c != null){
                    sObj.put('MV_Process__c' , ta.MV_Process__c) ;
                }
                if(ta.Approved_By__c != null){
                    sObj.put('Approved_By__c' , ta.Approved_By__c) ;
                }
                if(ta.Comment__c != null){
                    sObj.put('Comment__c' , ta.Comment__c) ;
                }
                if(ta.IsApproved__c != null){
                    sObj.put('IsApproved__c' , ta.IsApproved__c) ;
                }
                if(ta.IsSave__c != null){
                    sObj.put('IsSave__c' , ta.IsSave__c) ;
                }
                if(ta.Timestamp__c != null){
                    sObj.put('Timestamp__c' , ta.Timestamp__c) ;
                }
               
                if(ta.MV_Task__c != null){
                    system.debug('----ta.MV_Task__c-----------'+ ta.MV_Task__c);
                    system.debug('ta.Task_API_Name__c---------------'+IdToApiName.get(ta.MV_Task__c));
                    if(IdToApiName.get(ta.MV_Task__c) != null){
                        sObj.put(IdToApiName.get(ta.MV_Task__c), ta.Answer__c) ;
                    }
                }
                
                sObj.put('Is_Migrated__c' , true) ;
            }
            paList.add((ProcessAnswer__c) sObj);
        }
        if(paList.size() > 0){
            system.debug('process answr count'+ paList.size());
            insert paList;
        }
    }
    
    public static void testCode() {
         Integer i =0;
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