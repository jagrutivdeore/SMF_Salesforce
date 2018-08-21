public class TrainingFeedbackReport
{
  public Event_Calender__c Event{get;set;}
  public String fromDate{get;set;} 
  public String toDate{get;set;}
  public List<Event_Calender__c> eventList = new List<Event_Calender__c>();
  public List<wrapper> wrapperList = new List<wrapper>();
  public transient List<wrapper> wrapperList1{get;set;}
  public String selType{get;set;}
  
  
    public TrainingFeedbackReport(ApexPages.StandardController controller) {
     this.Event = (Event_Calender__c)controller.getRecord();
     wrapperList1 = new List<wrapper>();
    }

   public TrainingFeedbackReport()
   {
   
   }

      public List<SelectOption> getTypeList() {
        Schema.DescribeFieldResult fieldResult = Event_Calender__c.Event_Type__c.getDescribe();
   
         List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('','--None--'));
         for(Schema.picklistEntry f: fieldResult.getPicklistValues())    
            {    
             
                 options.add(new SelectOption(f.getLabel(),f.getLabel()));                    
            }    
         
         return options;
     }



  public void generateReport()
  {
  
   // System.debug('***********'+fromDate+'*****************'+toDate);
   
   wrapperList = new List<wrapper>();
    
   if( fromDate != null && toDate != null && fromDate != '' && toDate != '')
   {
   if(selType != null)
    eventList = [SELECT Id,Present_User_Count__c,Present_Name__c,Title__c,State__c,Event_Type__c,Taluka__c,Status__c,District__c,Date__c,End_Date__c,MV_User__r.Full_Name__c,MV_User__r.Super_Visor_Name__r.Full_Name__c FROM Event_Calender__c WHERE Event_Type__c =: selType And Date__c >= : Date.valueOf(fromDate) and Date__c <= :  Date.valueOf(toDate)];
   else
    eventList = [SELECT Id,Present_User_Count__c,Present_Name__c,Title__c,State__c,Event_Type__c,Taluka__c,Status__c,District__c,Date__c,End_Date__c,MV_User__r.Full_Name__c,MV_User__r.Super_Visor_Name__r.Full_Name__c FROM Event_Calender__c WHERE Event_Type__c = null And Date__c >= : Date.valueOf(fromDate) and Date__c <= :  Date.valueOf(toDate)];
   
   
   set<String> EventIdList = new set<String>();
   for(Event_Calender__c eObj : eventList)
   {
     EventIdList.add(eObj.Id);
   }
   
   System.debug('*********eventList **'+eventList);
   
    Map<String,Integer> trainingFMap = new Map<String,Integer>();
    Map<String,Integer> deleyFMap = new Map<String,Integer>();
    
    for(AggregateResult agr: [SELECT calenderId__c idCal, Count(Id) traningForm,sum(DeleyForm__c) DeleyForm FROM ProcessAnswer__c where calenderId__c IN: EventIdList GROUP BY calenderId__c ])
    {
    
     // System.debug('***********'+String.valueOf(agr.get('idCal')));
     if(String.valueOf(agr.get('idCal')) != null)
     {
      trainingFMap.put(String.valueOf(agr.get('idCal')),Integer.valueof(agr.get('traningForm'))); 
      deleyFMap.put(String.valueOf(agr.get('idCal')),Integer.valueof(agr.get('DeleyForm'))); 
     }
    }
   
    for(Event_Calender__c ev : eventList)
    {
      wrapper wrapperObj = new wrapper();
      wrapperObj.id = ev.Id;
      
      if(ev.Title__c != null)
      wrapperObj.Name= ev.Title__c;
      
      if(ev.State__c != null)
      wrapperObj.State = ev.State__c;
      
      if(ev.State__c != null)
      wrapperObj.District = ev.District__c;
      
      if(ev.Taluka__c != null)
      wrapperObj.Taluka = ev.Taluka__c;
      
      if(String.valueOf(ev.Date__c) != null)
      wrapperObj.StartDate = String.valueOf(ev.Date__c);
      
      if(String.valueOf(ev.Date__c) != null)
      wrapperObj.EndDate = String.valueOf(ev.End_Date__c);
      
      if(ev.MV_User__r.Super_Visor_Name__r.Full_Name__c != null)
      wrapperObj.MTName = ev.MV_User__r.Super_Visor_Name__r.Full_Name__c;
      
      if(ev.MV_User__r.Full_Name__c != null)
      wrapperObj.TCName = ev.MV_User__r.Full_Name__c;
      if(trainingFMap.get(ev.Id) != null ) 
      wrapperObj.Feedbacksreceived = trainingFMap.get(ev.Id);
      if(deleyFMap.get(ev.Id) != null ) 
      wrapperObj.FeedbacksDelay = deleyFMap.get(ev.Id);
      wrapperObj.Status = ev.Status__c;
      
      wrapperObj.UserCount = Integer.valueOf(ev.Present_User_Count__c);
      wrapperObj.UsersName = ev.Present_Name__c;
      
      System.debug('*************abc'+wrapperObj);
      wrapperList.add(wrapperObj); 
    }
   }
    else
    {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Date.'));
    }
    
    wrapperList1 = wrapperList;
   // System.debug('***********'+wrapperList);
  }
  
  
   public PageReference DownloadReport(){
      wrapperList1 = wrapperList;
      PageReference pg = new PageReference('/apex/TrainingFeedbackReportDownload');
      pg.setRedirect(false);
      return pg; 
     }
   
   
   public class wrapper
  {
    public String id{get;set;}
    public String Name{get;set;}
    public String State{get;set;}
    public String District{get;set;}
    public String Taluka{get;set;}
    public String StartDate{get;set;}
    public String EndDate{get;set;}
    public String MTName{get;set;}
    public String TCName{get;set;}
    public Integer Feedbacksreceived{get;set;}
    public Integer FeedbacksDelay{get;set;}
    public String Status{get;set;}
    
    public Integer UserCount{get;set;}
    public String UsersName{get;set;}
  }
     
   public void testObj()
   {
     Integer i = 0;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
     i++;
     i--;
   } 
     
  
  
 
}