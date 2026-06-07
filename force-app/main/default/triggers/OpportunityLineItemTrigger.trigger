trigger OpportunityLineItemTrigger on OpportunityLineItem (after insert, after update, after delete, after undelete) {

    if (Trigger.isAfter && Trigger.isInsert)
        OpportunityLineItemTriggerHandler.updateOpportunityAmount(Trigger.new, null);

    if (Trigger.isAfter && Trigger.isUpdate)
        OpportunityLineItemTriggerHandler.updateOpportunityAmount(Trigger.new, Trigger.oldMap);

    if (Trigger.isAfter && Trigger.isDelete)
        OpportunityLineItemTriggerHandler.updateOpportunityAmount(Trigger.old, null);

    if (Trigger.isAfter && Trigger.isUndelete)
        OpportunityLineItemTriggerHandler.updateOpportunityAmount(Trigger.new, null);
}
