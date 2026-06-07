public class JobApplicationTriggerHandler{

	public static Boolean hasRun = false;

	public static void updateContact(List<Job_Application__c> newList){

		Set<Id> contactIdSet = new Set<Id>();

		for(Job_Application__c ja : newList){
			if(ja.Status__c == 'Offer Accepted' && ja.contact__c != null){
				contactIdSet.add(ja.contact__c);
			}
		}

		if(contactIdSet.isEmpty())
			return;

		if(!Schema.sObjectType.Contact.fields.Is_Hired__c.isUpdateable()){
			System.debug('FLS check failed — insufficient permissions');
			return;
		}

		List<Contact> contactListToUpdate = new List<Contact>();

		for(Contact con : [SELECT Id, Is_Hired__c FROM Contact WHERE Id IN :contactIdSet]){
			con.Is_Hired__c = true;
			contactListToUpdate.add(con);
		}

		if(!contactListToUpdate.isEmpty()){
			List<Database.SaveResult> results = Database.update(contactListToUpdate, false);
			for(Database.SaveResult sr : results){
				if(!sr.isSuccess())
					System.debug('Failed: ' + sr.getErrors());
			}
		}
	}

	public static void updateContact(Map<Id, Job_Application__c> oldMap, List<Job_Application__c> newList){

		Set<Id> contactIdSet = new Set<Id>();

		for(Job_Application__c ja : newList){
			if(ja.Status__c == 'Offer Accepted' && oldMap.get(ja.Id).Status__c != 'Offer Accepted' && ja.contact__c != null){
				contactIdSet.add(ja.contact__c);
			}
		}

		if(contactIdSet.isEmpty())
			return;

		if(!Schema.sObjectType.Contact.fields.Is_Hired__c.isUpdateable()){
			System.debug('FLS check failed — insufficient permissions');
			return;
		}

		List<Contact> contactListToUpdate = new List<Contact>();

		for(Contact con : [SELECT Id, Is_Hired__c FROM Contact WHERE Id IN :contactIdSet]){
			con.Is_Hired__c = true;
			contactListToUpdate.add(con);
		}

		if(!contactListToUpdate.isEmpty()){
			List<Database.SaveResult> results = Database.update(contactListToUpdate, false);
			for(Database.SaveResult sr : results){
				if(!sr.isSuccess())
					System.debug('Failed: ' + sr.getErrors());
			}
		}
	}
}
