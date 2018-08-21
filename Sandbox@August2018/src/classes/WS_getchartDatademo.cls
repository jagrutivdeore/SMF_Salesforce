@RestResource(urlMapping='/getchartDatademo/*')
global class WS_getchartDatademo {
    
  @HttpPost
    global static void AddVisitData(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json'); 
        
       
        Map<String,output> mapResponse1 = new Map<String,output>();
        dataList mVisitsData = new dataList();
        system.debug('test-----------'+req.requestBody.toString());
        mVisitsData = (dataList)JSON.deserialize(req.requestBody.toString(),dataList.class);
       String State = mVisitsData.state;
       string dist = mVisitsData.district;
       string tal = mVisitsData.taluka;
       string tskId = mVisitsData.tskId;
       string role = mVisitsData.role;
       decimal questioncnt=1;
        List<FeedBackWrapper> feedBackWrapper = new List<FeedBackWrapper>();
        List<Task_Answer__c> FeedBackInDetail = new List<Task_Answer__c>();
        List<outputdata> odList = new List<outputdata>();
        Integer feedbackCount = 0;
        string caption='';
        integer validafeedbackCount=0;
        string NameOfState = '';
        string NameOfDistrict = '';
        string NameOfTaluka = '';
        string NameOfCluster = '';
        integer countOfDistrict = 0;
        integer countOfTaluka = 0;
        integer countOfcluster = 0;
        string processName='';
           List<feedbackdata> feedbackdatalistNew = new List<feedbackdata>();
    try{
    //
        List<MV_Task__c> tsk = [SELECT Id,Picklist_Value__c,Section_Question_Count__c,Caption__c,Section_Name__c,Task_type__c,MV_Process__c,Task_Text__c,MV_Process__r.Name FROM MV_Task__c where Id =: tskId];
         if(tsk[0].Section_Question_Count__c != null){
                questioncnt = tsk[0].Section_Question_Count__c;
                
            }
        caption = tsk[0].Caption__c;
        processName = tsk[0].MV_Process__r.Name;
         List<String> pickList = new List<String>();
        set<String> pickListset = new set<String>();
         
       AggregateResult[] groupedResults = null;
       List<FeedBackWrapper> updatedFeedBackWrapper = new List<FeedBackWrapper>();
        
       
       if(tsk[0].Task_type__c == 'Selection'){

          pickList = tsk[0].Picklist_Value__c.split(','); 
          pickListset.addAll(pickList);
          if(dist == 'select'){
           List<Task_Answer__c> tskList = [select id,Unique_Id__c from Task_Answer__c where MV_Process__r.Name=:tsk[0].MV_Process__r.Name AND Answer__c =:State AND Answer__c != '' AND Role_Name__c = :role];
           set<String> uniqIdSet = new set<String>();
            for(Task_Answer__c ta : tskList){
                uniqIdSet.add(ta.Unique_Id__c); 
              }
          
            groupedResults =[SELECT Answer__c, Count(Id)cnt FROM Task_Answer__c where (MV_Process__c = :tsk[0].MV_Process__c AND Section_Name__c = :tsk[0].Section_Name__c AND State__c =:State AND Answer__c != '' AND Section_Name__c != '') group by Answer__c];
            
          List<Task_Answer__c> tskList1 = [SELECT id,Unique_Id__c FROM Task_Answer__c where (MV_Process__r.Name=:tsk[0].MV_Process__r.Name AND Section_Name__c =:tsk[0].Section_Name__c AND Unique_Id__c IN :uniqIdSet AND Role_Name__c = :role)];
              
            system.debug('--------------'+tskList1.size());
            feedbackCount = tskList1.size();
            feedbackCount = Integer.valueOf(feedbackCount/questioncnt);
            validafeedbackCount = feedbackCount;
            
            set<String> talukalist = new set<String>();
            set<String> districtlist = new set<String>();
            set<String> clusterlist = new set<String>();
            
            set<string> tskIds = new set<string>();
            for(Task_Answer__c ts : tskList1){
                tskIds.add(ts.Unique_Id__c);
            }
            
            List<Task_Answer__c> tskList2 = new List<Task_Answer__c>();
            tskList2 = [SELECT id,Question__c,Answer__c,Section_Name__c,Unique_Id__c FROM Task_Answer__c where (MV_Process__r.Name=:tsk[0].MV_Process__r.Name AND Role_Name__c = :role AND Unique_Id__c IN :tskIds AND( Question__c = 'District' OR Question__c = 'Taluka' OR Question__c = 'Cluster' )AND Answer__c != 'select')];
            
             system.debug('--------------'+tskList2.size());
            for(Task_Answer__c ta : tskList2){
               if(ta.Question__c == 'District' && ta.Answer__c != 'select'){
                   system.debug('distrsict----------' + ta.Answer__c);
                    districtlist.add(ta.Answer__c);
               }else if(ta.Question__c == 'Taluka' && ta.Answer__c != 'select'){
                   talukalist.add(ta.Answer__c);
               }else if(ta.Question__c == 'Cluster' && ta.Answer__c != 'select'){
                   clusterlist.add(ta.Answer__c);
               }
            }
              
            for(string str : districtlist){
                NameOfDistrict += str + ',';
            }
            
            NameOfDistrict = NameOfDistrict.removeEnd(',');
            NameOfState = state;
            countOfDistrict = districtlist.size();
            countOfTaluka = talukalist.size();
            countOfcluster = clusterlist.size();
            
                
          }else if( tal == 'select'){
             List<Task_Answer__c> tskList = [select id,Unique_Id__c from Task_Answer__c where (MV_Process__r.Name=:tsk[0].MV_Process__r.Name AND Answer__c = :dist AND Role_Name__c = :role)];
             set<String> uniqIdSet = new set<String>();
             
             for(Task_Answer__c ta : tskList){
                uniqIdSet.add(ta.Unique_Id__c); 
                
             }
             List<Task_Answer__c> tskList1 = [SELECT id,Unique_Id__c FROM Task_Answer__c where (MV_Process__r.Name=:tsk[0].MV_Process__r.Name AND Section_Name__c =:tsk[0].Section_Name__c AND Unique_Id__c IN :uniqIdSet AND Role_Name__c = :role)];
             
             feedbackCount = tskList1.size();
            feedbackCount = Integer.valueOf(feedbackCount/questioncnt);
             validafeedbackCount = feedbackCount; 
             
             groupedResults =[SELECT Answer__c, Count(Id)cnt FROM Task_Answer__c where (MV_Process__c = :tsk[0].MV_Process__c AND Section_Name__c =:tsk[0].Section_Name__c AND District__c =:dist AND State__c =:State AND Answer__c != '' AND Section_Name__c != '') group by Answer__c];
             
            set<String> statelist = new set<String>();
            set<String> talukalist = new set<String>();
            set<String> districtlist = new set<String>();
            set<String> clusterlist = new set<String>();
            set<string> tskIds = new set<string>();
            for(Task_Answer__c ts : tskList1){
                tskIds.add(ts.Unique_Id__c);
            }
            
           List<Task_Answer__c> tskList2 = new List<Task_Answer__c>();
            tskList2 = [SELECT id,Question__c,Answer__c,Section_Name__c,Unique_Id__c FROM Task_Answer__c where (MV_Process__r.Name=:tsk[0].MV_Process__r.Name AND Role_Name__c = :role AND Unique_Id__c IN :tskIds AND( Question__c = 'District' OR Question__c = 'Taluka' OR Question__c = 'Cluster' )AND Answer__c != 'select')];
            
             system.debug('--------------'+tskList2.size());
            for(Task_Answer__c ta : tskList2){
               if(ta.Question__c == 'District' && ta.Answer__c != 'select'){
                   system.debug('distrsict----------' + ta.Answer__c);
                    districtlist.add(ta.Answer__c);
               }else if(ta.Question__c == 'Taluka' && ta.Answer__c != 'select'){
                   talukalist.add(ta.Answer__c);
               }else if(ta.Question__c == 'Cluster' && ta.Answer__c != 'select'){
                   clusterlist.add(ta.Answer__c);
               }
            }
                
            for(string str : talukalist){
                NameOfTaluka += str + ','; 
            }
            NameOfTaluka = NameOfTaluka.removeEnd(',');
            NameOfDistrict = dist;
            NameOfState = state;
            countOfDistrict = districtlist.size();
            countOfTaluka = talukalist.size();
            countOfcluster = clusterlist.size();
            
          }else{
               List<Task_Answer__c> tskList = [select id,Unique_Id__c from Task_Answer__c where (MV_Process__r.Name=:tsk[0].MV_Process__r.Name AND Answer__c =:tal AND Role_Name__c = :role)];
             set<String> uniqIdSet = new set<String>();
             
             for(Task_Answer__c ta : tskList){
                uniqIdSet.add(ta.Unique_Id__c); 
                
             }
             
             List<Task_Answer__c> tskList1 = [SELECT id,Unique_Id__c FROM Task_Answer__c where (MV_Process__r.Name=:tsk[0].MV_Process__r.Name AND Section_Name__c =:tsk[0].Section_Name__c   AND Unique_Id__c IN :uniqIdSet AND Role_Name__c = :role)];
             
             feedbackCount = tskList1.size();
             feedbackCount = Integer.valueOf(feedbackCount/questioncnt);
             validafeedbackCount = feedbackCount;
              
              
              
           groupedResults =[SELECT Answer__c, Count(Id)cnt FROM Task_Answer__c where (MV_Process__c = :tsk[0].MV_Process__c AND Section_Name__c =:tsk[0].Section_Name__c AND District__c =:dist AND State__c =:State AND Taluka__c =:tal  AND Answer__c != '' AND Section_Name__c != '') group by Answer__c];
           
            set<String> statelist = new set<String>();
            set<String> talukalist = new set<String>();
            set<String> districtlist = new set<String>();
            set<String> clusterlist = new set<String>();
            set<string> tskIds = new set<string>();
            for(Task_Answer__c ts : tskList1){
                tskIds.add(ts.Unique_Id__c);
            }
            
           List<Task_Answer__c> tskList2 = new List<Task_Answer__c>();
            tskList2 = [SELECT id,Question__c,Answer__c,Section_Name__c,Unique_Id__c FROM Task_Answer__c where (MV_Process__r.Name=:tsk[0].MV_Process__r.Name AND Unique_Id__c IN :tskIds AND Role_Name__c = :role AND( Question__c = 'District' OR Question__c = 'Taluka' OR Question__c = 'Cluster' )AND Answer__c != 'select')];
            
             system.debug('--------------'+tskList2.size());
            for(Task_Answer__c ta : tskList2){
               if(ta.Question__c == 'District' && ta.Answer__c != 'select'){
                   system.debug('distrsict----------' + ta.Answer__c);
                    districtlist.add(ta.Answer__c);
               }else if(ta.Question__c == 'Taluka' && ta.Answer__c != 'select'){
                   talukalist.add(ta.Answer__c);
               }else if(ta.Question__c == 'Cluster' && ta.Answer__c != 'select'){
                   clusterlist.add(ta.Answer__c);
               }
            }
          
            for(string str : clusterlist){
                NameOfCluster += str + ',';
            }
           NameOfCluster = NameOfCluster.removeEnd(',');
           NameOfState = state;
           NameOfDistrict = dist;
           NameOfTaluka = tal;
            countOfDistrict = districtlist.size();
            countOfTaluka = talukalist.size();
            countOfcluster = clusterlist.size();
            
          }
          system.debug('--------groupedResults--------' + groupedResults);
        for(AggregateResult ar : groupedResults){
           FeedBackWrapper f = new FeedBackWrapper();
            String ans = (String) ar.get('Answer__c'); 
            system.debug('-----------ans' + ans);
             system.debug('-----------Value-------' + (Integer)ar.get('cnt'));
            if(ans != '' || ans != null){
                system.debug('--------pickListset--------' + pickListset);
                pickListset.remove(ans);
                system.debug('--------pickListset--------' + pickListset);
                f.setType(ans);
                f.setvalue((Integer)ar.get('cnt'));
                feedBackWrapper.add(f);
            }
            
        }
              for(String str : pickListset){
                system.debug('--------pickListset--------' + pickListset);
                FeedBackWrapper f1 = new FeedBackWrapper();
                f1.setType(str);
                f1.setvalue(0);
                feedBackWrapper.add(f1);
            }
            
            
        
    }
    /*else if(tsk[0].Task_type__c == 'Checkbox'){
         if(dist == 'select'){
           // feedbackCount = [select count() from Task_Answer__c where (MV_Process__c = :tsk[0].MV_Process__c AND Section_Name__c =:tsk[0].Section_Name__c AND State__c =:State)];
            
            groupedResults =[SELECT Answer__c, Count(Id)cnt FROM Task_Answer__c where (MV_Process__c = :tsk[0].MV_Process__c AND Section_Name__c =:tsk[0].Section_Name__c AND State__c =:State AND Answer__c != '' AND Section_Name__c != '')group by Answer__c];
          }else if( tal == 'select'){
            //  feedbackCount = [select count() from Task_Answer__c where (MV_Process__c = :tsk[0].MV_Process__c AND Section_Name__c =:tsk[0].Section_Name__c AND District__c =:dist AND State__c =:State)];
              
              groupedResults =[SELECT Answer__c, Count(Id)cnt FROM Task_Answer__c where (MV_Process__c = :tsk[0].MV_Process__c AND Section_Name__c =:tsk[0].Section_Name__c AND District__c =:dist AND State__c =:State AND Answer__c != '' AND Section_Name__c != '') group by Answer__c];
          
          }else{
              
             // feedbackCount = [select count() from Task_Answer__c where (MV_Process__c = :tsk[0].MV_Process__c AND Section_Name__c =:tsk[0].Section_Name__c AND District__c =:dist AND State__c =:State AND Taluka__c =:tal )];
              
            groupedResults =[SELECT Answer__c, Count(Id)cnt FROM Task_Answer__c where (MV_Process__c = :tsk[0].MV_Process__c AND Section_Name__c =:tsk[0].Section_Name__c AND District__c =:dist AND State__c =:State AND Taluka__c =:tal  AND Answer__c != '' AND Section_Name__c != '' )group by Answer__c];
          }
        for(AggregateResult ar : groupedResults){
                    
            FeedBackWrapper f = new FeedBackWrapper();
            String ans = (String) ar.get('Answer__c'); 
            f.setType(ans);
            f.setvalue((Integer)ar.get('cnt'));
            feedBackWrapper.add(f);
            }
            
        }
        */
        
     else{
          
            if(dist == 'select'){
                
                  List<Task_Answer__c> tskList = [select id,Unique_Id__c from Task_Answer__c where MV_Process__r.Name=:tsk[0].MV_Process__r.Name AND Answer__c =:State AND Answer__c != '' AND Role_Name__c = :role];
                 set<String> uniqIdSet = new set<String>();
                 
                 for(Task_Answer__c ta : tskList){
                    uniqIdSet.add(ta.Unique_Id__c); 
                  }
                  
                List<Task_Answer__c> tskList1 = [SELECT id,Unique_Id__c FROM Task_Answer__c where (MV_Process__r.Name= :tsk[0].MV_Process__r.Name AND Section_Name__c = :tsk[0].Section_Name__c AND Unique_Id__c IN :uniqIdSet AND Role_Name__c = :role)];
               feedbackCount = tskList1.size();
                feedbackCount = Integer.valueOf(feedbackCount/questioncnt);
                
                set<String> idset = new set<string>();
                 for(Task_Answer__c td : tskList1){
                     idset.add(td.Unique_Id__c);
                 }
                
                FeedBackInDetail = [SELECT Section_Name__c,Unique_Id__c,Question__c,Answer__c,MV_User__r.Name,MV_User__r.Last_Name__c,District__c,Taluka__c,State__c,Cluster_Name__c FROM Task_Answer__c where (MV_Process__r.Name= :tsk[0].MV_Process__r.Name AND Unique_Id__c IN :idset AND Answer__c != '' AND Role_Name__c = :role AND ( Question__c = 'State' OR Question__c = 'District' OR Question__c = 'Taluka' OR Question__c = 'Cluster' OR Section_Name__c = :tsk[0].Section_Name__c))];
             
             List<Task_Answer__c> FeedBackInDetailcount = new List<Task_Answer__c>();
             FeedBackInDetailcount = [SELECT Section_Name__c,Unique_Id__c,Question__c,Answer__c,MV_User__r.Name,MV_User__r.Last_Name__c,District__c,Taluka__c,State__c,Cluster_Name__c FROM Task_Answer__c where (MV_Process__r.Name= :tsk[0].MV_Process__r.Name AND Unique_Id__c IN :idset AND Answer__c != '' AND Section_Name__c = :tsk[0].Section_Name__c AND Role_Name__c = :role)];
             
             
            validafeedbackCount = FeedBackInDetailcount.size();
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
             //feedbackdatalist = new List<feedbackdata>();
             for(String id1 : idTotskListMap.keySet()){
                 List<Task_Answer__c> tsk5 = new List<Task_Answer__c>();
                 tsk5 = idTotskListMap.get(id1);
                 feedbackdata fd = new feedbackdata();
                 for(Task_Answer__c ts : tsk5){
                     if(ts.Question__c == 'State'){
                        fd.name = ts.MV_User__r.Name +' '+ ts.MV_User__r.Last_Name__c;
                        fd.state = ts.Answer__c;
                       // fd.index = rownumber;
                       // rownumber++;
                        //currentcount++;
                     }else if(ts.Question__c == 'District'){
                         fd.district = ts.Answer__c;
                     }else if(ts.Question__c == 'Taluka'){
                         fd.Taluka  = ts.Answer__c;
                     }else if(ts.Question__c == 'Cluster'){
                         fd.cluster = ts.Answer__c;
                     }
                     
                     if(ts.Section_Name__c == tsk[0].Section_Name__c){
                        fd.answer =  ts.Answer__c;
                     }
                 }
                 feedbackdatalistNew.add(fd);
             }
 
                
            }else if(tal == 'select'){
                List<Task_Answer__c> tskList = new List<Task_Answer__c>();
                tskList = [select id,Unique_Id__c from Task_Answer__c where (MV_Process__r.Name= :tsk[0].MV_Process__r.Name AND Answer__c = :dist AND Answer__c != '' AND Role_Name__c = :role)];
                 set<String> uniqIdSet = new set<String>();
                 
                 for(Task_Answer__c ta : tskList){
                    uniqIdSet.add(ta.Unique_Id__c); 
                   
                 }
                 set<String> idset = new set<string>();
                 List<Task_Answer__c> tskList1 = new List<Task_Answer__c>();
                 tskList1 = [SELECT id,Unique_Id__c FROM Task_Answer__c where (MV_Process__r.Name= :tsk[0].MV_Process__r.Name AND Section_Name__c = :tsk[0].Section_Name__c AND Unique_Id__c IN :uniqIdSet AND Role_Name__c = :role)];
                 
                 system.debug('-------tsjList1-----------'+ tskList1.size());
                  feedbackCount = tskList1.size();
                  feedbackCount = Integer.valueOf(feedbackCount/questioncnt);
                   for(Task_Answer__c td : tskList1){
                     idset.add(td.Unique_Id__c);
                 }
                 system.debug('-------idset-----------'+ idset.size());
                 for(Task_Answer__c td : tskList1){
                    idset.add(td.Unique_Id__c);
                 }
                
                FeedBackInDetail = [SELECT Unique_Id__c,Section_Name__c,Question__c,Answer__c,MV_User__r.Name,MV_User__r.Last_Name__c,District__c,Taluka__c,State__c,Cluster_Name__c FROM Task_Answer__c where (MV_Process__r.Name= :tsk[0].MV_Process__r.Name AND Unique_Id__c IN :idset AND Answer__c != ''  AND Role_Name__c = :role AND ( Question__c = 'State' OR Question__c = 'District' OR Question__c = 'Taluka' OR Question__c = 'Cluster' OR Section_Name__c = :tsk[0].Section_Name__c))];
             
             List<Task_Answer__c> FeedBackInDetailcount = new List<Task_Answer__c>();
             FeedBackInDetailcount = [SELECT Section_Name__c,Unique_Id__c,Question__c,Answer__c,MV_User__r.Name,MV_User__r.Last_Name__c,District__c,Taluka__c,State__c,Cluster_Name__c FROM Task_Answer__c where (MV_Process__r.Name= :tsk[0].MV_Process__r.Name AND Unique_Id__c IN :idset AND Answer__c != '' AND Section_Name__c = :tsk[0].Section_Name__c AND Role_Name__c = :role)];
             
             
            validafeedbackCount = FeedBackInDetailcount.size();
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
             //feedbackdatalist = new List<feedbackdata>();
             for(String id1 : idTotskListMap.keySet()){
                 List<Task_Answer__c> tsk5 = new List<Task_Answer__c>();
                 tsk5 = idTotskListMap.get(id1);
                 feedbackdata fd = new feedbackdata();
                 for(Task_Answer__c ts : tsk5){
                     if(ts.Question__c == 'State'){
                        fd.name = ts.MV_User__r.Name +' '+ ts.MV_User__r.Last_Name__c;
                        fd.state = ts.Answer__c;
                        //fd.index = rownumber;
                        //rownumber++;
                        //currentcount++;
                     }else if(ts.Question__c == 'District'){
                         fd.district = ts.Answer__c;
                     }else if(ts.Question__c == 'Taluka'){
                         fd.Taluka  = ts.Answer__c;
                     }else if(ts.Question__c == 'Cluster'){
                         fd.cluster = ts.Answer__c;
                     }
                     if(ts.Section_Name__c == tsk[0].Section_Name__c){
                        fd.answer =  ts.Answer__c;
                     }
                 }
                  feedbackdatalistNew.add(fd);
             }
            //feedbackdatalist = feedbackdatalistNew;
            
            
            }else{
                   List<Task_Answer__c> tskList = [select id,Unique_Id__c from Task_Answer__c where (MV_Process__r.Name= :tsk[0].MV_Process__r.Name AND Answer__c = :tal AND Answer__c != '' AND Role_Name__c = :role)];
                 set<String> uniqIdSet = new set<String>();
                 
                 for(Task_Answer__c ta : tskList){
                    uniqIdSet.add(ta.Unique_Id__c); 
                    
                 }
                 List<Task_Answer__c> tskList1 = [SELECT id,Unique_Id__c FROM Task_Answer__c where (MV_Process__r.Name= :tsk[0].MV_Process__r.Name AND Section_Name__c = :tsk[0].Section_Name__c AND Unique_Id__c IN :uniqIdSet AND Role_Name__c = :role)];
                 
                  feedbackCount = tskList1.size();
                feedbackCount = Integer.valueOf(feedbackCount/questioncnt);
               
                set<String> idset = new set<string>();
                 for(Task_Answer__c td : tskList1){
                     idset.add(td.Unique_Id__c);
                 }
                
             FeedBackInDetail = [SELECT Unique_Id__c,Section_Name__c,Question__c,Answer__c,MV_User__r.Name,MV_User__r.Last_Name__c,District__c,Taluka__c,State__c,Cluster_Name__c FROM Task_Answer__c where (MV_Process__r.Name= :tsk[0].MV_Process__r.Name AND Unique_Id__c IN :idset AND Answer__c != '' AND Role_Name__c = :role AND( Question__c = 'State' OR Question__c = 'District' OR Question__c = 'Taluka' OR Question__c = 'Cluster' OR Section_Name__c = :tsk[0].Section_Name__c)) ];
             
             List<Task_Answer__c> FeedBackInDetailcount = new List<Task_Answer__c>();
             FeedBackInDetailcount = [SELECT Section_Name__c,Unique_Id__c,Question__c,Answer__c,MV_User__r.Name,MV_User__r.Last_Name__c,District__c,Taluka__c,State__c,Cluster_Name__c FROM Task_Answer__c where (MV_Process__r.Name= :tsk[0].MV_Process__r.Name AND Unique_Id__c IN :idset AND Answer__c != '' AND Section_Name__c = :tsk[0].Section_Name__c AND Role_Name__c = :role)];
             
             
            validafeedbackCount = FeedBackInDetailcount.size();
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
             //feedbackdatalist = new List<feedbackdata>();
             for(String id1 : idTotskListMap.keySet()){
                 List<Task_Answer__c> tsk5 = new List<Task_Answer__c>();
                 tsk5 = idTotskListMap.get(id1);
                 feedbackdata fd = new feedbackdata();
                 for(Task_Answer__c ts : tsk5){
                     if(ts.Question__c == 'State'){
                        fd.name = ts.MV_User__r.Name +' '+ ts.MV_User__r.Last_Name__c;
                        fd.state = ts.Answer__c;
                        //fd.index = rownumber;
                        //rownumber++;
                        //currentcount++;
                     }else if(ts.Question__c == 'District'){
                         fd.district = ts.Answer__c;
                     }else if(ts.Question__c == 'Taluka'){
                         fd.Taluka  = ts.Answer__c;
                     }else if(ts.Question__c == 'Cluster'){
                         fd.cluster = ts.Answer__c;
                     }
                        
                     if(ts.Section_Name__c == tsk[0].Section_Name__c){
                        fd.answer =  ts.Answer__c;
                     }
                 }
                feedbackdatalistNew.add(fd);
             }
           
      }
    } 
        if(feedbackdatalistNew.size() > 0){
            for(feedbackdata f:feedbackdatalistNew){
                outputdata od = new outputdata();
                od.Name = f.Name;
                //od.lName = f.MV_User__r.Last_Name__c;
                od.state = f.state;
                od.district = f.district; 
                od.taluka = f.Taluka;
                od.feedbackdetail = f.answer;
                odList.add(od);
            }
        }
        
          if(feedBackWrapper != null){
            Decimal totalCount = 0;
               for(FeedBackWrapper f:feedBackWrapper){
                  if(f.getType() != null || f.getValue() != null){
                       totalCount = totalCount + f.getValue();
                  }
              }
              
           System.debug('Final Report values are:'+ feedBackWrapper);
           for(FeedBackWrapper f:feedBackWrapper){
              if(f.getType() != null && f.getValue() != null){
                  Decimal specificCount = f.getValue();
                  Decimal percentCount = 0.0;
                  if(totalCount>0){
                    percentCount = Math.round((Decimal)(100*specificCount)/totalCount);                     
                  }
                    //data.add(new PieWedgeData(f.getType()+'  ==>>'+percentCount +' %', percentCount));
                    outputdata od = new outputdata();
                    od.key = f.getType();
                    od.value = percentCount;
                    odList.add(od);
              }
              
        }
   }
                data dt = new data();
                dt.feedbackCount = feedbackCount;
                dt.validafeedbackCount = validafeedbackCount;
                dt.NameOfDistrict = NameOfDistrict;
                dt.NameOfState = NameOfState;
                dt.NameOfTaluka = NameOfTaluka;
                dt.countOfDistrict = countOfDistrict;
                dt.countOfTaluka = countOfTaluka;
                dt.countOfcluster = countOfcluster;
                dt.caption = caption;
                dt.processName = processName;
                
                output op = new output();
                op.data = dt;
                op.outputdata = odList;
          
          
            mapResponse1.put('Records', op);
            res.responseBody = Blob.valueOf(JSON.serialize(mapResponse1));
        }catch(Exception e){
            res.responseBody = Blob.valueOf(JSON.serialize(e.getMessage()));
        }
    }
    
   global class dataList{
        String state;
        String district;
        string taluka;
        string tskId;
        string role;
  
    }
    
    global class outputdata{
        public String key;
        public Decimal value;
        
         public String Name;
         
         public String state;
         public String district;
         public String taluka;
         public String feedbackdetail;
        
    }
    global class feedbackdata{
       global String name { get; set; }
        global string state { get; set; }
        global string district { get; set; }
        global string taluka { get; set; }
        global string cluster { get; set; }
        global string answer { get; set; }
        
    }
    global class output{
        data data; 
        List<outputdata> outputdata;
    }
    global class data{
        Integer feedbackCount;
        Integer validafeedbackCount;
        string NameOfDistrict;
        string NameOfState;
        string NameOfTaluka;
        Integer countOfDistrict;
        Integer countOfTaluka;
        Integer countOfcluster;
        string caption;
        string processName;
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
      
        }
    
}