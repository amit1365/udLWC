trigger contactTrigger on Contact (before insert, before update) {
    
    if(trigger.isBefore){
        if(trigger.isInsert || trigger.isUpdate){
            //contactTriggerHandler.checkNumberOfContacts(trigger.New);
        }
    }

}