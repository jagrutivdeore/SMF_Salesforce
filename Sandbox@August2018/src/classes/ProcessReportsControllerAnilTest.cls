@isTest
public class ProcessReportsControllerAnilTest {
 
  public static testMethod void Test1()
  {
       test.startTest();
       
       MV_Process__c mPro = new MV_Process__c();
       
       mPro.Name = 'एस.एम.एफ.च्या तज्ञांकडून SMF प्रशिक्षकांचे तालुका-स्तरीय प्रशिक्षणाचे निरीक्षण';
       mPro.Multiple_Role__c = 'MT'; 
       insert mPro;
      
       ProcessReportsControllerAnil pObj = new ProcessReportsControllerAnil();
       pObj.getselectedProcess();
       
       pObj.selectProcess = mPro.Id;
       pObj.getPAList();
       pObj.First();
       pObj.test();
       pObj.Previous();
       pObj.Next();
       pObj.Last();
       pObj.displayData();
       pObj.xlsForm();
       pObj.DownloadExcelReport();
      /* pObj.end();
       pObj.getprev();
       pObj.getnxt();*/
       test.stopTest();
  }
}