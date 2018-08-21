public class ProgramForm {
    
     public List<List<SelectOption>> selectOp {get;set;}
    
    
    //For Specif Select List
    public List<SelectOption> dist {get;set;}
    public List<SelectOption> tal {get;set;}
    public List<SelectOption> cluster {get;set;}
    public List<SelectOption> village {get;set;}
    public List<SelectOption> school {get;set;}
    
    
    //For Specific value
    public String stateIs {get;set;}
    public String distIs {get;set;}
    public String talIs {get;set;}
    public String clusterIs {get;set;}
    public String villageIs {get;set;}
    public String schoolIs {get;set;}
    
    //isSpecific Value available 
    public boolean isState {get;set;}
    public boolean isDistrict {get;set;}
    public boolean isTaluka {get;set;}
    
    public List<MV_Task__c> tskList {get;set;}
    public List<MV_Task__c> tskListForVF {get;set;}
    
    public ProgramForm()
    {
        
            tskList = new List<MV_Task__c>();
    		tskList = [SELECT Id,IsEditable__c,Is_Header_Name__c,Picklist_Value__c,API_field_Name__c,Validaytion_on_text__c,Name,Is_Completed__c,Is_Response_Mnadetory__c,MV_Process__c,Task_Response__c,Task_type__c,Task_Text__c,CreatedDate,Position__c,Location_Level__c,Mobile_Question_Text_English__c,Picklist_Value_English__c,Mobile_Question_Text_Hindi__c,Picklist_Value_Hindi__c,Mobile_Question_Text_Marathi__c,Picklist_Value_Marathi__c from MV_Task__c where MV_Process__c = 'a1Q0k000000ClPi' AND IsActived__c = true ORDER BY Position__c];

    
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
       // FeedBackInDetail =null;
       
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
          //FeedBackInDetail =null;
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
       // return options;
        return null;
    }
    
    public PageReference getTaluka() {
        
         //FeedBackInDetail =null;
            List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('Select','Select'));
          AggregateResult[] groupedResults = [SELECT Taluka_Name__c, Count(Id) FROM MV_Location__c where District_Name__c =: distIs GROUP BY Taluka_Name__c];
            for (AggregateResult ar : groupedResults)  {
                    options.add(new SelectOption((String)ar.get('Taluka_Name__c'),(String)ar.get('Taluka_Name__c')));
       
            }
            system.debug('--------------'+options.size());
        //return options;
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
            //return options;
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
            //return options;
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
    
      public Pagereference saveForm(){
        //tskList = [SELECT Id,IsEditable__c,Is_Header_Name__c,Picklist_Value__c,API_field_Name__c,Validaytion_on_text__c,Name,Is_Completed__c,Is_Response_Mnadetory__c,MV_Process__c,Task_Response__c,Task_type__c,Task_Text__c,CreatedDate,Position__c,Location_Level__c,Mobile_Question_Text_English__c,Picklist_Value_English__c,Mobile_Question_Text_Hindi__c,Picklist_Value_Hindi__c,Mobile_Question_Text_Marathi__c,Picklist_Value_Marathi__c from MV_Task__c where MV_Process__c = 'a1Q0k000000ClPi' AND IsActived__c = true ORDER BY Position__c];
        System.debug('I am in save form');
        for(Integer i=0; i<tskList.size(); i++)
        {
            System.debug('API Name is' + tskListForVF[i].Task_Text__c);
        	 System.debug('Value is' + tskListForVF[i].API_field_Name__c);
        }
        
    return null;
    }
    

}