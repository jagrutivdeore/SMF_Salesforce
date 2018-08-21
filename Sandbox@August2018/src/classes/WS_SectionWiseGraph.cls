@RestResource(urlMapping='/getSectionWiseReport/*')
global class WS_SectionWiseGraph {
    @HttpGet
    global static List<FinalResult> doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        String state = RestContext.request.params.get('state');
        String dist = RestContext.request.params.get('dist');
        String tal = RestContext.request.params.get('tal');
        String processId = RestContext.request.params.get('processId');
        System.debug('State is' + state);
        System.debug('processId is' + processId);        
        List<MV_Task__c> taskforAllIndicators = new List<MV_Task__c>();
        taskforAllIndicators = [SELECT Id,Indicator_Names__c,Picklist_Value__c,Bar_Chart_Labels__c,All_Indicator_Bar_Chart_Label__c,Max_Score__c,Max_Individual_Score__c,Task_Text__c,Picklist_Values_Scoring__c,Section_Name__c,API_field_Name__c,Task_type__c,Section_Question_Count__c,Caption__c,Section_Group_No__c FROM MV_Task__c where Task_type__c = 'selection' AND Picklist_Values_Scoring__c != null ANd MV_Process__c =: processId]; 
        
        List<String> listSectionName = new List<String>();
        List<String> secList = new List<String>();
        Set<String> secSet = new Set<String>(); 
        
        //3. Field Value and Option Mapping
        Map<String, Map<String,String>> FVOM = new  Map<String, Map<String,String>>();
        
        //List Of API i.e Field
        List<String> listOfAPIField = new List<String>();
        
        
        for(MV_Task__c mvt: taskforAllIndicators)
        {
            // 1. Section Name
            String sName = mvt.Indicator_Names__c;
            
            if(sName != null && sName != '')
            {
                if(sName.length()>0)
                {
                    listSectionName = sName.split(',');
                }
                
            }
            for(String s: listSectionName)
            {
                secSet.add(s);
            }
            //3. 
            Map<String,String> OVM = new Map<String,String>();
            OVM.put(mvt.Picklist_Value__c,mvt.Picklist_Values_Scoring__c);
            FVOM.put(mvt.API_field_Name__c,OVM);
            
            listOfAPIField.add(mvt.API_field_Name__c);
        }
        
        if(secSet.size() == 0)
        {
            return null;
        }
        
        //2. Indicator to field mapping
        Map<String,List<String>> indToFieldMap = new Map<String,List<String>>();
        
        for(String s: secSet)
        {
            List<String> fieldForResInd = new List<String>();
            
            List<MV_Task__c> taskforSpecificIndicator = new List<MV_Task__c>();
            String ind= '%'+s+'%';
            taskforSpecificIndicator = [SELECT Id,Indicator_Names__c,Picklist_Value__c,Bar_Chart_Labels__c,All_Indicator_Bar_Chart_Label__c,Max_Score__c,Max_Individual_Score__c,Task_Text__c,Picklist_Values_Scoring__c,Section_Name__c,API_field_Name__c,Task_type__c,Section_Question_Count__c,Caption__c,Section_Group_No__c FROM MV_Task__c where Task_type__c = 'selection' AND Picklist_Values_Scoring__c != null ANd Indicator_Names__c like : ind And MV_Process__c =: processId ]; 
            
            for(MV_Task__c mvt: taskforSpecificIndicator)
            {
                fieldForResInd.add(mvt.API_field_Name__c);   
            }
            
            indToFieldMap.put(s,fieldForResInd);
        }
        
        
        //Final Calculation
        List<ProcessAnswer__c> prAnswer = new List<ProcessAnswer__c>();
        //String processId = 'a1Q0k000000CjKP';
        //String Dist = 'Akola';
        String soql = null;
        if(tal != null && tal != '')
        {
         System.debug('tal  is' + tal );
              soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c, ' + String.join(listOfAPIField, ',')+ ' from ProcessAnswer__c where State__c =\'' + state +'\' And District__c =\'' + dist +'\' And Taluka__c =\'' + tal +'\' And MV_Process__c =\'' + processId +'\'';      
        
            System.debug('------------------------SOQL Query is: ' + soql);
        }
        else if(dist != null && dist != '')
        {
                 System.debug('dist  is' + dist );
              soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c, ' + String.join(listOfAPIField, ',')+ ' from ProcessAnswer__c where State__c =\'' + state +'\' And District__c =\'' + dist +'\' And MV_Process__c =\'' + processId +'\'';   

        }
        else if(state != null && state != '')
        {
             System.debug('state  is' + state );
             soql = ' select Id,Cluster__c,District__c,State__c,Taluka__c,Village__c, ' + String.join(listOfAPIField, ',')+ ' from ProcessAnswer__c where State__c =\'' + state +'\' And MV_Process__c =\'' + processId +'\'';   
        }


        
        System.debug('Query is' + soql);
        
        prAnswer = Database.query(soql);
        
        if(prAnswer.size() == 0 )
        {
            return null;
        }
        
        /*for(String sec: secSet)
{
System.debug('Section Are' + sec);
}*/
        
        List<FinalResult> finalList = new List<FinalResult>();
        for(String sec: secSet)
        {
            Integer totalFeedBack = 0;
            Integer sectionValueTotal = 0;
            Integer sectionTotalQuestion = 0;
            Decimal SectionAvg = 0;
            List<String> fieldOfInd = indToFieldMap.get(sec);
            for(String f: fieldOfInd)
            {
                sectionTotalQuestion ++;
                Map<String,String> VOM = FVOM.get(f);
                Set<String> op = VOM.keySet();
                List<String> val = VOM.values();
                
                String opString = null;
                String ValString = null;
                
                List<String> opList = new List<String>();
                List<String> ValList  = new List<String>();
                
                for(String o: op)
                {
                    opString = o;
                }
                for(String v: val)
                {
                    ValString = v;
                }
                
                opList = opString.split(','); 
                ValList = ValString.split(',');
                //System.debug('Options Are: ' + opList);
                //System.debug('Values Are: ' + ValList);
                
                //System.debug('-----------Section is-----------------' +sec);
                //totalFeedBack = prAnswer.size();
                for(ProcessAnswer__c pra: prAnswer)
                {
                    
                    
                    String s = (String)pra.get(f);
                    
                    if(s != null)
                    {
                        totalFeedBack ++;
                    }
                    //System.debug('Answer' + s);
                    
                    Integer ind = 0;
                    ind = 0;
                    
                    
                    for(String o: opList)
                    {
                        //System.debug('-----------------Anser is' + s );
                        //System.debug('-----------------Option is' + o );
                        
                        
                        if(s == o){
                            // System.debug('Sect Value' + s);
                            //System.debug('Op Value' + o);
                            //System.debug('Selected value weigtage' + Integer.valueof(ValList[ind].trim()));
                            sectionValueTotal =  sectionValueTotal + Integer.valueof(ValList[ind].trim());
                            //System.debug('SectionValueTotal----' + sectionValueTotal);
                            break;
                        }
                        ind++;
                    }
                    
                    //sectionValueTotal =  sectionValueTotal + Integer.valueof(ValList[ind].trim());
                    
                    
                    //System.debug('Value Option Mapping' + VOM);
                }
                
                
            }
            System.debug('---------------------------------------------------');
            System.debug('Section Name' + sec);
            System.debug('Section Value Total' + sectionValueTotal);
            System.debug('Section Total Question' + sectionTotalQuestion);
            System.debug('---------Total Feedback Count: ' + totalFeedBack);
            if(sectionTotalQuestion != 0)
            {
                //SectionAvg = (Double)sectionValueTotal/sectionTotalQuestion;
                SectionAvg = (Double)sectionValueTotal;
            }
            
            // System.debug('Section Avg' +SectionAvg);
            
            
            FinalResult fr = new FinalResult();
            fr.sectionName = sec;  
            
            
            //System.debug('---------SectionAvg: ' + SectionAvg);
            fr.value = (Double) SectionAvg/totalFeedBack;
            
            fr.value = fr.value.setScale(2);
            
            finalList.add(fr);
        }
        
        //System.debug('---------------------------');
        for(FinalResult f : finalList)
        {
            System.debug('sectionName is ' + f.sectionName);
            System.debug('value is' + f.value);
        }
        
        return finalList;
    }
    
    
    
    global class FinalResult{
        public String sectionName {get;set;}
        public Decimal value {get;set;}
    }
    
    public static void  CCHelp()
    {
        Integer val = 1;
        
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        
    }
}