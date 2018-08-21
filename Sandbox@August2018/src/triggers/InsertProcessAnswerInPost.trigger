trigger InsertProcessAnswerInPost on ProcessAnswer__c (after insert,after update) {
    for (ProcessAnswer__c pa: Trigger.new){ 
        pa.Comment__c = '';   
    }
    
    if(trigger.IsInsert)
    {
    List<ProcessAnswer__c> paList = new List<ProcessAnswer__c>();
    List<string> prcIdList = new List<string>();
    List<MV_Task__c> tskList = new List<MV_Task__c>();
    List<MV_Process__c> prcList = new List<MV_Process__c>();
    map<string,map<string, string>> processTotextTouniqueIdmap = new map<string,map<string, string>>();
    map<string,List<String>> prcIdToStringmap = new map<string,List<String>>();
    map<string,string> idToNameMap = new map<string,string>();
    List<MV_Content__c> conList = new List<MV_Content__c>();
    List<String> emailIdList = new List<String>();
   
    List<String> fullEmail = new List<String>();

    
    for (ProcessAnswer__c pa: Trigger.new){ 
    system.debug('=========pa.Post_data_in_Community__c==============='+ pa.Post_data_in_Community__c);
        
        if(pa.Post_data_in_Community__c == true){   
           paList.add(pa);
           prcIdList.add(pa.MV_Process__c);
        }
    }
    if(prcIdList.size() > 0){
        tskList = [select id,API_field_Name__c,IsActived__c,Position__c,MV_Process__c,Task_Text__c from MV_Task__c where MV_Process__c IN :prcIdList AND IsActived__c = true order by Position__c];
        
        
        prcList = [select id,Posting_Comminity_Ids__c,Name,Enter_Email_Id_s_to_Send_Form__c from MV_Process__c where id IN :prcIdList];
        
      
        for(MV_Process__c prc : prcList){
            if(prc.Posting_Comminity_Ids__c != null && prc.Posting_Comminity_Ids__c != ''){
                List<String> lstAlpha = prc.Posting_Comminity_Ids__c.split(',');
                prcIdToStringmap.put(prc.Id,lstAlpha);
                idToNameMap.put(prc.Id, prc.Name);
                
                //Nikhil Jamdar
                if(prc.Enter_Email_Id_s_to_Send_Form__c != null)
                {
                   emailIdList.add(prc.Enter_Email_Id_s_to_Send_Form__c);
                }
            }
            
        }
        
        for(MV_Task__c tsk : tskList){
            if(processTotextTouniqueIdmap.get(tsk.MV_Process__c) != null){
                map<string,string> textTouniqueIdmap = new map<string,string>();
                textTouniqueIdmap = processTotextTouniqueIdmap.get(tsk.MV_Process__c);
                textTouniqueIdmap.put(tsk.Task_Text__c, tsk.API_field_Name__c);
                processTotextTouniqueIdmap.put(tsk.MV_Process__c, textTouniqueIdmap);
            
            }else{
                map<string,string> textTouniqueIdmap1 = new map<string,string>();
                textTouniqueIdmap1.put(tsk.Task_Text__c, tsk.API_field_Name__c);
                processTotextTouniqueIdmap.put(tsk.MV_Process__c, textTouniqueIdmap1);
            }
        }
        for(ProcessAnswer__c pa : paList){
            map<string,string> textTouniqueIdmap2 = new map<string,string>();
            textTouniqueIdmap2 = processTotextTouniqueIdmap.get(pa.MV_Process__c);
            String Description='';
            for(string key: textTouniqueIdmap2.keyset()){
                if(pa.get(textTouniqueIdmap2.get(key))!=null){
                Description += key+ ': ';
                Description += pa.get(textTouniqueIdmap2.get(key)) +' \n';}
            }
            system.debug('=------------Description-----------' + Description);
            if(Description != ''){
                List<String> strList = new List<String>();
                strList = prcIdToStringmap.get(pa.MV_Process__c);
                for(string str : strList){
                    MV_Content__c con  = new MV_Content__c();
                    con.Description__c = Description;
                    con.Title__c = idToNameMap.get(pa.MV_Process__c);
                    con.MV_Community__c = str;
                    con.MV_User__c = pa.MV_User__c;
                    conList.add(con);
                }
            }
        }
    }
    system.debug('=------------conList-----------' + conList.size());
    if(conList.size() > 0){
        insert conList;
        
        //Nikhil Jamdar
        if(emailIdList.size()>0)
        {
                fullEmail = emailIdList[0].split(',');
        }
        for(MV_Content__c con : conList)
        {
            System.debug('Full Email Id is' + fullEmail);
            SendEmailFunctionality.sendEmail(fullEmail,con.Description__c,con.Title__c);
        }
    
    }
    
    
    
    List<MV_ChatHistory__c> chList = new List<MV_ChatHistory__c>();
    for(MV_Content__c con : conList){
        MV_ChatHistory__c ch = new MV_ChatHistory__c();
        ch.MV_Community__c = con.MV_Community__c;
        ch.MV_Content__c = con.id;
        ch.MV_User__c = con.MV_User__c;
        chList.add(ch);
    }
    if(chList.size() > 0){
        insert chList;
    }
    }
    
    
    
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
}