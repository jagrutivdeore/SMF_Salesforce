global with sharing class demoForTalukaTable {
    public String stateName {get;set;}
    public String districtName {get;set;}
   
 
      public demoForTalukaTable() {
          
      }
     
     public List<SelectOption> getstateList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Select','Select'));
        AggregateResult[] groupedResults = [SELECT Name, Count(Id) FROM State__c GROUP BY Name];
        for (AggregateResult ar : groupedResults)  {
            options.add(new SelectOption((String)ar.get('Name'),(String)ar.get('Name')));
        }
        system.debug('--------------'+options.size());
        return options;
      }
 
 
      @RemoteAction
      global static List<SelectOption> fetchdistrictList(String state) {
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
 
}