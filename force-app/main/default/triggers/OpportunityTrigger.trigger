trigger OpportunityTrigger on Opportunity (after update, after delete, after insert) {
    
    /*if(trigger.isafter && trigger.isUpdate){
        
        for(Opportunity opp: trigger.New){
            Contract__c c = new Contract__c();
            c.account = opp.account;
            accountSet.add(opp.account);
            contractToInsert.add(c);
        }
        
        List<contact> contactList = [SELECT Id, iscustomer from contact where account in accountIdSet];
        for(contact c: acontactList){
            if(c.iscustomer == false){
                c.iscustomer = true;
                contactListToUpdate.add(c);
            }
        }
        if(!contactListToUpdate.isempty()){
            update contactListToUpdate
        }
    }*/
    if(trigger.isBefore && trigger.isInsert)
        OpportunityTriggerHandler.beforeInsert( trigger.new);
    
    if(trigger.isAfter && trigger.isUpdate){
        OpportunityTriggerHandler.afterUpdate(trigger.oldMap, trigger.new);
    }
    if(trigger.isAfter && trigger.isDelete){
       OpportunityTriggerHandler.afterDelete(trigger.old);
    }
    
    

}