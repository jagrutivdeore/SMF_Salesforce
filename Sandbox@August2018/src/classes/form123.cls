public class form123{

    public String Process{get; set;}
    
    public form123(ApexPages.StandardController controller) {
    
        Process = 'select';
    }

    public List<SelectOption> getProcessList() {
        
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Select','Select'));
            AggregateResult[] groupedResults = [SELECT Name, Count(Id) FROM MV_Process__c GROUP BY Name];
            for (AggregateResult ar : groupedResults)  {
                options.add(new SelectOption((String)ar.get('Name'),(String)ar.get('Name')));
            }
            
            return options;
    }
}