Trigger roleTrigger on MV_Role__c (after insert, after update, before insert) {
    
   
    
  List<Id> roleList = new List<Id>();
    if ( Trigger.isUpdate ){
      For(MV_Role__c role : trigger.new){
          if (Trigger.oldMap.get(role.Id).Visible_Tab__c != Trigger.newMap.get(role.Id).Visible_Tab__c || Trigger.oldMap.get(role.Id).Tab_Names__c != Trigger.newMap.get(role.Id).Tab_Names__c || Trigger.oldMap.get(role.Id).Approval_person_Role__c != Trigger.newMap.get(role.Id).Approval_person_Role__c){
              roleList.add(role.Id);
          } 
      }
    }
    
    if( Trigger.isInsert ){
         For(MV_Role__c role : trigger.new){
              roleList.add(role.Id);
       }
        
    }   
  List<MV_Role__c> listem = new List<MV_Role__c>();
  List<MV_Role__c> listemp = new List<MV_Role__c>();
  listem = [Select id,Approval_person_Role__c,Tab_Names__c,Before_Approved_Tab_Names__c,Approval_Role__c,Mobile_Tab_Name__c,Visible_Tab__c from MV_Role__c where id In :roleList];
  
  for(MV_Role__c emp: listem){
    if(emp.Approval_person_Role__c != null || emp.Tab_Names__c != null){
     emp.Approval_Role__c = emp.Approval_person_Role__c;
     
     emp.Mobile_Tab_Name__c = emp.Visible_Tab__c; //after approved
     emp.Before_Approved_Tab_Names__c = emp.Tab_Names__c; // before approved
     
     listemp.add(emp);
   
    }
  }  
  if(listemp.size() > 0){
       update listemp;
  }
 

}