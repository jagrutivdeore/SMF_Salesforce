global class sectionwiseDashboard {
   
    public String Process{get; set;}
    public String role{get; set;}
    public String question{get; set;}
    public String State{get; set;}
    public String dist {get; set;}
    public String tal {get; set;}
    public String cluster {get; set;}
    public String caption {get; set;}

    public String NameOfState {get; set;}
    public String NameOfDistrict {get; set;}
    public String NameOfTaluka {get; set;}
    public String NameOfCluster {get; set;}
    public List<feedbackdata> feedbackdatalist {get; set;}
    
    public integer countOfDistrict {get; set;}
    public integer countOfTaluka {get; set;}
    public integer countOfcluster {get; set;}
    public integer validafeedbackCount {get; set;}
    public integer countofrecords{get; set;}
    public integer initialCount{get; set;}
    public integer presenrcount{get; set;}
    

    public integer feedbackCount {get; set;}
    public List<FeedBackWrapper> getFeedBackWrapper() {
        return feedBackWrapper;
    }
    public void setFeedBackWrapper(List<feedBackWrapper> mvTraineeFeedBack) {
        this.feedBackWrapper = feedBackWrapper;
    }

    public List<Task_Answer__c> getFeedBackInDetail() {
        return FeedBackInDetail;
    }
    public void setFeedBackInDetail(List<Task_Answer__c> FeedBackInDetail) {
        this.FeedBackInDetail = FeedBackInDetail;
    }   
   
    Integer totalCount = null;
  
    List<MV_Training_Calender__c> records = new List<MV_Training_Calender__c>();
    List<MV_TraineeFeedback__c> mvTraineeFeedBack = new List<MV_TraineeFeedback__c>();
    List<FeedBackWrapper> feedBackWrapper = null;
    List<FeedBackWrapper> updatedFeedBackWrapper = null;
    List<feedbackdata> feedbackdatalistNew = new List<feedbackdata>();
   
    List<Task_Answer__c> FeedBackInDetail = null;
    List<Id> recordId = null;
    
    global sectionwiseDashboard(ApexPages.StandardController controller) {
        State = 'select';
        dist = 'select';
        tal = 'select';
        feedbackCount = 0;
        PaginationCount__c myCS1 = PaginationCount__c.getValues('section');
        countofrecords = Integer.valueOf(myCS1.record_Count__c);
        presenrcount=0;

    }
     global sectionwiseDashboard() {
        State = 'select';
        dist = 'select';
        tal = 'select';
        feedbackCount = 0;
        PaginationCount__c myCS1 = PaginationCount__c.getValues('section');
        countofrecords = Integer.valueOf(myCS1.record_Count__c);
        presenrcount=0;
    }
    public List<SelectOption> getprocessList() {
        FeedBackInDetail =null;
       // totalFeedBackCount = 0;
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Select','Select'));
            //AggregateResult[] groupedResults = [SELECT Name, Count(Id) FROM MV_Process__c GROUP BY Name];
            //AggregateResult[] groupedResults = [SELECT Name, Count(Id) FROM MV_Role__c GROUP BY Name];
            
           for (RoleManagement__c iso : RoleManagement__c.getAll().values()){
                if(iso.IsActived__c == true){
                    options.add(new SelectOption(iso.Name,iso.Name));
                 }
            }
            system.debug('--------------'+options.size());
    return options;
        }
    
      public List<SelectOption> getroleList() {
         // totalFeedBackCount = 0;
          FeedBackInDetail =null;
            List<SelectOption> options = new List<SelectOption>();
            List<Id> idList = new List<Id>();
          options.add(new SelectOption('Select','Select'));
          AggregateResult[] groupedResults = [SELECT Name, Count(Id) FROM MV_Process__c where Multiple_Role__c includes(:Process) AND IS_In_Executive_dashboard__c = true GROUP BY Name];
          for (AggregateResult ar : groupedResults){
             options.add(new SelectOption((String)ar.get('Name'),(String)ar.get('Name')));
            }
         system.debug('--------------'+options.size());
    return options;
        }
    
     public List<SelectOption> getquestionList() {
        // totalFeedBackCount = 0;
         FeedBackInDetail =null;
            List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('Select','Select'));
         
            AggregateResult[] groupedResults = [SELECT Section_Name__c,count(Id) FROM MV_Task__c where MV_Process__r.Name =:role AND (Task_type__c = 'Selection' OR Task_type__c = 'Text' OR Task_type__c = 'Multi-Lines' OR Task_type__c = 'Multi-select' OR Task_type__c = 'Checkbox') AND Section_Name__c != '' GROUP BY Section_Name__c];
            
          for (AggregateResult ar : groupedResults){
             options.add(new SelectOption((String)ar.get('Section_Name__c'),(String)ar.get('Section_Name__c')));
            }
            
        return options;
        }
    
    
      public List<SelectOption> getStateList() {
        FeedBackInDetail =null;
       // totalFeedBackCount = 0;
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Select','Select'));
            AggregateResult[] groupedResults = [SELECT Name, Count(Id) FROM State__c GROUP BY Name];
            for (AggregateResult ar : groupedResults)  {
                    options.add(new SelectOption((String)ar.get('Name'),(String)ar.get('Name')));
            }
            system.debug('--------------'+options.size());
        return options;
        }
    
        
      public List<SelectOption> getDistrict() {
        system.debug('----'+ State);
          FeedBackInDetail =null;
            List<SelectOption> options = new List<SelectOption>();
          options.add(new SelectOption('Select','Select'));
          if(State == null){
              State = 'Maharashtra';
          }
          AggregateResult[] groupedResults = [SELECT Name, Count(Id) FROM District__c where State__r.Name = :State  GROUP BY Name];
            for (AggregateResult ar : groupedResults)  {
                    options.add(new SelectOption((String)ar.get('Name'),(String)ar.get('Name')));
       
            }
          system.debug('--------------'+options.size());
            return options;
        }
    
     public List<SelectOption> getTaluka() {
        // totalFeedBackCount = 0;
         FeedBackInDetail =null;
            List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('Select','Select'));
          AggregateResult[] groupedResults = [SELECT Taluka_Name__c, Count(Id) FROM MV_Location__c where District_Name__c =: dist  GROUP BY Taluka_Name__c];
            for (AggregateResult ar : groupedResults)  {
                    options.add(new SelectOption((String)ar.get('Taluka_Name__c'),(String)ar.get('Taluka_Name__c')));
       
            }
            system.debug('--------------'+options.size());
            return options;
            
     }
     
      public List<SelectOption> getclusterlist() {
        // totalFeedBackCount = 0;
         FeedBackInDetail =null;
            List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('Select','Select'));
          AggregateResult[] groupedResults = [SELECT Cluster_Name__c, Count(Id) FROM MV_Location__c where Taluka_Name__c =: tal  GROUP BY Cluster_Name__c];
            for (AggregateResult ar : groupedResults)  {
                    options.add(new SelectOption((String)ar.get('Cluster_Name__c'),(String)ar.get('Cluster_Name__c')));
       
            }
            system.debug('--------------'+options.size());
            return options;
        }
         public void next(){
             system.debug('---------'+ feedbackdatalistNew.size());
             system.debug('---------'+ presenrcount);
                                                                                // 0 - 3 -2
             if(presenrcount < (feedbackdatalistNew.size()-countofrecords)){
                 feedbackdatalist = new List<feedbackdata>();
                 integer cnt = countofrecords+countofrecords+presenrcount;
                 integer init = (countofrecords + presenrcount);
                 for(integer i = init; i < cnt; i++){
                     if(feedbackdatalistNew.size() > i){
                         feedbackdatalist.add(feedbackdatalistNew[i]);
                        
                     }
                      presenrcount++;
                }
             }
             
         }
         public void Previous(){
              system.debug('----presenrcount-----'+ presenrcount);
             if(presenrcount >= 0){
                 system.debug('----presenrcount-----'+ presenrcount);
                 feedbackdatalist = new List<feedbackdata>();
                 Integer cnt = presenrcount+countofrecords;
                integer init = (cnt-countofrecords);     
                system.debug('---init------'+ init);
                system.debug('---cnt------'+ cnt);
                 for(integer i = init; i < cnt; i++){
                     if(i>=0){
                          if(feedbackdatalistNew.size() > i){
                            feedbackdatalist.add(feedbackdatalistNew[i]);
                          } 
                     }
                     presenrcount--;
                }
             }
            
             
         }
    
    
    public void fetchTraineeDataFromDatabase(){  
        //system.debug('----------fetchTraineeDataFromDatabase');
       // system.debug('--------------' + question);
        decimal questioncnt = 1;
        feedbackCount = 0;
        validafeedbackCount = 0;
        presenrcount=0;
        feedBackWrapper = new List<FeedBackWrapper>();
        feedbackdatalist = new List<feedbackdata>();
        updatedFeedBackWrapper = new List<FeedBackWrapper>();
        List<MV_Task__c> tsk = new List<MV_Task__c>();
         AggregateResult[] groupedResults = null;
       //
        tsk = [SELECT Id,Picklist_Value__c,Section_Name__c,Task_type__c,Section_Question_Count__c,Caption__c,Section_Group_No__c FROM MV_Task__c where Section_Name__c = :question]; 
        system.debug('--------------'+tsk.size());
        set<decimal> strset = new set<decimal>();
        for(MV_Task__c ts : tsk){
            strset.add(ts.Section_Group_No__c);
        }
        if(tsk.size() > 0){
            caption = tsk[0].Caption__c;
        
        for(MV_Task__c tk : tsk){
            if(tk.Section_Question_Count__c != null){
                questioncnt = tk.Section_Question_Count__c;
                break;
            }
        }
        
        List<String> pickList = new List<String>();
        set<String> pickListset = new set<String>();
        
       
     //  system.debug('------Section_Question_Count__c----------'+ tsk[0].Section_Question_Count__c);
       if(tsk[0].Task_type__c == 'Selection'){
           
              pickList = tsk[0].Picklist_Value__c.split(','); 
              pickListset.addAll(pickList);
              if(dist == 'select'){
                  
                 List<Task_Answer__c> tskList = [select id,Unique_Id__c from Task_Answer__c where (MV_Process__r.Name=:role AND Answer__c = :State)];
                 
                 system.debug('--------------'+tskList.size());
                 set<String> uniqIdSet = new set<String>();
                 
                 for(Task_Answer__c ta : tskList){
                    uniqIdSet.add(ta.Unique_Id__c); 
                    //feedbackCount++;
                 }
                  groupedResults =[SELECT Answer__c, Count(Id)cnt FROM Task_Answer__c where (MV_Process__r.Name=:role AND Unique_Id__c IN :uniqIdSet AND Answer__c != '' AND Section_Name__c =:question) group by Answer__c];
                  
                  List<Task_Answer__c> tskList1 = [SELECT id,Unique_Id__c FROM Task_Answer__c where (MV_Process__r.Name=:role AND Section_Name__c =:question AND Unique_Id__c IN :uniqIdSet)];
                  
                system.debug('--------------'+tskList1.size());
                feedbackCount = tskList1.size();
                feedbackCount = Integer.valueOf(feedbackCount/questioncnt);
                validafeedbackCount = feedbackCount;
                
                //set<String> talukalist = new set<String>();
                set<String> districtlist = new set<String>();
                //set<String> clusterlist = new set<String>();
                NameOfState = '';
                NameOfDistrict = '';
                NameOfTaluka = '';
                NameOfCluster = '';
                countOfDistrict = 0;
                countOfTaluka = 0;
                countOfcluster = 0;
                set<string> tskIds = new set<string>();
                for(Task_Answer__c ts : tskList1){
                    tskIds.add(ts.Unique_Id__c);
                }
                
                List<Task_Answer__c> tskList2 = new List<Task_Answer__c>();
                tskList2 = [SELECT id,Question__c,Answer__c,Section_Name__c,Unique_Id__c FROM Task_Answer__c where (MV_Process__r.Name=:role AND Unique_Id__c IN :tskIds AND Question__c = 'District' AND Answer__c != 'select')];
                
                 system.debug('--------------'+tskList2.size());
                for(Task_Answer__c ta : tskList2){
                   if(ta.Question__c == 'District' && ta.Answer__c != 'select'){
                       system.debug('distrsict----------' + ta.Answer__c);
                        districtlist.add(ta.Answer__c);
                   }
                system.debug('distrsict----------' + districtlist);
                
                
             }
                  
                for(string str : districtlist){
                    NameOfDistrict += str + ',';
                }
                
                NameOfDistrict = NameOfDistrict.removeEnd(',');
                NameOfState = state;
                countOfDistrict = districtlist.size();                
        
        }
    //}
          else if( tal == 'select'){
            
              List<Task_Answer__c> tskList = [select id,Unique_Id__c from Task_Answer__c where (MV_Process__r.Name=:role AND Answer__c = :dist)];
             set<String> uniqIdSet = new set<String>();
             
             for(Task_Answer__c ta : tskList){
                uniqIdSet.add(ta.Unique_Id__c); 
                
             }
             List<Task_Answer__c> tskList1 = [SELECT id,Unique_Id__c FROM Task_Answer__c where (MV_Process__r.Name=:role AND Section_Name__c =:question AND Unique_Id__c IN :uniqIdSet)];
             
             feedbackCount = tskList1.size();
            feedbackCount = Integer.valueOf(feedbackCount/questioncnt);
             validafeedbackCount = feedbackCount; 
              groupedResults =[SELECT Answer__c, Count(Id)cnt FROM Task_Answer__c where (MV_Process__r.Name=:role AND Unique_Id__c IN :uniqIdSet AND Answer__c != '' AND Section_Name__c =:question) group by Answer__c];
              
            set<String> statelist = new set<String>();
            set<String> talukalist = new set<String>();
            set<String> districtlist = new set<String>();
            set<String> clusterlist = new set<String>();
            NameOfState = '';
            NameOfDistrict = '';
            NameOfTaluka = '';
            NameOfCluster = '';
            countOfDistrict = 0;
            countOfTaluka = 0;
            countOfcluster = 0;
            set<string> tskIds = new set<string>();
            for(Task_Answer__c ts : tskList1){
                tskIds.add(ts.Unique_Id__c);
            }
            
            List<Task_Answer__c> tskList2 = [SELECT id,Question__c,Answer__c,Section_Name__c,Unique_Id__c FROM Task_Answer__c where (MV_Process__r.Name=:role AND Unique_Id__c IN :tskIds AND Question__c = 'Taluka')];
            
            for(Task_Answer__c ta : tskList2){
               if(ta.Question__c == 'Taluka' && ta.Answer__c != 'select'){
                    talukalist.add(ta.Answer__c);
                
                }
            }
            for(string str : talukalist){
                NameOfTaluka += str + ','; 
            }
            NameOfTaluka = NameOfTaluka.removeEnd(',');
            NameOfDistrict = dist;
            NameOfState = state;
            countOfTaluka = talukalist.size();
            countOfDistrict = 1;
            
            
          
          }
          
          else if(cluster == 'select'){
              
              List<Task_Answer__c> tskList = [select id,Unique_Id__c from Task_Answer__c where (MV_Process__r.Name=:role AND Answer__c =:tal)];
             set<String> uniqIdSet = new set<String>();
             
             for(Task_Answer__c ta : tskList){
                uniqIdSet.add(ta.Unique_Id__c); 
                
             }
             
             List<Task_Answer__c> tskList1 = [SELECT id,Unique_Id__c FROM Task_Answer__c where (MV_Process__r.Name=:role AND Section_Name__c =:question  AND Unique_Id__c IN :uniqIdSet)];
             
             feedbackCount = tskList1.size();
             feedbackCount = Integer.valueOf(feedbackCount/questioncnt);
              validafeedbackCount = feedbackCount;
           groupedResults =[SELECT Answer__c, Count(Id)cnt FROM Task_Answer__c where (MV_Process__r.Name=:role AND Section_Name__c =:question AND Unique_Id__c IN :uniqIdSet AND Answer__c != '' ) group by Answer__c];
           
          set<String> statelist = new set<String>();
            set<String> talukalist = new set<String>();
            set<String> districtlist = new set<String>();
            set<String> clusterlist = new set<String>();
            NameOfState = '';
            NameOfDistrict = '';
            NameOfTaluka = '';
            NameOfCluster = '';
            countOfDistrict = 1;
            countOfTaluka = 1;
            countOfcluster = 0;
            set<string> tskIds = new set<string>();
            for(Task_Answer__c ts : tskList1){
                tskIds.add(ts.Unique_Id__c);
            }
            
            List<Task_Answer__c> tskList2 = [SELECT id,Question__c,Answer__c,Section_Name__c,Unique_Id__c FROM Task_Answer__c where (MV_Process__r.Name=:role AND Unique_Id__c IN :tskIds AND Question__c = 'Cluster' )];
            
            for(Task_Answer__c ta : tskList2){
               if(ta.Question__c == 'Cluster' && ta.Answer__c != 'select'){
                    clusterlist.add(ta.Answer__c);
                }
            }
          
            for(string str : clusterlist){
                NameOfCluster += str + ',';
            }
           NameOfCluster = NameOfCluster.removeEnd(',');
           countOfcluster = clusterlist.size();
           NameOfState = state;
           NameOfDistrict = dist;
           NameOfTaluka = tal;
           
           }
           
           else{
             List<Task_Answer__c> tskList = [select id,Unique_Id__c from Task_Answer__c where (MV_Process__r.Name=:role AND Answer__c =:cluster)];
             set<String> uniqIdSet = new set<String>();
             
             for(Task_Answer__c ta : tskList){
                uniqIdSet.add(ta.Unique_Id__c); 
                //feedbackCount++;
             }
             List<Task_Answer__c> tskList1 = [SELECT id,Unique_Id__c FROM Task_Answer__c where (MV_Process__r.Name=:role AND Section_Name__c =:question AND Unique_Id__c IN :uniqIdSet)]; 
             feedbackCount = tskList1.size();
             feedbackCount = Integer.valueOf(feedbackCount/questioncnt);
             validafeedbackCount = feedbackCount;
           //}  
           
          groupedResults  =[SELECT Answer__c, Count(Id)cnt FROM Task_Answer__c where (MV_Process__r.Name=:role AND Section_Name__c =:question AND Unique_Id__c IN :uniqIdSet AND Answer__c != '' ) group by Answer__c]; 
          
            NameOfState = state;
            NameOfDistrict = dist;
            NameOfTaluka = tal;
            NameOfCluster = cluster;
            countOfDistrict = 1;
            countOfTaluka =1;
            countOfcluster =1;
            
         }
          
           for(AggregateResult ar : groupedResults){
                FeedBackWrapper f = new FeedBackWrapper();
                String ans = (String) ar.get('Answer__c'); 
                system.debug('-----------ans' + ans);
                 system.debug('-----------Value-------' + (Integer)ar.get('cnt'));
                
                pickListset.remove(ans);
                if(ans != '' || ans != null){
                    f.setType(ans);
                    f.setvalue((Integer)ar.get('cnt'));
                    feedBackWrapper.add(f);
                }
            
        }
          
        for(String str : pickListset){
            FeedBackWrapper f = new FeedBackWrapper();
            f.setType(str);
            f.setvalue(0);
            feedBackWrapper.add(f);
        }
        pickList = tsk[0].Picklist_Value__c.split(','); 
        pickListset = new set<String>();
        pickListset.addAll(pickList);
        for(String str : pickListset){
              for(FeedBackWrapper f:feedBackWrapper){
                  
                if(f.getType() == str){
                    updatedFeedBackWrapper.add(f);
                }
            }
        }
         feedBackWrapper = new List<FeedBackWrapper>();
         feedBackWrapper = updatedFeedBackWrapper;
       //feedBackWrapper.sort();
      
    }
    
    else if(tsk[0].Task_type__c == 'Checkbox'){
         if(dist == 'select'){
             
           
             List<Task_Answer__c> tskList = [select id,Unique_Id__c from Task_Answer__c where (MV_Process__r.Name=:role AND Answer__c = :State)];
                     
                     system.debug('--------------'+tskList.size());
                     set<String> uniqIdSet = new set<String>();
                     
                     for(Task_Answer__c ta : tskList){
                        uniqIdSet.add(ta.Unique_Id__c); 
                        //feedbackCount++;
                     }
                     
                      List<Task_Answer__c> tskList1 = [SELECT id,Unique_Id__c FROM Task_Answer__c where (MV_Process__r.Name=:role AND Section_Name__c =:question AND Unique_Id__c IN :uniqIdSet)];
                      
                    system.debug('--------------'+tskList1.size());
                    feedbackCount = tskList1.size();
                    feedbackCount = Integer.valueOf(feedbackCount/questioncnt);
                    validafeedbackCount = feedbackCount;
                    
                    //set<String> talukalist = new set<String>();
                    set<String> districtlist = new set<String>();
                    //set<String> clusterlist = new set<String>();
                    NameOfState = '';
                    NameOfDistrict = '';
                    NameOfTaluka = '';
                    NameOfCluster = '';
                    countOfDistrict = 0;
                    countOfTaluka = 0;
                    countOfcluster = 0;
                    set<string> tskIds = new set<string>();
                    for(Task_Answer__c ts : tskList1){
                        tskIds.add(ts.Unique_Id__c);
                    }
                    
                    List<Task_Answer__c> tskList2 = [SELECT id,Question__c,Answer__c,Section_Name__c,Unique_Id__c FROM Task_Answer__c where (MV_Process__r.Name=:role AND Unique_Id__c IN :tskIds) AND Question__c = 'District'];
                    
                     system.debug('--------------'+tskList2.size());
                    for(Task_Answer__c ta : tskList2){
                       if(ta.Question__c == 'District' && ta.Answer__c != 'select'){
                            districtlist.add(ta.Answer__c);
                       }
                   
                    for(string str : districtlist){
                        NameOfDistrict += str + ',';  
                    }
                    NameOfDistrict = NameOfDistrict.removeEnd(',');
             }
             NameOfState = state;
             countOfDistrict = districtlist.size();
             
          }else if( tal == 'select'){
              
             List<Task_Answer__c> tskList = [select id,Unique_Id__c from Task_Answer__c where (MV_Process__r.Name=:role AND Answer__c =:dist)];
             set<String> uniqIdSet = new set<String>();
             
             for(Task_Answer__c ta : tskList){
                uniqIdSet.add(ta.Unique_Id__c); 
                
             }
             List<Task_Answer__c> tskList1 = [SELECT id,Unique_Id__c FROM Task_Answer__c where (MV_Process__r.Name=:role AND Section_Name__c =:question AND Unique_Id__c IN :uniqIdSet)];
             
             
             feedbackCount = tskList1.size();
            feedbackCount = Integer.valueOf(feedbackCount/questioncnt);
            validafeedbackCount = feedbackCount;
              groupedResults =[SELECT Answer__c, Count(Id)cnt FROM Task_Answer__c where (MV_Process__r.Name=:role AND Section_Name__c =:question AND Unique_Id__c IN :uniqIdSet AND Answer__c != '') group by Answer__c];
              
             set<String> statelist = new set<String>();
            set<String> talukalist = new set<String>();
            set<String> districtlist = new set<String>();
            set<String> clusterlist = new set<String>();
            NameOfState = '';
            NameOfDistrict = '';
            NameOfTaluka = '';
            NameOfCluster = '';
            countOfDistrict = 0;
            countOfTaluka = 0;
            countOfcluster = 0;
            set<string> tskIds = new set<string>();
            for(Task_Answer__c ts : tskList1){
                tskIds.add(ts.Unique_Id__c);
            }
            
            List<Task_Answer__c> tskList2 = [SELECT id,Question__c,Answer__c,Section_Name__c,Unique_Id__c FROM Task_Answer__c where (MV_Process__r.Name=:role AND Unique_Id__c IN :tskIds AND Question__c = 'Taluka')];
            
            for(Task_Answer__c ta : tskList2){
               if(ta.Question__c == 'Taluka' && ta.Answer__c != 'select'){
                    talukalist.add(ta.Answer__c);
                
                }
            }
            for(string str : talukalist){
                NameOfTaluka += str + ','; 
            }
            NameOfTaluka = NameOfTaluka.removeEnd(',');
            NameOfDistrict = dist;
            NameOfState = state;
            countOfTaluka = talukalist.size();
            countOfDistrict = 1;
            
          
          }else if(cluster =='select'){
             
               List<Task_Answer__c> tskList = [select id,Unique_Id__c from Task_Answer__c where (MV_Process__r.Name=:role AND Answer__c =:tal )];
                set<String> uniqIdSet = new set<String>();
             
             for(Task_Answer__c ta : tskList){
                uniqIdSet.add(ta.Unique_Id__c); 
                
             }
             List<Task_Answer__c> tskList1 = [SELECT id,Unique_Id__c FROM Task_Answer__c where (MV_Process__r.Name=:role AND Section_Name__c =:question AND Unique_Id__c IN :uniqIdSet)];
             feedbackCount = tskList1.size();
            feedbackCount = Integer.valueOf(feedbackCount/questioncnt); 
            validafeedbackCount = feedbackCount;
            groupedResults =[SELECT Answer__c, Count(Id)cnt FROM Task_Answer__c where (MV_Process__r.Name=:role AND Section_Name__c =:question AND Unique_Id__c IN :uniqIdSet  AND Answer__c != '' )group by Answer__c];
            
            set<String> statelist = new set<String>();
            set<String> talukalist = new set<String>();
            set<String> districtlist = new set<String>();
            set<String> clusterlist = new set<String>();
            NameOfState = '';
            NameOfDistrict = '';
            NameOfTaluka = '';
            NameOfCluster = '';
            countOfDistrict = 1;
            countOfTaluka = 1;
            countOfcluster = 0;
            set<string> tskIds = new set<string>();
            for(Task_Answer__c ts : tskList1){
                tskIds.add(ts.Unique_Id__c);
            }
            
            List<Task_Answer__c> tskList2 = [SELECT id,Question__c,Answer__c,Section_Name__c,Unique_Id__c FROM Task_Answer__c where (MV_Process__r.Name=:role AND Unique_Id__c IN :tskIds AND Question__c = 'Cluster' )];
            
            for(Task_Answer__c ta : tskList2){
               if(ta.Question__c == 'Cluster' && ta.Answer__c != 'select'){
                    clusterlist.add(ta.Answer__c);
                }
            }
          
            for(string str : clusterlist){
                NameOfCluster += str + ',';
            }
           NameOfCluster = NameOfCluster.removeEnd(',');
           countOfcluster = clusterlist.size();
           NameOfState = state;
           NameOfDistrict = dist;
           NameOfTaluka = tal;
            
     }
          
          else {
                  List<Task_Answer__c> tskList = [select id,Unique_Id__c from Task_Answer__c where (MV_Process__r.Name=:role AND Answer__c =:cluster )];
                set<String> uniqIdSet = new set<String>();
             
             for(Task_Answer__c ta : tskList){
                uniqIdSet.add(ta.Unique_Id__c); 
                
             }
             List<Task_Answer__c> tskList1 = [SELECT id,Unique_Id__c FROM Task_Answer__c where (MV_Process__r.Name=:role AND Section_Name__c =:question AND Unique_Id__c IN :uniqIdSet)];
             feedbackCount = tskList1.size();
            feedbackCount = Integer.valueOf(feedbackCount/questioncnt);
            validafeedbackCount = feedbackCount;
            
            groupedResults =[SELECT Answer__c, Count(Id)cnt FROM Task_Answer__c where (MV_Process__r.Name= :role AND Section_Name__c = :question AND Unique_Id__c IN :uniqIdSet  AND Answer__c != '' )group by Answer__c];
          
         set<String> statelist = new set<String>();
            set<String> talukalist = new set<String>();
            set<String> districtlist = new set<String>();
            set<String> clusterlist = new set<String>();
            
            set<string> tskIds = new set<string>();
            for(Task_Answer__c ts : tskList1){
                tskIds.add(ts.Unique_Id__c);
            }
            
             NameOfState = state;
            NameOfDistrict = dist;
            NameOfTaluka = tal;
            NameOfCluster = cluster;
            countOfDistrict = 1;
            countOfTaluka =1;
            countOfcluster =1;
          
          }
          
        for(AggregateResult ar : groupedResults){
            FeedBackWrapper f = new FeedBackWrapper();
            String ans = (String) ar.get('Answer__c'); 
            f.setType(ans);
            f.setvalue((Integer)ar.get('cnt'));
            feedBackWrapper.add(f);
        }
        
        
    } else{
          FeedBackInDetail = new List<Task_Answer__c>();
          feedbackdatalistNew = new List<feedbackdata>();
            if(dist == 'select'){
                List<Task_Answer__c> tskList = [select id,Unique_Id__c from Task_Answer__c where(MV_Process__r.Name=:role AND Answer__c =:State) AND Answer__c != ''];
                 set<String> uniqIdSet = new set<String>();
                 
                 for(Task_Answer__c ta : tskList){
                    uniqIdSet.add(ta.Unique_Id__c); 
                  }
                  
                List<Task_Answer__c> tskList1 = [SELECT id,Unique_Id__c FROM Task_Answer__c where (MV_Process__r.Name= :role AND Section_Name__c = :question AND Unique_Id__c IN :uniqIdSet)];
                 feedbackCount = tskList1.size();
                
            feedbackCount = Integer.valueOf(feedbackCount/questioncnt);
            
                 set<String> idset = new set<string>();
                 for(Task_Answer__c td : tskList1){
                     idset.add(td.Unique_Id__c);
                 }
                 
             FeedBackInDetail = [SELECT Section_Name__c,Unique_Id__c,Question__c,Answer__c,MV_User__r.Name,MV_User__r.Last_Name__c,District__c,Taluka__c,State__c,Cluster_Name__c FROM Task_Answer__c where (MV_Process__r.Name= :role AND Unique_Id__c IN :idset AND Answer__c != '' AND ( Question__c = 'State' OR Question__c = 'District' OR Question__c = 'Taluka' OR Question__c = 'Cluster' OR Section_Name__c = :question))];
             
              validafeedbackCount = FeedBackInDetail.size();
            validafeedbackCount = Integer.valueOf(validafeedbackCount/questioncnt);
            
            
             map<String,List<Task_Answer__c>> idTotskListMap = new map<String,List<Task_Answer__c>>();
             for(Task_Answer__c ta : FeedBackInDetail){
                 if(idTotskListMap.get(ta.Unique_Id__c)!= null){
                      List<Task_Answer__c> tskList3 = idTotskListMap.get(ta.Unique_Id__c);
                      tskList3.add(ta);
                      idTotskListMap.put(ta.Unique_Id__c, tskList3);
                }else{
                     List<Task_Answer__c> tskList3 = new List<Task_Answer__c>();
                     tskList3.add(ta);
                     idTotskListMap.put(ta.Unique_Id__c, tskList3);
                }
                
             }
             feedbackdatalist = new List<feedbackdata>();
             for(String id1 : idTotskListMap.keySet()){
                 List<Task_Answer__c> tsk5 = new List<Task_Answer__c>();
                 tsk5 = idTotskListMap.get(id1);
                 feedbackdata fd = new feedbackdata();
                 for(Task_Answer__c ts : tsk5){
                     if(ts.Question__c == 'State'){
                        fd.name = ts.MV_User__r.Name +' '+ ts.MV_User__r.Last_Name__c;
                        fd.state = ts.Answer__c;
                     }else if(ts.Question__c == 'District'){
                         fd.district = ts.Answer__c;
                     }else if(ts.Question__c == 'Taluka'){
                         fd.Taluka  = ts.Answer__c;
                     }else if(ts.Question__c == 'Cluster'){
                         fd.cluster = ts.Answer__c;
                     }
                     
                     if(ts.Section_Name__c == question){
                        fd.answer =  ts.Answer__c;
                     }
                 }
                 feedbackdatalistNew.add(fd);
             }
             
             if(feedbackdatalistNew.size() > countofrecords){
                 for(integer i = 0; i < countofrecords; i++ ){
                     feedbackdatalist.add(feedbackdatalistNew[i]);
                 }
             }else{
                feedbackdatalist = feedbackdatalistNew;
             }
             
                
            }else if(tal == 'select'){
                
                List<Task_Answer__c> tskList = [select id,Unique_Id__c from Task_Answer__c where (MV_Process__r.Name= :role AND Answer__c = :dist AND Answer__c != '')];
                 set<String> uniqIdSet = new set<String>();
                 
                 for(Task_Answer__c ta : tskList){
                    uniqIdSet.add(ta.Unique_Id__c); 
                   
                 }
                 List<Task_Answer__c> tskList1 = [SELECT id,Unique_Id__c FROM Task_Answer__c where (MV_Process__r.Name= :role AND Section_Name__c = :question AND Unique_Id__c IN :uniqIdSet)];
                  feedbackCount = tskList1.size();
                  feedbackCount = Integer.valueOf(feedbackCount/questioncnt);
                   set<String> idset = new set<string>();
                 for(Task_Answer__c td : tskList1){
                    idset.add(td.Unique_Id__c);
                 }
                 
             FeedBackInDetail = [SELECT Unique_Id__c,Section_Name__c,Question__c,Answer__c,MV_User__r.Name,MV_User__r.Last_Name__c,District__c,Taluka__c,State__c,Cluster_Name__c FROM Task_Answer__c where (MV_Process__r.Name= :role AND Unique_Id__c IN :idset AND Answer__c != ''  AND ( Question__c = 'State' OR Question__c = 'District' OR Question__c = 'Taluka' OR Question__c = 'Cluster' OR Section_Name__c = :question))];
             
              validafeedbackCount = FeedBackInDetail.size();
            validafeedbackCount = Integer.valueOf(validafeedbackCount/questioncnt);
            
             map<String,List<Task_Answer__c>> idTotskListMap = new map<String,List<Task_Answer__c>>();
             for(Task_Answer__c ta : FeedBackInDetail){
                 if(idTotskListMap.get(ta.Unique_Id__c)!= null){
                      List<Task_Answer__c> tskList3 = idTotskListMap.get(ta.Unique_Id__c);
                      tskList3.add(ta);
                      idTotskListMap.put(ta.Unique_Id__c, tskList3);
                }else{
                     List<Task_Answer__c> tskList3 = new List<Task_Answer__c>();
                     tskList3.add(ta);
                     idTotskListMap.put(ta.Unique_Id__c, tskList3);
                }
                
             }
             feedbackdatalist = new List<feedbackdata>();
             for(String id1 : idTotskListMap.keySet()){
                 List<Task_Answer__c> tsk5 = new List<Task_Answer__c>();
                 tsk5 = idTotskListMap.get(id1);
                 feedbackdata fd = new feedbackdata();
                 for(Task_Answer__c ts : tsk5){
                     if(ts.Question__c == 'State'){
                        fd.name = ts.MV_User__r.Name +' '+ ts.MV_User__r.Last_Name__c;
                        fd.state = ts.Answer__c;
                     }else if(ts.Question__c == 'District'){
                         fd.district = ts.Answer__c;
                     }else if(ts.Question__c == 'Taluka'){
                         fd.Taluka  = ts.Answer__c;
                     }else if(ts.Question__c == 'Cluster'){
                         fd.cluster = ts.Answer__c;
                     }
                     if(ts.Section_Name__c == question){
                        fd.answer =  ts.Answer__c;
                     }
                 }
                  feedbackdatalistNew.add(fd);
             }
             
             if(feedbackdatalistNew.size() > countofrecords){
                 for(integer i = 0; i < countofrecords; i++ ){
                     feedbackdatalist.add(feedbackdatalistNew[i]);
                 }
             }else{
                feedbackdatalist = feedbackdatalistNew;
             }
                
            }
            else if(cluster == 'select'){
                List<Task_Answer__c> tskList = [select id,Unique_Id__c from Task_Answer__c where (MV_Process__r.Name= :role AND Answer__c = :tal AND Answer__c != '')];
                 set<String> uniqIdSet = new set<String>();
                 
                 for(Task_Answer__c ta : tskList){
                    uniqIdSet.add(ta.Unique_Id__c); 
                    
                 }
                 List<Task_Answer__c> tskList1 = [SELECT id,Unique_Id__c FROM Task_Answer__c where (MV_Process__r.Name= :role AND Section_Name__c = :question AND Unique_Id__c IN :uniqIdSet)];
                  feedbackCount = tskList1.size();
               feedbackCount = Integer.valueOf(feedbackCount/questioncnt);
               
                set<String> idset = new set<string>();
                 for(Task_Answer__c td : tskList1){
                     idset.add(td.Unique_Id__c);
                 }
                 
             FeedBackInDetail = [SELECT Unique_Id__c,Section_Name__c,Question__c,Answer__c,MV_User__r.Name,MV_User__r.Last_Name__c,District__c,Taluka__c,State__c,Cluster_Name__c FROM Task_Answer__c where (MV_Process__r.Name= :role AND Unique_Id__c IN :idset AND Answer__c != '' AND ( Question__c = 'State' OR Question__c = 'District' OR Question__c = 'Taluka' OR Question__c = 'Cluster' OR Section_Name__c = :question))];
             
             
              validafeedbackCount = FeedBackInDetail.size();
            validafeedbackCount = Integer.valueOf(validafeedbackCount/questioncnt);
             
             map<String,List<Task_Answer__c>> idTotskListMap = new map<String,List<Task_Answer__c>>();
             for(Task_Answer__c ta : FeedBackInDetail){
                 if(idTotskListMap.get(ta.Unique_Id__c)!= null){
                      List<Task_Answer__c> tskList3 = idTotskListMap.get(ta.Unique_Id__c);
                      tskList3.add(ta);
                      idTotskListMap.put(ta.Unique_Id__c, tskList3);
                }else{
                     List<Task_Answer__c> tskList3 = new List<Task_Answer__c>();
                     tskList3.add(ta);
                     idTotskListMap.put(ta.Unique_Id__c, tskList3);
                }
                
             }
             feedbackdatalist = new List<feedbackdata>();
             for(String id1 : idTotskListMap.keySet()){
                 List<Task_Answer__c> tsk5 = new List<Task_Answer__c>();
                 tsk5 = idTotskListMap.get(id1);
                 feedbackdata fd = new feedbackdata();
                 for(Task_Answer__c ts : tsk5){
                     if(ts.Question__c == 'State'){
                        fd.name = ts.MV_User__r.Name +' '+ ts.MV_User__r.Last_Name__c;
                        fd.state = ts.Answer__c;
                     }else if(ts.Question__c == 'District'){
                         fd.district = ts.Answer__c;
                     }else if(ts.Question__c == 'Taluka'){
                         fd.Taluka  = ts.Answer__c;
                     }else if(ts.Question__c == 'Cluster'){
                         fd.cluster = ts.Answer__c;
                     }
                        
                     if(ts.Section_Name__c == question){
                        fd.answer =  ts.Answer__c;
                     }
                 }
                feedbackdatalistNew.add(fd);
             }
             
             if(feedbackdatalistNew.size() > countofrecords){
                 for(integer i = 0; i < countofrecords; i++ ){
                     feedbackdatalist.add(feedbackdatalistNew[i]);
                 }
             }else{
                feedbackdatalist = feedbackdatalistNew;
             }
    }
             
            else{
                
                List<Task_Answer__c> tskList = [select id,Unique_Id__c from Task_Answer__c where (MV_Process__r.Name= :role AND Answer__c = :cluster AND Answer__c != '')];
                 set<String> uniqIdSet = new set<String>();
                 
                 for(Task_Answer__c ta : tskList){
                    uniqIdSet.add(ta.Unique_Id__c); 
                    //feedbackCount++;
                 }
                  List<Task_Answer__c> tskList1 = [SELECT id,Unique_Id__c FROM Task_Answer__c where (MV_Process__r.Name= :role AND Section_Name__c = :question AND Unique_Id__c IN :uniqIdSet)];
                  
                   feedbackCount = tskList1.size();
                 feedbackCount = Integer.valueOf(feedbackCount/questioncnt);
                  set<String> idset = new set<string>();
                 for(Task_Answer__c td : tskList1){
                     idset.add(td.Unique_Id__c);
                 }
                 
             FeedBackInDetail = [SELECT Unique_Id__c,Section_Name__c,Question__c,Answer__c,MV_User__r.Name,MV_User__r.Last_Name__c,District__c,Taluka__c,State__c,Cluster_Name__c FROM Task_Answer__c where (MV_Process__r.Name= :role AND Unique_Id__c IN :idset AND Answer__c != '' AND ( Question__c = 'State' OR Question__c = 'District' OR Question__c = 'Taluka' OR Question__c = 'Cluster' OR Section_Name__c = :question))];
             
             
              validafeedbackCount = FeedBackInDetail.size();
            validafeedbackCount = Integer.valueOf(validafeedbackCount/questioncnt);
             
             map<String,List<Task_Answer__c>> idTotskListMap = new map<String,List<Task_Answer__c>>();
             for(Task_Answer__c ta : FeedBackInDetail){
                 if(idTotskListMap.get(ta.Unique_Id__c)!= null){
                      List<Task_Answer__c> tskList3 = idTotskListMap.get(ta.Unique_Id__c);
                      tskList3.add(ta);
                      idTotskListMap.put(ta.Unique_Id__c, tskList3);
                }else{
                     List<Task_Answer__c> tskList3 = new List<Task_Answer__c>();
                     tskList3.add(ta);
                     idTotskListMap.put(ta.Unique_Id__c, tskList3);
                }
                
             }
             feedbackdatalist = new List<feedbackdata>();
             for(String id1 : idTotskListMap.keySet()){
                 List<Task_Answer__c> tsk5 = new List<Task_Answer__c>();
                 tsk5 = idTotskListMap.get(id1);
                 feedbackdata fd = new feedbackdata();
                 for(Task_Answer__c ts : tsk5){
                     if(ts.Question__c == 'State'){
                        fd.name = ts.MV_User__r.Name +' '+ ts.MV_User__r.Last_Name__c;
                        fd.state = ts.Answer__c;
                     }else if(ts.Question__c == 'District'){
                         fd.district = ts.Answer__c;
                     }else if(ts.Question__c == 'Taluka'){
                         fd.Taluka  = ts.Answer__c;
                     }else if(ts.Question__c == 'Cluster'){
                         fd.cluster = ts.Answer__c;
                     }
                     
                     if(ts.Section_Name__c == question){
                        fd.answer = ts.Answer__c;
                     }
                 }
                feedbackdatalistNew.add(fd);
             }
             
             if(feedbackdatalistNew.size() > countofrecords){
                 for(integer i = 0; i < countofrecords; i++ ){
                     feedbackdatalist.add(feedbackdatalistNew[i]);
                     presenrcount++;
                 }
             }else{
                feedbackdatalist = feedbackdatalistNew;
             }
                
            }
        }
    }
        
        
  }
  
    
      public List<PieWedgeData> getPieData1() {
        List<PieWedgeData> data = new List<PieWedgeData>();
          if(feedBackWrapper != null){
            totalCount = 0;
               for(FeedBackWrapper f:feedBackWrapper){
                    if(f.getType() != null || f.getValue() != null){
                   totalCount = totalCount + f.getValue();
                    }
              
                }
              
          // System.debug('Final Report values are:'+ feedBackWrapper);
           for(FeedBackWrapper f:feedBackWrapper){
              if(f.getType() != null && f.getValue() != null)
              {
                  Decimal specificCount = f.getValue();
                  Decimal percentCount = 0.0;
                  if(totalCount>0)
                  {
                           percentCount = Math.round((Decimal)(100*specificCount)/totalCount);                     
                  }
                  //percentCount = Math.round(percentCount*100)/100.0;
                    //String output = string.valueof(percentCount) + '%';  
                  data.add(new PieWedgeData(f.getType()+'  ==>>'+percentCount +' %', percentCount));
              }
              
          }
          }
          else
          {
              //do nothing
          }
          //System.debug('--------Data is'+data);
        return data;
    }
   
     public void checkProcessValue()
          {
              getroleList();
              fetchTraineeDataFromDatabase();
              //system.debug('----------checkProcessValue');
               
          }
    
     public void checkTalValue()
          {
             // system.debug('----------checkTalValue');
              fetchTraineeDataFromDatabase(); 
          }
    public void checkStateValue()
          {
           //   system.debug('----------checkStateValue');
            getDistrict();
            fetchTraineeDataFromDatabase();
          }
    
    public void setValueToDist()
    {    //system.debug('----------setValueToDist');
       getquestionList();
       fetchTraineeDataFromDatabase();
    }
    
    public void setValueToDist1()
    {   //system.debug('----------setValueToDist1');
       getTaluka();
       fetchTraineeDataFromDatabase();
    }
    
     public void setValueTocluster()
    {   //system.debug('----------getclusterlist');
       getclusterlist();
       fetchTraineeDataFromDatabase();
    }
   
    
      global class PieWedgeData implements Comparable{
        global String name { get; set; }
        global Decimal data { get; set; }
        //public String data { get; set; }
        global PieWedgeData(String name, Decimal data) {
            this.name = name;
            this.data= data.setScale(2);
             //this.data= data;
            
        }
        global Integer compareTo(Object ObjToCompare) {
            return name.CompareTo(((PieWedgeData)ObjToCompare).name);
        }
        
    }
    
    global class feedbackdata{
        global String name { get; set; }
        global string state { get; set; }
        global string district { get; set; }
        global string taluka { get; set; }
        global string cluster { get; set; }
        global string answer { get; set; }
        
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
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
         
           i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
                  i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
           i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
         
           i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
          i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
         
           i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
           i++;
         i++;
         i++;
         i++;
       
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
           i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
         
           i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
          i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
         
           i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
           i++;
         i++;
         i++;
         i++;
          i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
         
           i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
           i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
         
           i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
         
           i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
                  i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
           i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
         
           i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
          i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
         
           i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
           i++;
         i++;
         i++;
         i++;
       
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
           i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
         
           i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
          i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
         
           i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
           i++;
         i++;
         i++;
         i++;
       
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
           i++;
         i++;
         i++;
         i++;
       
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
           i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
         
           i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
          i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
         
           i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
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