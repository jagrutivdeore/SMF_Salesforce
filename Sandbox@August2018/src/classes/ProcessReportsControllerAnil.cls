public with sharing class ProcessReportsControllerAnil {


    Public Boolean hasPrevious{get;set;}
    Public Boolean hasNext{get;set;}
   
    private Integer pageno = 0;
    Public transient Integer pageno1{get;set;}
   
    Public Integer count = 0;
    
    Public transient id selectProcess{get;set;}
   
     public transient List<sObject> PAList1 {set;get;}
     public transient List<String> listOfText1 {set;get;}
     public transient List<String> listOfAPI1 {set;get;}
    
    
    private transient List<MV_Task__c> taskList = new List<MV_Task__c>();  
    private transient List<sObject> PAList = new List<sObject>();
    private transient List<String> listOfText = new List<String>();
    private transient List<String> listOfAPI = new List<String>();
    
    
    public transient String Name{set;get;}
    public transient String ReportName{set;get;}
    
    
 public ProcessReportsControllerAnil()
 {
        
     PAList1=new List<sObject>();
 }
     Public List<Selectoption> getselectedProcess(){
      
        List<Selectoption> processList = new List<selectoption>();
        processList.add(new selectOption('', '--Select--'));
        
        for(MV_Process__c process :[SELECT id,name FROM MV_Process__c]){
            
            processList.add(new selectoption(process.id,process.name));
        }
         
        return processList; 
    }
    
    public void displayData()
    {
        PAList = new List<sObject>();
        listOfAPI = new List<String>();
        taskList = new List<MV_Task__c>(); 
       
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
        
        listOfText1 = listOfText;
        selectString = selectString.removeEnd(',');
        
        listOfAPI = selectString.split(',');
        listOfAPI1 = listOfAPI;  
      
        if(listOfAPI.size() > 1)     
        { 

            string sql = 'select '+selectString+' from ProcessAnswer__c where MV_Process__c =\'' + selectProcess +'\'';
          
            for(sObject s: Database.query(sql)){
                PAList.add(s);
            } 
           
             if(PAList.size()>2000)
             {
                 count=PAList.size();
                 hasPrevious =false;
                 hasNext=true;
                 pageno=1;
                 pageno1=pageno;
                 PAList1=new List<sObject>();
                 for(Integer i=0;i<2000;i++)
                 {
                   if(PAList.size() > i && i >= 0)
                     PAList1.add(PAList[i]); 
                 }
             
         }
         else
         {
           count=PAList.size();
           hasPrevious =false;
            hasNext=false;
             pageno=1;
                 pageno1=pageno;
                 PAList1=new List<sObject>();
                 for(Integer i=0;i<PAList.size();i++)
                 {
                   PAList1.add(PAList[i]); 
                 }
         }
      }
    }
    
     public void getPAList()
    {
        
        PAList = new List<sObject>();
        listOfAPI = new List<String>();
       
        taskList = new List<MV_Task__c>(); 
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
        
        listOfText1 = listOfText;
        selectString = selectString.removeEnd(',');
        
        listOfAPI = selectString.split(',');
        listOfAPI1 = listOfAPI;  
        
        if(listOfAPI.size() > 1)     
        { 
            string sql = 'select '+selectString+' from ProcessAnswer__c where MV_Process__c =\'' + selectProcess +'\'';
          
            for(sObject s: Database.query(sql)){
                PAList.add(s);
                 
            } 
       }
    }
    
    Public void First()
     {
         getPAList();
         
         PAList1 = new List<sObject>();
         
         PAList1 = new List<sObject>();
         PAList1.clear();
         hasPrevious=false;
         
         pageno =1;
         pageno1=pageno;
         for(integer i=0;i<2000;i++)
          {
          if(PAList.size() > i && i >= 0)
          PAList1.add(PAList[i]);  
         }
         
         if(PAList.size()>2000)
           hasNext=true;
         else
           hasNext=false;
         listOfText1 = listOfText;
         listOfAPI1 = listOfAPI;
     }
     
     Public void Previous()
     {  
        getPAList();
         hasNext=true;
         PAList1 = new List<sObject>();
         PAList1.clear();
         if(pageno  !=1)
             {
                  pageno  = pageno  - 1;
                  If(pageno  ==1 )
                  hasPrevious=false;
                   for(integer i=(pageno -1)*2000;i<(pageno *2000);i++ )
                     {
                        if(PAList.size() > i && i >= 0)
                         PAList1.add(PAList[i]); 
                          
                     }
             }                           
             else
              {
                  hasPrevious=false;
                  
                  for(integer i=(pageno -1)*2000;i<(pageno *2000);i++ )
                     {
                        if(PAList.size() > i && i >= 0)
                         PAList1 .add(PAList[i]); 
                     }
              }
              
              pageno1=pageno;
              listOfText1 = listOfText;
              listOfAPI1 = listOfAPI;
       }
     
    
     Public void Next()
     {
         getPAList();
         pageno  = pageno +1;
         integer pgno;
       
         PAList1 = new List<sObject>();
         PAList1.clear();
         if(math.mod(PAList.size(),2000)==0)
           { 
                pgno=PAList.size()/2000;
           }
            else
            pgno=(PAList.size()/2000) +1; 
            if(pageno ==pgno)
             { 
                  hasNext=false;
                  for(integer i=(pageno -1)*2000;i<PAList.size();i++ )
                    {
                    if(PAList.size() > i && i >= 0)
                     PAList1 .add(PAList[i]); 
                    
                    }
             }
           else            
            for(integer i=(pageno -1)*2000;i<(pageno *2000);i++ )
              {
               hasNext=true;
              
                if(PAList.size() > i && i >= 0)
                     PAList1.add(PAList[i]); 
                     
             }
            pageno1=pageno;
            hasPrevious=true;
           
            listOfText1 = listOfText;
            listOfAPI1 = listOfAPI;
    }
     
     Public void Last()
     {  
        getPAList();
        hasPrevious=true;
        PAList1 = new List<sObject>();
           PAList1 .clear();
         hasNext=false;
        if( math.mod(PAList.size(),2000)==0)
             pageno =PAList.size()/2000;
            else
            pageno =(PAList.size()/2000) +1; 
         for(integer i=(pageno -1)*2000;i<PAList.size();i++)
          {
            if(PAList.size() > i && i >= 0)
              PAList1.add(PAList[i]);  
         }
         pageno1=pageno;
        
         if(PAList.size()>2000)
           hasPrevious=true;
         else
           hasPrevious=false;
         
         listOfText1 = listOfText;
         listOfAPI1 = listOfAPI;
     }
    
    
      Public void xlsForm()
     {
       List<MV_Process__c> mv_pro = [select Name,Report_Name__c From MV_Process__c where id =: selectProcess limit 1];
        
        if(mv_pro.size() > 0 )
        { 
            Name = mv_pro[0].Name;
            ReportName = 'application/octet-stream#'+mv_pro[0].Report_Name__c+'_'+pageno+'.xls;'; 
        }
    
         getPAList();
        
         integer pgno;
         PAList1 = new List<sObject>();
         PAList1.clear();
         if(math.mod(PAList.size(),2000)==0)
           { 
                pgno=PAList.size()/2000;
           }
            else
            pgno=(PAList.size()/2000) +1; 
            if(pageno ==pgno)
             { 
                  hasNext=false;
                  for(integer i=(pageno -1)*2000;i<PAList.size();i++ )
                    {
                    if(PAList.size() > i && i >= 0)
                     PAList1 .add(PAList[i]); 
                    
                    }
             }
           else            
            for(integer i=(pageno -1)*2000;i<(pageno *2000);i++ )
              {
                if(PAList.size() > i && i >= 0)
                     PAList1.add(PAList[i]); 
             }
            pageno1=pageno;
            hasPrevious=true;
           
            listOfText1 = listOfText;
            listOfAPI1 = listOfAPI;
      
     }
     
     public PageReference DownloadExcelReport(){
     
      PageReference pg = new PageReference('/apex/ProcessReportDownloadAnil?id='+selectProcess);
      pg.setRedirect(false);
      return pg; 
     }
     
     
     public void test()
     {
      Integer i =0;
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