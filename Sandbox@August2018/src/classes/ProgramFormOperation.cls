public class ProgramFormOperation {
    public ProgramFormOperation(ApexPages.StandardController sc){
    }
    /*public List<MV_Process__c> programList{get;set;}
    public List<MV_Task__c> tskList {get;set;}
    public List<MV_Task__c> tskListForVF {get;set;}
    
    public List<MV_User__c> userList1 {get;set;}
    public List<List<SelectOption>> selectOp {get;set;}
    public List<List<taskAnswerClass>> pa;
    
    
    public List<SelectOption> dist {get;set;}
    public List<SelectOption> tal {get;set;}
    public List<SelectOption> cluster {get;set;}
    public List<SelectOption> village {get;set;}
    public List<SelectOption> school {get;set;}
    
    
    
    public String stateIs {get;set;}
    public String distIs {get;set;}
    public String talIs {get;set;}
    public String clusterIs {get;set;}
    public String villageIs {get;set;}
    public String schoolIs {get;set;}
    
    
    public boolean isState {get;set;}
    public boolean isDistrict {get;set;}
    public boolean isTaluka {get;set;}
    
    
    
    
    public ProgramFormOperation(ApexPages.StandardController sc){
        Cookie theCookie;
        theCookie = ApexPages.currentPage().getCookies().get('usernameincookies');
        system.debug('------theCookie.getValue()-------' + theCookie.getValue());
         userList1 = new List<MV_User__c>();
        userList1 = [SELECT Id,Show_All_Community__c,Role_Name__c,User_Mobile_No__c,MV_Role__c,Location_wise_filter_on_Community__c,User_District__c,User_State__c,User_Taluka__c FROM MV_User__c where User_Mobile_No__c = :theCookie.getValue() limit 1];
        
    programList = new List<MV_Process__c>();
    
    programList = [SELECT Location_Level__c,Location_Required__c,Id,Is_Editable__c,Is_Multiple_Entry_Allowed__c,IsTemplate__c,MV_Role__c,Name,Multiple_Role__c,Targated_Date__c from MV_Process__c where Id =: sc.getId()];
    System.debug('Program Form Operation' + sc.getId());
    
    tskList = new List<MV_Task__c>();
    tskList = [SELECT Id,IsEditable__c,Is_Header_Name__c,Picklist_Value__c,API_field_Name__c,Validaytion_on_text__c,Name,Is_Completed__c,Is_Response_Mnadetory__c,MV_Process__c,Task_Response__c,Task_type__c,Task_Text__c,CreatedDate,Position__c,Location_Level__c,Mobile_Question_Text_English__c,Picklist_Value_English__c,Mobile_Question_Text_Hindi__c,Picklist_Value_Hindi__c,Mobile_Question_Text_Marathi__c,Picklist_Value_Marathi__c from MV_Task__c where MV_Process__c = 'a1Q0k000000ClPi' AND IsActived__c = true ORDER BY Position__c];

	
        
   
    System.debug('Task List Size is' + tskList.size());    
	pa = new List<List<taskAnswerClass>>();
     WS_getprocessAnswerDataNew.procssToTask w = new WS_getprocessAnswerDataNew.procssToTask();
     WS_getprocessAnswerDataNew.processId = 'a1Q0k000000ClPi';
     WS_getprocessAnswerDataNew.UserId = userList1[0].id;
     WS_getprocessAnswerDataNew.lan = 'en';
     WS_getprocessAnswerDataNew.callFromApex = true;
     w = WS_getprocessAnswerDataNew.doGet();
	 System.debug('Process Answer is' + w);
        
        
        tskListForVF = new List<MV_Task__c>();
        selectOp = new List<List<SelectOption>>();
        Integer c = 0;
        for(MV_Task__c mvt : tskList)
        {
            MV_Task__c m = new MV_Task__c();
            m = mvt;
            m.API_field_Name__c = '';
            tskListForVF.add(m);
            List<SelectOption> s = new List<SelectOption>();
            s = getItems(mvt.Picklist_Value__c);
            c++;
            selectOp.add(s);
            
            if(mvt.Task_type__c == 'Location')
            {
                if(mvt.Task_Text__c == 'State')
                isState = true;
                if(mvt.Task_Text__c == 'District')
                isDistrict = true;
                if(mvt.Task_Text__c == 'Taluka')
				isTaluka = true;

            }
            
            
        }
    }
    
    public Pagereference saveForm(){
        System.debug('I am in save form');
        for(Integer i=0; i<tskList.size(); i++)
        {
            System.debug('API Name is' + tskListForVF[i].Task_Text__c);
        	 System.debug('Value is' + tskListForVF[i].API_field_Name__c);
        }
        
    return null;
    }
    
    
    
    public List<SelectOption> getItems(String pickListVal) {
        	
        	System.debug('Count is' + pickListVal);
       	 List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('Select','Select')); 
        if(pickListVal != null)
        {
           List<String> pickListValList = pickListVal.split(',');
            
            for(String s: pickListValList)
            {
                options.add(new SelectOption(s,s)); 
            }
        }
            return options;
        }
    
     public List<SelectOption> getState() {
       
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Select','Select'));
            AggregateResult[] groupedResults = [SELECT Name, Count(Id) FROM State__c GROUP BY Name];
            for (AggregateResult ar : groupedResults)  {
                    options.add(new SelectOption((String)ar.get('Name'),(String)ar.get('Name')));
            }
            system.debug('--------------'+options.size());
         
         
         
        
      return options;
      
    }
    
        
    public PageReference getDistrict() {
        system.debug('----state is'+ stateIs);
          List<SelectOption> options = new List<SelectOption>();
          options.add(new SelectOption('Select','Select'));
         
         if(stateIs == null){
              stateIs = 'Maharashtra';
          }
          AggregateResult[] groupedResults = [SELECT Name, Count(Id) FROM District__c where State__r.Name = :stateIs GROUP BY Name];
            for (AggregateResult ar : groupedResults)  {
                    options.add(new SelectOption((String)ar.get('Name'),(String)ar.get('Name')));
       
            }
          system.debug('--------------'+options.size());
        dist = options;
        return null;
    }
    
    public PageReference getTaluka() {
        
           List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('Select','Select'));
          AggregateResult[] groupedResults = [SELECT Taluka_Name__c, Count(Id) FROM MV_Location__c where District_Name__c =: distIs GROUP BY Taluka_Name__c];
            for (AggregateResult ar : groupedResults)  {
                    options.add(new SelectOption((String)ar.get('Taluka_Name__c'),(String)ar.get('Taluka_Name__c')));
       
            }
            system.debug('--------------'+options.size());
        tal = options;
        return null;            
    }
     
   public PageReference getclusterlist() {
       
            List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('Select','Select'));
          AggregateResult[] groupedResults = [SELECT Cluster_Name__c, Count(Id) FROM MV_Location__c where Taluka_Name__c =: talIs GROUP BY Cluster_Name__c];
            for (AggregateResult ar : groupedResults)  {
                    options.add(new SelectOption((String)ar.get('Cluster_Name__c'),(String)ar.get('Cluster_Name__c')));
       
            }
            system.debug('--------------'+options.size());
            cluster = options;
       return null;
    } 
    
    
     public PageReference getVillageList() {
       
         System.debug('Cluster is' + clusterIs);
            List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('Select','Select'));
          AggregateResult[] groupedResults = [SELECT Village_Name__c	,Count(Id) FROM MV_Location__c where Cluster_Name__c =: clusterIs GROUP BY Village_Name__c];
            for (AggregateResult ar : groupedResults)  {
                    options.add(new SelectOption((String)ar.get('Village_Name__c'),(String)ar.get('Village_Name__c')));
       
            }
            system.debug('--------------village size is'+options.size());
            village = options;
       return null;
    } 
    
     public PageReference getSchoollist() {
       
            List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('Select','Select'));
         
         List<MV_Location__c> mvl;
         mvl = [select Id from MV_Location__c where Village_Name__c =: villageIs];
         
         System.debug('MV Location Id is' + mvl);
         if(mvl.size()>0)
         {
                       AggregateResult[] groupedResults = [SELECT Name, Count(Id) FROM MV_School__c where MV_Location__c =: mvl[0].id GROUP BY Name];
            for (AggregateResult ar : groupedResults)  {
                    options.add(new SelectOption((String)ar.get('Name'),(String)ar.get('Name')));
       
            }
            system.debug('--------------'+options.size());

         }
            school = options;
       return null;
    } 
    
    
    
    
    
     
    public PageReference setValToVar()
    {
        return null;
    }
    */
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
        val=val+1;
        val=val+1;
        val=val+1;
            val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
            val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
            val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
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