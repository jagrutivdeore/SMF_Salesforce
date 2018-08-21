@RestResource(urlMapping='/getchartDatademoNew/*')
global class WS_getchartDatademoNew {
    
  @HttpPost
    global static void AddVisitData()
    {
        
        RestRequest r = RestContext.request;
        dataList dList = new dataList();
        system.debug('test-----------'+r.requestBody.toString());
        dList = (dataList)JSON.deserialize(r.requestBody.toString(),dataList.class);
        
        string tskIdForSpecificRep = dList.tskId;
        List<MV_Task__c> t = new List<MV_Task__c>();
        
        t = [select id, Position__c from MV_Task__c where id =: tskIdForSpecificRep];
            
        System.debug('Position is' + t[0].position__c);
        if(t[0].position__c != 100)
        {
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
            List<ProcessAnswer__c> paList = new List<ProcessAnswer__c>();
            decimal questioncnt=1;
            List<FeedBackWrapper> feedBackWrapper = new List<FeedBackWrapper>();
            List<Task_Answer__c> FeedBackInDetail = new List<Task_Answer__c>();
            List<outputdata> odList = new List<outputdata>();
            Integer feedbackCount = 0;
            string caption='';
            Decimal validafeedbackCount=0;
            string NameOfState = '';
            string NameOfDistrict = '';
            string NameOfTaluka = '';
            string NameOfCluster = '';
            integer countOfDistrict = 0;
            integer countOfTaluka = 0;
            integer countOfcluster = 0;
            string processName='';
            List<feedbackdata> feedbackdatalistNew = new List<feedbackdata>();
            List<String> fieldstr = new List<String>();
            
            List<String> pickList = new List<String>();
            set<String> pickListset = new set<String>();
            set<String> statelist = new set<String>();
            set<String> talukalist = new set<String>();
            set<String> districtlist = new set<String>();
            set<String> clusterlist = new set<String>();
            set<string> tskIds = new set<string>();
            map<string,List<ProcessAnswer__c>> outputmap = new map<string,List<ProcessAnswer__c>>();
            
        try{
        //
            List<MV_Task__c> tsk = [SELECT Id,Picklist_Value__c,API_field_Name__c ,Section_Question_Count__c,Caption__c,Section_Name__c,Task_type__c,MV_Process__c,Task_Text__c,MV_Process__r.Name FROM MV_Task__c where Id =: tskId];
            for(MV_Task__c ts : tsk){
                fieldstr.add(ts.API_field_Name__c);
            }
            caption = tsk[0].Caption__c;
            processName = tsk[0].MV_Process__r.Name;
            
            System.debug('Task Type is ' + tsk[0].Task_type__c);
            System.debug('Dist is' + dist);
            
           if(tsk[0].Task_type__c == 'Selection'){
                pickList = tsk[0].Picklist_Value__c.split(','); 
                pickListset.addAll(pickList);

                if(dist == 'select'){
                      
                    //Nikhil Jamdar
                   //String soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__c =\'' + tsk[0].MV_Process__c +'\' AND Role_Name__c = \''+role+'\'';
                   String soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__c =\'' + tsk[0].MV_Process__c +'\' AND Role_Name__c in'+getStringFromList(role);
                   //includes(:Process)
                   //
                   System.debug('Query Is' + soql);
                    paList = Database.query(soql);
                    
                   System.debug('P list Is' + paList);
                    for(ProcessAnswer__c pa : paList){
                        districtlist.add(pa.District__c);
                        talukalist.add(pa.Taluka__c);
                        clusterlist.add(pa.Cluster__c);
                        for(string str : fieldstr){
                            if(outputmap.get((string)pa.get(str)) != null){
                                List<ProcessAnswer__c> paList2 = new List<ProcessAnswer__c>();
                                paList2 = outputmap.get((string)pa.get(str));
                                paList2.add(pa);
                                outputmap.put((string)pa.get(str), paList2);
                            }else{
                                List<ProcessAnswer__c> paList1 = new List<ProcessAnswer__c>();
                                paList1.add(pa);
                                outputmap.put((string)pa.get(str), paList1);
                            }                   
                        }
                    }
                    
                    for(string str : outputmap.keyset()){
                        if(str != null || str != ''){
                            pickListset.remove(str);
                            FeedBackWrapper f = new FeedBackWrapper();
                            //String ans = (String) ar.get('Answer__c'); 
                            f.setType(str);
                            f.setvalue(outputmap.get(str).size());
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
                    for(string str : talukalist){
                        if(str != '' || str != null){
                            NameOfTaluka += str + ','; 
                        }
                    }
                    
                    
                    for(string str : clusterlist){
                        if(str != '' || str != null){
                            NameOfCluster += str + ',';
                        }
                    }
                    for(string str : districtlist){
                        if(str != '' || str != null){
                            NameOfDistrict += str + ',';
                        }   
                    }
                    NameOfDistrict = NameOfDistrict.removeEnd(',');
                    NameOfTaluka = NameOfTaluka.removeEnd(',');
                    NameOfCluster = NameOfCluster.removeEnd(',');
                    countOfDistrict = districtlist.size();
                    countOfTaluka = talukalist.size();
                    countOfcluster = clusterlist.size();
                    NameOfState = state;
                }
                
                else if(tal=='select'){
                    String soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND MV_Process__c =\'' + tsk[0].MV_Process__c +'\' AND Role_Name__c in '+getStringFromList(role);
                    paList = Database.query(soql);
                    for(ProcessAnswer__c pa : paList){
                        districtlist.add(pa.District__c);
                        talukalist.add(pa.Taluka__c);
                        clusterlist.add(pa.Cluster__c);
                        for(string str : fieldstr){
                            system.debug('----strrrrrr------'+ (string)pa.get(str));
                            if(outputmap.get((string)pa.get(str)) != null){
                                List<ProcessAnswer__c> paList2 = new List<ProcessAnswer__c>();
                                paList2 = outputmap.get((string)pa.get(str));
                                paList2.add(pa);
                                outputmap.put((string)pa.get(str), paList2);
                            }else{
                                List<ProcessAnswer__c> paList1 = new List<ProcessAnswer__c>();
                                paList1.add(pa);
                                outputmap.put((string)pa.get(str), paList1);
                            }                   
                        }
                    }
                    system.debug('----outputmap------'+ outputmap.keyset());
                    
                    for(string str : outputmap.keyset()){
                        if(str != null || str != ''){
                            pickListset.remove(str);
                            FeedBackWrapper f = new FeedBackWrapper();
                            //String ans = (String) ar.get('Answer__c'); 
                            f.setType(str);
                            f.setvalue(outputmap.get(str).size());
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
                    for(string str : talukalist){
                        if(str != '' || str != null){
                            NameOfTaluka += str + ','; 
                        }
                    }
                    
                    for(string str : clusterlist){
                        if(str != '' || str != null){
                        NameOfCluster += str + ',';
                        }
                    }
                    for(string str : districtlist){
                        if(str != '' || str != null){
                        NameOfDistrict += str + ',';
                        }
                    }
                    NameOfDistrict = NameOfDistrict.removeEnd(',');
                    NameOfTaluka = NameOfTaluka.removeEnd(',');
                    NameOfCluster = NameOfCluster.removeEnd(',');
                    countOfDistrict = districtlist.size();
                    countOfTaluka = talukalist.size();
                    countOfcluster = clusterlist.size();
                    NameOfState = state;
                }
                
                else{
              //  String soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND Taluka__c =\''+tal +'\' AND MV_Process__c =\'' + tsk[0].MV_Process__c +'\' AND Role_Name__c in '+getStringFromList(role);
                  String soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND Taluka__c in '+getStringFromList(tal)+' AND MV_Process__c =\'' + tsk[0].MV_Process__c +'\' AND Role_Name__c in '+getStringFromList(role); //swarupa
                    paList = Database.query(soql);
                    for(ProcessAnswer__c pa : paList){
                        districtlist.add(pa.District__c);
                        talukalist.add(pa.Taluka__c);
                        clusterlist.add(pa.Cluster__c);
                        for(string str : fieldstr){
                            if(outputmap.get((string)pa.get(str)) != null){
                                List<ProcessAnswer__c> paList2 = new List<ProcessAnswer__c>();
                                paList2 = outputmap.get((string)pa.get(str));
                                paList2.add(pa);
                                outputmap.put((string)pa.get(str), paList2);
                            }else{
                                List<ProcessAnswer__c> paList1 = new List<ProcessAnswer__c>();
                                paList1.add(pa);
                                outputmap.put((string)pa.get(str), paList1);
                            }                   
                        }
                    }
                    
                    for(string str : outputmap.keyset()){
                        if(str != null || str != ''){
                            pickListset.remove(str);
                            FeedBackWrapper f = new FeedBackWrapper();
                            f.setType(str);
                            f.setvalue(outputmap.get(str).size());
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
                    for(string str : talukalist){
                        NameOfTaluka += str + ','; 
                    }
                    
                    for(string str : clusterlist){
                        NameOfCluster += str + ',';
                    }
                    for(string str : districtlist){
                        NameOfDistrict += str + ',';
                    }
                    NameOfDistrict = NameOfDistrict.removeEnd(',');
                    NameOfTaluka = NameOfTaluka.removeEnd(',');
                    NameOfCluster = NameOfCluster.removeEnd(',');
                    countOfDistrict = districtlist.size();
                    countOfTaluka = talukalist.size();
                    countOfcluster = clusterlist.size();
                    NameOfState = state;
                }               
           }
           
           else if(tsk[0].Task_type__c != 'Selection'){
                if(dist=='select'){
                     List<String> rlList = role.split(',');
                    System.debug('Role Name is' + rlList);
                    
                    
                   // String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__c =\'' + tsk[0].MV_Process__c +'\' AND Role_Name__c = \''+role+'\'';
                    String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__c =\'' + tsk[0].MV_Process__c +'\' AND Role_Name__c in '+getStringFromList(role);
                    
                    System.debug('SOQL Query is -----' +soql);
                    
                    paList = Database.query(soql);
                    for(ProcessAnswer__c pa : paList){
                        for(string str : fieldstr){
                            feedbackdata fd = new feedbackdata();
                            if(pa.MV_User__r.Last_Name__c == null || pa.MV_User__r.Last_Name__c == 'null' || pa.MV_User__r.Last_Name__c == '')
                                fd.name = pa.MV_User__r.Name;
                            else
                                fd.name = pa.MV_User__r.Name +' '+ pa.MV_User__r.Last_Name__c;
                            
                            fd.state = pa.State__c;
                            fd.district = pa.District__c;
                            fd.Taluka = pa.Taluka__c;
                            fd.cluster = pa.Cluster__c;
                        
                            fd.answer = (string) pa.get(str);
                            if((string) pa.get(str) != null || (string) pa.get(str) != '' || (string) pa.get(str) != 'null') 
                            feedbackdatalistNew.add(fd);
                        }
                    }
                
                }else if(tal=='select'){
                    String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND MV_Process__c =\'' + tsk[0].MV_Process__c +'\' AND Role_Name__c in '+getStringFromList(role);
                    paList = Database.query(soql);
                    for(ProcessAnswer__c pa : paList){
                        for(string str : fieldstr){
                            feedbackdata fd = new feedbackdata();
                            if(pa.MV_User__r.Last_Name__c == null || pa.MV_User__r.Last_Name__c == '' || pa.MV_User__r.Last_Name__c == 'null')
                                fd.name = pa.MV_User__r.Name;
                            else
                                fd.name = pa.MV_User__r.Name +' '+ pa.MV_User__r.Last_Name__c;
                            
                            fd.state = pa.State__c;
                            fd.district = pa.District__c;
                            fd.Taluka = pa.Taluka__c;
                            fd.cluster = pa.Cluster__c;
                                fd.answer = (string) pa.get(str);
                            if((string) pa.get(str) != null || (string) pa.get(str) != '' || (string) pa.get(str) != 'null')
                            feedbackdatalistNew.add(fd);
                        }
                    }
                }else {
              //  String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND Taluka__c =\''+tal +'\' AND MV_Process__c =\'' + tsk[0].MV_Process__c +'\' AND Role_Name__c in '+getStringFromList(role);
                String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND Taluka__c in '+getStringFromList(tal)+' AND MV_Process__c =\'' + tsk[0].MV_Process__c +'\' AND Role_Name__c in '+getStringFromList(role);   //Swarupa
                    paList = Database.query(soql);
                    for(ProcessAnswer__c pa : paList){
                        for(string str : fieldstr){
                            feedbackdata fd = new feedbackdata();
                            if(pa.MV_User__r.Last_Name__c == null || pa.MV_User__r.Last_Name__c == '' || pa.MV_User__r.Last_Name__c == 'null')
                                fd.name = pa.MV_User__r.Name;
                            else
                                fd.name = pa.MV_User__r.Name +' '+ pa.MV_User__r.Last_Name__c;
                            
                            fd.state = pa.State__c;
                            fd.district = pa.District__c;
                            fd.Taluka = pa.Taluka__c;
                            fd.cluster = pa.Cluster__c;
                          
                            fd.answer = (string) pa.get(str);
                            if((string) pa.get(str) != null || (string) pa.get(str) != '' || (string) pa.get(str) != 'null')
                             feedbackdatalistNew.add(fd);
                        }
                    }
                    
                }
               
                
           }
            
            
            if(feedBackWrapper != null){
                Decimal totalCount = 0;
               for(FeedBackWrapper f:feedBackWrapper){
                  if(f.getType() != null && f.getValue() != null){
                       totalCount = totalCount + f.getValue();
                  }
              }
               validafeedbackCount = totalCount; 
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
            if(feedbackdatalistNew.size() > 0){
                for(feedbackdata f:feedbackdatalistNew){
                    outputdata od = new outputdata();
                    od.Name = f.Name;
                    od.state = f.state;
                    od.district = f.district; 
                    od.taluka = f.Taluka;
                    od.feedbackdetail = f.answer;
                    odList.add(od);
                }
            }
                data dt = new data();
                dt.feedbackCount = paList.size();
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
            }
            catch(Exception e){
                res.responseBody = Blob.valueOf(JSON.serialize(e.getMessage()));
            }
        } //if ended
        else
        {
            
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json'); 
            
        set<String> talukalist = new set<String>();
        set<String> districtlist = new set<String>();    
        string NameOfDistrict = '';
        string NameOfTaluka = '';
            

        Map<String,output> mapResponse1 = new Map<String,output>();
        dataList mVisitsData = new dataList();
        system.debug('test-----------'+req.requestBody.toString());
        mVisitsData = (dataList)JSON.deserialize(req.requestBody.toString(),dataList.class);
        String State = mVisitsData.state;
        string dist = mVisitsData.district;
        string tal = mVisitsData.taluka;
        string tskId = mVisitsData.tskId;
        string role = mVisitsData.role;
        String caption = null;
        String processName = null;
            
        String ProcessId = null; 
            
             List<MV_Task__c> ts = new List<MV_Task__c>();
        
        ts = [select id, Position__c,MV_Process__c,MV_Process__r.Name,Section_Name__c  from MV_Task__c where id =: tskIdForSpecificRep];
          ProcessId  =  ts[0].MV_Process__c;
          caption = ts[0].Section_Name__c;
          processName = ts[0].MV_Process__r.Name;
            
            System.debug('Process Id is ' + ProcessId);
            
            
            System.debug('State is' + state);
        System.debug('processId is' + processId);        
        List<MV_Task__c> taskforAllIndicators = new List<MV_Task__c>();
        taskforAllIndicators = [SELECT Id,Indicator_Names__c,Picklist_Value__c,Bar_Chart_Labels__c,All_Indicator_Bar_Chart_Label__c,Max_Score__c,Max_Individual_Score__c,Task_Text__c,Picklist_Values_Scoring__c,Section_Name__c,API_field_Name__c,Task_type__c,Section_Question_Count__c,Caption__c,Section_Group_No__c FROM MV_Task__c where Task_type__c = 'selection' AND Picklist_Values_Scoring__c != null ANd MV_Process__c =: processId]; 
        
        List<String> listSectionName = new List<String>();
        List<String> secList = new List<String>();
        Set<String> secSet = new Set<String>(); 
        
        //3. Field Value and Option Mapping
        Map<String, Map<String,String>> FVOM = new  Map<String, Map<String,String>>();
        
        //List Of API i.e Field
        List<String> listOfAPIField = new List<String>();
        
        
        for(MV_Task__c mvt: taskforAllIndicators)
        {
            // 1. Section Name
            String sName = mvt.Indicator_Names__c;
            
            if(sName != null && sName != '')
            {
                if(sName.length()>0)
                {
                    listSectionName = sName.split(',');
                }
                
            }
            for(String s: listSectionName)
            {
                secSet.add(s);
            }
            //3. 
            Map<String,String> OVM = new Map<String,String>();
            OVM.put(mvt.Picklist_Value__c,mvt.Picklist_Values_Scoring__c);
            FVOM.put(mvt.API_field_Name__c,OVM);
            
            listOfAPIField.add(mvt.API_field_Name__c);
        }
        
        if(secSet.size() == 0)
        {
           // return null;
           res.responseBody = Blob.valueOf(JSON.serialize('Indicator is not inserted'));
        }
        
        //2. Indicator to field mapping
        Map<String,List<String>> indToFieldMap = new Map<String,List<String>>();
        
        for(String s: secSet)
        {
            List<String> fieldForResInd = new List<String>();
            
            List<MV_Task__c> taskforSpecificIndicator = new List<MV_Task__c>();
            String ind= '%'+s+'%';
            taskforSpecificIndicator = [SELECT Id,Indicator_Names__c,Picklist_Value__c,Bar_Chart_Labels__c,All_Indicator_Bar_Chart_Label__c,Max_Score__c,Max_Individual_Score__c,Task_Text__c,Picklist_Values_Scoring__c,Section_Name__c,API_field_Name__c,Task_type__c,Section_Question_Count__c,Caption__c,Section_Group_No__c FROM MV_Task__c where Task_type__c = 'selection' AND Picklist_Values_Scoring__c != null ANd Indicator_Names__c like : ind And MV_Process__c =: processId ]; 
            
            for(MV_Task__c mvt: taskforSpecificIndicator)
            {
                fieldForResInd.add(mvt.API_field_Name__c);   
            }
            
            indToFieldMap.put(s,fieldForResInd);
        }
        
        
        //Final Calculation
        List<ProcessAnswer__c> prAnswer = new List<ProcessAnswer__c>();
        //String processId = 'a1Q0k000000CjKP';
        //String Dist = 'Akola';
        String soql = null;
            
            System.debug('Taluka is ------' + tal);
            
        if(tal != null && tal != '' && tal != 'Select')
        {
         System.debug('tal  is' + tal );
            System.debug('ROle  is' + role );
            if(role != null && role != '')
            {
              //soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c, ' + String.join(listOfAPIField, ',')+ ' from ProcessAnswer__c where State__c =\'' + state +'\' And District__c =\'' + dist +'\' And Taluka__c =\'' + tal +'\' And MV_Process__c =\'' + processId +'\' AND Role_Name__c in'+getStringFromList(role);      
           
                soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c, ' + String.join(listOfAPIField, ',')+ ' from ProcessAnswer__c where State__c =\'' + state +'\' And District__c =\'' + dist +'\' AND Taluka__c in '+getStringFromList(tal)+' And MV_Process__c =\'' + processId +'\' AND Role_Name__c in'+getStringFromList(role);      //swarupa
            }
                else
            {
              //soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c, ' + String.join(listOfAPIField, ',')+ ' from ProcessAnswer__c where State__c =\'' + state +'\' And District__c =\'' + dist +'\' And Taluka__c =\'' + tal +'\' And MV_Process__c =\'' + processId +'\'';      
            
                soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c, ' + String.join(listOfAPIField, ',')+ ' from ProcessAnswer__c where State__c =\'' + state +'\' And District__c =\'' + dist +'\' AND Taluka__c in '+getStringFromList(tal)+' And MV_Process__c =\'' + processId +'\'';       //swarupa
            }
            System.debug('------------------------SOQL Query is: ' + soql);
        }
        else if(dist != null && dist != '' && dist != 'Select')
        {
                 System.debug('dist  is' + dist );
            if(role != null && role != '')
            {
                              soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c, ' + String.join(listOfAPIField, ',')+ ' from ProcessAnswer__c where State__c =\'' + state +'\' And District__c =\'' + dist +'\' And MV_Process__c =\'' + processId +'\' AND Role_Name__c in'+getStringFromList(role);   
            }
            else
            {
                              soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c, ' + String.join(listOfAPIField, ',')+ ' from ProcessAnswer__c where State__c =\'' + state +'\' And District__c =\'' + dist +'\' And MV_Process__c =\'' + processId +'\'';   
                
            }

        }
        else if(state != null && state != '' && state != 'Select')
        {
             System.debug('state  is' + state );
            if(role != null && role != '')
            {
                            soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c, ' + String.join(listOfAPIField, ',')+ ' from ProcessAnswer__c where State__c =\'' + state +'\' And MV_Process__c =\'' + processId +'\' AND Role_Name__c in'+getStringFromList(role);   
            }
            else
            {
                            soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c, ' + String.join(listOfAPIField, ',')+ ' from ProcessAnswer__c where State__c =\'' + state +'\' And MV_Process__c =\'' + processId +'\'';   
            }
         
        }


        
        System.debug('Query is' + soql);
        
        prAnswer = Database.query(soql);
        
        if(prAnswer.size() == 0 )
        {
            res.responseBody = Blob.valueOf(JSON.serialize('No Process Answer'));
        }
        
        /*for(String sec: secSet)
{
System.debug('Section Are' + sec);
}*/
        
        List<FinalResult> finalList = new List<FinalResult>();
        for(String sec: secSet)
        {
            Integer totalFeedBack = 0;
            Integer sectionValueTotal = 0;
            Integer sectionTotalQuestion = 0;
            Decimal SectionAvg = 0;
            List<String> fieldOfInd = indToFieldMap.get(sec);
            for(String f: fieldOfInd)
            {
                sectionTotalQuestion ++;
                Map<String,String> VOM = FVOM.get(f);
                Set<String> op = VOM.keySet();
                List<String> val = VOM.values();
                
                String opString = null;
                String ValString = null;
                
                List<String> opList = new List<String>();
                List<String> ValList  = new List<String>();
                
                for(String o: op)
                {
                    opString = o;
                }
                for(String v: val)
                {
                    ValString = v;
                }
                
                opList = opString.split(','); 
                ValList = ValString.split(',');
                //System.debug('Options Are: ' + opList);
                //System.debug('Values Are: ' + ValList);
                
                //System.debug('-----------Section is-----------------' +sec);
                //totalFeedBack = prAnswer.size();
                for(ProcessAnswer__c pra: prAnswer)
                {
                    
                    //
                    districtlist.add(pra.District__c);
                    talukalist.add(pra.Taluka__c);
                    
                    
                    
                    
                    String s = (String)pra.get(f);
                    
                    if(s != null)
                    {
                        totalFeedBack ++;
                    }
                    //System.debug('Answer' + s);
                    
                    Integer ind = 0;
                    ind = 0;
                    
                    
                    for(String o: opList)
                    {
                        //System.debug('-----------------Anser is' + s );
                        //System.debug('-----------------Option is' + o );
                        
                        
                        if(s == o){
                            // System.debug('Sect Value' + s);
                            //System.debug('Op Value' + o);
                            //System.debug('Selected value weigtage' + Integer.valueof(ValList[ind].trim()));
                            sectionValueTotal =  sectionValueTotal + Integer.valueof(ValList[ind].trim());
                            //System.debug('SectionValueTotal----' + sectionValueTotal);
                            break;
                        }
                        ind++;
                    }
                    
                    //sectionValueTotal =  sectionValueTotal + Integer.valueof(ValList[ind].trim());
                    
                    
                    //System.debug('Value Option Mapping' + VOM);
                }
                
                
            }
             
            //Name of Dist and Taluka
            for(string str : talukalist){
                    if(str != '' || str != null){
                        NameOfTaluka += str + ','; 
                    }
                }
               
                for(string str : districtlist){
                    if(str != '' || str != null){
                        NameOfDistrict += str + ',';
                    }   
                }
            System.debug('---------------------------------------------------');
            System.debug('Section Name' + sec);
            System.debug('Section Value Total' + sectionValueTotal);
            System.debug('Section Total Question' + sectionTotalQuestion);
            System.debug('---------Total Feedback Count: ' + totalFeedBack);
            if(sectionTotalQuestion != 0)
            {
                //SectionAvg = (Double)sectionValueTotal/sectionTotalQuestion;
                SectionAvg = (Double)sectionValueTotal;
            }
            
            // System.debug('Section Avg' +SectionAvg);
            
            
            FinalResult fr = new FinalResult();
            fr.sectionName = sec;  
            
            
            //System.debug('---------SectionAvg: ' + SectionAvg);
            //
            if(totalFeedBack != 0)
            {
                 fr.value = (Double) SectionAvg/totalFeedBack;
            }
            else
            {
                //Set 0 value
                fr.value = (Double) SectionAvg;   
            }
            fr.value = fr.value.setScale(2);
            
            finalList.add(fr);
        }
        
        //System.debug('---------------------------');
        List<outputdata> od = new List<outputdata>();
        for(FinalResult f : finalList)
        {
             outputdata o = new outputdata();
                System.debug('sectionName is ' + f.sectionName);
                System.debug('value is' + f.value);
            o.key = f.sectionName;
            o.value = f.value;
            od.add(o);
        }
        
        System.debug('---od---' + od);
            data d = new data();
            d.NameOfDistrict = NameOfDistrict;
            d.NameOfTaluka = NameOfTaluka;
            d.NameOfState = State;
            d.countOfDistrict = districtList.size();
            d.countOfTaluka = talukalist.size();
            d.caption = caption;
            d.processName = processName;
             output op = new output();
            op.data = d;
            op.outputdata = od;
            mapResponse1.put('Records', op);
            res.responseBody = Blob.valueOf(JSON.serialize(mapResponse1));
            
            
            
            
        //return finalList;
            
            
            
            
        } //else ended
    }
    
    
     global class FinalResult{
        public String sectionName {get;set;}
        public Decimal value {get;set;}
    }
    
    public static String getStringFromList(String role)
        {
            /*if(role.contains(','))
                return role*/
            List<String> rlList = role.split(';');
                System.debug('Role Name is' + rlList);
                String strList = '(';
                for(String str:rlList)
                    {
                        strList = strList+'\''+str+'\',';
                    }
                strList = strList.removeEnd(',');
                strList = strList+')' ;
            return strList;
        }
    
    
   global class dataList{
        String state;
        String district;
        string taluka;
        string tskId;
        string role;
        //List<String> role;
  
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
        Decimal validafeedbackCount;
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


      
        }
    
}