public class ContentDetailController {
     string accId;
    public List<MV_Content_Comment__c> conList {get; set;}
    public MV_Community__c comm {get; set;}
    public MV_Content__c newcon {get; set;}
    
    public Transient Blob AttchBody {get;set;}
    public string theatcontentType {get; set;}
    public string commId = '';
    public ContentDetailController(ApexPages.StandardController sc){
        
        
        System.debug('Content Id is' + sc.getId());
      // comm = [SELECT id,Name,Community_Cluster__c,Community_District__c,Community_State__c,Community_Taluka__c,FROM_MV_Role__c,Role_Name__c,MV_Role__c FROM MV_Community__c WHERE Id = :sc.getId()];
        
        conList = [SELECT Comment__c,status__c,User_Name__c FROM MV_Content_Comment__c where MV_Content__c =: sc.getId() order by createdDate desc];
        //newcon = new MV_Content__c();
       // commId = sc.getId(); */
        
        
        
    }
}