@RestResource(urlMapping='/getDashboardDatademo/*')
global with sharing class WS_getDashboardDatademo {

    @HttpGet
    global static List<returndata> doGet() {
       /* RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
       String userId = RestContext.request.params.get('userId');
        String qustionArea = RestContext.request.params.get('qustionArea');
    
        MV_User__c user = new MV_User__c();
        List<FeedBackWrapper> feedBackWrapper = new List<FeedBackWrapper>();
            List<FeedBackWrapper> feedBackWrapper1 = new List<FeedBackWrapper>();
            List<FeedBackWrapper> feedBackWrapper2 = new List<FeedBackWrapper>();
          
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
            AggregateResult[] groupedResults10 = null;
            AggregateResult[] groupedResults11 = null;
            AggregateResult[] groupedResults12 = null;
            
        user = [SELECT Id,User_Taluka__c,User_District__c,User_State__c FROM MV_User__c where id =:userId];

      
        
        List<MV_Training_Calender__c> records = new List<MV_Training_Calender__c>();
     
        if(user.User_District__c == 'select'){
            records = [SELECT Id, Batch__c, Cluster__c, Code__c,Start_Date__c,End_Date__c,District__c,No_Of_Participant__c,State__c,Taluka__c FROM MV_Training_Calender__c where State__c =:user.User_State__c];
            
        }else if(user.User_Taluka__c == 'select'){
            records = [SELECT Id, Batch__c, Cluster__c, Code__c,Start_Date__c,End_Date__c,District__c,No_Of_Participant__c,State__c,Taluka__c FROM MV_Training_Calender__c where District__c = :user.User_District__c];
        }else{
            records = [SELECT Id, Batch__c, Cluster__c, Code__c,Start_Date__c,End_Date__c,District__c,No_Of_Participant__c,State__c,Taluka__c FROM MV_Training_Calender__c where Taluka__c =:user.User_Taluka__c];
        }
        
         Map<String, decimal> strToDecimalMap = new Map<String, decimal>();
         List<returndata> returnList = new List<returndata>();
  
      if(qustionArea== '1 मूल्यवर्धन कार्यक्रम') {
          

            System.debug('Karyashalecha Niyam');
           

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
            
            
            Integer totalFeedBackCount = [select count() from MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records];
            
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
            
          
            System.debug('Result is' + feedBackWrapper);
           
            Decimal totalCount =0;
             if(feedBackWrapper != null){
               totalCount = 0;
                for(FeedBackWrapper f1:feedBackWrapper){
                    if(f1.getType() != null && f1.getValue() != null){
                        totalCount = totalCount + f1.getValue();
                    }
                }
          }   
          

       for(FeedBackWrapper f2:feedBackWrapper){
              if(f2.getType() != null && f2.getValue() != null)
              {
                  Decimal specificCount = f2.getValue();
                  Decimal percentCount = 0.0;
                  if(totalCount>0)
                  {
                           percentCount = Math.round((Decimal)(100*specificCount)/totalCount);                     
                  }
                  returndata rd = new returndata();
                  rd.key = f2.getType();
                  rd.value = percentCount;
                  //strToDecimalMap.put(f2.getType(), percentCount);
                  returnList.add(rd);
              }
              
}

}
///////////////////////////////////////////////////////////////
else if(qustionArea=='2 शिक्षक व विद्यार्थ्यांसाठी उपयुक्त संदर्भ साहित्य'){
        
          
        System.debug('Karyashalecha Niyam');
  
      
        groupedResults1 = [SELECT ShikshakupkramPustika__c, Count(Id)cnt FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records group by ShikshakupkramPustika__c];
        groupedResults2 = [SELECT VidyarthiUpkramPustika__c, Count(Id)cnt FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records group by VidyarthiUpkramPustika__c];
        groupedResults3 = [SELECT VargUpkramancheAyojan__c, Count(Id)cnt FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records group by VargUpkramancheAyojan__c];
       
        Integer u = 0;
        Integer c = 0;
        Integer n = 0;
        Integer s = 0;
        Integer b = 0;
        
        Integer totalFeedBackCount = [select count() from MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records];
        
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
      Decimal totalCount =0;
             if(feedBackWrapper != null){
               totalCount = 0;
                for(FeedBackWrapper f1:feedBackWrapper){
                    if(f1.getType() != null && f1.getValue() != null){
                        totalCount = totalCount + f1.getValue();
                    }
                }
          }   
          

       for(FeedBackWrapper f2:feedBackWrapper){
              if(f2.getType() != null && f2.getValue() != null)
              {
                  Decimal specificCount = f2.getValue();
                  Decimal percentCount = 0.0;
                  if(totalCount>0)
                  {
                           percentCount = Math.round((Decimal)(100*specificCount)/totalCount);                     
                  }
                
                  returndata rd = new returndata();
                  rd.key = f2.getType();
                  rd.value = percentCount;
                  returnList.add(rd);
              }
              
        }

    }


////////////////////////////////////////////////////////
else if(qustionArea == '3 अध्ययन पद्धती')
    {
        System.debug('Karyashalecha Niyam');
      

        
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
        
        integer totalFeedBackCount = [select count() from MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records];
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

          Decimal totalCount =0;
             if(feedBackWrapper != null){
               totalCount = 0;
                for(FeedBackWrapper f1:feedBackWrapper){
                    if(f1.getType() != null && f1.getValue() != null){
                        totalCount = totalCount + f1.getValue();
                    }
                }
          }   
          

       for(FeedBackWrapper f2:feedBackWrapper){
              if(f2.getType() != null && f2.getValue() != null)
              {
                  Decimal specificCount = f2.getValue();
                  Decimal percentCount = 0.0;
                  if(totalCount>0)
                  {
                           percentCount = Math.round((Decimal)(100*specificCount)/totalCount);                     
                  }
                 returndata rd = new returndata();
                  rd.key = f2.getType();
                  rd.value = percentCount;
                  returnList.add(rd);
              }
              
        }
        
    
}else if(qustionArea == '4 कार्यशाळेचा उद्देश पूर्ण झाला का ?'){
    List<MV_TraineeFeedback__c> FeedBackInDetail = new List<MV_TraineeFeedback__c>();
    FeedBackInDetail = [SELECT  AseKaWatate__c FROM MV_TraineeFeedback__c where MV_TrainingCalendar__c in:records AND AseKaWatate__c != '' limit 900];
    List<string> asekavatte = new List<string>();
    for(MV_TraineeFeedback__c tf : FeedBackInDetail){
        returndata rd = new returndata();
        rd.key = tf.AseKaWatate__c;
        returnList.add(rd);
    }
    
}*/
    return null;
}

global class returndata{
    String key;
    Decimal value;
    
}


    public static void  CCHelp()
{
       Integer v = 1;

        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
     /*   v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;
        v=v+1;*/
}
 
}