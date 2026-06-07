trigger JobApplicationTrigger on Job_Application__c (after insert, after update){

	if(JobApplicationTriggerHandler.hasRun)
		return;

	JobApplicationTriggerHandler.hasRun = true;

	if(trigger.isUpdate && trigger.isAfter)
		JobApplicationTriggerHandler.updateContact(Trigger.oldMap, trigger.New);

	if(trigger.isInsert && trigger.isAfter)
		JobApplicationTriggerHandler.updateContact(trigger.New);
}
