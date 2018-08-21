public class ProcessReportsController{

     Public transient id selectProcess{get;set;}
     public transient List<ProcessAnswer__c> ProcessAnsList{get; set;}
     //List <MV_Task__c> tsk {set;get;}
     private List<MV_Task__c> taskList = new List<MV_Task__c>();  
     public transient List<sObject> PAList {set;get;}
     public transient List<String> listOfAPI {set;get;}
     public transient List<String> listOfText {set;get;}
     public transient String Name{set;get;}
     public transient String ReportName{set;get;}
     
     
     /*--------Pagination-------*/
     private integer totalRecs = 0;     
     private integer index = 0;
     private integer blockSize = 5000; 
   
    /*--------Pagination-------*/
     
    public ProcessReportsController()
    {
       totalRecs = [select count() from ProcessAnswer__c where MV_Process__c =: selectProcess]; 
       System.debug('-------'+totalRecs);       
    }
        Public List<Selectoption> getselectedProcess(){
        
            List<Selectoption> processList = new List<selectoption>();
            processList.add(new selectOption('', '--Select--'));
            
            for(MV_Process__c process :[SELECT id,name FROM MV_Process__c]){
            
                processList.add(new selectoption(process.id,process.name));
            }
            return processList; 
        }
        
      
      public void generateReport()
      {
       totalRecs = 0;     
       index = 0;
       blockSize = 5000; 
       getPAList();
      }
       public void getPAList()
       {
       
       totalRecs = [select count() from ProcessAnswer__c where MV_Process__c =: selectProcess]; 
       System.debug('-------'+totalRecs); 
       
       listOfAPI = new List<String>();
       PAList = new List<sObject>();
       taskList = new List<MV_Task__c>(); 
        
        List<MV_Process__c> mv_pro = [select Name,Report_Name__c From MV_Process__c where id =: selectProcess limit 1];
          
         if(mv_pro.size() > 0 )
         { 
          Name = mv_pro[0].Name;
          ReportName = 'application/octet-stream#'+mv_pro[0].Report_Name__c+'.xls;'; 
          }
           taskList = [select Task_Text__c,API_field_Name__c from MV_Task__c where MV_Process__c =: selectProcess];
           string selectString = '';
         
           map<string,string> apiFieldToTextMap = new map<string,string>();

            listOfText = new List<String>();
            for(MV_Task__c task: taskList ){
              
              if(task.API_field_Name__c != null)
              {  
                apiFieldToTextMap.put(task.API_field_Name__c,task.Task_Text__c);
                selectString = selectString+task.API_field_Name__c+',';
                listOfText.add(task.Task_Text__c);

             }        
            }
           
            selectString = selectString.removeEnd(',');
         
           listOfAPI = selectString.split(',');
          
         if(listOfAPI.size() > 1)     
         { 
       
           string sql = 'select '+selectString+' from ProcessAnswer__c where MV_Process__c =\'' + selectProcess +'\' LIMIT '+blockSize+ ' OFFSET '+index;
      
        for(sObject s: Database.query(sql)){
          PAList.add(s);
        } 
       }
     }
    
    
     public PageReference DownloadExcelReport(){
     
     PageReference pg = new PageReference('/apex/ProcessReportDownload?id='+selectProcess);
      pg.setRedirect(false);
      return pg; 
     }
    
    
    public void beginning()
    {
        index = 0;
        getPAList();
    }
    
    public void previous()
    {
        index = index - blockSize;
        getPAList();
    }
    
    public void next()
    {
       index = index + blockSize;
       getPAList();
    }

    public void end()
    {
        index = totalrecs - math.mod(totalRecs,blockSize);
        getPAList();
    }        
    
      public boolean getprev()
    {
        if(index == 0)
        return true;
        else
        return false;
    }  
    
    public boolean getnxt()
    {
        if((index + blockSize) > totalRecs)
        return true;
        else
        return false;
    }      
    
    
   
   
    
    }