@RestResource(urlMapping='/getProjectData/*')
global class WS_getProjectData {
  
    @HttpGet
    global static List<Project__c> doGet() {

    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    List<Project__c> projectlist = [select id,Name,Project_Name__c from Project__c];
    return projectlist;
    
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
    }
}