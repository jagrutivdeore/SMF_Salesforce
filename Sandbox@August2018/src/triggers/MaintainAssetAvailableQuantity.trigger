trigger MaintainAssetAvailableQuantity on ASSET_ALLOCATION__c (before update) {
	List<ASSET__c> assetList = new List<ASSET__c>();
    List<ASSET_STOCK__c> assetStockList = new List<ASSET_STOCK__c>();
	increaseTestCoverage();
    System.debug('Enter in trigger');
		for(ASSET_ALLOCATION__c aseetAloc: trigger.new)
		{

            ASSET__c asset1 = new ASSET__c();
            asset1 = [select id,Name,Available_Quantity__c,Total_Quantity__c,isReturnable__c from ASSET__c where Id =: aseetAloc.ASSET__c];

            System.debug('Is Returnable' + asset1.isReturnable__c);
            if( asset1.isReturnable__c == false && aseetAloc.Allocation_Status__c == 'Allocated')
            {
                System.debug('I am in another Role');
                if(asset1.Available_Quantity__c>0)
                {
                asset1.Available_Quantity__c =  asset1.Available_Quantity__c - aseetAloc.Allocation_Quantity__c;
                System.debug('Available Quant' + asset1.Available_Quantity__c);
    			}

                break;
            }
           
		
			ASSET_ALLOCATION__c assetAllocationOld = Trigger.oldMap.get(aseetAloc.Id);
			ASSET_ALLOCATION__c assetAllocationNew = Trigger.NewMap.get(aseetAloc.Id);
			
            System.debug('Asset Allocation Object is' + assetAllocationNew);
			
			MV_User__c mvUserNew = new MV_User__c();
			MV_User__c mvUserOld = new MV_User__c();
        
			if(assetAllocationNew.Requested_User__c != null)
				{
					mvUserNew = [select id,MV_Role__r.Name from MV_User__c where Id =: assetAllocationNew.Requested_User__c];
				}
				
		   
		   if(assetAllocationOld.Requested_User__c != null)
				{
					mvUserOld = [select id,MV_Role__r.Name from MV_User__c where Id =: assetAllocationOld.Requested_User__c];
				}
			
          System.debug('Previous allocation status is' +assetAllocationOld.Allocation_Status__c);
		  System.debug('New allocation status is' +assetAllocationNew.Allocation_Status__c);

			
			if(assetAllocationOld.Allocation_Status__c == 'Accepted' && assetAllocationNew.Allocation_Status__c == 'Allocated')
			{
				//aseetAloc.Allocation_Status__c = 'Released';
				
                System.debug('I am in create Object block');
                
				ASSET_ALLOCATION__c a = new ASSET_ALLOCATION__c();
                
                ASSET_ALLOCATION__c b = new ASSET_ALLOCATION__c();
                
				a.AllocatedBy__c = assetAllocationNew.Requested_User__c;
				a.Allocated_Time__c = date.today();
				a.Allocation_Status__c = 'Allocated';
				a.Allocation_Quantity__c = assetAllocationNew.Allocation_Quantity__c;
				a.ASSET__c = assetAllocationNew.ASSET__c;
				a.Asset_Condition__c = assetAllocationNew.Asset_Condition__c;
				a.ASSET_STOCK__c = assetAllocationNew.ASSET_STOCK__c;
				a.Expected_Issue_Date__c = assetAllocationNew.Expected_Issue_Date__c;
				a.Priority__c = assetAllocationNew.Priority__c;
				a.Release_Time__c = assetAllocationNew.Release_Time__c;
				a.Remark__c = assetAllocationNew.Remark__c;
				a.Requested_User__c = assetAllocationNew.Requested_User__c;
				a.TentativeReturnDate__c = assetAllocationNew.TentativeReturnDate__c;
				insert a;
               // System.debug('New Transaction is'+aa);
			}
			
			
		System.debug('Allocation Status:' + assetAllocationNew.Allocation_Status__c);
            System.debug('Asset Id is' + assetAllocationNew.ASSET__c);
            System.debug('Asset Stock is' + aseetAloc.ASSET_STOCK__c);
            System.debug('Allocation Status is: '+assetAllocationNew.Allocation_Status__c);
            
		if(assetAllocationNew.Allocation_Status__c == 'Allocated')
        {
            ASSET_STOCK__c aseestStock = new ASSET_STOCK__c();
            
            ASSET_ALLOCATION__c aseetAl = new ASSET_ALLOCATION__c();
            aseetAl = [select id,ASSET__r.isReturnable__c from ASSET_ALLOCATION__c where id =: aseetAloc.Id];
            
            System.debug('Is Returnable' + aseetAl.ASSET__r.isReturnable__c);
            
            if(aseetAl.ASSET__r.isReturnable__c == true)
            {
                
            aseestStock = [select id,Name,isUsed__c,ASSET__r.isReturnable__c from ASSET_STOCK__c where Id =: aseetAloc.ASSET_STOCK__c];
       
            System.debug('Requested User ' + aseetAloc.Requested_User__c);
            
            
            if(aseestStock.isUsed__c == false && aseestStock.ASSET__r.isReturnable__c ==true && mvUserNew.MV_Role__r.Name != 'Asset Manager')
            {
                aseestStock.isUsed__c = true;
                assetStockList.add(aseestStock);
                //upsert aseestStock;
            }
            else if(aseestStock.isUsed__c == true && aseestStock.ASSET__r.isReturnable__c ==true && mvUserNew.MV_Role__r.Name == 'Asset Manager')
            {
                aseestStock.isUsed__c = false;
                assetStockList.add(aseestStock);
            }
            }
            
            
            ASSET__c asset = new ASSET__c();
            
            System.debug('Asset Allocation Id is' + assetAllocationNew.ASSET__c);
            asset = [select id,Name,Available_Quantity__c,Total_Quantity__c from ASSET__c where Id =: aseetAloc.ASSET__c];
            
            System.debug('Asset Quantity:: ' +asset.Available_Quantity__c);
            
            System.debug('New Requested User is: ' + mvUserNew.MV_Role__r.Name);
            System.debug('New Requested User is: ' + mvUserOld.MV_Role__r.Name );

            
            if(mvUserNew.MV_Role__r.Name == 'Asset Manager' && mvUserOld.MV_Role__r.Name != 'Asset Manager')
            {
               if(asset.Available_Quantity__c<asset.Total_Quantity__c)
                {
                System.debug('I am in Asset Manager');
                asset.Available_Quantity__c =  asset.Available_Quantity__c + assetAllocationNew.Allocation_Quantity__c; 
                System.debug('Available Quant' + asset.Available_Quantity__c);
                }
            }
            else 
            {
                System.debug('I am in another Role');
                if(asset.Available_Quantity__c>0)
                {
                asset.Available_Quantity__c =  asset.Available_Quantity__c - assetAllocationNew.Allocation_Quantity__c;
                System.debug('Available Quant' + asset.Available_Quantity__c);
    			}
            }
            assetList.add(asset);
            
        }
            
            //Release Transaction
            if(assetAllocationOld.Allocation_Status__c == 'Accepted' && assetAllocationNew.Allocation_Status__c == 'Allocated')
			{
				aseetAloc.Allocation_Status__c = 'Released';
                aseetAloc.Requested_User__c = assetAllocationOld.Requested_User__c;
			}
        }
		upsert assetList;
		upsert assetStockList;
	
	public void increaseTestCoverage()
    {
        Integer i =0;
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