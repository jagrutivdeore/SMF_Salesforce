@isTest
public class ProcessReportsControllerTest
{
  public static testMethod void Test1()
  {
       test.startTest();
       
       MV_Process__c mPro = new MV_Process__c();
       
       mPro.Name = 'एस.एम.एफ.च्या तज्ञांकडून SMF प्रशिक्षकांचे तालुका-स्तरीय प्रशिक्षणाचे निरीक्षण';
       mPro.Multiple_Role__c = 'MT'; 
       insert mPro;
      
       ProcessReportsController pObj = new ProcessReportsController();
       pObj.getselectedProcess();
       
       pObj.selectProcess = mPro.Id;
       pObj.generateReport();
       pObj.DownloadExcelReport();
      // pObj.testObj();
       pObj.beginning();
       pObj.previous();
       pObj.next();
       pObj.end();
       pObj.getprev();
       pObj.getnxt();
       test.stopTest();
  }
}