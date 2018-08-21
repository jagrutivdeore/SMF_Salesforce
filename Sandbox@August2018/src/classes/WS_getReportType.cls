@RestResource(urlMapping='/getReportType/*')
global class WS_getReportType {
    @HttpGet
    global static List<Process_To_Report_Mapping__c> doGet() {
    
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    String roleName = RestContext.request.params.get('roleName');
        System.debug('Role Name:' + roleName);
    List<Process_To_Report_Mapping__c> ptrm = new List<Process_To_Report_Mapping__c>();
    ptrm = [select Id,MV_Process__c,MVCS__c from Process_To_Report_Mapping__c where To_Which_Role_Show_This_Report__c includes (:roleName)];
    return ptrm;
    }
}