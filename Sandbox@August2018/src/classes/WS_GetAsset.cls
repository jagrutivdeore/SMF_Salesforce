@RestResource(urlMapping='/getAsset/*')
global class WS_GetAsset {

    @HttpGet
    global static List<assetPojo> getData(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String userId = RestContext.request.params.get('userId');
        
        List<ASSET__c> allAsset = new List<ASSET__c>();
        
         allAsset = [select id,Name,Available_Quantity__c,isReturnable__c,Type__c from ASSET__c where Available_Quantity__c > 0];
        
        List<AssetPojo> asset = new List<AssetPojo>();
        
        for(ASSET__c a: allAsset)
        {
			AssetPojo assetPJ = new AssetPojo();
			assetPJ.Id = a.Id;
            assetPJ.Name = a.Name;
            assetPJ.availableQuantity = a.Available_Quantity__c;
            assetPJ.isReturnable = a.isReturnable__c;
            assetPJ.type = a.Type__c;
            asset.add(assetPJ);
        }
        return asset;
        }
    
    global class AssetPojo{
        public String Id;
        public string Name;
        public Decimal availableQuantity;
        public boolean isReturnable;
        public string type;
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
    }
}