public class TransactionLogHandler 
{
  Public static void DoHandleException(system.Exception Ex , string ProcessName)
  {
      Error_Log__c TransectionLog = New Error_Log__c();
       
      TransectionLog.Log_Details__c = ex.getStackTraceString() + '<br/><strong> Message Is </strong>' + ex.getMessage() +'<br/>'
                                       + ex.getCause() + '<br/>' + ex.getTypeName() + '<br/>' + ex.getLineNumber();
      TransectionLog.Lod_DateTime__c = system.now();
      TransectionLog.Process_Name__c = ProcessName;
      
      Insert TransectionLog;
  }
}