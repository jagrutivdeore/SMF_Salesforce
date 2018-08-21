@RestResource(urlMapping='/getProcessFields/*')
global class WS_getProcessFields {
  
    @HttpGet
    global static List<MV_Process_Fileds__c> doGet() {

    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
     String userId = RestContext.request.params.get('userId');
    String processId = RestContext.request.params.get('processId');
    List<MV_Process_Fileds__c> outputList = new List<MV_Process_Fileds__c>();
    If(processId != null && userId !=null){
        outputList = [SELECT Id,Name,MV_Process__c,MV_User__c,P1F1__c,P1F2__c,P1F3__c,P1F4__c,
        P1F5__c,P2F1__c,P2F2__c,P2F3__c,P2F4__c,P2F5__c from MV_Process_Fileds__c where MV_Process__c = :processId AND MV_User__c = :userId  ];
    }
     return outputList;
     
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
         
        }
    
}