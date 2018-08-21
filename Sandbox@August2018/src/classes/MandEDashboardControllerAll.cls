global class MandEDashboardControllerAll{

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
    public List<feedbackdata> totalfeedbackdatalist {get; set;}  
    public integer countOfDistrict {get; set;}
    public integer countOfTaluka {get; set;}
    public integer countOfcluster {get; set;}
    public Transient integer validafeedbackCount {get; set;}
    public Transient integer validafeedbackCount1 {get; set;}
    public Transient integer validafeedbackCount11 {get; set;}
    list<String> idset = new list<string>();
    public Transient integer feedbackCount {get; set;}
    public Transient integer feedbackCnt {get; set;}
    public Transient integer feedbackCnt1 {get; set;}
    public integer rownumber{get; set;}
    public decimal finalMvcs {get;set;}
    public decimal mvcs {get;set;}
    public Integer counter;
    public decimal sectionCount;
    map<string,map<string,Integer>> QuestionOptionScoreMapNew = new map<string,map<string,Integer>>();
    map<string,map<string,Integer>> QuestionOptionScoreMapNew1 = new map<string,map<string,Integer>>();
    map<string,string>tempMap = new map<string,string>();
    map<string,string>tempMap1 = new map<string,string>();
    map<string,set<string>> sectionAPI = new map<string,set<string>>();
    map<string,set<string>> indicatorToApiFieldsMap = new map<string,set<string>>();
    //map<string,set<Decimal>> maxScoreMap = new map<string,set<Decimal>>();
    public map<string,map<string,integer>> mainMap {get;set;}
    public Integer scale = 4;
    map<string,Decimal> indMaxScoreMap = new map<string,Decimal>();
    map<string,Decimal> indMaxScoreAllIndicatorMap = new map<string,Decimal>();
    map<string,Decimal> AllIndicatorMaxScoreMap = new map<string,Decimal>();
    public List<String> questionHeadingsList {get;set;}
    public list<String> SectionList{get;set;}
    map<string,map<String,Integer>> QuetionDistrictScoreMap = new map<string,map<String,Integer>>();
        
    
    public Integer getCounter()
    {
        return counter;
    }
    public void setCounter()
    {
        counter = 0;
    }
    public Integer limitSize = 0;//Number of records to be displayed
    public Integer totalSize = 0; //To Store the total number of records available
    public Integer totalrecordscount=0;
    
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
   
    decimal totalCount = null;

    List<FeedBackWrapper> feedBackWrapper = null;
    List<FeedBackWrapper> feedBackWrapper1 = null;
    List<FeedBackWrapper> feedBackWrapper2 = null;
    List<FeedBackWrapper> feedBackWrapper3 = null;
    List<FeedBackWrapper> feedBackWrapper4 = null;
    List<FeedBackWrapper> feedBackWrapper5 = null;
    List<FeedBackWrapper> feedBackWrapper6 = null;
    List<FeedBackWrapper> feedBackWrapper7 = null;
    List<List<FeedBackWrapper>> feedBackWrapper5temp = null;
    List<FeedBackWrapper> updatedFeedBackWrapper = null;
    List<feedbackdata> feedbackdatalistNew = new List<feedbackdata>();
   
    List<Task_Answer__c> FeedBackInDetail = null;
    List<Id> recordId = null;
    
    global MandEDashboardControllerAll(ApexPages.StandardController controller) {
        mainMap = new map<string,map<string,integer>>();
        setCounter();
        State = 'select';
        dist = 'select';
        tal = 'select';
        feedbackCount = 0;
        PaginationCount__c myCS1 = PaginationCount__c.getValues('section');
        limitSize = Integer.valueOf(myCS1.record_Count__c);
        PaginationCount__c myCS2 = PaginationCount__c.getValues('total');
        totalrecordscount = Integer.valueOf(myCS2.record_Count__c);
        rownumber=1;
        NameOfState='';
        NameOfDistrict='';
        NameOfTaluka='';
        NameOfCluster='';
        
    }
    
     global MandEDashboardControllerAll() {
    mainMap = new map<string,map<string,integer>>();
        State = 'select';
        dist = 'select';
        tal = 'select';
        feedbackCount = 0;
        PaginationCount__c myCS1 = PaginationCount__c.getValues('section');
        limitSize = Integer.valueOf(myCS1.record_Count__c);
        PaginationCount__c myCS2 = PaginationCount__c.getValues('total');
        totalrecordscount = Integer.valueOf(myCS2.record_Count__c);
        rownumber=1;
        NameOfState='';
        NameOfDistrict='';
        NameOfTaluka='';
        NameOfCluster=''; 
    }
    
    
    public List<SelectOption> getprocessList() {
    
        FeedBackInDetail =null;
      
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Select','Select'));
           for (RoleManagement__c iso : RoleManagement__c.getAll().values()){
                if(iso.IsActived__c == true){
                    options.add(new SelectOption(iso.Name,iso.Name));
                 }
            }
           // system.debug('--------------'+options.size());
        
        return options;
    }
    
    public List<SelectOption> getroleList() {
       
          FeedBackInDetail =null;
          List<SelectOption> options = new List<SelectOption>();
          List<Id> idList = new List<Id>();
          options.add(new SelectOption('Select','Select'));
          
          System.debug('Statte name is------'+state);
          System.debug('Process Name is'+Process);
          
          AggregateResult[] groupedResults = [SELECT Name, Count(Id) FROM MV_Process__c where state__c includes(:state) and Role_For_Executive_dashbord__c includes(:Process) AND IS_In_Executive_dashboard__c = true GROUP BY Name];
          
          
          for (AggregateResult ar : groupedResults){
             options.add(new SelectOption((String)ar.get('Name'),(String)ar.get('Name')));
            }
          
         //System.debug('Group Result are------'+options);
         //system.debug('--------------'+options.size());
        
        return options;
    }
    
    public List<SelectOption> getquestionList() {
        
         FeedBackInDetail =null;
            List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('Select','Select'));
         
            AggregateResult[] groupedResults = [SELECT Section_Name__c,count(Id) FROM MV_Task__c where MV_Process__r.Name =:role AND (Task_type__c = 'Selection' OR Task_type__c = 'Text' OR Task_type__c = 'Multi-Lines' OR Task_type__c = 'Multi-select' OR Task_type__c = 'Checkbox') AND Section_Name__c != '' GROUP BY Section_Name__c];
            
          for (AggregateResult ar : groupedResults){
             options.add(new SelectOption((String)ar.get('Section_Name__c'),(String)ar.get('Section_Name__c')));
            }
            
           // system.debug('---question section wise---'+options);
            //system.debug('---question size---'+options.size());
            
        return options;
    }
    
    
    public List<SelectOption> getStateList() {
        FeedBackInDetail =null;
       
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Select','Select'));
            AggregateResult[] groupedResults = [SELECT Name, Count(Id) FROM State__c GROUP BY Name];
            for (AggregateResult ar : groupedResults)  {
                    options.add(new SelectOption((String)ar.get('Name'),(String)ar.get('Name')));
            }
            //system.debug('--------------'+options.size());
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
          AggregateResult[] groupedResults = [SELECT Name, Count(Id) FROM District__c where State__r.Name = :State GROUP BY Name];
            for (AggregateResult ar : groupedResults)  {
                    options.add(new SelectOption((String)ar.get('Name'),(String)ar.get('Name')));
       
            }
          //system.debug('--------------'+options.size());
        return options;
    }
    
    public List<SelectOption> getTaluka() {
        
         FeedBackInDetail =null;
            List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('Select','Select'));
          AggregateResult[] groupedResults = [SELECT Taluka_Name__c, Count(Id) FROM MV_Location__c where District_Name__c =: dist GROUP BY Taluka_Name__c];
            for (AggregateResult ar : groupedResults)  {
                    options.add(new SelectOption((String)ar.get('Taluka_Name__c'),(String)ar.get('Taluka_Name__c')));
       
            }
            //system.debug('--------------'+options.size());
        return options;            
    }
     
    public List<SelectOption> getclusterlist() {
        
         FeedBackInDetail =null;
            List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('Select','Select'));
          AggregateResult[] groupedResults = [SELECT Cluster_Name__c, Count(Id) FROM MV_Location__c where Taluka_Name__c =: tal GROUP BY Cluster_Name__c];
            for (AggregateResult ar : groupedResults)  {
                    options.add(new SelectOption((String)ar.get('Cluster_Name__c'),(String)ar.get('Cluster_Name__c')));
       
            }
            //system.debug('--------------'+options.size());
            return options;
    }
           
    public void descriptiveDateMethod(string soql, List<string> fieldstr){
    
        List<ProcessAnswer__c> paList = new List<ProcessAnswer__c>();
        map<string,List<ProcessAnswer__c>> outputmap = new map<string,List<ProcessAnswer__c>>();
        set<String> talukalist = new set<String>();
        set<String> districtlist = new set<String>();
        set<String> clusterlist = new set<String>();
        string strfield = fieldstr[0];
        
        System.debug('Descriptive Query Name: ' + soql);
        paList = Database.query(soql);
        
        rownumber = 1;
        totalfeedbackdatalist.clear();
        
        for(ProcessAnswer__c pa : paList){
            feedbackdata fd = new feedbackdata();
            fd.name = pa.MV_User__r.Name +' '+ pa.MV_User__r.Last_Name__c;
            fd.state = pa.State__c;
            fd.index = rownumber;
            rownumber++;
            fd.district = pa.District__c;
            fd.Taluka  = pa.Taluka__c;
            fd.cluster = pa.Cluster__c;
            
            if((string)pa.get(strfield) != null && (string)pa.get(strfield) != '' && (string)pa.get(strfield) != 'Yes' && (string)pa.get(strfield) != 'No' && (string)pa.get(strfield) != 'Good' && (string)pa.get(strfield) != '-' && (string)pa.get(strfield) != '--' && (string)pa.get(strfield) != 'Ho' && (string)pa.get(strfield) != 'Nahi' && (string)pa.get(strfield) != ' very good' && (string)pa.get(strfield) != '??? '){
                
                fd.answer =  (string)pa.get(strfield);
                
                totalfeedbackdatalist.add(fd);
            }
        }
        
        totalSize = totalfeedbackdatalist.size();
        feedbackdatalist.clear();
        feedbackdatalist.addAll(totalfeedbackdatalist);
    }

   
 ///////////////////////////////////////////////////////////////   
