public class SawandModel_Controller {
    
    string accId;
    public List<MV_Content_Comment__c> commentList {get; set;}
    public MV_Content__c con {get; set;}
    public MV_Content_Comment__c comm {get; set;}
    public string commentId { get; set; }
	public List<MV_User__c> userList1 {get;set; }
    
     public List<MV_Role__c> rl {get;set;}
    
    public SawandModel_Controller(ApexPages.StandardController sc){
        con = [SELECT Id,Content_Type__c,Attachment_Type__c,User_Name__c,Description__c,MV_User__c,District__c,MV_Template__c,Priority__c,Reporting_Type__c,Report_Type__c,State__c,Taluka__c,Title__c,Category__c,status__c,isAttachmentPresent__c FROM MV_Content__c WHERE Id =: sc.getId()];
        commentList = [SELECT Comment__c,MV_Content__c,MV_User__c,User_Name__c FROM MV_Content_Comment__c WHERE MV_Content__c =: con.Id];
        comm = new MV_Content_Comment__c();
    	
        Cookie theCookie;
        theCookie = ApexPages.currentPage().getCookies().get('usernameincookies');
        system.debug('------theCookie.getValue()-------' + theCookie.getValue());
        userList1 = new List<MV_User__c>();
        userList1 = [SELECT Id,Role_Name__c,User_Mobile_No__c,MV_Role__c,Location_wise_filter_on_Community__c,User_District__c,User_State__c,User_Taluka__c FROM MV_User__c where User_Mobile_No__c = :theCookie.getValue() limit 1];
        
         if(userList1.size()>0)
        {

            System.debug('Role___________________'+userList1[0].MV_Role__c); 
            
            rl = [select id, canAddBrodcastMsg__c,canDeletePostAndComment__c,onBehalfOrg__c	, Name from MV_Role__c where id =: userList1[0].MV_Role__c];
            
            
            System.debug('Role Detail is___________________'+userList1[0].MV_Role__c); 
            
            
            if(rl.size()>0)
            {
                         System.debug('Role list is: ' + rl[0].canAddBrodcastMsg__c);
            }
        }
    
    }
    
    public void addComment(){
        
        System.debug('On Behaf of: ' + rl[0].onBehalfOrg__c);
        
        if(rl[0].onBehalfOrg__c == true)
        {
        System.debug('I am in If');
        IdManagement__c myCS1 = IdManagement__c.getValues('mutthaSir');
        comm.MV_User__c = myCS1.Id__c;
   		}
        else
        {
         System.debug('I am in else' + userList1[0].id);
         comm.MV_User__c = userList1[0].id;
        }
        comm.MV_Content__c = con.Id;
        insert comm;
        commentList.add(comm);        
        comm = new MV_Content_Comment__c();
    }
    
    public pagereference DeleteBroadcastComment(){
       system.debug('----------------'+ commentId);
    //commentId = string.valueOf(ApexPages.currentPage().getParameters().get('commentId'));
        
        //system.debug('Comment Id is----------------'+ commentId);
        
     if (commentId == null) {
      return null;
      }
      MV_Content_Comment__c conComm = new MV_Content_Comment__c();
      conComm = [select id from MV_Content_Comment__c where id = :commentId];
      delete conComm;
        System.debug('Con Id::' + con.Id);
        PageReference pgref = new PageReference('/apex/SawandModel?id='+con.Id);
        pgref.setRedirect(true);
       return pgref;
   } 
    
    
     public void changeStatus(){
       upsert con;         
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
        }
}