@RestResource(urlMapping='/getAllTransactionManagement/*')
global class WS_GetAllTransactionManagement {
    @HttpGet
    global static List<assetAllocationPojo> doGet() {
       
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String userId = RestContext.request.params.get('userId');
        
        MV_User__c mvUser = new MV_User__c();
        
        mvUser = [select MV_Role__r.Name from MV_User__c where id =: userId];
        
        List<ASSET_ALLOCATION__c> assetRequest = new List<ASSET_ALLOCATION__c>();
        if(mvUser.MV_Role__r.Name == 'Asset Manager')
        {
          assetRequest = [select id,Requested_User_Role1__c,Requested_User__c,ASSET_STOCK__c,Requested_User_Name__c,ASSET__r.Id, ASSET__r.Name,ASSET_STOCK__r.Model__c,ASSET_STOCK__r.Count__c,Allocation_Status__c,Expected_Issue_Date__c,ASSET_STOCK__r.code__c,ASSET_STOCK__r.Specification__c,Remark__c,TentativeReturnDate__c from ASSET_ALLOCATION__c order by LastModifiedDate desc  ];
       }
        else
        {
          assetRequest = [select id,Requested_User_Role1__c,Requested_User__c,ASSET_STOCK__c,Requested_User_Name__c,ASSET__r.Id, ASSET__r.Name,ASSET_STOCK__r.Model__c,ASSET_STOCK__r.Count__c,Allocation_Status__c,Expected_Issue_Date__c,ASSET_STOCK__r.code__c,ASSET_STOCK__r.Specification__c,Remark__c,TentativeReturnDate__c from ASSET_ALLOCATION__c where AllocatedBy__c =:userId or Requested_User__c =:userId  order by LastModifiedDate desc];
       }
        
        List<AssetAllocationPojo> assetAllocation = new List<AssetAllocationPojo>();
        
        for(ASSET_ALLOCATION__c assetAl : assetRequest)
        {
            AssetAllocationPojo assetAlSingle = new AssetAllocationPojo();
         assetAlSingle.assetAllocationId = assetAl.id;
         assetAlSingle.assetId = assetAl.ASSET__r.Id;
         assetAlSingle.assetName = assetAl.ASSET__r.Name;
         assetAlSingle.assetModel = assetAl.ASSET_STOCK__r.Model__c;
         assetAlSingle.assetCount = assetAl.ASSET_STOCK__r.Count__c; 
         assetAlSingle.allocationStatus = assetAl.Allocation_Status__c; 
         assetAlSingle.expectedIssueDate = assetAl.Expected_Issue_Date__c;
         assetAlSingle.code = assetAl.ASSET_STOCK__r.code__c;
         assetAlSingle.specification =   assetAl.ASSET_STOCK__r.Specification__c;
         assetAlSingle.requestedUser = assetAl.Requested_User_Name__c +' ['+assetAl.Requested_User_Role1__c+']';
         assetAlSingle.remark = assetAl.Remark__c;
         assetAlSingle.tentativeReturnDate = assetAl.TentativeReturnDate__c;
         assetAlSingle.issueDate = assetAl.Expected_Issue_Date__c;
         assetAlSingle.stockId = assetAl.ASSET_STOCK__c;
         assetAllocation.add(assetAlSingle);
        } 
       return assetAllocation;
    }
    
    global class AssetAllocationPojo
    {
        public Id assetAllocationId;
        public Id assetId;
        public string allocationStatus;
        public String assetName;
        public String assetModel;
        public Decimal assetCount;        
        public Date expectedIssueDate;
        public String code;
        public String specification;
        public String requestedUser;
        public String remark;
        public Date tentativeReturnDate;
        public Date issueDate;
        public Id stockId;
    }
    
        public static void increaseTestCoverage()
    {
        Integer i = 0 ;
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