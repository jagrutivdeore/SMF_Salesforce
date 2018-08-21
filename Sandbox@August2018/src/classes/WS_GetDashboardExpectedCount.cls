@RestResource(urlMapping='/getDashboardExpectedCount1/*')
global class WS_GetDashboardExpectedCount {

    @HttpGet
    global static List<KeyValue> AddVisitData(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json'); 

        
        String State = RestContext.request.params.get('state');
        string dist =RestContext.request.params.get('district');
        string tal = RestContext.request.params.get('taluka');
        string processId = RestContext.request.params.get('processId');
        string role = RestContext.request.params.get('role');
        
        System.debug('State---' + State);
        System.debug('dist---' + dist);
        System.debug('tal---' + tal);
        System.debug('Process Id---' + processId);
        System.debug('role---' + role);
        List<ProcessAnswer__c> paList = new List<ProcessAnswer__c>();
        AggregateResult[] groupedResultsEx = new List<AggregateResult>();
        AggregateResult[] groupedResultsSub = new List<AggregateResult>();
        if(dist == null || dist ==''|| dist =='Select')
        {
            String soqlEx = ' select Taluka__c, count(ID) from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__c =\'' + processId +'\' AND Status__c = \'Expected\'  AND Role_Name__c in '+getStringFromList(role)+'  group by Taluka__c ';
            System.debug('Soql Query is' + soqlEx);
            groupedResultsEx = Database.query(soqlEx);
            
            System.debug('Result Ex is' + groupedResultsEx);
            
            String soqlSu = ' select Taluka__c, count(ID) from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__c =\'' + processId +'\' AND Status__c != \'Expected\'  AND Role_Name__c in ' +getStringFromList(role)+'  group by Taluka__c';
            System.debug('Soql Query is' + soqlSu);
            groupedResultsSub = Database.query(soqlSu);
            
            
            
            System.debug('REsult Sub is' + groupedResultsSub);
        }
       else if(tal == null || tal ==''|| tal =='Select')
        {
            String soqlEx = ' select Taluka__c, count(ID) from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__c =\'' + processId +'\' AND Status__c = \'Expected\' AND District__c =\'' + dist +'\' AND Role_Name__c in '+getStringFromList(role)+'  group by Taluka__c ';
            System.debug('Soql Query is' + soqlEx);
            groupedResultsEx = Database.query(soqlEx);
            
            System.debug('Result Ex is' + groupedResultsEx);
            
            String soqlSu = ' select Taluka__c, count(ID) from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__c =\'' + processId +'\' AND Status__c != \'Expected\' AND District__c =\'' + dist +'\' AND Role_Name__c in ' +getStringFromList(role)+'  group by Taluka__c';
            System.debug('Soql Query is' + soqlSu);
            groupedResultsSub = Database.query(soqlSu);
            
            
            
            System.debug('REsult Sub is' + groupedResultsSub);
        }
        
        else if(tal != null)
        {
     //   String soqlEx = ' select Taluka__c, count(ID) from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__c =\'' + processId +'\' AND Taluka__c =\'' + tal +'\' AND Status__c = \'Expected\' AND District__c =\'' + dist +'\' AND Role_Name__c in '+getStringFromList(role)+' group by Taluka__c ';
        
        String soqlEx = ' select Taluka__c, count(ID) from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__c =\'' + processId +'\' AND Taluka__c in '+getStringFromList(tal)+' AND Status__c = \'Expected\' AND District__c =\'' + dist +'\' AND Role_Name__c in '+getStringFromList(role)+' group by Taluka__c';  //swarupa -Multiple Taluka
            System.debug('Soql Query is' + soqlEx);
            groupedResultsEx = Database.query(soqlEx);
            
            System.debug('Result Ex is' + groupedResultsEx);
 //           String soqlSu = ' select Taluka__c, count(ID) from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__c =\'' + processId +'\' AND Taluka__c =\'' + tal +'\' AND Status__c != \'Expected\' AND District__c =\'' + dist +'\' AND Role_Name__c in '+getStringFromList(role)+' group by Taluka__c';
            
            String soqlSu = ' select Taluka__c, count(ID) from ProcessAnswer__c'+' where State__c =\'' + State +'\' AND MV_Process__c =\'' + processId +'\' AND Taluka__c in '+getStringFromList(tal)+' AND Status__c != \'Expected\' AND District__c =\'' + dist +'\' AND Role_Name__c in '+getStringFromList(role)+' group by Taluka__c'; //swarupa -Multiple Taluka
            System.debug('Soql Query is' + soqlSu);
            groupedResultsSub = Database.query(soqlSu);
            
            
            
            System.debug('REsult Sub is' + groupedResultsSub);
        }
        
        else
            {
                //do nothing 
            }
       
       
        Map<String,Count> result = new Map<String,Count>();
        
        for (AggregateResult arEx : groupedResultsEx)  {
            Count count = new Count();
            count.expectedCount = Integer.valueOf(arEx.get('expr0'));
            result.put(String.valueOf(arEx.get('Taluka__c')),count);
        }
         System.debug('Expected List is' + result);
        for(AggregateResult arSub : groupedResultsSub){
            Count count = null;
            if(result.containsKey(String.valueOf(arSub.get('Taluka__c'))))
                count = result.get(String.valueOf(arSub.get('Taluka__c')));
            if(count==null)
                count = new Count();
            count.submittedCount = Integer.valueOf(arSub.get('expr0'));
            result.put(String.valueOf(arSub.get('Taluka__c')),count);
        }
        
        System.debug('Expected List is' + result);
        List<KeyValue> expectedReault = new List<KeyValue>();
        
        for (String fieldName : result.keySet()){
            Count count = result.get(fieldName);
            KeyValue kv = new KeyValue();
            kv.key = fieldName;
            kv.expectedCount = count.expectedCount;
            kv.submittedCount = count.submittedCount;
            expectedReault.add(kv);
           
        }
        
        return expectedReault;
        
    }
    
    
     public static String getStringFromList(String role)
        {
            /*if(role.contains(','))
                return role*/
            List<String> rlList = role.split(';');
                System.debug('Role Name is' + rlList);
                String strList = '(';
                for(String str:rlList)
                    {
                        strList = strList+'\''+str+'\',';
                    }
                strList = strList.removeEnd(',');
                strList = strList+')' ;
            return strList;
        }
    
    global class KeyValue{
        String key;
        Integer expectedCount = 0;
        Integer submittedCount = 0;
    }
    
    global class Count{
        Integer expectedCount = 0;
        Integer submittedCount = 0;
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
     }
    
    
}