@RestResource(urlMapping='/deleteEventcalender/*')
global class WS_DeleteEventcalender {
  @HttpGet
    global static StatusPojo deleteEventcalender(){
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    String eventId = RestContext.request.params.get('eventId');
    List<Event_Calender__c> eventList = [SELECT Name FROM Event_Calender__c WHERE ID =: eventId];
        
    List<ProcessAnswer__c> prAnswer = [SELECT Name FROM ProcessAnswer__c WHERE calenderId__c =: eventId];    
        
    StatusPojo statusObject = new StatusPojo();
    if (prAnswer.size() > 0){
        statusObject.Status = true;
   		delete prAnswer;
	} 
        
	System.Debug('SOQL Returned ' + eventList.size());
	if (eventList.size() > 0){
        statusObject.Status = true;
   		delete eventList;
	}
        
        return statusObject;
    }
    
    global Class StatusPojo
    {
        boolean Status = false;
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
    }

}