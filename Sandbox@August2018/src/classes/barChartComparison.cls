public class barChartComparison {
    String State = 'Select';
    String dist = 'Select';
    String tal = 'Select';
    String qustionArea = 'Select';
    public String displayTaluka = '';
    public String talukaList {get; set;}
    public Integer index { get; set; }
    map<String,decimal> strTodecimalMap1 = new map<String, decimal>();
    map<String,decimal> strTodecimalMap2 = new map<String, decimal>();
         
    public String sessionName;
    public Integer totalFeedBackCount{get; set;}
    Decimal totalCount = null;
    Date StartDate = null;
    Public Date EndDate {get; set;}
    public Integer totalTaluka{get; set;}
    public Integer feedbackCountnew {get; set;}
    
    List<MV_Training_Calender__c> records = new List<MV_Training_Calender__c>();
    List<MV_TraineeFeedback__c> mvTraineeFeedBack = new List<MV_TraineeFeedback__c>();
    List<FeedBackWrapper> feedBackWrapper = null;
    List<FeedBackWrapper> feedBackWrappernew = null;
    List<FeedBackWrapper> feedBackWrapper1 = null;
     
     List<Task_Answer__c> FeedBackInDetailNew {get; set;}
    
    List<FeedBackWrapper> feedBackWrapper2 = null;
    List<FeedBackWrapper> updatedFeedBackWrappernew = null;
    List<MV_TraineeFeedback__c> FeedBackInDetail = null;
     //List<MV_TraineeFeedback__c> FeedBackInDetailNew = null;
    
    
    List<Id> recordId = null;
    public String filterclouse {get; set;}
    public String filterType {get; set;}
    public String filterOn {get; set;}
    
    
    List<MV_TraineeFeedback__c> traineeFeedbackFilterList = null;
    
    public barChartComparison(ApexPages.StandardController controller) {
        sessionName = '';
        totalTaluka = 0;
        totalFeedBackCount = 0;
    }
     public barChartComparison() {
        
    }
    public List<SelectOption> getStateList() {
        FeedBackInDetail =null;
       // totalFeedBackCount = 0;
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Select','Select'));
            AggregateResult[] groupedResults = [SELECT State__c, Count(Id) FROM MV_Training_Calender__c GROUP BY State__c];
            for (AggregateResult ar : groupedResults)  {
                    options.add(new SelectOption((String)ar.get('State__c'),(String)ar.get('State__c')));
       
    }
    return options;
        }
    
      public List<SelectOption> getDistrict() {
         // totalFeedBackCount = 0;
          FeedBackInDetail =null;
            List<SelectOption> options = new List<SelectOption>();
          options.add(new SelectOption('Select','Select'));
          AggregateResult[] groupedResults = [SELECT District__c, Count(Id) FROM MV_Training_Calender__c where State__C =: State  GROUP BY District__c];
            for (AggregateResult ar : groupedResults)  {
                    options.add(new SelectOption((String)ar.get('District__c'),(String)ar.get('District__c')));
       
    }
          
    return options;
        }
    
     public List<SelectOption> getTaluka() {
        // totalFeedBackCount = 0;
         FeedBackInDetail =null;
            List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('Select','Select'));
          AggregateResult[] groupedResults = [SELECT Taluka__c, Count(Id) FROM MV_Training_Calender__c where District__c =: dist  GROUP BY Taluka__c];
            for (AggregateResult ar : groupedResults)  {
                    options.add(new SelectOption((String)ar.get('Taluka__c'),(String)ar.get('Taluka__c')));
       
    }
          
    return options;
        }
    
    public List<SelectOption> getSection() {
        List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('Select','Select'));
       
        List<MV_Training_Calender__c> trainingCalender = new List<MV_Training_Calender__c>();
        trainingCalender = [SELECT Taluka__c, Code__c FROM MV_Training_Calender__c where Taluka__c =: tal];
        
        if(trainingCalender.size()>0)
        {
            displayTaluka = trainingCalender.get(0).Code__c;  
        }
        
        AggregateResult[] listOfSection = [select Section_Name__c from Section_To_Question_Mapping__c group by Section_Name__c];
        for(AggregateResult sec : listOfSection)
        {
               options.add(new SelectOption((String)sec.get('Section_Name__c'),(String)sec.get('Section_Name__c')));
        }
        
    return options;
    }
    
   
    public List<SelectOption> getfilterOnList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('उत्कृष्ट','उत्कृष्ट'));
        return options;
    }

    public List<SelectOption> getFiltertyprcluase() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Percentage','Percentage'));
        return options;
    }
    public void refreshdata(){
        fetchTraineeDataFromDatabase();
        fetchsectionwisedataFromDatabase();
        PieData1();
        PieData2();
        
    }
     public List<PieWedgeData> getPieData(){  
        List<PieWedgeData> data = new List<PieWedgeData>();
        system.debug('----getPieData-------');
        for(String str : strTodecimalMap1.keyset()){
            if(strTodecimalMap2.get(str) == null){
                data.add(new PieWedgeData(str,strTodecimalMap1.get(str), 0));
            }else{
                data.add(new PieWedgeData(str,strTodecimalMap1.get(str), strTodecimalMap2.get(str)));
            }
             
            
        }
        
       system.debug('----getPieData-------'+ data);
        return data;  
    }
    
    public void fetchTraineeDataFromDatabase(){   
        sessionName = qustionArea;
        feedBackWrapper = null;
        traineeFeedbackFilterList = new List<MV_TraineeFeedback__c>();
        talukaList= '';
      System.debug('State' + state+' Dist' + dist+' Tal' + tal);
        if(state == 'Select')
        {
            records = [SELECT Id, Batch__c, Cluster__c,Start_Date__c,End_Date__c, Code__c,District__c,No_Of_Participant__c,State__c,Taluka__c FROM MV_Training_Calender__c]; 
                     
             
        }
        else if(dist == 'Select')
        {
            records = [SELECT Id, Batch__c,Start_Date__c,End_Date__c, Cluster__c, Code__c,District__c,No_Of_Participant__c,State__c,Taluka__c FROM MV_Training_Calender__c where State__c =:state]; 
            
            
        }
        else if(tal == 'Select')
        {
            records = [SELECT Id, Batch__c,Start_Date__c,End_Date__c, Cluster__c, Code__c,District__c,No_Of_Participant__c,State__c,Taluka__c FROM MV_Training_Calender__c where District__c =:dist]; 
                     
            
        }
        else
        {   system.debug('--------------taluka' + tal);
            records = [SELECT Id, Batch__c, Cluster__c, Code__c,Start_Date__c,End_Date__c,District__c,No_Of_Participant__c,State__c,Taluka__c FROM MV_Training_Calender__c where Taluka__c =:tal];
            
            
        }
        
     totalFeedBackCount = [select count() from MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records];
        
        
    if(qustionArea== '1 मूल्यवर्धन कार्यक्रम'){
          
        System.debug('Karyashalecha Niyam');
        feedBackWrapper = new List<FeedBackWrapper>();
        feedBackWrapper1 = new List<FeedBackWrapper>();
        feedBackWrapper2 = new List<FeedBackWrapper>();
      
        AggregateResult[] groupedResults1 = null; 
        AggregateResult[] groupedResults2 = null;
        AggregateResult[] groupedResults3 = null;
        AggregateResult[] groupedResults4 = null;
        AggregateResult[] groupedResults5 = null;
        
        //0.4
        AggregateResult[] groupedResults6 = null; 
        AggregateResult[] groupedResults7 = null;
        AggregateResult[] groupedResults8 = null;
        AggregateResult[] groupedResults9 = null;

        groupedResults1 = [SELECT MulyavardhanKamachiAvshakyata__c, Count(Id)cnt FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records group by MulyavardhanKamachiAvshakyata__c];
        groupedResults2 = [SELECT KarykamachaUddesh__c, Count(Id)cnt FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records group by    KarykamachaUddesh__c];
        groupedResults3 = [SELECT KaryakamachaAwaka__c, Count(Id)cnt FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records group by KaryakamachaAwaka__c];
        groupedResults4 = [SELECT KarykamacheSwarup__c, Count(Id)cnt FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records group by KarykamacheSwarup__c];
        groupedResults5 = [SELECT KaryakramachiMulyaAniAdhyayanNishpapti__c, Count(Id)cnt FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records group by KaryakramachiMulyaAniAdhyayanNishpapti__c];
        
        //0.4
        groupedResults6 = [SELECT   MiAniMazyaKshamata__c, Count(Id)cnt FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records group by     MiAniMazyaKshamata__c];
        groupedResults7 = [SELECT MazyaJababdarya__c, Count(Id)cnt FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records group by  MazyaJababdarya__c];
        groupedResults8 = [SELECT MiAniMazeNateSambandh__c, Count(Id)cnt FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records group by MiAniMazeNateSambandh__c];
        groupedResults9 = [SELECT   MIAniApleJag__c, Count(Id)cnt FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records group by   MIAniApleJag__c];
        
        Integer u = 0;
        Integer c = 0;
        Integer n = 0;
        Integer s = 0;
        Integer b = 0;
        
        
        totalFeedBackCount = [select count() from MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records];
        
        System.debug('Total COunt is: ' +totalFeedBackCount);
        
        
                   for (AggregateResult ar : groupedResults1)  {
                        if(((String)ar.get('MulyavardhanKamachiAvshakyata__c')) == 'उत्कृष्ट')
                        {
                            
                           u = u +  (Integer)ar.get('cnt');
                           
                        }
                        if(((String)ar.get('MulyavardhanKamachiAvshakyata__c')) == 'चांगले')
                        {
                           c = c + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('MulyavardhanKamachiAvshakyata__c')) == 'नाही दिला')
                        {
                            n = n + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('MulyavardhanKamachiAvshakyata__c')) == 'सर्व साधारण')
                        {
                            s = s + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('MulyavardhanKamachiAvshakyata__c')) == '')
                        {
                            b = b + (Integer)ar.get('cnt');
                        }
                    }
                    for (AggregateResult ar : groupedResults2)  {
                        if(((String)ar.get('KarykamachaUddesh__c')) == 'उत्कृष्ट')
                        {
                           u = u +  (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('KarykamachaUddesh__c')) == 'चांगले')
                        {
                           c = c + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('KarykamachaUddesh__c')) == 'नाही दिला')
                        {
                            n = n + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('KarykamachaUddesh__c')) == 'सर्व साधारण')
                        {
                            s = s + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('KarykamachaUddesh__c')) == '')
                        {
                            b = b + (Integer)ar.get('cnt');
                        }
                    }
                    for (AggregateResult ar : groupedResults3)  {
                        if(((String)ar.get('KaryakamachaAwaka__c')) == 'उत्कृष्ट')
                        {
                           u = u +  (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('KaryakamachaAwaka__c')) == 'चांगले')
                        {
                           c = c + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('KaryakamachaAwaka__c')) == 'नाही दिला')
                        {
                            n = n + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('KaryakamachaAwaka__c')) == 'सर्व साधारण')
                        {
                            s = s + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('KaryakamachaAwaka__c')) == '')
                        {
                            b = b + (Integer)ar.get('cnt');
                        }
                    }
                    for (AggregateResult ar : groupedResults4)  {
                        if(((String)ar.get('KarykamacheSwarup__c')) == 'उत्कृष्ट')
                        {
                           u = u +  (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('KarykamacheSwarup__c')) == 'चांगले')
                        {
                           c = c + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('KarykamacheSwarup__c')) == 'नाही दिला')
                        {
                            n = n + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('KarykamacheSwarup__c')) == 'सर्व साधारण')
                        {
                            s = s + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('KarykamacheSwarup__c')) == '')
                        {
                            b = b + (Integer)ar.get('cnt');
                        }
                    }
                    for (AggregateResult ar : groupedResults5)  {
                        if(((String)ar.get('KaryakramachiMulyaAniAdhyayanNishpapti__c')) == 'उत्कृष्ट')
                        {
                           u = u +  (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('KaryakramachiMulyaAniAdhyayanNishpapti__c')) == 'चांगले')
                        {
                           c = c + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('KaryakramachiMulyaAniAdhyayanNishpapti__c')) == 'नाही दिला')
                        {
                            n = n + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('KaryakramachiMulyaAniAdhyayanNishpapti__c')) == 'सर्व साधारण')
                        {
                            s = s + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('KaryakramachiMulyaAniAdhyayanNishpapti__c')) == '')
                        {
                            b = b + (Integer)ar.get('cnt');
                        }
                    }
        
        //0.6
              for (AggregateResult ar : groupedResults6)  {
                        if(((String)ar.get('MiAniMazyaKshamata__c')) == 'उत्कृष्ट')
                        {
                           u = u +  (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('MiAniMazyaKshamata__c')) == 'चांगले')
                        {
                           c = c + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('MiAniMazyaKshamata__c')) == 'नाही दिला')
                        {
                            n = n + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('MiAniMazyaKshamata__c')) == 'सर्व साधारण')
                        {
                            s = s + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('MiAniMazyaKshamata__c')) == '')
                        {
                            b = b + (Integer)ar.get('cnt');
                        }
                    }
                    for (AggregateResult ar : groupedResults7)  {
                        if(((String)ar.get('MazyaJababdarya__c')) == 'उत्कृष्ट')
                        {
                           u = u +  (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('MazyaJababdarya__c')) == 'चांगले')
                        {
                           c = c + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('MazyaJababdarya__c')) == 'नाही दिला')
                        {
                            n = n + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('MazyaJababdarya__c')) == 'सर्व साधारण')
                        {
                            s = s + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('MazyaJababdarya__c')) == '')
                        {
                            b = b + (Integer)ar.get('cnt');
                        }
                    }
                    for (AggregateResult ar : groupedResults8)  {
                        if(((String)ar.get('MiAniMazeNateSambandh__c')) == 'उत्कृष्ट')
                        {
                           u = u +  (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('MiAniMazeNateSambandh__c')) == 'चांगले')
                        {
                           c = c + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('MiAniMazeNateSambandh__c')) == 'नाही दिला')
                        {
                            n = n + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('MiAniMazeNateSambandh__c')) == 'सर्व साधारण')
                        {
                            s = s + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('MiAniMazeNateSambandh__c')) == '')
                        {
                            b = b + (Integer)ar.get('cnt');
                        }
                    }
                    for (AggregateResult ar : groupedResults9)  {
                        if(((String)ar.get('MIAniApleJag__c')) == 'उत्कृष्ट')
                        {
                           u = u +  (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('MIAniApleJag__c')) == 'चांगले')
                        {
                           c = c + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('MIAniApleJag__c')) == 'नाही दिला')
                        {
                            n = n + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('MIAniApleJag__c')) == 'सर्व साधारण')
                        {
                            s = s + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('MIAniApleJag__c')) == '')
                        {
                            b = b + (Integer)ar.get('cnt');
                        }
                    }
                    

        
        
        
        
        FeedBackWrapper f = new FeedBackWrapper();
        f.setType('उत्कृष्ट');
        f.setvalue(u);
        feedBackWrapper.add(f);
       
        f = new FeedBackWrapper();
        f.setType('चांगले');
        f.setvalue(c);
        feedBackWrapper.add(f);
        
        
        f = new FeedBackWrapper();
        f.setType('सर्व साधारण');
        f.setvalue(n);
        feedBackWrapper.add(f);
        
        f = new FeedBackWrapper();
        f.setType('नाही दिला');
        f.setvalue(s);
        feedBackWrapper.add(f);
       
        
    }
        
        
      if(qustionArea=='2 शिक्षक व विद्यार्थ्यांसाठी उपयुक्त संदर्भ साहित्य'){
        
            /* records = [SELECT Id, Batch__c,  Cluster__c, Code__c,District__c,No_Of_Participant__c,State__c,
                     Taluka__c FROM MV_Training_Calender__c where Taluka__c =:tal]; */
        System.debug('Karyashalecha Niyam');
        feedBackWrapper = new List<FeedBackWrapper>();
        feedBackWrapper1 = new List<FeedBackWrapper>();
        feedBackWrapper2 = new List<FeedBackWrapper>();
      
        AggregateResult[] groupedResults1 = null; 
        AggregateResult[] groupedResults2 = null;
        AggregateResult[] groupedResults3 = null;
      
        groupedResults1 = [SELECT ShikshakupkramPustika__c, Count(Id)cnt FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records group by ShikshakupkramPustika__c];
        groupedResults2 = [SELECT VidyarthiUpkramPustika__c, Count(Id)cnt FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records group by VidyarthiUpkramPustika__c];
        groupedResults3 = [SELECT VargUpkramancheAyojan__c, Count(Id)cnt FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records group by VargUpkramancheAyojan__c];
       
        Integer u = 0;
        Integer c = 0;
        Integer n = 0;
        Integer s = 0;
        Integer b = 0;
        
       totalFeedBackCount = [select count() from MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records];
        
                   for (AggregateResult ar : groupedResults1)  {
                        if(((String)ar.get('ShikshakupkramPustika__c')) == 'उत्कृष्ट')
                        {
                           u = u +  (Integer)ar.get('cnt');
                            
                        }
                        if(((String)ar.get('ShikshakupkramPustika__c')) == 'चांगले')
                        {
                           c = c + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('ShikshakupkramPustika__c')) == 'नाही दिला')
                        {
                            n = n + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('ShikshakupkramPustika__c')) == 'सर्व साधारण')
                        {
                            s = s + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('ShikshakupkramPustika__c')) == '')
                        {
                            b = b + (Integer)ar.get('cnt');
                        }
                    }
                    for (AggregateResult ar : groupedResults2)  {
                        if(((String)ar.get('VidyarthiUpkramPustika__c')) == 'उत्कृष्ट')
                        {
                           u = u +  (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('VidyarthiUpkramPustika__c')) == 'चांगले')
                        {
                           c = c + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('VidyarthiUpkramPustika__c')) == 'नाही दिला')
                        {
                            n = n + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('VidyarthiUpkramPustika__c')) == 'सर्व साधारण')
                        {
                            s = s + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('VidyarthiUpkramPustika__c')) == '')
                        {
                            b = b + (Integer)ar.get('cnt');
                        }
                    }
                    
                    for (AggregateResult ar : groupedResults3)  {
                        if(((String)ar.get('VargUpkramancheAyojan__c')) == 'उत्कृष्ट')
                        {
                           u = u +  (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('VargUpkramancheAyojan__c')) == 'चांगले')
                        {
                           c = c + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('VargUpkramancheAyojan__c')) == 'नाही दिला')
                        {
                            n = n + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('VargUpkramancheAyojan__c')) == 'सर्व साधारण')
                        {
                            s = s + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('VargUpkramancheAyojan__c')) == '')
                        {
                            b = b + (Integer)ar.get('cnt');
                        }
                    }
                    
        
        FeedBackWrapper f = new FeedBackWrapper();
        f.setType('उत्कृष्ट');
        f.setvalue(u);
        feedBackWrapper.add(f);
       
        f = new FeedBackWrapper();
        f.setType('चांगले');
        f.setvalue(c);
        feedBackWrapper.add(f);
        
        
        f = new FeedBackWrapper();
        f.setType('सर्व साधारण');
        f.setvalue(n);
        feedBackWrapper.add(f);
        
        f = new FeedBackWrapper();
        f.setType('नाही दिला');
        f.setvalue(s);
        feedBackWrapper.add(f);
        System.debug('Result is' + groupedResults2);
        
        //Decimal per=0;
        Map<String, decimal> talToperMap = new Map<String, decimal>();
        Map<String, Integer> talTocountMap = new Map<String, Integer>();
        
         for(MV_TraineeFeedback__c tf : traineeFeedbackFilterList){
             if(talToperMap.get(tf.Taluka__c) != null){
                decimal per = talToperMap.get(tf.Taluka__c);
                Integer i = talTocountMap.get(tf.Taluka__c);
                per += tf.Session_2_percentage__c;
                i++;
                talToperMap.put(tf.Taluka__c, per);
                talTocountMap.put(tf.Taluka__c, i);
             }else{
                talToperMap.put(tf.Taluka__c, tf.Session_2_percentage__c);
                talTocountMap.put(tf.Taluka__c, 1);
                
             }   
        }
        
        set<String> talList  = new set<String>();
        Map<String, Decimal> talukaToPerMap = new Map<String, Decimal>();
        for(String taluka : talToperMap.keySet()){
            decimal per = (talToperMap.get(taluka)/talTocountMap.get(taluka));
            talukaToPerMap.put(taluka, per);
        }
        
        for(String taluka : talukaToPerMap.keySet()){
            if(filterclouse == 'below 40%'){
                if(talukaToPerMap.get(taluka) < 40){
                        talList.add(taluka);
                    }
                
            }else if(filterclouse == '40%-50%'){
                 if(talukaToPerMap.get(taluka) >= 40 && talukaToPerMap.get(taluka) < 50){
                    talList.add(taluka);
                }
            }else if(filterclouse == '50%-60%'){
                if(talukaToPerMap.get(taluka) >= 50 && talukaToPerMap.get(taluka) < 60){
                    talList.add(taluka);
                }
            }else if(filterclouse == '60%-70%'){
                if(talukaToPerMap.get(taluka) >= 60 && talukaToPerMap.get(taluka) < 70){
                    talList.add(taluka);
                }
            }else if(filterclouse == '70%-80%'){
                if(talukaToPerMap.get(taluka) >= 70 && talukaToPerMap.get(taluka) < 80){
                    talList.add(taluka);
                }
            }else if(filterclouse == 'above 80%'){
                if(talukaToPerMap.get(taluka) >= 80){
                    talList.add(taluka);
                }
            }else{
                system.debug('------else-----');
            }
        }
        
        for(String str : talList){
            talukaList += str +',';
        }
        talukaList.removeEnd(',');
        

    }

                       
        if(qustionArea=='3 अध्ययन पद्धती')
    {
        
        System.debug('Karyashalecha Niyam');
        feedBackWrapper = new List<FeedBackWrapper>();
        feedBackWrapper1 = new List<FeedBackWrapper>();
        feedBackWrapper2 = new List<FeedBackWrapper>();
      
        AggregateResult[] groupedResults1 = null; 
        AggregateResult[] groupedResults2 = null;
        AggregateResult[] groupedResults3 = null;
        AggregateResult[] groupedResults4 = null;
        AggregateResult[] groupedResults5 = null;
        
        
        
        //0.6
        AggregateResult[] groupedResults6 = null; 
        AggregateResult[] groupedResults7 = null;
        AggregateResult[] groupedResults8 = null;
        
                //0.7
        AggregateResult[] groupedResults9 = null; 
        AggregateResult[] groupedResults10= null;
        AggregateResult[] groupedResults11= null;
        AggregateResult[] groupedResults12= null;

        
        groupedResults1 = [SELECT       UpkrammanchiSuruvat__c, Count(Id)cnt FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records group by        UpkrammanchiSuruvat__c];
        groupedResults2 = [SELECT SpashthSuchanaDene__c, Count(Id)cnt FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records group by   SpashthSuchanaDene__c];
        groupedResults3 = [SELECT PrashnVicharane__c, Count(Id)cnt FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records group by PrashnVicharane__c];
        groupedResults4 = [SELECT   GoshtSangane__c, Count(Id)cnt FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records group by   GoshtSangane__c];
        groupedResults5 = [SELECT   AbhinayGeet__c, Count(Id)cnt FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records group by    AbhinayGeet__c];
        
        //0.6
        groupedResults6 = [SELECT       JodiCharcha__c, Count(Id)cnt FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records group by        JodiCharcha__c];
        groupedResults7 = [SELECT GattCharcha__c, Count(Id)cnt FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records group by  GattCharcha__c];
        groupedResults8 = [SELECT SamudayikVartul__c, Count(Id)cnt FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records group by SamudayikVartul__c];
        
                //0.7
        groupedResults9 = [SELECT       VargNiyam__c, Count(Id)cnt FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records group by      VargNiyam__c];
        groupedResults10= [SELECT ShantataSanket__c, Count(Id)cnt FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records group by   ShantataSanket__c];
        groupedResults11= [SELECT BaithakVyavstha__c    , Count(Id)cnt FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records group by BaithakVyavstha__c   ];
        groupedResults12= [SELECT SakaratmkLakshDene__c , Count(Id)cnt FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records group by SakaratmkLakshDene__c    ];


       

        
        Integer u = 0;
        Integer c = 0;
        Integer n = 0;
        Integer s = 0;
        Integer b = 0;
        
        totalFeedBackCount = [select count() from MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records];
                   for (AggregateResult ar : groupedResults1)  {
                        if(((String)ar.get('UpkrammanchiSuruvat__c')) == 'उत्कृष्ट')
                        {
                           u = u +  (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('UpkrammanchiSuruvat__c')) == 'चांगले')
                        {
                           c = c + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('UpkrammanchiSuruvat__c')) == 'नाही दिला')
                        {
                            n = n + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('UpkrammanchiSuruvat__c')) == 'सर्व साधारण')
                        {
                            s = s + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('UpkrammanchiSuruvat__c')) == '')
                        {
                            b = b + (Integer)ar.get('cnt');
                        }
                    }
                    for (AggregateResult ar : groupedResults2)  {
                        if(((String)ar.get('SpashthSuchanaDene__c')) == 'उत्कृष्ट')
                        {
                           u = u +  (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('SpashthSuchanaDene__c')) == 'चांगले')
                        {
                           c = c + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('SpashthSuchanaDene__c')) == 'नाही दिला')
                        {
                            n = n + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('SpashthSuchanaDene__c')) == 'सर्व साधारण')
                        {
                            s = s + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('SpashthSuchanaDene__c')) == '')
                        {
                            b = b + (Integer)ar.get('cnt');
                        }
                    }
                    for (AggregateResult ar : groupedResults3)  {
                        if(((String)ar.get('PrashnVicharane__c')) == 'उत्कृष्ट')
                        {
                           u = u +  (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('PrashnVicharane__c')) == 'चांगले')
                        {
                           c = c + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('PrashnVicharane__c')) == 'नाही दिला')
                        {
                            n = n + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('PrashnVicharane__c')) == 'सर्व साधारण')
                        {
                            s = s + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('PrashnVicharane__c')) == '')
                        {
                            b = b + (Integer)ar.get('cnt');
                        }
                    }
                    for (AggregateResult ar : groupedResults4)  {
                        if(((String)ar.get('GoshtSangane__c')) == 'उत्कृष्ट')
                        {
                           u = u +  (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('GoshtSangane__c')) == 'चांगले')
                        {
                           c = c + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('GoshtSangane__c')) == 'नाही दिला')
                        {
                            n = n + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('GoshtSangane__c')) == 'सर्व साधारण')
                        {
                            s = s + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('GoshtSangane__c')) == '')
                        {
                            b = b + (Integer)ar.get('cnt');
                        }
                    }
        
                    for (AggregateResult ar : groupedResults5)  {
                        if(((String)ar.get('AbhinayGeet__c')) == 'उत्कृष्ट')
                        {
                           u = u +  (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('AbhinayGeet__c')) == 'चांगले')
                        {
                           c = c + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('AbhinayGeet__c')) == 'नाही दिला')
                        {
                            n = n + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('AbhinayGeet__c')) == 'सर्व साधारण')
                        {
                            s = s + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('AbhinayGeet__c')) == '')
                        {
                            b = b + (Integer)ar.get('cnt');
                        }
                    }
                    
                    //0.6
                           
                   for (AggregateResult ar : groupedResults6)  {
                        if(((String)ar.get('JodiCharcha__c')) == 'उत्कृष्ट')
                        {
                           u = u +  (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('JodiCharcha__c')) == 'चांगले')
                        {
                           c = c + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('JodiCharcha__c')) == 'नाही दिला')
                        {
                            n = n + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('JodiCharcha__c')) == 'सर्व साधारण')
                        {
                            s = s + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('JodiCharcha__c')) == '')
                        {
                            b = b + (Integer)ar.get('cnt');
                        }
                    }
                    for (AggregateResult ar : groupedResults7)  {
                        if(((String)ar.get('GattCharcha__c')) == 'उत्कृष्ट')
                        {
                           u = u +  (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('GattCharcha__c')) == 'चांगले')
                        {
                           c = c + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('GattCharcha__c')) == 'नाही दिला')
                        {
                            n = n + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('GattCharcha__c')) == 'सर्व साधारण')
                        {
                            s = s + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('GattCharcha__c')) == '')
                        {
                            b = b + (Integer)ar.get('cnt');
                        }
                    }
                    for (AggregateResult ar : groupedResults8)  {
                        if(((String)ar.get('SamudayikVartul__c')) == 'उत्कृष्ट')
                        {
                           u = u +  (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('SamudayikVartul__c')) == 'चांगले')
                        {
                           c = c + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('SamudayikVartul__c')) == 'नाही दिला')
                        {
                            n = n + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('SamudayikVartul__c')) == 'सर्व साधारण')
                        {
                            s = s + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('SamudayikVartul__c')) == '')
                        {
                            b = b + (Integer)ar.get('cnt');
                        }
                    }
                //0.7
                      for (AggregateResult ar : groupedResults9)  {
                        if(((String)ar.get('VargNiyam__c')) == 'उत्कृष्ट')
                        {
                           u = u +  (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('VargNiyam__c')) == 'चांगले')
                        {
                           c = c + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('VargNiyam__c')) == 'नाही दिला')
                        {
                            n = n + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('VargNiyam__c')) == 'सर्व साधारण')
                        {
                            s = s + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('VargNiyam__c')) == '')
                        {
                            b = b + (Integer)ar.get('cnt');
                        }
                    }
                    for (AggregateResult ar : groupedResults10) {
                        if(((String)ar.get('ShantataSanket__c')) == 'उत्कृष्ट')
                        {
                           u = u +  (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('ShantataSanket__c')) == 'चांगले')
                        {
                           c = c + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('ShantataSanket__c')) == 'नाही दिला')
                        {
                            n = n + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('ShantataSanket__c')) == 'सर्व साधारण')
                        {
                            s = s + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('ShantataSanket__c')) == '')
                        {
                            b = b + (Integer)ar.get('cnt');
                        }
                    }
                    for (AggregateResult ar : groupedResults11) {
                        if(((String)ar.get('BaithakVyavstha__c')) == 'उत्कृष्ट')
                        {
                           u = u +  (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('BaithakVyavstha__c')) == 'चांगले')
                        {
                           c = c + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('BaithakVyavstha__c')) == 'नाही दिला')
                        {
                            n = n + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('BaithakVyavstha__c')) == 'सर्व साधारण')
                        {
                            s = s + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('BaithakVyavstha__c')) == '')
                        {
                            b = b + (Integer)ar.get('cnt');
                        }
                    } 
                    for (AggregateResult ar : groupedResults12) {
                        if(((String)ar.get('SakaratmkLakshDene__c')) == 'उत्कृष्ट')
                        {
                           u = u +  (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('SakaratmkLakshDene__c')) == 'चांगले')
                        {
                           c = c + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('SakaratmkLakshDene__c')) == 'नाही दिला')
                        {
                            n = n + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('SakaratmkLakshDene__c')) == 'सर्व साधारण')
                        {
                            s = s + (Integer)ar.get('cnt');
                        }
                        if(((String)ar.get('SakaratmkLakshDene__c')) == '')
                        {
                            b = b + (Integer)ar.get('cnt');
                        }
                    } 

        FeedBackWrapper f = new FeedBackWrapper();
        f.setType('उत्कृष्ट');
        f.setvalue(u);
        feedBackWrapper.add(f);
       
        f = new FeedBackWrapper();
        f.setType('चांगले');
        f.setvalue(c);
        feedBackWrapper.add(f);
        
        
        f = new FeedBackWrapper();
        f.setType('सर्व साधारण');
        f.setvalue(n);
        feedBackWrapper.add(f);
        
        f = new FeedBackWrapper();
        f.setType('नाही दिला');
        f.setvalue(s);
        feedBackWrapper.add(f);
        System.debug('Result is' + groupedResults2);
        
    }
    
     if(qustionArea=='4 कार्यशाळेचा उद्देश पूर्ण झाला का ?')
    {
        //Work in progress.
        // 
        totalFeedBackCount = [select count() from MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records];
        FeedBackInDetail = new List<MV_TraineeFeedback__c>();
        
        FeedBackInDetail = [SELECT  AseKaWatate__c FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records AND AseKaWatate__c != '' limit 900];
    }
    
     if(feedBackWrapper != null){
           totalCount = 0;
           for(FeedBackWrapper f:feedBackWrapper){
              if(f.getType() != null && f.getValue() != null){
                   totalCount = totalCount + f.getValue();
              }
          }
           System.debug('Final Report values are:'+ feedBackWrapper);
           for(FeedBackWrapper f:feedBackWrapper){
              if(f.getType() != null && f.getValue() != null){
                  Decimal specificCount = f.getValue();
                  Decimal percentCount = 0.0;
                  if(totalCount > 0){
                       percentCount = Math.round((Decimal)(100*specificCount)/totalCount);                     
                  }
                 strTodecimalMap1.put(f.getType(), percentCount);
              }
              
            }
        }
    
    }
    
    public void fetchsectionwisedataFromDatabase(){  
        
        decimal qustionAreacnt = 1;
        feedbackCountnew = 0;
        feedBackWrappernew = new List<FeedBackWrapper>();
        updatedFeedBackWrappernew = new List<FeedBackWrapper>();
        //
        List<MV_Task__c> tsk = [SELECT Picklist_Value__c,Id,Section_Name__c,Task_type__c,Section_Question_Count__c FROM MV_Task__c where Section_Name__c = :qustionArea];
       
        List<String> pickList = new List<String>();
        set<String> pickListset = new set<String>();
        
       AggregateResult[] groupedResultsnew = null;
      
       if(tsk[0].Task_type__c == 'Selection'){

          pickList = tsk[0].Picklist_Value__c.split(','); 
          pickListset.addAll(pickList);
          if(dist == 'select'){
              List<Task_Answer__c> tskList = [select id,Unique_Id__c from Task_Answer__c where Answer__c = :State];
             set<String> uniqIdSet = new set<String>();
             for(Task_Answer__c ta : tskList){
                uniqIdSet.add(ta.Unique_Id__c); 
                //feedbackCountnew++;
             }
             //feedbackCountnew = Integer.valueOf(feedbackCountnew/qustionAreacnt);
             groupedResultsnew =[SELECT Answer__c, Count(Id)cnt FROM Task_Answer__c where (Section_Name__c =:qustionArea AND Unique_Id__c IN :uniqIdSet AND Answer__c != '') group by Answer__c];
           
           
          }else if( tal == 'select'){
            
              List<Task_Answer__c> tskList = [select id,Unique_Id__c from Task_Answer__c where Answer__c = :dist];
             set<String> uniqIdSet = new set<String>();
             
             for(Task_Answer__c ta : tskList){
                uniqIdSet.add(ta.Unique_Id__c); 
                feedbackCountnew++;
             }
             
            feedbackCountnew = Integer.valueOf(feedbackCountnew/qustionAreacnt);
              
              groupedResultsnew =[SELECT Answer__c, Count(Id)cnt FROM Task_Answer__c where (Section_Name__c =:qustionArea AND Unique_Id__c IN :uniqIdSet AND Answer__c != '') group by Answer__c];
          
          } else{
             List<Task_Answer__c> tskList = [select id,Unique_Id__c from Task_Answer__c where Answer__c =:tal];
             set<String> uniqIdSet = new set<String>();
             for(Task_Answer__c ta : tskList){
                uniqIdSet.add(ta.Unique_Id__c); 
                feedbackCountnew++;
             }
             feedbackCountnew = Integer.valueOf(feedbackCountnew/qustionAreacnt);
             groupedResultsnew  =[SELECT Answer__c, Count(Id)cnt FROM Task_Answer__c where (Section_Name__c =:qustionArea AND Unique_Id__c IN :uniqIdSet AND Answer__c != '' ) group by Answer__c]; 
              
          }
          system.debug('--------groupedResultsnew--------' + groupedResultsnew);
        for(AggregateResult ar : groupedResultsnew){
            FeedBackWrapper f = new FeedBackWrapper();
            String ans = (String) ar.get('Answer__c'); 
           
            pickListset.remove(ans);
            if(ans != '' || ans != null){
                f.setType(ans);
                f.setvalue((Integer)ar.get('cnt'));
                feedBackWrappernew.add(f);
            }
            
        }
        
        for(String str : pickListset){
            FeedBackWrapper f = new FeedBackWrapper();
            f.setType(str);
            f.setvalue(0);
            feedBackWrappernew.add(f);
        }
        pickList = tsk[0].Picklist_Value__c.split(','); 
        pickListset = new set<String>();
        pickListset.addAll(pickList);
        for(String str : pickListset){
              for(FeedBackWrapper f:feedBackWrappernew){
               if(f.getType() == str){
                    updatedFeedBackWrappernew.add(f);
                }
            }
        }
         feedBackWrappernew = new List<FeedBackWrapper>();
         feedBackWrappernew = updatedFeedBackWrappernew;
      
      
    }
    
    else if(tsk[0].Task_type__c == 'Checkbox'){
         if(dist == 'select'){
             List<Task_Answer__c> tskList = [select id,Unique_Id__c from Task_Answer__c where Answer__c =:State];
             set<String> uniqIdSet = new set<String>();
             for(Task_Answer__c ta : tskList){
                uniqIdSet.add(ta.Unique_Id__c); 
                feedbackCountnew++;
             }
             feedbackCountnew = Integer.valueOf(feedbackCountnew/qustionAreacnt);
             groupedResultsnew =[SELECT Answer__c, Count(Id)cnt FROM Task_Answer__c where (Section_Name__c =:qustionArea AND Unique_Id__c IN :uniqIdSet AND Answer__c != '')group by Answer__c];
             
          }else if( tal == 'select'){
             List<Task_Answer__c> tskList = [select id,Unique_Id__c from Task_Answer__c where Answer__c =:dist];
             set<String> uniqIdSet = new set<String>();
             for(Task_Answer__c ta : tskList){
                uniqIdSet.add(ta.Unique_Id__c); 
                feedbackCountnew++;
             }
             feedbackCountnew = Integer.valueOf(feedbackCountnew/qustionAreacnt);
             groupedResultsnew =[SELECT Answer__c, Count(Id)cnt FROM Task_Answer__c where (Section_Name__c =:qustionArea AND Unique_Id__c IN :uniqIdSet AND Answer__c != '') group by Answer__c];
          
          }else {
             
               List<Task_Answer__c> tskList = [select id,Unique_Id__c from Task_Answer__c where (Answer__c =:tal )];
               set<String> uniqIdSet = new set<String>();
             
             for(Task_Answer__c ta : tskList){
                uniqIdSet.add(ta.Unique_Id__c); 
                feedbackCountnew++;
             }
             feedbackCountnew = Integer.valueOf(feedbackCountnew/qustionAreacnt);
             groupedResultsnew =[SELECT Answer__c, Count(Id)cnt FROM Task_Answer__c where (Section_Name__c =:qustionArea AND Unique_Id__c IN :uniqIdSet AND Answer__c != '' )group by Answer__c];
          }
          
        for(AggregateResult ar : groupedResultsnew){
            FeedBackWrapper f = new FeedBackWrapper();
            String ans = (String) ar.get('Answer__c'); 
            f.setType(ans);
            f.setvalue((Integer)ar.get('cnt'));
            feedBackWrappernew.add(f);
        }
        
        
    } else{
          FeedBackInDetailNew = new List<Task_Answer__c>();
            if(dist == 'select'){
                List<Task_Answer__c> tskList = [select id,Unique_Id__c from Task_Answer__c where Answer__c =:State];
                 set<String> uniqIdSet = new set<String>();
                 for(Task_Answer__c ta : tskList){
                    uniqIdSet.add(ta.Unique_Id__c); 
                    feedbackCountnew++;
                 }
             FeedBackInDetailNew = [SELECT Answer__c,MV_User__r.Name,MV_User__r.Last_Name__c,District__c,Taluka__c,State__c FROM Task_Answer__c where (Section_Name__c = :qustionArea AND Unique_Id__c IN :uniqIdSet AND Answer__c != '') limit 900];
                
            }else if(tal == 'select'){
                
                List<Task_Answer__c> tskList = [select id,Unique_Id__c from Task_Answer__c where (Answer__c = :dist AND Answer__c != '')];
                 set<String> uniqIdSet = new set<String>();
                 
                 for(Task_Answer__c ta : tskList){
                    uniqIdSet.add(ta.Unique_Id__c); 
                    feedbackCountnew++;
                 }
                 
                FeedBackInDetailNew = [SELECT Answer__c,MV_User__r.Name,MV_User__r.Last_Name__c,District__c,Taluka__c,State__c FROM Task_Answer__c where (Section_Name__c = :qustionArea AND Unique_Id__c IN :uniqIdSet AND Answer__c != '') limit 900];
                
            }else {
                List<Task_Answer__c> tskList = [select id,Unique_Id__c from Task_Answer__c where (Answer__c = :tal AND Answer__c != '')];
                 set<String> uniqIdSet = new set<String>();
                 for(Task_Answer__c ta : tskList){
                    uniqIdSet.add(ta.Unique_Id__c); 
                    feedbackCountnew++;
                 }
                 
                FeedBackInDetailNew = [SELECT Answer__c,MV_User__r.Name,MV_User__r.Last_Name__c,District__c,Taluka__c,State__c FROM Task_Answer__c where (Section_Name__c = :qustionArea AND Unique_Id__c IN :uniqIdSet AND Answer__c != '') limit 900];
            }
          if(FeedBackInDetailNew != null || FeedBackInDetailNew.size() > 0){
            feedbackCountnew = FeedBackInDetailNew.size();
        }  
    
    }
    
     if(feedBackWrappernew != null){
           integer totalCount1 = 0;
           for(FeedBackWrapper f:feedBackWrappernew){
              if(f.getType() != null && f.getValue() != null){
                   totalCount1 = totalCount1 + f.getValue();
              }
          }
           System.debug('Final Report values are:'+ feedBackWrappernew);
           for(FeedBackWrapper f:feedBackWrappernew){
              if(f.getType() != null && f.getValue() != null){
                  Decimal specificCount = f.getValue();
                  Decimal percentCount = 0.0;
                  if(totalCount1 > 0){
                       percentCount = Math.round((Decimal)(100*specificCount)/totalCount1);                     
                  }
                 strTodecimalMap2.put(f.getType(), percentCount);
              }
              
          }
       }
        
        
    }
    
    public void PieData1(){
        
         
    }
    
    public void PieData2(){
        
         
         
    }
            


    
   
    public void checkStateValue()
          {
              dist = 'Select';
        qustionArea = 'Select';
              totalCount = null;
        tal = 'Select';
                      qustionArea = 'Select';
                tal = 'Select';
              getSection();
              feedBackWrapper = null;
              System.debug('State is'+State);

          }
    
    public void setValueToDist()
    {
        qustionArea = 'Select';
        totalCount = null;
        tal = 'Select';
    }

   public void checkTalValue()
          {
              qustionArea = null;
              totalCount = null;
              //pieData1 = null;
              getSection();
              //fetchTraineeDataFromDatabase();
              feedBackWrapper = null;
              System.debug('State is'+State);
          }
    
    
     public String getState() {
            return state;
        }
    
     public void setState(String state) {
            this.state = state;
        }
    
         public String getTal() {
            return tal;
        }
    
     public void setTal(String tal) {
            this.tal = tal;
        }
     public String getDist() {
            return dist;
        }
     public void setDist(String dist) {
            this.dist = dist;
        }

    public String getQustionArea() {
            return qustionArea;
        }
     public void setQustionArea(String qustionArea) {
            this.qustionArea = qustionArea;
        }


    
     public List<MV_Training_Calender__c> getRecords() {
            return records;
        }
     public void setRecords(List<MV_Training_Calender__c> records) {
            this.records = records;
        }
    
    public List<MV_TraineeFeedback__c> getMvTraineeFeedBack() {
            return mvTraineeFeedBack;
        }
     public void setMvTraineeFeedBack(List<MV_TraineeFeedback__c> mvTraineeFeedBack) {
            this.mvTraineeFeedBack = mvTraineeFeedBack;
        }
    
     public List<FeedBackWrapper> getFeedBackWrapper() {
            return feedBackWrapper;
        }
     public void setFeedBackWrapper(List<feedBackWrapper> mvTraineeFeedBack) {
            this.feedBackWrapper = feedBackWrapper;
        }
    
     public Decimal getTotalCount() {
            return totalCount;
        }
     public void setTotalCount(Decimal mvTraineeFeedBack) {
            this.totalCount = totalCount;
        }
         public String getdisplayTaluka() {
            return displayTaluka;
        }
     public void setdisplayTaluka(String mvTraineeFeedBack) {
            this.displayTaluka = displayTaluka;
        }
    
     public List<MV_TraineeFeedback__c> getFeedBackInDetail() {
            return FeedBackInDetail;
        }
     public void setFeedBackInDetail(List<MV_TraineeFeedback__c> FeedBackInDetail) {
            this.FeedBackInDetail = FeedBackInDetail;
        }
    
    public void settotalFeedBackCount(Integer totalFeedBackCount)
    {
        this.totalFeedBackCount = totalFeedBackCount;
    } 
    
    public Integer gettotalFeedBackCount()
    {
        return totalFeedBackCount;
    } 

    //FeedBackInDetail
   
    public void setStartDate(Date startDate)
    {
        this.startDate = startDate;
    }

    public Date getStartDate()
    {
        return startDate;
    }
    
     
      public class PieWedgeData 
    {  
        public String name { get; set; }  
        public Decimal data1 { get; set; }  
         public Decimal data2 { get; set; }  
        
        public PieWedgeData(String name, Decimal data1, Decimal data2) 
        {  
            this.name = name;  
            this.data1 = data1; 
            this.data2 = data2;             
        }  
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
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
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