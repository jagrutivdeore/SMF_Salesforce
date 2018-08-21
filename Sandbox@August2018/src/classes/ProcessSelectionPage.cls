public class ProcessSelectionPage{

    public ProcessSelectionPage(ApexPages.StandardController controller) {

    }

    
    Public id selectProcess{get;set;}
    
        Public List<Selectoption> getselectedProcess(){
        
            List<Selectoption> processList = new List<selectoption>();
            processList.add(new selectOption('', '--Select--'));
            
            for(MV_Process__c process :[SELECT id,name FROM MV_Process__c]){
            
                processList.add(new selectoption(process.id,process.name));
            }
            return processList; 
        }
        
        
        public pagereference redirect(){
            PageReference pageRef= new PageReference('/apex/'+selectProcess);
            pageRef.setredirect(true);
            return pageRef;
        }
}