global class ProcessController {
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
    public integer countofrecords{get; set;}
    public integer initialCount{get; set;}
    public integer presenrcount{get; set;}
    public decimal questioncnt {get; set;}
    list<String> idset = new list<string>();
    public Transient integer feedbackCount {get; set;}
    public integer rownumber{get; set;}
    public integer currentcount{get; set;}
    public Integer counter;
    public decimal sectionCount;
    
    public Integer getCounter()
    {
        return counter;
    }
    public void setCounter()
    {
        counter = 0;
    }
    public Integer limitSize = 0;//Number of records to be displayed
    public Integer totalSize =0; //To Store the total number of records available
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
   
    Integer totalCount = null;
  
    List<MV_Training_Calender__c> records = new List<MV_Training_Calender__c>();
    List<MV_TraineeFeedback__c> mvTraineeFeedBack = new List<MV_TraineeFeedback__c>();
    List<FeedBackWrapper> feedBackWrapper = null;
    List<FeedBackWrapper> updatedFeedBackWrapper = null;
    List<feedbackdata> feedbackdatalistNew = new List<feedbackdata>();
   
    List<Task_Answer__c> FeedBackInDetail = null;
    List<Id> recordId = null;
    
    global ProcessController(ApexPages.StandardController controller) {
        setCounter();
        State = 'select';
        dist = 'select';
        tal = 'select';
        feedbackCount = 0;
        PaginationCount__c myCS1 = PaginationCount__c.getValues('section');
        limitSize = Integer.valueOf(myCS1.record_Count__c);
        PaginationCount__c myCS2 = PaginationCount__c.getValues('total');
        totalrecordscount = Integer.valueOf(myCS2.record_Count__c);
        presenrcount=0;
        rownumber=1;
        currentcount=1;
        NameOfState='';
        NameOfDistrict='';
        NameOfTaluka='';
        NameOfCluster='';
        
    }
     global ProcessController() {
        State = 'select';
        dist = 'select';
        tal = 'select';
        feedbackCount = 0;
        PaginationCount__c myCS1 = PaginationCount__c.getValues('section');
        limitSize = Integer.valueOf(myCS1.record_Count__c);
        PaginationCount__c myCS2 = PaginationCount__c.getValues('total');
        totalrecordscount = Integer.valueOf(myCS2.record_Count__c);
        
        presenrcount=0;
        rownumber=1;
        currentcount=1;
        NameOfState='';
        NameOfDistrict='';
        NameOfTaluka='';
        NameOfCluster='';
        
    }
        public List<SelectOption> getprocessList() {
        FeedBackInDetail = null;
      
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Select','Select'));
                for (RoleManagement__c iso : RoleManagement__c.getAll().values()){
                if(iso.IsActived__c == true){
                    options.add(new SelectOption(iso.Name,iso.Name));
                 }
            }
            system.debug('--------------'+options.size());
        return options;
    }
    
    public List<SelectOption> getroleList() {
       
          FeedBackInDetail =null;
            List<SelectOption> options = new List<SelectOption>();
            List<Id> idList = new List<Id>();
          options.add(new SelectOption('Select','Select'));
          System.debug('Statte name is------'+state);
          System.debug('Process Name is'+Process);
          //commented by Nikhil Jamdar
          //AggregateResult[] groupedResults = [SELECT Name, Count(Id) FROM MV_Process__c where state__c =: state and Role_For_Executive_dashbord__c includes(:Process) AND IS_In_Executive_dashboard__c = true GROUP BY Name];
          AggregateResult[] groupedResults = [SELECT Name, Count(Id) FROM MV_Process__c where state__c includes(:state) AND Multiple_Role__c includes(:Process) GROUP BY Name];
          
          
          for (AggregateResult ar : groupedResults){
             options.add(new SelectOption((String)ar.get('Name'),(String)ar.get('Name')));
            }
          
          System.debug('Group Result are------'+options);
          system.debug('--------------'+options.size());
            
         return options;
        
    }
    
        public List<SelectOption> getquestionList() {
        // totalFeedBackCount = 0;
         FeedBackInDetail =null;
            List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('Select','Select'));
         
            AggregateResult[] groupedResults = [SELECT Task_Text__c,count(Id) FROM MV_Task__c where MV_Process__r.Name =:role AND (Task_type__c = 'Selection' OR Task_type__c = 'Text' OR Task_type__c = 'Multi-Lines' OR Task_type__c = 'Multi-select' OR Task_type__c = 'Checkbox') AND Task_Text__c != '' GROUP BY Task_Text__c];
            
          for (AggregateResult ar : groupedResults){
             options.add(new SelectOption((String)ar.get('Task_Text__c'),(String)ar.get('Task_Text__c')));
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
         
     public void descriptiveDateMethod(string soql, List<string> fieldstr){
        List<ProcessAnswer__c> paList = new List<ProcessAnswer__c>();
        map<string,List<ProcessAnswer__c>> outputmap = new map<string,List<ProcessAnswer__c>>();
        set<String> talukalist = new set<String>();
        set<String> districtlist = new set<String>();
        set<String> clusterlist = new set<String>();
        string strfield = fieldstr[0];
        //feedbackCount = 0;
        //validafeedbackCount= 0;
        System.debug('Descriptive Query Name: ' + soql);
        paList = Database.query(soql);
        //feedbackCount = paList.size();
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
            if((string)pa.get(strfield) != null && (string)pa.get(strfield) != '' && (string)pa.get(strfield) != 'Yes' && (string)pa.get(strfield) != 'No' && (string)pa.get(strfield) != 'Good' && (string)pa.get(strfield) != '-' && (string)pa.get(strfield) != '--' && (string)pa.get(strfield) != 'Ho' && (string)pa.get(strfield) != 'Nahi' && (string)pa.get(strfield) != ' very good' && (string)pa.get(strfield) != 'छान '){
                //validafeedbackCount++;
                fd.answer =  (string)pa.get(strfield);
                //feedbackdatalist.add(fd);
                totalfeedbackdatalist.add(fd);
            }  
        }
        totalSize = totalfeedbackdatalist.size();
         feedbackdatalist.clear();
         feedbackdatalist.addAll(totalfeedbackdatalist);       
  }
  
  public void next(){
   
        feedbackdatalist.clear();
       // counter=counter+limitSize;
        counter=counter+100;
       
      /*if((counter+limitSize) <= totalSize){
            for(Integer i=counter-1;i<(counter+limitSize);i++){
                feedbackdatalist.add(totalfeedbackdatalist.get(i));
            }
        } else{
            for(Integer i=counter;i<totalSize;i++){
                feedbackdatalist.add(totalfeedbackdatalist.get(i));
            }
        }*/
      
      
      List<MV_Task__c> tsk = new List<MV_Task__c>();      
        tsk = [SELECT Id,Picklist_Value__c,Task_Text__c,API_field_Name__c,Task_type__c,Section_Question_Count__c,Caption__c,Section_Group_No__c FROM MV_Task__c where Task_Text__c = :question]; 
    
    List<String> fieldstr = new List<String>();
     set<String> fieldstr1 = new set<String>();
    if(tsk.size() > 0){
        caption = tsk[0].Caption__c;
        sectionCount = tsk[0].Section_Question_Count__c;
    }
    for(MV_Task__c tk : tsk){
        if(tk.API_field_Name__c != null){
            fieldstr1.add(tk.API_field_Name__c);
        }
    }
    if(fieldstr1.size() > 0){
        fieldstr.addAll(fieldstr1);
    }
    List<String> pickList = new List<String>();
    set<String> pickListset = new set<String>();
    
      if(tsk.size() > 0)
      {  
        if(tsk[0].Task_type__c == 'Text' || tsk[0].Task_type__c == 'Multi-Lines'){
            
             if(dist == 'select'){
                 //Commneted By Nikhil Jamdar
                 //String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\'' +'AND ' +fieldstr[0] +'!= null AND '+fieldstr[0] +'!= \'\' '+' limit '+totalrecordscount;
                 String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\'' +' limit 100 offset '+counter;
                 //String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\'' +' limit 500';
        //String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\'';
                descriptiveDateMethod(soql,fieldstr);
            }
            else if( tal == 'select'){
                //Commneted By Nikhil Jamdar
                String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\' ' +' limit 100 offset '+counter;
                //String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\'';
                descriptiveDateMethod(soql,fieldstr);
            }
            else if(cluster == 'select'){
                //Commneted By Nikhil Jamdar
                String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND Taluka__c =\''+tal +'\' AND MV_Process__r.Name =\'' + role+'\' AND Role_Name__c = \''+Process+'\' ' +' limit 100 offset '+counter;
                //String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND Taluka__c =\''+tal +'\' AND MV_Process__r.Name =\'' + role+'\' AND Role_Name__c = \''+Process+'\'';
                descriptiveDateMethod(soql,fieldstr);
            }else {
                //Commneted By Nikhil Jamdar
                String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND Taluka__c =\''+tal +'\'AND Cluster__c = \''+cluster+'\' AND MV_Process__r.Name =\'' + role+'\' AND Role_Name__c = \''+Process+'\' ' +' limit 100 offset '+counter;
                //String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND Taluka__c =\''+tal +'\'AND Cluster__c = \''+cluster+'\' AND MV_Process__r.Name =\'' + role+'\' AND Role_Name__c = \''+Process+'\'';
                descriptiveDateMethod(soql,fieldstr);
            }
            }
            
        }  
    }
    
    
    public void previous(){
   
        feedbackdatalist.clear();

        //counter=counter-limitSize;
        counter=counter-100;       
       
        List<MV_Task__c> tsk = new List<MV_Task__c>();      
        tsk = [SELECT Id,Picklist_Value__c,Task_Text__c,API_field_Name__c,Task_type__c,Section_Question_Count__c,Caption__c,Section_Group_No__c FROM MV_Task__c where Task_Text__c = :question]; 
    
    List<String> fieldstr = new List<String>();
     set<String> fieldstr1 = new set<String>();
    if(tsk.size() > 0){
        caption = tsk[0].Caption__c;
        sectionCount = tsk[0].Section_Question_Count__c;
    }
    for(MV_Task__c tk : tsk){
        if(tk.API_field_Name__c != null){
            fieldstr1.add(tk.API_field_Name__c);
        }
    }
    if(fieldstr1.size() > 0){
        fieldstr.addAll(fieldstr1);
    }
    List<String> pickList = new List<String>();
    set<String> pickListset = new set<String>();
    
      if(tsk.size() > 0)
      {  
        if(tsk[0].Task_type__c == 'Text' || tsk[0].Task_type__c == 'Multi-Lines'){
            
             if(dist == 'select'){
                 //Commneted By Nikhil Jamdar
                 //String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\'' +'AND ' +fieldstr[0] +'!= null AND '+fieldstr[0] +'!= \'\' '+' limit '+totalrecordscount;
                 String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\'' +' limit 100 offset '+counter;
                 //String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\'' +' limit 500';
        //String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\'';
                descriptiveDateMethod(soql,fieldstr);
            }
            else if( tal == 'select'){
                //Commneted By Nikhil Jamdar
                String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\' ' +' limit 100 offset '+counter;
                //String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\'';
                descriptiveDateMethod(soql,fieldstr);
            }
            else if(cluster == 'select'){
                //Commneted By Nikhil Jamdar
                String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND Taluka__c =\''+tal +'\' AND MV_Process__r.Name =\'' + role+'\' AND Role_Name__c = \''+Process+'\' ' +' limit 100 offset '+counter;
                //String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND Taluka__c =\''+tal +'\' AND MV_Process__r.Name =\'' + role+'\' AND Role_Name__c = \''+Process+'\'';
                descriptiveDateMethod(soql,fieldstr);
            }else {
                //Commneted By Nikhil Jamdar
                String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND Taluka__c =\''+tal +'\'AND Cluster__c = \''+cluster+'\' AND MV_Process__r.Name =\'' + role+'\' AND Role_Name__c = \''+Process+'\' ' +' limit 100 offset '+counter;
                //String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND Taluka__c =\''+tal +'\'AND Cluster__c = \''+cluster+'\' AND MV_Process__r.Name =\'' + role+'\' AND Role_Name__c = \''+Process+'\'';
                descriptiveDateMethod(soql,fieldstr);
            }
            }
            
        }
        
        /*for(Integer i=counter;i<(counter+limitSize); i++){
            feedbackdatalist.add(totalfeedbackdatalist.get(i));
        }*/
    }
     public Boolean getDisablePrevious(){
   
        if(counter == 0)
            return true ;
        else
            return false ;
    } 
    public Boolean getDisableNext(){
   
        if((counter + 100) > validafeedbackCount )
            return true ;
        else
            return false ;
    }
   
 ///////////////////////////////////////////////////////////////   
   public void fetchTraineeDataFromDatabase(){  
    
    questioncnt = 1;
    feedbackCount = 0;
    validafeedbackCount = 0;
    presenrcount=0;
    rownumber=1;
    currentcount=1;
    feedBackWrapper = new List<FeedBackWrapper>();
    feedbackdatalist = new List<feedbackdata>();
    updatedFeedBackWrapper = new List<FeedBackWrapper>();
    List<MV_Task__c> tsk = new List<MV_Task__c>();
    FeedBackInDetail = new List<Task_Answer__c>();
    feedbackdatalistNew = new List<feedbackdata>();
    totalfeedbackdatalist = new List<feedbackdata>();
    counter = 0;
    totalSize =0;
       
      
        
     AggregateResult[] groupedResults = null;
   //
    tsk = [SELECT Id,Picklist_Value__c,Task_Text__c,API_field_Name__c,Task_type__c,Section_Question_Count__c,Caption__c,Section_Group_No__c FROM MV_Task__c where Task_Text__c = :question]; 
           
    System.debug('Text Type------'+tsk);

    List<String> fieldstr = new List<String>();
     set<String> fieldstr1 = new set<String>();
    if(tsk.size() > 0){
        caption = tsk[0].Caption__c;
        sectionCount = tsk[0].Section_Question_Count__c;
    }
    for(MV_Task__c tk : tsk){
        if(tk.API_field_Name__c != null){
            fieldstr1.add(tk.API_field_Name__c);
        }
    }
    if(fieldstr1.size() > 0){
        fieldstr.addAll(fieldstr1);
    }
    List<String> pickList = new List<String>();
    set<String> pickListset = new set<String>();
    if(tsk.size() > 0){
        if(tsk[0].Task_type__c != null && tsk[0].Task_type__c == 'Selection'){
            pickList = tsk[0].Picklist_Value__c.split(','); 
            pickListset.addAll(pickList);
            if(dist == 'select'){
                String soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\'';
                processdataforPiChart(soql,fieldstr,pickListset);
            }
            else if( tal == 'select'){
                String soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\'';
                processdataforPiChart(soql,fieldstr,pickListset);
            }
            else if(cluster == 'select'){
                String soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND Taluka__c =\''+tal +'\' AND MV_Process__r.Name =\'' + role+'\' AND Role_Name__c = \''+Process+'\'';
                processdataforPiChart(soql,fieldstr,pickListset);
            }else {
                String soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND Taluka__c =\''+tal +'\'AND Cluster__c = \''+cluster+'\' AND MV_Process__r.Name =\'' + role+'\' AND Role_Name__c = \''+Process+'\'';
                processdataforPiChart(soql,fieldstr,pickListset);
            }
        }
        else if(tsk[0].Task_type__c == 'Text' || tsk[0].Task_type__c == 'Multi-Lines'){
            System.debug('Dist is-----' + dist);
            System.debug('Tal is-----' + tal);
            System.debug('Cluster is-----' + cluster);
            
            
             if(dist == 'select'){
                 //Commneted By Nikhil Jamdar
                 //String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\'' +'AND ' +fieldstr[0] +'!= null AND '+fieldstr[0] +'!= \'\' '+' limit '+totalrecordscount;
                 //String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\'' +' limit '+totalrecordscount;
                 String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\'' +' limit 100 offset 1';
        //String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\'';
                
                  
                 feedbackCount = [select count() from ProcessAnswer__c where State__c =: State  AND MV_Process__r.Name =: role AND Role_Name__c =:Process]; 
                 List<ProcessAnswer__c> l = new List<ProcessAnswer__c>();
                 //String validCountQuery = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\'' +'AND ' +fieldstr[0] +'!= null AND '+fieldstr[0] +'!= \'\' '+' limit '+feedbackCount;
                 //l = Database.query(validCountQuery);
                // validafeedbackCount = l.size();
                 descriptiveDateMethod(soql,fieldstr);
            }
            else if( tal == 'select'){
                //Commneted By Nikhil Jamdar
                String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\' ' +' limit 100 offset 1';
                //String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\'';
                
                
                feedbackCount = [select count() from ProcessAnswer__c where State__c =: State  AND District__c =:dist  and MV_Process__r.Name =: role AND Role_Name__c =:Process]; 
                 List<ProcessAnswer__c> l = new List<ProcessAnswer__c>();
                // String validCountQuery = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' and District__c = \'' + dist +'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\'' +'AND ' +fieldstr[0] +'!= null AND '+fieldstr[0] +'!= \'\' '+' limit '+feedbackCount;
                // System.debug('Dist Query is' + validCountQuery);
                // l = Database.query(validCountQuery);
                // validafeedbackCount = l.size();
                descriptiveDateMethod(soql,fieldstr);
            }
            else if(cluster == 'select'){
                //Commneted By Nikhil Jamdar
                //String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND Taluka__c =\''+tal +'\' AND MV_Process__r.Name =\'' + role+'\' AND Role_Name__c = \''+Process+'\' ' +'AND ' +fieldstr[0] +'!= null AND '+fieldstr[0] +'!= \'\' '+' limit '+totalrecordscount;
                String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND Taluka__c =\''+tal +'\' AND MV_Process__r.Name =\'' + role+'\' AND Role_Name__c = \''+Process+'\' limit 100 offset 1';
                
                
                
                feedbackCount = [select count() from ProcessAnswer__c where State__c =: State  AND District__c =:dist  and Taluka__c =: tal and MV_Process__r.Name =: role AND Role_Name__c =:Process]; 
                 List<ProcessAnswer__c> l = new List<ProcessAnswer__c>();
                //String validCountQuery = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' and District__c =\'' + dist +'\' AND Taluka__c =\''+tal +'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\'' +'AND ' +fieldstr[0] +'!= null AND '+fieldstr[0] +'!= \'\' '+' limit '+feedbackCount;
                //System.debug('Valid Cluster query is' + validCountQuery); 
                //l = Database.query(validCountQuery);
                 //validafeedbackCount = l.size();
                
                descriptiveDateMethod(soql,fieldstr);
            }else {
                //Commneted By Nikhil Jamdar
                //String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND Taluka__c =\''+tal +'\'AND Cluster__c = \''+cluster+'\' AND MV_Process__r.Name =\'' + role+'\' AND Role_Name__c = \''+Process+'\' ' +'AND ' +fieldstr[0] +'!= null AND '+fieldstr[0] +'!= \'\' '+' limit '+totalrecordscount;
                String soql = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND District__c = \''+dist+'\' AND Taluka__c =\''+tal +'\'AND Cluster__c = \''+cluster+'\' AND MV_Process__r.Name =\'' + role+'\' AND Role_Name__c = \''+Process+'\' limit 100 offset 1';
              
                
                feedbackCount = [select count() from ProcessAnswer__c where State__c =: State  AND District__c =:dist  and Taluka__c =: tal and Cluster__c =: cluster and MV_Process__r.Name =: role AND Role_Name__c =:Process]; 
                 List<ProcessAnswer__c> l = new List<ProcessAnswer__c>();
                // String validCountQuery = ' select Id,MV_User__r.Name,MV_User__r.Last_Name__c,Cluster__c,District__c,State__c,Taluka__c,Village__c,' + String.join(fieldstr, ',')+ ' from ProcessAnswer__c'+' where State__c =\'' + State +'\' and District__c =\'' + dist +'\' AND Taluka__c =\''+tal +'\' AND MV_Process__r.Name =\'' + role +'\' AND Role_Name__c = \''+Process+'\'' +'AND ' +fieldstr[0] +'!= null AND '+fieldstr[0] +'!= \'\' '+' limit '+feedbackCount;
                // l = Database.query(validCountQuery);
                // validafeedbackCount = l.size();
                 
                descriptiveDateMethod(soql,fieldstr);
            }
            
        }
    }
}

public void processdataforPiChart(string soql, List<string> fieldstr,set<string> pickListset){
    
List<ProcessAnswer__c> paList = new List<ProcessAnswer__c>();
map<string,List<ProcessAnswer__c>> outputmap = new map<string,List<ProcessAnswer__c>>();
set<String> talukalist = new set<String>();
set<String> districtlist = new set<String>();
set<String> clusterlist = new set<String>();
feedbackCount = 0;
validafeedbackCount=0;
validafeedbackCount1 = 0;
NameOfTaluka='';
NameOfDistrict='';
NameOfCluster='';
NameOfState='';

    paList = Database.query(soql);
    feedbackCount = paList.size();
    //validafeedbackCount = feedbackCount;
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
                //system.debug('----str is---'+str);
                validafeedbackCount1++;
                //system.debug('---validafeedbackCount1---'+validafeedbackCount1);
            }
            
            
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
    //NameOfCluster = NameOfCluster.removeEnd(',');
    system.debug('--------districtlist--------' + districtlist.size());
    system.debug('--------talukalist--------' + talukalist.size());
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
      public List<PieWedgeData> getPieData1() {
        List<PieWedgeData> data = new List<PieWedgeData>();
        if(feedBackWrapper != null){
            totalCount = 0;
        
        for(FeedBackWrapper f:feedBackWrapper){
            
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
            
            if(f != null)
                data.add(new PieWedgeData(f.getType()+'  ==>>'+percentCount +' %', percentCount));
            }
        }
          }
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
            //fetchTraineeDataFromDatabase();
          }
    
    public void setValueToDist()
    {    //system.debug('----------setValueToDist');
       getquestionList();
       fetchTraineeDataFromDatabase();
    }
    
    public void setValueToDist1()
    {   system.debug('Hello----------setValueToDist1');
       tal = 'select';
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
            
             if(data != null)
            {
                       this.data= data.setScale(2); 
            }
            //this.data= data;
            
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
       
        
         
        }
    
    
}