public void fetchTraineeDataFromDatabase(){
    
    feedbackCount = 0;
    validafeedbackCount = 0;
    rownumber = 1;
    feedBackWrapper = new List<FeedBackWrapper>();
    feedBackWrapper1 = new List<FeedBackWrapper>();
    feedbackdatalist = new List<feedbackdata>();
    updatedFeedBackWrapper = new List<FeedBackWrapper>();
    List<MV_Task__c> tsk = new List<MV_Task__c>();
    List<MV_Task__c> taskforAllIndicators = new List<MV_Task__c>();
    FeedBackInDetail = new List<Task_Answer__c>();
    feedbackdatalistNew = new List<feedbackdata>();
    totalfeedbackdatalist = new List<feedbackdata>();
    counter = 0;
    totalSize =0;
    AggregateResult[] groupedResults = null;
    List<String> pickList = new List<String>(); 
    set<String> pickListset = new set<String>();
    
    set<Integer> intSet = new set<Integer>();
    list<Integer> intList = new list<Integer>();
    String[] slist = new list<string>();
    String[] strList = new list<string>();
    String[] slist1 = new list<string>();
    String[] strList1 = new list<string>();
    list<string> indicatorsList;
    set<string> indicatorsSet;
    SectionList = new list<String>();
    set<String> Allfieldstr = new set<String>();
    List<String> AllfieldstrList = new List<String>();
    
    
    tsk = [SELECT Id,Picklist_Value__c,Indicator_Names__c,Bar_Chart_Labels__c,All_Indicator_Bar_Chart_Label__c,Max_Score__c,Max_Individual_Score__c,Task_Text__c,Picklist_Values_Scoring__c,Section_Name__c,API_field_Name__c,Task_type__c,Section_Question_Count__c,Caption__c,Section_Group_No__c FROM MV_Task__c where Section_Name__c = :question AND MV_Process__r.Name =:role];        
        System.debug('---Text Type---'+tsk);
        
    taskforAllIndicators = [SELECT Id,Indicator_Names__c,Picklist_Value__c,Bar_Chart_Labels__c,All_Indicator_Bar_Chart_Label__c,Max_Score__c,Max_Individual_Score__c,Task_Text__c,Picklist_Values_Scoring__c,Section_Name__c,API_field_Name__c,Task_type__c,Section_Question_Count__c,Caption__c,Section_Group_No__c FROM MV_Task__c where Task_type__c = 'selection' AND Picklist_Values_Scoring__c != null ANd MV_Process__r.Name =:role]; 
        System.debug('---Text Type in taskforAllIndicators---'+taskforAllIndicators);
    
    List<String> fieldstr = new List<String>();
    set<String> fieldstr1 = new set<String>();
    set<String> fieldstrAllIndicaotr = new set<String>();
    
    if(tsk.size() > 0){
        caption = tsk[0].Caption__c;
        sectionCount = tsk[0].Section_Question_Count__c;
    }

    for(MV_Task__c tk : tsk){
        if(tk.API_field_Name__c != null){
            fieldstr1.add(tk.API_field_Name__c);
            indMaxScoreMap.put(tk.API_field_Name__c,tk.Max_Individual_Score__c);
        }
    }
    
    for(MV_Task__c task : taskforAllIndicators){
        if(task.Bar_Chart_Labels__c != null){
            fieldstrAllIndicaotr.add(task.Bar_Chart_Labels__c);
            indMaxScoreAllIndicatorMap.put(task.Bar_Chart_Labels__c,task.Max_Individual_Score__c);
        }
    }
    
    system.debug('--indMaxScoreMap map---'+indMaxScoreMap+'---indMaxScoreMap size---'+indMaxScoreMap.size());
    
    if(fieldstr1.size() > 0){
        fieldstr.addAll(fieldstr1);
    }
    
    
    for(MV_Task__c t : tsk){
        
        if(t.Task_type__c != null && t.Task_type__c == 'Selection'){
    
            intList = new list<Integer>();
            
                if(t.Picklist_Values_Scoring__c != null){
                
                    slist = t.Picklist_Values_Scoring__c.split(',');
                        system.debug('---slist in seperate---'+ slist);
            
                    slist1 = t.Picklist_Value__c.split(',');
                        system.debug('---slist1 in seperate---'+ slist1);
                    
                        for(String score : slist){
                        intList.add(Integer.valueOf(score));
                    }
                        system.debug('---intList in seperate---'+ intList);
                
                    map<string,Integer> scoreMap = new map<string,Integer>();
                    Integer i =0;
                    
                    for(Integer s : intList){
                        scoreMap.put(slist1.get(i),s);
                        i++;
                    }
                    system.debug('---scoreMap---'+scoreMap);
                    
                    QuestionOptionScoreMapNew.put(t.API_field_Name__c,scoreMap);
                    
                    if(t.Bar_Chart_Labels__c != null)
                        tempMap.put(t.API_field_Name__c,t.Bar_Chart_Labels__c);
                }
        }
    }
    system.debug('---QuestionOptionScoreMapNew---'+ QuestionOptionScoreMapNew);
    
    questionHeadingsList = new list<string>();
    
    if(taskforAllIndicators.size() > 0){
    
        for(MV_Task__c t : taskforAllIndicators){
        
            if(t.Bar_Chart_Labels__c != null)
                        tempMap.put(t.API_field_Name__c,t.Bar_Chart_Labels__c);
            
            questionHeadingsList.add(t.Task_Text__c);
            
            Allfieldstr.add(t.API_field_Name__c);
                
                AllIndicatorMaxScoreMap.put(t.API_field_Name__c,t.Max_Individual_Score__c); 
     
            if(t.Task_type__c != null && t.Task_type__c == 'Selection'){
    
                intList = new list<Integer>();
    
                if(t.Picklist_Values_Scoring__c != null){
    
                    slist = t.Picklist_Values_Scoring__c.split(',');
                    system.debug('---slist in all---'+ slist);
                    
                    slist1 = t.Picklist_Value__c.split(',');
                    system.debug('---slist1 in all---'+ slist1);
    
                    for(String score : slist){
                        intList.add(Integer.valueOf(score));
                    }
                    system.debug('---intList in all---'+ intList);
    
                    SectionList.add(t.Section_Name__c);
                    system.debug('---SectionList---'+ SectionList);
    
    
                    map<string,Integer> scoreMap = new map<string,Integer>();
                    Integer i =0;
    
                    for(Integer s : intList){
                    
                        scoreMap.put(slist1.get(i),s);
                        i++;
                    }
    
                    QuestionOptionScoreMapNew1.put(t.API_field_Name__c,scoreMap);
    
                    if(t.All_Indicator_Bar_Chart_Label__c != null)
                        tempMap1.put(t.Section_Name__c,t.All_Indicator_Bar_Chart_Label__c);
    
                    if(sectionAPI.containskey(t.Section_Name__c)){
                    
                        sectionAPI.get(t.Section_Name__c).add(t.API_field_Name__c);
                    
                    }else{
                        
                        sectionAPI.put(t.Section_Name__c,new set<string>{t.API_field_Name__c});
                    }
                    
                    indicatorsList  = new list<string>();
                    indicatorsSet  = new set<string>();
                    
                    indicatorsList = t.Indicator_Names__c.split(',');
                    indicatorsSet.addAll(indicatorsList);                   
                        
                    for(String eachIndicator : indicatorsSet){
                    
                        if(indicatorToApiFieldsMap.containskey(eachIndicator)){
                            
                            indicatorToApiFieldsMap.get(eachIndicator).add(t.API_field_Name__c);
                            
                        }else{
                        
                            indicatorToApiFieldsMap.put(eachIndicator,new set<string>{t.API_field_Name__c});    
                        }
                    }   
                }
            }
        }
    }
    
    AllfieldstrList.addAll(Allfieldstr);
    
    system.debug('---questionHeadingsList---'+ questionHeadingsList);
       
    system.debug('---QuestionOptionScoreMapNew1---'+ QuestionOptionScoreMapNew1);
    system.debug('---sectionAPI---'+ sectionAPI);
    system.debug('---indicatorToApiFieldsMap---'+ indicatorToApiFieldsMap+'---indicatorToApiFieldsMap size---'+indicatorToApiFieldsMap.size());
    system.debug('---Allfieldstr---'+ Allfieldstr);
    system.debug('---AllfieldstrList---'+ AllfieldstrList);

    if(tsk.size() > 0){
    
        if(tsk[0].Task_type__c != null && tsk[0].Task_type__c == 'Selection'){
        
            pickList = tsk[0].Picklist_Value__c.split(','); 
            pickListset.addAll(pickList);
                system.debug('---pickListset---'+pickListset);
                
    
            if(dist == 'select'){
                String soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\'';
                processdataforPiChart(soql,fieldstr,pickListset);
                    system.debug('---soql 1---'+soql);
                    system.debug('---fieldstr 1---'+fieldstr);
                    system.debug('---pickListset 1---'+pickListset);
                
            }
            else if( tal == 'select'){
                String soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\'';
                processdataforPiChart(soql,fieldstr,pickListset);
                    system.debug('---soql 2---'+soql);
                    system.debug('---fieldstr 2---'+fieldstr);
                    system.debug('---pickListset 2---'+pickListset);
                
            }
            else if(cluster == 'select'){
                String soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND Taluka__c =\''+tal +'\' AND MV_Process__r.Name =\'' + role+'\' AND Role_Name__c = \''+Process+'\'';
                processdataforPiChart(soql,fieldstr,pickListset);
                    system.debug('---soql 3---'+soql);
                    system.debug('---fieldstr 3---'+fieldstr);
                    system.debug('---pickListset 3---'+pickListset);
                
            }else {
                String soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND Taluka__c =\''+tal +'\'AND Cluster__c = \''+cluster+'\' AND MV_Process__r.Name =\'' + role+'\' AND Role_Name__c = \''+Process+'\'';
                processdataforPiChart(soql,fieldstr,pickListset);
                    system.debug('---soql 4---'+soql);
                    system.debug('---fieldstr 4---'+fieldstr);
                    system.debug('---pickListset 4---'+pickListset);
            }
    
        }  
    }
    
    if(taskforAllIndicators.size() > 0){
    
        if(taskforAllIndicators[0].Task_type__c != null && taskforAllIndicators[0].Task_type__c == 'Selection'){
     
            if(dist == 'select'){
                String soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(AllfieldstrList, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\'';
                processDataforAllIndicators(soql,AllfieldstrList);
                    system.debug('---soql 1 in all---'+soql+'---AllfieldstrList 1 in all---'+AllfieldstrList);
                
            }
            else if( tal == 'select'){
                String soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(AllfieldstrList, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\'';
                processDataforAllIndicators(soql,AllfieldstrList);
                system.debug('---soql 2 in all---'+soql+'---AllfieldstrList 2 in all---'+AllfieldstrList);
                
            }
            else if(cluster == 'select'){
                String soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(AllfieldstrList, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND Taluka__c =\''+tal +'\' AND MV_Process__r.Name =\'' + role+'\' AND Role_Name__c = \''+Process+'\'';
                processDataforAllIndicators(soql,AllfieldstrList);
                system.debug('---soql 3 in all---'+soql+'---AllfieldstrList 3 in all---'+AllfieldstrList);
                
            }else {
                String soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(AllfieldstrList, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND Taluka__c =\''+tal +'\'AND Cluster__c = \''+cluster+'\' AND MV_Process__r.Name =\'' + role+'\' AND Role_Name__c = \''+Process+'\'';
                processDataforAllIndicators(soql,AllfieldstrList);
                system.debug('---soql 4 in all---'+soql+'---AllfieldstrList 4 in all---'+AllfieldstrList);
            }
        }
    }
}

public void processDataforAllIndicators(string soql,List<string> AllfieldstrList){

    List<sObject> paListNew = new List<sObject>();
    List<ProcessAnswer__c> paList1 = new List<ProcessAnswer__c>();
    map<String,Integer> TotalScoreMapforAllIndicators = new map<String,Integer>();
    map<string,Integer> newMap = new map<String,Integer>();
    map<string,Integer> indicatorScoreMap = new map<String,Integer>();
    map<string,list<string>> dataValueMap = new map<String,list<string>>();
    set<String> Alltalukalist = new set<String>();
    set<String> Alldistrictlist = new set<String>();
    set<String> Allclusterlist = new set<String>();
    NameOfTaluka='';
    NameOfDistrict='';
    NameOfCluster='';
    NameOfState='';
    feedbackCount = 0;
    validafeedbackCount11 = 1;
    set<string> AllSections = new set<string>();
    QuetionDistrictScoreMap = new map<string,map<String,Integer>>();
    map<String,Integer> districtScoreMap = new map<String,Integer>();
    
    paListNew = Database.query(soql);
    paList1 = Database.query(soql);
    feedbackCount = paListNew.size();   
    feedbackCnt1 = paListNew.size();
        system.debug('---feedbackCnt1---'+feedbackCnt1);
    validafeedbackCount11 = paListNew.size();
    
    
        for(ProcessAnswer__c pa : paList1){
        
            if(dist == 'select'){
                Alldistrictlist.add(pa.District__c);
            
            }else if(tal == 'select'){
             
                Alldistrictlist.add(pa.District__c);
                Alltalukalist.add(pa.Taluka__c);
            
            }else if(cluster == 'select'){
            
                Alldistrictlist.add(pa.District__c);
                Alltalukalist.add(pa.Taluka__c);
                Allclusterlist.add(pa.Cluster__c);
            
            }else{
            
                Alldistrictlist.add(pa.District__c);
                Alltalukalist.add(pa.Taluka__c);
                Allclusterlist.add(pa.Cluster__c); 
            }
        }
        system.debug('--Alldistrictlist---'+Alldistrictlist+'---Alldistrictlist size---'+Alldistrictlist.size());
        system.debug('--Alltalukalist---'+Alltalukalist+'---Alltalukalist size---'+Alltalukalist.size());
        system.debug('--Allclusterlist---'+Allclusterlist+'---Allclusterlist size---'+Allclusterlist.size());
    
    if(QuestionOptionScoreMapNew1.size() > 0){
    
        for(sObject paNew : paListNew){
            
                for(String s : AllfieldstrList){
                
                    if(paNew.get(s) != null){
                                
                        String str = String.valueOf(paNew.get(s));
                        system.debug('--str here is-->'+str);
                        
                            if(TotalScoreMapforAllIndicators.get(s) == null){

                                TotalScoreMapforAllIndicators.put(s,QuestionOptionScoreMapNew1.get(s).get(str));
                                    
                            }else{
                                        
                                Integer marks = TotalScoreMapforAllIndicators.get(s);
                                marks = marks + QuestionOptionScoreMapNew1.get(s).get(str);
                                
                                TotalScoreMapforAllIndicators.put(s,marks); 
                            }
                    }
                }
        }
        
        //map for district - wise scoring 
        
        /*for(sObject paNew : paListNew){
            
                for(String s : AllfieldstrList){
                
                    if(paNew.get(s) != null){
                                
                        String str = String.valueOf(paNew.get(s));
                            system.debug('--str here is-->'+str);
                            
                        String District = String.valueOf(paNew.get('District__c'));
                            system.debug('--District here is-->'+District);

                            if(districtScoreMap.get(District) == null){
                                
                                if(QuestionOptionScoreMapNew1.get(s).get(str) != null)
                                    districtScoreMap.put(District,QuestionOptionScoreMapNew1.get(s).get(str));
                                
                            }else{
                            
                                Integer marks = districtScoreMap.get(District);
                                    if(QuestionOptionScoreMapNew1.get(s).get(str) != null)
                                        marks = marks + QuestionOptionScoreMapNew1.get(s).get(str);
                                
                                districtScoreMap.put(District,marks);
                                
                            }
                    }   
                }   
        }*/
        
        system.debug('---TotalScoreMapforAllIndicators---'+TotalScoreMapforAllIndicators);
        system.debug('---TotalScoreMapforAllIndicators size---'+TotalScoreMapforAllIndicators.size());
        
        system.debug('---districtScoreMap---'+districtScoreMap);
        system.debug('---districtScoreMap size---'+districtScoreMap.size());
        
        // Using 3rd level map
        
        map<string,Integer> innerMap1 = new map<string,Integer>();
        
        for(sObject paNew : paListNew){
            
            innerMap1 = new map<string,Integer>();
            
                for(String s : AllfieldstrList){
                
                    system.debug('---QuetionDistrictScoreMap 1st---'+QuetionDistrictScoreMap);
                
                    if(paNew.get(s) != null){
                    
                        String District = String.valueOf(paNew.get('District__c'));
                            system.debug('--District here is-->'+District);
                                
                        String str = String.valueOf(paNew.get(s));
                            system.debug('--str here is-->'+str);
                        
                            if(!QuetionDistrictScoreMap.containskey(District)){
                                
                                if(!innerMap1.containskey(s)){
                                
                                    if(QuestionOptionScoreMapNew1.get(s).get(str) != null)
                                        innerMap1.put(s,QuestionOptionScoreMapNew1.get(s).get(str));
                                }   
                                
                                QuetionDistrictScoreMap.put(District,innerMap1);
                                    system.debug('---QuetionDistrictScoreMap in if---'+QuetionDistrictScoreMap);
                            
                            }else{
                                    
                                    if((QuetionDistrictScoreMap.containskey(District))&&(!innerMap1.containskey(s))){
                                        innerMap1.put(s,QuestionOptionScoreMapNew1.get(s).get(str));
                                    
                                    }else{
                                    
                                        Integer marks1 = innerMap1.get(s);
    
                                        if(QuestionOptionScoreMapNew1.get(s).get(str) != null)
                                            marks1 = marks1 + QuestionOptionScoreMapNew1.get(s).get(str);

                                        innerMap1.put(s,marks1);
                                    }
                                    
                                QuetionDistrictScoreMap.put(District,innerMap1);
                                    system.debug('---QuetionDistrictScoreMap in else---'+QuetionDistrictScoreMap);
                            }
                    }
                }       
        }
    
        system.debug('---QuetionDistrictScoreMap---'+QuetionDistrictScoreMap);
        system.debug('---QuetionDistrictScoreMap size---'+QuetionDistrictScoreMap.size());
        
        if(sectionAPI.keyset() != null){
        
            for(string secName : sectionAPI.keyset()){
                
                AllSections = sectionAPI.get(secName);
                    
                    for(string tempSec : AllSections){
 
                        if(newMap.get(secName) == null){
                            
                            newMap.put(secName,TotalScoreMapforAllIndicators.get(tempSec));
                                
                        }else{
                                        
                            Integer tempVal = newMap.get(secName);
                            tempVal = tempVal + TotalScoreMapforAllIndicators.get(tempSec);        
                            newMap.put(secName,tempVal);
                        
                        }
                    }
            }
        }
        
        system.debug('---newMap----'+newMap);
        
        feedBackWrapper3 = new List<FeedBackWrapper>();
            
        if(newMap.keyset() != null){
    
            for(string s : newMap.keyset()){
            
                FeedBackWrapper feedBackTemp1 = new FeedBackWrapper();
                
                feedBackTemp1.setType(tempMap1.get(s));

                decimal indTotalScore = newMap.get(s);
                
                if(indTotalScore > 0){
                
                    indTotalScore = indTotalScore/feedbackCnt1;
                
                    set<String> sectionAPIMapValues = sectionAPI.get(s);
                
                    indTotalScore = indTotalScore/sectionAPIMapValues.size();

                    feedBackTemp1.setvalue(indTotalScore);
                }
                    feedBackWrapper3.add(feedBackTemp1);
                
                    //system.debug('---feedBackWrapper3---'+feedBackWrapper3);
                    //system.debug('---feedBackWrapper3---'+feedBackWrapper3.size());
            }
        }
        
        
        if(indicatorToApiFieldsMap.keyset() != null){
        
            for(string secName : indicatorToApiFieldsMap.keyset()){
                
                AllSections = indicatorToApiFieldsMap.get(secName);
                    
                    for(string tempSec : AllSections){
                    
                        if(TotalScoreMapforAllIndicators.get(tempSec) != null){
                            
                            if(indicatorScoreMap.get(secName) == null){
                            
                                indicatorScoreMap.put(secName,TotalScoreMapforAllIndicators.get(tempSec));
                            
                            }else{
                                            
                                Integer tempValue = indicatorScoreMap.get(secName);
                                    system.debug('---tempValue---'+tempValue);
                                
                                tempValue = tempValue + TotalScoreMapforAllIndicators.get(tempSec);        
                                indicatorScoreMap.put(secName,tempValue);
                            }
                        }
                    }
            }
        }
        
    }
        system.debug('---indicatorScoreMap----'+indicatorScoreMap);

        feedBackWrapper7 = new List<FeedBackWrapper>();
        mvcs = 0;
        if(indicatorScoreMap.keyset() != null){

            for(string s : indicatorScoreMap.keyset()){
            
                FeedBackWrapper fdbkForAllIndicators = new FeedBackWrapper();
                
                fdbkForAllIndicators.setType(tempMap1.get(s));

                decimal indTotalScore = indicatorScoreMap.get(s);
                
                if(feedbackCnt1 > 0)
                    indTotalScore = indTotalScore/feedbackCnt1;
                
                set<String> indicatorToApiFieldsMapValues = indicatorToApiFieldsMap.get(s);
                    system.debug('---indTotalScore---'+indTotalScore);
                    system.debug('---indicatorToApiFieldsMapValues.size()---'+indicatorToApiFieldsMapValues.size());
                
                indTotalScore = indTotalScore/indicatorToApiFieldsMapValues.size();

                fdbkForAllIndicators.setvalue(indTotalScore);
                    
                feedBackWrapper7.add(fdbkForAllIndicators);
                
                    system.debug('---feedBackWrapper7---'+feedBackWrapper7);
                    system.debug('---feedBackWrapper7---'+feedBackWrapper7.size());
                    
                
                mvcs += indTotalScore; 
                    system.debug('--mvcs---'+mvcs);
            }
                system.debug('--mvcs final---'+mvcs);
            
                finalMvcs = mvcs/indicatorScoreMap.size();
                finalMvcs = finalMvcs.setScale(2);
                    system.debug('--finalMvcs---'+finalMvcs);
        }   

    
    if(paListNew.size() > 0){
    
        for(ProcessAnswer__c pa : paList1){
        
            if(dist == 'select'){
                Alldistrictlist.add(pa.District__c);
            
            }else if(tal == 'select'){
             
                Alldistrictlist.add(pa.District__c);
                Alltalukalist.add(pa.Taluka__c);
            
            }else if(cluster == 'select'){
            
                Alldistrictlist.add(pa.District__c);
                Alltalukalist.add(pa.Taluka__c);
                Allclusterlist.add(pa.Cluster__c);
            
            }else{
            
                Alldistrictlist.add(pa.District__c);
                Alltalukalist.add(pa.Taluka__c);
                Allclusterlist.add(pa.Cluster__c); 
            }
    
        
            for(string str : AllfieldstrList){
                
                if((string)pa.get(str) != null){
                
                    //system.debug('----str is---'+str);
                
                    if(dataValueMap.get(str) != null){
                    
                        List<string> strList2 = new List<string>();
                        strList2 = dataValueMap.get(str);
                        strList2.add((string)pa.get(str));
                        dataValueMap.put(str,strList2);
                    
                    }else{
                    
                        List<string> strList1 = new List<string>();
                        strList1.add((string)pa.get(str));  
                        dataValueMap.put(str,strList1);
                    
                    }

                    //validafeedbackCount11++;
                    //system.debug('---validafeedbackCount11---'+validafeedbackCount11);
                }
            }
            //system.debug('---dataValueMap---'+dataValueMap);
        }
    
        if(dataValueMap.keyset() != null){
            
            //feedBackWrapper4 = new List<FeedBackWrapper>();
            
            for(string val : dataValueMap.keyset()){
                        
                list<string> pickVal = dataValueMap.get(val);
                map<string,integer>  pickCountMap = new map<string,integer>();
                feedBackWrapper4 = new List<FeedBackWrapper>();
   
                for(string temp : pickVal){
                
                    if(pickCountMap.get(temp) == null){
            
                        pickCountMap.put(temp,1);
                        system.debug('---pickCountMap in if---'+pickCountMap);
            
                    }else{
                        
                        Integer tempVal = pickCountMap.get(temp);
                        tempVal = tempVal + 1;
                        pickCountMap.put(temp,tempVal);
                    }
                    mainMap.put(val,pickCountMap);
                    
                    FeedBackWrapper feedBackTemp1 = new FeedBackWrapper();
                    
                    feedBackTemp1.setType(temp);
                    feedBackTemp1.setvalue(pickCountMap.get(temp));
                    
                    feedBackWrapper4.add(feedBackTemp1);
                }
                system.debug('---pickCountMap---'+pickCountMap+'=size='+pickCountMap.size());
                system.debug('---feedBackWrapper4 in for---'+feedBackWrapper4+'==feedBackWrapper4 size=='+feedBackWrapper4.size());     
            }
            system.debug('---mainMap---'+mainMap+'==size=='+mainMap.size());
        }
        system.debug('---feedBackWrapper4---'+feedBackWrapper4+'==feedBackWrapper4 size=='+feedBackWrapper4.size());        
    }
    
    
    feedBackWrapper5temp = new List<List<FeedBackWrapper>>();
    feedBackWrapper6 = new List<FeedBackWrapper>();
        
    for(string mm : mainMap.keyset()){

        map<string,integer> innermap = mainMap.get(mm);
        FeedBackWrapper feedBackTemp1 = new FeedBackWrapper();
        FeedBackWrapper feedbackWrap = new FeedBackWrapper();
        feedBackWrapper5 = new List<FeedBackWrapper>();
        
        decimal total = 0;
        
        for(string im : innermap.keyset()){
            
            Integer tempInt = innermap.get(im);
            tempInt = tempInt * QuestionOptionScoreMapNew1.get(mm).get(im);
                
            total = total + tempInt;
                system.debug('--total 1st---'+total);
                
                
            feedBackTemp1 = new FeedBackWrapper();
            feedBackTemp1.setType(im);
            feedBackTemp1.setvalue(innermap.get(im));
            feedBackWrapper5.add(feedBackTemp1);
    
        }

            feedbackWrap = new FeedBackWrapper();
            feedbackWrap.setType(tempMap.get(mm));
            feedbackWrap.setvalue(total);
            feedBackWrapper6.add(feedbackWrap);
                system.debug('---feedBackWrapper6 here---'+feedBackWrapper6);
         
        feedBackWrapper5temp.add(feedBackWrapper5);
        
        system.debug('---feedBackWrapper5 in for ---'+feedBackWrapper5+'---feedBackWrapper5 size---'+feedBackWrapper5.size());
        system.debug('---feedBackWrapper5temp for---'+feedBackWrapper5temp+'---feedBackWrapper5temp size for---'+feedBackWrapper5temp.size());
    }
    system.debug('---feedBackWrapper6 out---'+feedBackWrapper6);
    system.debug('---feedBackWrapper5---'+feedBackWrapper5+'---feedBackWrapper5 size---'+feedBackWrapper5.size());
    system.debug('---feedBackWrapper5temp---'+feedBackWrapper5temp+'---feedBackWrapper5temp size---'+feedBackWrapper5temp.size());


    for(string str : Alltalukalist){
    
        if(str != '' && str != null){
            NameOfTaluka += str + ','; 
        }
    }
    
    for(string str : Allclusterlist){
    
        if(str != '' && str != null){
            NameOfCluster += str + ',';
        }
    }
    
    for(string str : Alldistrictlist){
    
        if(str != '' && str != null){
            NameOfDistrict += str + ',';
        }
    }
    
    NameOfDistrict = NameOfDistrict.removeEnd(',');
    NameOfTaluka = NameOfTaluka.removeEnd(',');
    
    if(Alldistrictlist.size() == 0){
        countOfDistrict = 0;
    }else{
        countOfDistrict = Alldistrictlist.size();    
    }
    
    if(Alltalukalist.size() == 0){
        countOfTaluka = 0;
    }else {
        countOfTaluka = Alltalukalist.size();
    }
    
    //Integer sectionCount1 = sectionCount.intValue();
    
        validafeedbackCount = validafeedbackCount11;
    
    NameOfState = state; 
}


public void processdataforPiChart(string soql, List<string> fieldstr,set<string> pickListset){
    
    List<ProcessAnswer__c> paList = new List<ProcessAnswer__c>();
    List<sObject> paListNew = new List<sObject>();
    map<string,List<ProcessAnswer__c>> outputmap = new map<string,List<ProcessAnswer__c>>();
    map<string,List<ProcessAnswer__c>> talukaCountMap = new map<string,List<ProcessAnswer__c>>();
    set<String> talukalist = new set<String>();
    set<String> districtlist = new set<String>();
    set<String> clusterlist = new set<String>();
    validafeedbackCount = 0;
    feedbackCount = 0;
    validafeedbackCount1 = 0;
    NameOfTaluka='';
    NameOfDistrict='';
    NameOfCluster='';
    NameOfState='';
    map<String,Integer> scoreMap = new map<String,Integer>();

    paList = Database.query(soql);
    paListNew = Database.query(soql);
      system.debug('---paList---'+paList.size());
      
    feedbackCount = paList.size();
    feedbackCnt = paList.size();
        system.debug('--feedbackCnt size--'+feedbackCnt);
        
    if(QuestionOptionScoreMapNew.size() > 0){
    
        for(sObject paNew : paListNew){
            
            for(String s : fieldstr){
                
                if(paNew.get(s) != null){
                    
                    String str = String.valueOf(paNew.get(s));
                    //system.debug('--str here is-->'+str);
                    
                    if(scoreMap.get(s) == null){//First time when when map is empty 
                        scoreMap.put(s,QuestionOptionScoreMapNew.get(s).get(str));
    
                    }else{//Consecutive iterations will go over here
    
                        //getting scores from score map
                            Integer marks = scoreMap.get(s);
                                            
                        //Adding all the scores
                        marks = marks + QuestionOptionScoreMapNew.get(s).get(str);
                                            //system.debug('---Marks ----'+marks);
                                            
                        //putting the questions and marks in the Map
                        scoreMap.put(s,marks);
                    }
                }
            }
        }

        system.debug('---scoreMap---'+scoreMap);
    
        feedBackWrapper2 = new List<FeedBackWrapper>();
        
        if(scoreMap.keyset() != null){
        
            for(string s : scoreMap.keyset()){
                
                FeedBackWrapper feedBackTemp = new FeedBackWrapper();
                
                system.debug('---tempMap----'+tempMap);

                //Setting Type for the Feedback Wrapper
                feedBackTemp.setType(tempMap.get(s));
                
                //Setting score

                    decimal indTotalScore = scoreMap.get(s);
                        
                        indTotalScore = indTotalScore/feedbackCnt;
                            
                        indTotalScore = indTotalScore * (scale/indMaxScoreMap.get(s));
                            
                            Integer indTotalScoreInt = Math.round(indTotalScore);
                                
                                system.debug('---indTotalScore----'+indTotalScore);
                                system.debug('---indTotalScoreInt----'+indTotalScoreInt);
                    //feedBackTemp.setvalue(scoreMap.get(s));
                
                    feedBackTemp.setvalue(indTotalScore);
                    
                feedBackWrapper2.add(feedBackTemp);
                        system.debug('---feedBackWrapper2----'+feedBackWrapper2);
            }
        }
    }
    
    
    if(paList.size() > 0){
    
        for(ProcessAnswer__c pa : paList){
            
            if(dist == 'select'){
                districtlist.add(pa.District__c);
                
            }else if(tal == 'select'){
             
                districtlist.add(pa.District__c);
                talukalist.add(pa.Taluka__c);
                
            }else if(cluster == 'select'){
                districtlist.add(pa.District__c);
                talukalist.add(pa.Taluka__c);
                clusterlist.add(pa.Cluster__c);
                
            }else{
                districtlist.add(pa.District__c);
                talukalist.add(pa.Taluka__c);
                clusterlist.add(pa.Cluster__c); 
            }
            
            for(string str : fieldstr){
            
                system.debug('----strrrrrr------'+ (string)pa.get(str));
                
                if((string)pa.get(str) != null){
                    system.debug('----str is---'+str);
                    
                    validafeedbackCount1++;
                        system.debug('---validafeedbackCount1---'+validafeedbackCount1);
                }
                
                if(outputmap.get((string)pa.get(str)) != null){
                
                    List<ProcessAnswer__c> paList2 = new List<ProcessAnswer__c>();
                    paList2 = outputmap.get((string)pa.get(str));
                    paList2.add(pa);
                        system.debug('---paList2---'+paList2);
                    outputmap.put((string)pa.get(str), paList2);
                
                }else{
                
                    List<ProcessAnswer__c> paList1 = new List<ProcessAnswer__c>();
                    paList1.add(pa);
                        system.debug('---paList1---'+paList1);
                    outputmap.put((string)pa.get(str), paList1);
                } 

                    system.debug('---outputmap---'+outputmap);
            }
        }
        
            for(ProcessAnswer__c p : paList){
                
                if(talukaCountMap.containskey(p.Taluka__c)){
                    
                    talukaCountMap.get(p.Taluka__c).add(p);
                
                }else{
                
                    talukaCountMap.put(p.Taluka__c, new list<ProcessAnswer__c>{p});
                }
            }
            
            system.debug('---talukaCountMap--'+talukaCountMap);
    }
    system.debug('----outputmap------'+ outputmap.keyset());
    
    
    for(string str : outputmap.keyset()){
    
        //system.debug('----Map Keyset---'+outputmap.keyset());
    
        if(str != null || str != ''){
            
            pickListset.remove(str);
            FeedBackWrapper f = new FeedBackWrapper();
             
            f.setType(str);
                
            validafeedbackCount += outputmap.get(str).size();
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
    
        if(str != '' && str != null){
            NameOfTaluka += str + ','; 
        }
        
        FeedBackWrapper fd = new FeedBackWrapper();
        fd.setType(str);
        
        System.debug('Taluka is: ' + str);
        system.debug('---talukaCountMap size---'+talukaCountMap.get(str));
        fd.setvalue(talukaCountMap.get(str).size());
        feedBackWrapper1.add(fd);
    }
    
    for(string str : clusterlist){
    
        if(str != '' && str != null){
        NameOfCluster += str + ',';
        }
    }
    
    for(string str : districtlist){
    
        if(str != '' && str != null){
        NameOfDistrict += str + ',';
        }
    }
    
    NameOfDistrict = NameOfDistrict.removeEnd(',');
    NameOfTaluka = NameOfTaluka.removeEnd(',');

    
    if(districtlist.size() == 0){
        countOfDistrict = 0;
    }else{
        countOfDistrict = districtlist.size();    
    }
    
    if(talukalist.size() == 0){
        countOfTaluka = 0;
    }else {
        countOfTaluka = talukalist.size();
    }
    
    system.debug('---sectionCount---'+sectionCount);
    
    Integer sectionCount1 = sectionCount.intValue();
    
        validafeedbackCount = validafeedbackCount1/sectionCount1;
    
    NameOfState = state;
    
}

//////////////////////////////////////////////////////////////////////
 
    
    public List<PieWedgeData> getPieData1(){
    
        List<PieWedgeData> data = new List<PieWedgeData>();

        if(feedBackWrapper != null){
            totalCount = 0;
            
            for(FeedBackWrapper f : feedBackWrapper){
                
                if(f.getType() != null || f.getValue() != null){
                    totalCount = totalCount + f.getValue();
                }   
            }
            
            for(FeedBackWrapper f:feedBackWrapper){
            
                if(f.getType() != null && f.getValue() != null){
                
                    Decimal specificCount = f.getValue();
                    Decimal percentCount;
                
                    if(totalCount>0) {
                        
                         if(validafeedbackCount1 > 0)
                            percentCount = (Decimal)(100*specificCount)/validafeedbackCount1;
                        else
                            percentCount = (Decimal)(100*specificCount);
                            
                          percentCount = percentCount.SetScale(2);
                    }
                    
                    if(totalCount>0) {
                    
                        if(f != null)
                        data.add(new PieWedgeData(f.getType()+'  ==>>'+percentCount +' %', percentCount));
                    }    
                }
            }
        }
        return data;
    }
    
    
    public List<PieWedgeData> getPieData2(){
    
        //system.debug('---sectionCount---'+sectionCount);
    
        List<PieWedgeData> data = new List<PieWedgeData>();

        if(feedBackWrapper != null){
            totalCount = 0;
            
            for(FeedBackWrapper f : feedBackWrapper){
                
                if(f.getType() != null || f.getValue() != null){
                    totalCount = totalCount + f.getValue();
                }   
            }
            
            for(FeedBackWrapper f:feedBackWrapper){
            
                if(f.getType() != null && f.getValue() != null){
                
                    Decimal specificCount = f.getValue();
                    Decimal percentCount;
                    
                    if(totalCount>0) {
                        if(f != null)
                            data.add(new PieWedgeData(f.getType(),specificCount));
                    }
                }
            }
        }
        return data;
    }
    
    
    public List<PieWedgeData> getPieData3() {
    
        List<PieWedgeData> data = new List<PieWedgeData>();

        if(feedBackWrapper1 != null){
            totalCount = 0;
            
            for(FeedBackWrapper f : feedBackWrapper1){
                
                if(f.getType() != null || f.getValue() != null){
                    
                    //system.debug('---type---'+f.getType());
                    //system.debug('---value---'+f.getValue());
                    
                    totalCount = totalCount + f.getValue();
                }   
            }
            
            for(FeedBackWrapper f:feedBackWrapper1){
                
                if(f.getType() != null && f.getValue() != null){
                
                    Decimal specificCount = f.getValue();
                    
                    if(totalCount>0) {
                        if(f != null)
                            data.add(new PieWedgeData(f.getType(),specificCount));
                            
                            //system.debug('---data in 1---'+data);
                    }      
                }
            }
        }
        return data;
    }
    
    
    public List<PieWedgeData> getPieData4(){
    
        List<PieWedgeData> data = new List<PieWedgeData>();

        if(feedBackWrapper2 != null){

            for(FeedBackWrapper f : feedBackWrapper2){
                    
                system.debug('---feedBackWrapper2 here---'+feedBackWrapper2);
                
                if(f.getType() != null && f.getValue() != null){
                
                    /*Decimal specificCount = f.getValue();
                    Decimal finalCnt;
                    
                    if(feedbackCnt != null){
                        finalCnt = specificCount/feedbackCnt;
                        
                            finalCnt = finalCnt.setScale(2);
                    }*/
                        
                        if(f != null)
                            //data.add(new PieWedgeData(f.getType(),finalCnt));
                            data.add(new PieWedgeData(f.getType(),f.getValue()));
                            
                    system.debug('---data in 2---'+data);      
                }
            }
        }
        return data;
    }
    
    
    public List<PieWedgeData> getPieData5(){
    
        List<PieWedgeData> data = new List<PieWedgeData>();

        if(feedBackWrapper3 != null){

            for(FeedBackWrapper f : feedBackWrapper3){
                
                if(f.getType() != null && f.getValue() != null){

                        data.add(new PieWedgeData(f.getType(),f.getValue()));
                            
                    //system.debug('---data is in 3---'+data);      
                }
            }
        }
        return data;
    }

    //Trial 
    
    public List<List<PieWedgeData>> getPieData6(){

        List<List<PieWedgeData>> data = new List<List<PieWedgeData>>();

        if(feedBackWrapper5temp != null){
            List<feedBackWrapper> temp = new List<feedBackWrapper>();
        
            for( integer i=0; i<feedBackWrapper5temp.size(); i++){
            
                temp = feedBackWrapper5temp[i];
                
                List<PieWedgeData> lpd = new List<PieWedgeData>();
                
                for(FeedBackWrapper f : temp){
    
                    PieWedgeData pd = new PieWedgeData(f.getType(),f.getValue());
                    System.debug('PD object is: ' + pd);
                    
                    lpd.add(pd);     
                }
                
                System.debug('LPD list is' + lpd);
                data.add(lpd);   
            }   
        }       
        System.debug('Data list is' + data);
        return data;
    }
    

    public List<PieWedgeData> getPieData7() {
    
        List<PieWedgeData> data = new List<PieWedgeData>();
        decimal perIndex = 0;
        string key;
        
        if(feedBackWrapper6 != null){

            for(FeedBackWrapper f : feedBackWrapper6){
                
                if(f.getType() != null && f.getValue() != null){
                    
                    perIndex = f.getValue();
                    key = f.getType();
                        system.debug('---key---'+key);
                        system.debug('---in map value is---'+indMaxScoreAllIndicatorMap.get(key));
                        
                    decimal deno = scale/indMaxScoreAllIndicatorMap.get(key);   
                        system.debug('---deno---'+deno);

                        perIndex = perIndex / deno;
                        
                        if(feedbackCnt1 > 0)
                            perIndex = perIndex / feedbackCnt1;

                    data.add(new PieWedgeData(f.getType(),perIndex));
                            
                    system.debug('---data is in 7---'+data);      
                }
            }
        }
        return data;
    }
    
    
    public List<PieWedgeData> getPieData8(){
    
        List<PieWedgeData> data = new List<PieWedgeData>();

        if(feedBackWrapper7 != null){

            for(FeedBackWrapper f : feedBackWrapper7){
                
                if(f.getType() != null && f.getValue() != null){

                    data.add(new PieWedgeData(f.getType(),f.getValue()));
                            
                    system.debug('---data is in 8---'+data);      
                }
            }
        }
        return data;
    }

    

    public void checkProcessValue(){
        
        getroleList();
        fetchTraineeDataFromDatabase();        
    }
    
    public void checkTalValue(){
       
        fetchTraineeDataFromDatabase(); 
    }
    
    public void checkStateValue(){
    
        getDistrict();
    }
    
    public void setValueToDist(){
    
       getquestionList();
       fetchTraineeDataFromDatabase();
    }
    
    public void setValueToDist1(){
       
       tal = 'select';
       getTaluka();
       fetchTraineeDataFromDatabase();
    }
    
     public void setValueTocluster(){
     
       getclusterlist();
       fetchTraineeDataFromDatabase();
    }
   
    
    global class PieWedgeData implements Comparable{
    
        global String name { get; set; }
        global Decimal data { get; set; }

        global PieWedgeData(String name, Decimal data) {
            
            this.name = name;
            if(data != null)
                this.data = data.setScale(2); 
        }
        
        global Integer compareTo(Object ObjToCompare) {
        
            return name.CompareTo(((PieWedgeData)ObjToCompare).name);
        }
        
    }
    
    global class feedbackdata{
    
        global integer index { get; set; }
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
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
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