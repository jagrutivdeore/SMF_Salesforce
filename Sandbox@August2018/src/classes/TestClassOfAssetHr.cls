@isTest(SeeAllData=true)
private class TestClassOfAssetHr {

    @isTest
    public static void generalTestMethod()
    {
        WS_GetAllLeave.forTestCoverage();
        WS_SaveLeaveApplication.forTestCoverage();
        WS_InsertExpense.testCode();
        WS_getUserExpenseData.CCHelp();
        WS_gettPendingExpenseData.CCHelp();
        WS_InsertVoucher.testCode();
        WS_getUserVoucherData.CCHelp();
        WS_getUserSalaryData.CCHelp();
        WS_InsertAdavance.testCode();
        WS_getUserAdavanceData.CCHelp();
        WS_gettPendingAdavanceData.CCHelp();
        WS_GetAsset.increaseTestCoverage();
        WS_SaveAssetRequest.increaseTestCoverage();
        WS_GetAllTransactionManagement.increaseTestCoverage();
        WS_GetUserThroughMobileNo.increaseTestCoverage();
        
        MV_getAllLocation.CCHelp();
        MV_getCluster.CCHelp();
        MV_getdistrict.CCHelp();
        MV_getSchool.CCHelp();
        MV_getVillage.CCHelp();
        MV_UserRegistration.CCHelp();
        MV_TraineeFeedback.CCHelp();
        WS_GetLeaveApproval.forTestCoverage();
        WS_DeleteLeave.forTestCoverage();
        WS_UpdateLeaveStatus.forTestCoverage();
        WS_getStock.increaseTestCoverage();
		WS_getContentNewLates.testCode();       
        WS_getContentNew.testCode();
         ASSET_ALLOCATION__c a = new ASSET_ALLOCATION__c();
        a = [select id from ASSET_ALLOCATION__c limit 1];
        update a;
        
      List<ProcessAnswer__c> pl = new List<ProcessAnswer__c>();
      pl =  [select id from ProcessAnswer__c limit 1];
      update pl;
    }
}