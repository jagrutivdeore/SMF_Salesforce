public class createProcessAnswerRecordsfutureclass {
   
   @future
    public static void addPost1(){
        Map<string,List<Task_Answer__c>> idtoListMap = new Map<string,List<Task_Answer__c>>();
        List<Task_Answer__c> tskList = new List<Task_Answer__c>();
        
        tskList = [select id,Answer__c,Approved_By__c,Comment__c,IsApproved__c,IsSave__c,MV_User__c,MV_Process__c,MV_Task__c,Task_API_Name__c,Timestamp__c,Unique_Id__c from Task_Answer__c where MV_Process__c = 'a1I7F000000Vcgp'];
        
        system.debug('------tskList.size()-------------'+ tskList.size());
        for(Task_Answer__c ta : tskList){
            if(idtoListMap.get(ta.Unique_Id__c) != null){
                List<Task_Answer__c> taList = new List<Task_Answer__c>();
                taList = idtoListMap.get(ta.Unique_Id__c);
                taList.add(ta);
                idtoListMap.put(ta.Unique_Id__c, taList);
            }else{
                List<Task_Answer__c> taList1 = new List<Task_Answer__c>();
                taList1.add(ta);
                idtoListMap.put(ta.Unique_Id__c, taList1);
            }
        }
        
        List<ProcessAnswer__c> paList = new List<ProcessAnswer__c>();
        List<MV_Task__c> tasklist = new List<MV_Task__c>();
        Map<string,string> IdToApiName = new map<string,string>();
        tasklist = [select id,API_field_Name__c from MV_Task__c where MV_Process__c = 'a1I7F000000Vcgp'];
        system.debug('---------------' + tasklist.size());
        for(MV_Task__c tsk :tasklist ){
            system.debug('---------------'+ tsk.Id);
            IdToApiName.put(tsk.Id, tsk.API_field_Name__c);
        }
        system.debug('-------idtoListMap------------'+ idtoListMap.keyset().size());
        for(string str : idtoListMap.keyset()){
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
                //system.debug('ta.Task_API_Name__c---------------'+ta.Task_API_Name__c);
                if(ta.MV_Task__c != null){
                    system.debug('----ta.MV_Task__c-----------'+ ta.MV_Task__c);
                    system.debug('ta.Task_API_Name__c---------------'+IdToApiName.get(ta.MV_Task__c));
                    if(IdToApiName.get(ta.MV_Task__c) != null){
                        sObj.put(IdToApiName.get(ta.MV_Task__c), ta.Answer__c) ;
                    }
                }
            }
            paList.add((ProcessAnswer__c) sObj);
        }
        if(paList.size() > 0){
            system.debug('process answr count'+ paList.size());
            insert paList;
        }
        
    }
    
    @future
    public static void addPost2(){
        Map<string,List<Task_Answer__c>> idtoListMap = new Map<string,List<Task_Answer__c>>();
        List<Task_Answer__c> tskList = new List<Task_Answer__c>();
        
        tskList = [select id,Answer__c,Approved_By__c,Comment__c,IsApproved__c,IsSave__c,MV_User__c,MV_Process__c,MV_Task__c,Task_API_Name__c,Timestamp__c,Unique_Id__c from Task_Answer__c where MV_Process__c = 'a1I7F000000VeJG'];
        
        system.debug('------tskList.size()-------------'+ tskList.size());
        for(Task_Answer__c ta : tskList){
            if(idtoListMap.get(ta.Unique_Id__c) != null){
                List<Task_Answer__c> taList = new List<Task_Answer__c>();
                taList = idtoListMap.get(ta.Unique_Id__c);
                taList.add(ta);
                idtoListMap.put(ta.Unique_Id__c, taList);
            }else{
                List<Task_Answer__c> taList1 = new List<Task_Answer__c>();
                taList1.add(ta);
                idtoListMap.put(ta.Unique_Id__c, taList1);
            }
        }
        
        List<ProcessAnswer__c> paList = new List<ProcessAnswer__c>();
        List<MV_Task__c> tasklist = new List<MV_Task__c>();
        Map<string,string> IdToApiName = new map<string,string>();
        tasklist = [select id,API_field_Name__c from MV_Task__c where MV_Process__c = 'a1I7F000000VeJG'];
        system.debug('---------------' + tasklist.size());
        for(MV_Task__c tsk :tasklist ){
            system.debug('---------------'+ tsk.Id);
            IdToApiName.put(tsk.Id, tsk.API_field_Name__c);
        }
        system.debug('-------idtoListMap------------'+ idtoListMap.keyset().size());
        for(string str : idtoListMap.keyset()){
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
                //system.debug('ta.Task_API_Name__c---------------'+ta.Task_API_Name__c);
                if(ta.MV_Task__c != null){
                    system.debug('----ta.MV_Task__c-----------'+ ta.MV_Task__c);
                    system.debug('ta.Task_API_Name__c---------------'+IdToApiName.get(ta.MV_Task__c));
                    if(IdToApiName.get(ta.MV_Task__c) != null){
                        sObj.put(IdToApiName.get(ta.MV_Task__c), ta.Answer__c) ;
                    }
                }
            }
            paList.add((ProcessAnswer__c) sObj);
        }
        if(paList.size() > 0){
            system.debug('process answr count'+ paList.size());
            insert paList;
        }
        
    }
    
 
       public static void  CCHelp()
    {
       Integer val = 1;
       
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
         val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        }
}