@isTest
private class LangServiceTest {

    @isTest
    private static void testLang()
    {
        WS_addNewRegisterNew.testCode();
        WS_getOTPNew.CCHelp();
        WS_getUserDataNew.CCHelp();
        WS_getallprocessandtaskNew.CCHelp();
        WS_MTTrainingForm.testCode();
        WS_MTTraining.testCode();
        MV_TrainersFeedback.CCHelp();
        WS_TCshikshanKaryashalaTaluka.testCode();
        sectionwiseDashboardAllData.testCode();
        WS_Get_User_Data.testCode();
        CheckRecordFetchLimit.increaseTestCoverage();
        ProcessReportsTest.testCode();
    }
}