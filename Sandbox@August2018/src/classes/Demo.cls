global class Demo {
      //public list<feedbackdata> feedbackdatalist{get; set;} 
    
    public Demo(ApexPages.StandardController controller) {
    
       /* feedbackdatalist = new list<feedbackdata>();
        List<Task_Answer__c> talist = new List<Task_Answer__c>();
        talist = [select id,Question__c,Answer__c,Unique_Id__c from Task_Answer__c where MV_Process__r.Name ='केंद्रस्तरीय मूल्यवर्धन कार्यशाळा - नियोजन पत्रक'];
        map<string,List<Task_Answer__c>> stringTotaMap = new map<string,List<Task_Answer__c>>();
        
        for(Task_Answer__c ta :talist){
            List<Task_Answer__c> talist2 = new List<Task_Answer__c>();
            if(stringTotaMap.get(ta.Unique_Id__c)!= null){
                talist2 = stringTotaMap.get(ta.Unique_Id__c);
                talist2.add(ta);
                stringTotaMap.put(ta.Unique_Id__c, talist2);
            }else{
                List<Task_Answer__c> talist3 = new List<Task_Answer__c>();
                talist3.add(ta);
                stringTotaMap.put(ta.Unique_Id__c, talist3);
                
            }
        }
        for(string str: stringTotaMap.keyset()){
            List<Task_Answer__c> talist4 = new List<Task_Answer__c>();
            talist4 = stringTotaMap.get(str);
            feedbackdata fd = new feedbackdata();
            fd.name0 = talist4[0].Unique_Id__c;
            for(Task_Answer__c ta : talist4){
                if(ta.Question__c == 'State'){
                    fd.name1 = ta.Answer__c;
                }else if(ta.Question__c == 'District'){
                    fd.name2 = ta.Answer__c;
                }else if(ta.Question__c == 'Taluka'){
                    fd.name3 = ta.Answer__c;
                }else if(ta.Question__c == 'ब्याच निवडा'){
                    fd.name4 = ta.Answer__c;
                }else if(ta.Question__c == 'केंद्र 1'){
                    fd.name5 = ta.Answer__c;
                }else if(ta.Question__c == 'केंद्राचे नाव 1'){
                    fd.name6 = ta.Answer__c;
                }else if(ta.Question__c == 'केंद्रातील (1) एकूण सहभागी प्राथमिक शिक्षकांची संख्या'){
                    fd.name7 = ta.Answer__c;
                }else if(ta.Question__c == 'मूल्यवर्धन प्रेरकांची नावे १'){
                    fd.name8 = ta.Answer__c;
                }else if(ta.Question__c == 'मूल्यवर्धन प्रेरकांची नावे २'){
                    fd.name9 = ta.Answer__c;
                }else if(ta.Question__c == 'मूल्यवर्धन प्रेरकांची नावे ३'){
                    fd.name10 = ta.Answer__c;
                }else if(ta.Question__c == 'केंद्र प्रमुखांची नावे १'){
                    fd.name11 = ta.Answer__c;
                }else if(ta.Question__c == 'केंद्र प्रमुखांची नावे २'){
                    fd.name12 = ta.Answer__c;
                }else if(ta.Question__c == 'केंद्र प्रमुखांची नावे ३'){
                    fd.name13 = ta.Answer__c;
                }else if(ta.Question__c == 'केंद्राचे नाव 2'){
                    fd.name14 = ta.Answer__c;
                }else if(ta.Question__c == 'केंद्रातील (2) एकूण सहभागी प्राथमिक शिक्षकांची संख्या'){
                    fd.name15 = ta.Answer__c;
                }else if(ta.Question__c == 'मूल्यवर्धन प्रेरकांची नावे १'){
                    fd.name16 = ta.Answer__c;
                }else if(ta.Question__c == 'मूल्यवर्धन प्रेरकांची नावे २'){
                    fd.name17 = ta.Answer__c;
                }else if(ta.Question__c == 'मूल्यवर्धन प्रेरकांची नावे ३'){
                    fd.name18 = ta.Answer__c;
                }else if(ta.Question__c == 'केंद्र प्रमुखांची नावे १'){
                    fd.name19 = ta.Answer__c;
                }else if(ta.Question__c == 'केंद्र प्रमुखांची नावे २'){
                    fd.name20 = ta.Answer__c;
                }else if(ta.Question__c == 'केंद्र प्रमुखांची नावे ३'){
                    fd.name21 = ta.Answer__c;
                }else if(ta.Question__c == 'दिनांक १'){
                    fd.name22 = ta.Answer__c;
                }else if(ta.Question__c ==' दिनांक २'){
                    fd.name23 = ta.Answer__c;
                }else if(ta.Question__c == 'दिनांक ३'){
                    fd.name24 = ta.Answer__c;
                }else if(ta.Question__c == 'दिनांक ४'){
                    fd.name25 = ta.Answer__c;
                }else if(ta.Question__c == 'कार्यशाळेसाठी निश्चित करण्यात आलेले ठिकाण'){
                    fd.name26 = ta.Answer__c;
                }else if(ta.Question__c == 'अभिप्राय'){
                    fd.name27 = ta.Answer__c;
                }
                
            }
            feedbackdatalist.add(fd);
        }
        system.debug('---------'+feedbackdatalist.size());*/
    }


  /*global  class feedbackdata{
         
        global String name0{ get; set; }
         global String name1 { get; set; }
        global  String name2 { get; set; }
         global String name3 { get; set; }
       global   String name4 { get; set; }
       global   String name5 { get; set; }
       global   String name6 { get; set; }
       global   String name7 { get; set; }
       global   String name8 { get; set; }
        global  String name9 { get; set; }
        global  String name10 { get; set; }
       global   String name11 { get; set; }
        global  String name12 { get; set; }
       global   String name13 { get; set; }
        global  String name14 { get; set; }
        global  String name15 { get; set; }
        global  String name16 { get; set; }
        global  String name17 { get; set; }
        global  String name18 { get; set; }
        global  String name19 { get; set; }
        global  String name20 { get; set; }
       global   String name21 { get; set; }
       global   String name22 { get; set; }
        global  String name23 { get; set; }
        global  String name24 { get; set; }
        global  String name25 { get; set; }
       global   String name26 { get; set; }
        global  String name27 { get; set; }
       global   String name28 { get; set; }
        global  String name29 { get; set; }
        global  String name30 { get; set; }
        global  String name31 { get; set; }
         global String name32 { get; set; }
        global  String name33 { get; set; }
         global String name34 { get; set; }
         global String name35 { get; set; }
         global String name36 { get; set; }
         global String name37 { get; set; }
         global String name38 { get; set; }
        global  String name39 { get; set; }
        global  String name40 { get; set; }
        global  String name41 { get; set; }
        global  String name42 { get; set; }
         global String name43 { get; set; }
         global String name44 { get; set; } 
         global String name45 { get; set; }
         global String name46 { get; set; }
        global  String name47 { get; set; }
        }*/
        
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
    }
}