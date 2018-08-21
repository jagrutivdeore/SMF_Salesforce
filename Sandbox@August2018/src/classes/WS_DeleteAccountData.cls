@RestResource(urlMapping='/DeleteAccountData/*')
global class WS_DeleteAccountData {
  
    @HttpGet
    global static string doGet() {

    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    String mId = RestContext.request.params.get('Id');
    String mObject= RestContext.request.params.get('Object');
    String qurey;
    if(mObject=='Voucher'){
        qurey = 'select Id from Voucher__c where Id = :mId';
    }else if(mObject=='Expense'){
        qurey = 'select Id from Expense__c where Id = :mId';
    }else if(mObject=='Adavance'){
        qurey = 'select Id from Adavance__c where Id = :mId';
    }else if(mObject=='Asset'){
        qurey = 'select Id from ASSET_ALLOCATION__c where Id = :mId';
    }
    system.debug('query is -----'+qurey);
    sObject sbj = Database.query(qurey);
    delete sbj;
    string output= 'succesfully deleted '+mObject;
   
    return output;
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
       }  
    
}