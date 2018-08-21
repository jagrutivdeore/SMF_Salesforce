public class PushNotification {
    
    @future(callout=true)
public static void notificationMessage(){
   /* List<MV_Community__c> l = new List<MV_Community__c>();
l =[select id from MV_Community__c where Name  = 'HO Support'];
    
for(MV_Community__cs mc : l)
{
    if(mc.id == 'a1D0k000000DvlWEAS')
    {
		System.debug('Yes');        
    }
    else
    {
        System.debug('No');
    }
}*/
    
    
    
     String body = '{"registration_ids" : ["e5M98THEs9g:APA91bFnb-2FaxNec43kScBcgb0oaaf_Jilizu8STXVmtKyfRhnFx6zmPpeA0xz3mni5R8SKr8wFoyWQdzsj8eOynM0vO9m6touQ7BCCUErHkUuZXajDPr_aFW_gyAA0ndal1qOM-_lt"],';
     String data = '"data":{"Id":"Nikhil"}}';
     body += data;
    
    
    system.debug('-------'+ body);
        HttpRequest req = new HttpRequest(); 
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        req.setHeader('Authorization','key=AIzaSyCpuVJexRcmDkEbidNJcEDNdRScT_UAaV0');
        req.setEndpoint('https://fcm.googleapis.com/fcm/send');
        req.setBody(body);  

        Http http = new Http();
        try {

        HTTPResponse res = http.send(req);  
        System.debug(res.toString());
        System.debug('STATUS:'+res.getStatus());
        System.debug('STATUS_CODE:'+res.getStatusCode());
         } catch(System.CalloutException e) {
            system.debug(e);
        }
    
}


}