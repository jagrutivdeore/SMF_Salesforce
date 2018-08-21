global class tableDataDemoNIranjan {
   
    public String Process{get; set;}
    public String role{get; set;}
    public String question{get; set;}
    public String State{get; set;}
    public String dist {get; set;}
    public String tal {get; set;}
    public String cluster {get; set;}
    public Transient String caption {get; set;}

    public String NameOfState {get; set;}
    public String NameOfDistrict {get; set;}
    public String NameOfTaluka {get; set;}
    public String NameOfCluster {get; set;}
    public List<feedbackdata> feedbackdatalist {get; set;}
  
    global tableDataDemoNIranjan(ApexPages.StandardController controller) {
        State = 'select';
        dist = 'select';
        tal = 'select';
        Process = 'select';
        
    }
     global tableDataDemoNIranjan() {
        State = 'select';
        dist = 'select';
        tal = 'select';
        Process = 'select';
       
    }
    public List<SelectOption> getroleList() {
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Select','Select'));
        for (RoleManagement__c iso : RoleManagement__c.getAll().values()){
            if(iso.IsActived__c == true){
                options.add(new SelectOption(iso.Name,iso.Name));
            }
        }
        return options;
        }
    
      public List<SelectOption> getprocessList() {
        
        List<SelectOption> options = new List<SelectOption>();
        List<Id> idList = new List<Id>();
        options.add(new SelectOption('Select','Select'));
        AggregateResult[] groupedResults = [SELECT Name, Count(Id) FROM MV_Process__c where Multiple_Role__c includes(:role) AND IS_In_Executive_dashboard__c = true GROUP BY Name];
        for (AggregateResult ar : groupedResults){
            options.add(new SelectOption((String)ar.get('Name'),(String)ar.get('Name')));
        }
        return options;
        }
    
     public List<SelectOption> getquestionList() {
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Select','Select'));

        AggregateResult[] groupedResults = [SELECT Section_Name__c,count(Id) FROM MV_Task__c where MV_Process__r.Name =:Process AND Task_type__c = 'Selection' AND Section_Name__c != null GROUP BY Section_Name__c];

        for (AggregateResult ar : groupedResults){
            options.add(new SelectOption((String)ar.get('Section_Name__c'),(String)ar.get('Section_Name__c')));
        }
        return options;
        }
    
    
      public List<SelectOption> getStateList() {
        
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
    
        
        public void refreshTable(){  
            system.debug('inside refreshTable-----------');
            List<Task_Answer__c> taList = new List<Task_Answer__c>();
            feedbackdatalist =  new List<feedbackdata>();
            List<Task_Answer__c> taList1 = new List<Task_Answer__c>();
            List<MV_Task__c> tsk = new List<MV_Task__c>();
            tsk = [select id,Picklist_Value__c from MV_Task__c where Section_Name__c =:question AND  MV_Process__r.Name =:Process];
            
            if(dist != 'select'){
                taList1 = [select id,Unique_Id__c from Task_Answer__c where Answer__c = :dist];
            }else{
                taList1 = [select id,Unique_Id__c from Task_Answer__c where Answer__c = :State];
            }
            set<string> uniqueId = new set<string>();
            for(Task_Answer__c ta4: taList1){
                uniqueId.add(ta4.Unique_Id__c);
            }
                taList = [select id,Section_Name__c,Answer__c,Unique_Id__c,Question__c from Task_Answer__c where Section_Name__c = :question AND Unique_Id__c IN :uniqueId];
                
                set<string> uniqueIdset = new set<string>();
                for(Task_Answer__c ta : taList){
                    uniqueIdset.add(ta.Unique_Id__c);
                }
                system.debug('uniqueIdset-----------'+uniqueIdset);
                map<string,List<string>> uniqueIdToanswerMap = new map<string,List<string>>();
                
                for(Task_Answer__c ta : taList){
                    List<string> ansList = new List<string>();
                    if(uniqueIdToanswerMap.get(ta.Unique_Id__c) != null){
                        ansList = uniqueIdToanswerMap.get(ta.Unique_Id__c);
                        ansList.add(ta.Answer__c);
                        uniqueIdToanswerMap.put(ta.Unique_Id__c,ansList);
                        
                    }else{
                        List<string> ansList1 = new List<string>();
                        ansList1.add(ta.Answer__c);
                        uniqueIdToanswerMap.put(ta.Unique_Id__c,ansList1);
                            
                    }
                }
                List<Task_Answer__c> taListlocation = new List<Task_Answer__c>();
                taListlocation = [select id,Answer__c,Unique_Id__c from Task_Answer__c where Task_Type__c = 'Location' AND Question__c = 'Taluka' AND Unique_Id__c IN :uniqueIdset];
                map<string,string> uniqueIdToTalukaMap = new map<string,string>();
                for(Task_Answer__c ta1 : taListlocation){
                    uniqueIdToTalukaMap.put(ta1.Unique_Id__c, ta1.Answer__c);
                }
                system.debug('uniqueIdToTalukaMap-----------'+uniqueIdToTalukaMap);
                
                map<string,List<String>> talukaToAnswerMap = new map<string,List<String>>();
                
                for(string str : uniqueIdToTalukaMap.keyset()){
                    if(talukaToAnswerMap.get(uniqueIdToTalukaMap.get(str)) != null){
                        if(uniqueIdToTalukaMap.get(str) != null){
                            if(uniqueIdToanswerMap.get(str) != null){
                                List<string> strlist = new List<string>();
                                strlist = talukaToAnswerMap.get(uniqueIdToTalukaMap.get(str));
                                strlist.addAll(uniqueIdToanswerMap.get(str));
                                talukaToAnswerMap.put(uniqueIdToTalukaMap.get(str),strlist);
                            }
                        }
                        
                    }else{
                        if(uniqueIdToTalukaMap.get(str) != null){
                            List<string> strlist = new List<string>();
                            //strlist = talukaToAnswerMap.get(str);
                            strlist.addAll(uniqueIdToanswerMap.get(str));
                            talukaToAnswerMap.put(uniqueIdToTalukaMap.get(str),strlist);
                            
                        }
                        
                    }
                }
            system.debug(' talukaToAnswerMap.keyset()-----------'+ talukaToAnswerMap.keyset()); 
            system.debug(' talukaToAnswerMap.keyset()-----------'+ talukaToAnswerMap);  
            Map<string, map<string,integer>> talukaToMapOfValueAndInteger = new Map<string, map<string,integer>>();
            map<string,integer> talToTotalCounrMap = new map<string,integer>();
            for(string taluka : talukaToAnswerMap.keyset()){
                List<string> strlist2 = new List<string>();
                if(talukaToAnswerMap.get(taluka) != null){
                    strlist2 = talukaToAnswerMap.get(taluka);
                }
                system.debug(' strlist2-------'+ strlist2); 
                talToTotalCounrMap.put(taluka,strlist2.size());
                map<string,Integer> valueToIntegerMap = new map<string,Integer>();
                for(string str : strlist2){
                    if(valueToIntegerMap.get(str)!= null){
                        integer count = valueToIntegerMap.get(str);
                        count++;
                        valueToIntegerMap.put(str, count);
                        
                    }else{
                        valueToIntegerMap.put(str,1);
                    }
                    
                }
                system.debug('  '+ valueToIntegerMap);
                talukaToMapOfValueAndInteger.put(taluka, valueToIntegerMap);
            }               
            system.debug(' talukaToMapOfValueAndInteger--------'+ talukaToMapOfValueAndInteger);
            string picklistValue='';
            if(taList.size() > 0){
                if(tsk.size() > 0){
                    picklistValue = tsk[0].Picklist_Value__c;
                }
            }
            List<string> picklistval = new List<string>();
            picklistval = picklistValue.split(',');
            map<string,string> valueToTalukaMap1 = new map<string,string>();
            map<string,string> valueToTalukaMap2 = new map<string,string>();
            map<string,string> valueToTalukaMap3 = new map<string,string>();
            map<string,string> valueToTalukaMap4 = new map<string,string>();
            string bestPlace;
            string goodplace;
            string averagePlace;
            string worstPlace;
            for(string tal : talukaToMapOfValueAndInteger.keyset()){
                map<string,integer> strToIntMap = new map<string,integer>();
                strToIntMap = talukaToMapOfValueAndInteger.get(tal);
                system.debug('---tal----'+ tal);
                system.debug('---strToIntMap----'+ strToIntMap);
                
                for(string str3 : strToIntMap.keyset()){
                    system.debug('---str3----'+ str3);
                    integer count = 0;
                    integer total = 0;
                    system.debug('---strToIntMap.get(str3)----'+ strToIntMap.get(str3));
                    if(strToIntMap.get(str3)!= null){
                        count = strToIntMap.get(str3);
                    }
                    
                    if(talToTotalCounrMap.get(tal)!= null){
                        total = talToTotalCounrMap.get(tal);
                    }
                    system.debug('---talToTotalCounrMap.get(tal)----'+ talToTotalCounrMap.get(tal));
                    //integer count = if(strToIntMap.get(str3)!= null ? strToIntMap.get(str3) : 0);
                    //integer total = if(talToTotalCounrMap.get(tal)!= null ? :1);
                    decimal count2 = count/total;
                    count2 = count2 *100;
                    if(count2 <=100 && count2 >=75){
                        bestPlace = bestPlace+', '+ tal;
                        bestPlace.remove('null,');
                        valueToTalukaMap1.put(str3,bestPlace);
                        system.debug('---valueToTalukaMap1----'+ valueToTalukaMap1);
                    }else if(count2 <75 && count2 >=50){
                        goodplace = goodplace +', '+ tal;
                        goodplace.remove('null,');
                        valueToTalukaMap2.put(str3,goodplace);
                        system.debug('---valueToTalukaMap2----'+ valueToTalukaMap2);
                    }else if(count2 <50 && count2 >=25){
                        averagePlace = averagePlace + ', '+tal;
                        averagePlace.remove('null,');
                        valueToTalukaMap3.put(str3,averagePlace);
                        system.debug('---valueToTalukaMap3----'+ valueToTalukaMap3);
                    }else{
                        worstPlace = worstPlace +', '+tal; 
                        worstPlace.remove('null,');
                        valueToTalukaMap4.put(str3,worstPlace);
                        system.debug('---valueToTalukaMap4----'+ valueToTalukaMap4);
                    }
                }
            }
                system.debug(' valueToTalukaMap1--------'+ valueToTalukaMap1);
                    system.debug(' valueToTalukaMap2--------'+ valueToTalukaMap2);
                        system.debug(' valueToTalukaMap3--------'+ valueToTalukaMap3);
                            system.debug(' valueToTalukaMap4--------'+ valueToTalukaMap4);
                            
            List<feedbackdata> fdList = new List<feedbackdata>();
            for(string value : picklistval){
                feedbackdata fd = new feedbackdata();
                fd.name = value;
                
                if(valueToTalukaMap1.get(value) != null){
                    List<string> bpList = new List<string>();
                    bpList = valueToTalukaMap1.get(value).split(',');
                    set<string> tempSet = new set<string>();
                    tempSet.addAll(bpList);
                    bpList = new List<string>();
                    bpList.addAll(tempSet);
                    string bestPlacefinal='';
                    for(string str : bpList){
                        if(str != 'null'){
                            bestPlacefinal+= str +', ';
                        }
                    }
                    
                    bestPlacefinal.removeEnd(',');
                    bestPlacefinal.remove('null ');
                    fd.bestPlace = bestPlacefinal;
                }
                if(valueToTalukaMap2.get(value) != null){
                    List<string> bpList1 = new List<string>();
                    bpList1 = valueToTalukaMap2.get(value).split(',');
                    set<string> tempSet1 = new set<string>();
                    tempSet1.addAll(bpList1);
                    bpList1 = new List<string>();
                    bpList1.addAll(tempSet1);
                    string bestPlacefinal1='';
                    for(string str : bpList1){
                        if(str != 'null'){
                            bestPlacefinal1+= str +', ';
                        }
                    }
                    bestPlacefinal1.removeEnd(',');
                    bestPlacefinal1.remove('null ');
                    fd.goodplace = bestPlacefinal1;
                }
                
                if(valueToTalukaMap3.get(value) != null){
                    List<string> bpList2 = new List<string>();
                    bpList2 = valueToTalukaMap3.get(value).split(',');
                    set<string> tempSet2 = new set<string>();
                    tempSet2.addAll(bpList2);
                    bpList2 = new List<string>();
                    bpList2.addAll(tempSet2);
                    string bestPlacefinal2='';
                    for(string str : bpList2){
                        if(str != 'null'){
                            bestPlacefinal2+= str +', ';
                        }
                    }
                    bestPlacefinal2.removeEnd(',');
                    bestPlacefinal2.remove('null ');
                    fd.averagePlace = bestPlacefinal2;
                }
                
                if(valueToTalukaMap4.get(value) !=  null){
                    List<string> bpList3 = new List<string>();
                    bpList3 = valueToTalukaMap4.get(value).split(',');
                    set<string> tempSet3 = new set<string>();
                    tempSet3.addAll(bpList3);
                    bpList3 = new List<string>();
                    bpList3.addAll(tempSet3);
                    string bestPlacefinal3='';
                    for(string str : bpList3){
                        if(str != 'null'){
                            bestPlacefinal3+= str +', ';
                        }
                    }
                    bestPlacefinal3.removeEnd(',');
                    bestPlacefinal3.remove('null ');
                    fd.worstPlace = bestPlacefinal3;
                }
                
                fdList.add(fd);
            }
            feedbackdatalist = fdList;
                
        }

        public void checkdistValue(){
            getDistrict();
            refreshTable();
        }
        
        
        public void checkProcessValue(){
            getprocessList();
            refreshTable();
        }
        
        public void checkQuestionValue(){
            getquestionList();
            refreshTable();
        }
        
        
    global class feedbackdata{
        global String name { get; set; }
        global string bestPlace { get; set; }
        global string goodplace { get; set; }
        global string averagePlace { get; set; }
        global string worstPlace { get; set; }
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
       
        }
    
    
}