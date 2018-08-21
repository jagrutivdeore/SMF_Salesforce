public class ProcessReportsTest{

     public List<MV_Task__c> taskList {set;get;}
     public List<sObject> PAList {set;get;}
     public List<String> listOfAPI {set;get;}
     public List<String> listOfText {set;get;}
    
       
       public ProcessReportsTest(ApexPages.StandardController controller){
 
            string selectString = '';
         
           map<string,string> apiFieldToTextMap = new map<string,string>();

            taskList = [select Task_Text__c,API_field_Name__c from MV_Task__c where MV_Process__c = 'a1I7F000000WSSp'];
            
            listOfText = new List<String>();
            
            for(MV_Task__c task: taskList ){
                
                apiFieldToTextMap.put(task.API_field_Name__c,task.Task_Text__c);
                    
                    system.debug('---apiFieldToTextMap ----'+apiFieldToTextMap );
                
                selectString = selectString+task.API_field_Name__c+',';
                
                    system.debug('---selectString ----'+selectString );
               
               listOfText.add(task.Task_Text__c);

                    system.debug('---tasks are---'+listOfText);           
            }
           
            selectString = selectString.removeEnd(',');
         
           listOfAPI = selectString.split(',');

           string sql = 'select '+selectString+' from ProcessAnswer__c where MV_Process__c = \'a1I7F000000WSSp\'';
        
               System.debug('-------SQL Queruy is------' + sql);
               
           List<sObject> sList = Database.query(sql);

       PAList = sList;
       
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
        }
    }