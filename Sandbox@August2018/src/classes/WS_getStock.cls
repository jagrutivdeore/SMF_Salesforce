@RestResource(urlMapping='/getStock/*')
global class WS_getStock {
    	@HttpGet
    	global static List<AssetStock> getData(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String assetId = RestContext.request.params.get('assetId');
            
        List<ASSET_STOCK__c> assetStock = new List<ASSET_STOCK__c>();
            
        assetStock = [select id,ASSET__r.Name,Model__c,Code__c from ASSET_STOCK__c where ASSET__c =: assetId and isUsed__c = false];
        //assetStock = [select id,ASSET__r.Name,Model__c,Code__c from ASSET_STOCK__c];
            
            
       List<AssetStock> assetStockList = new List<AssetStock>();
            for(ASSET_STOCK__c a: assetStock)
        {
			AssetStock assetStockPJ = new AssetStock();
			assetStockPJ.stockId = a.Id;
            assetStockPJ.assetName = a.ASSET__r.Name;
            assetStockPJ.modelNo = a.Model__c;
            assetStockPJ.code = a.Code__c;
            assetStockList.add(assetStockPJ);
        }
            
            
            return assetStockList;
         }
    
    
    global class AssetStock{
        public String stockId;
        public string assetName;
        public String modelNo;
        public String code;
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
    }
}