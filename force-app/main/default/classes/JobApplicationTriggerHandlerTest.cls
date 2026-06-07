@isTest
public class JobApplicationTriggerHandlerTest {

	@testSetup
	static void setupData(){

		List<Contact> contactToInsert = new List<Contact>();
		for(Integer i = 0; i < 200; i++){
			contactToInsert.add(new Contact(lastname = 'test' + i));
		}
		insert contactToInsert;

		List<Job_Application__c> jaListToInsert = new List<Job_Application__c>();

		for(Integer i = 0; i < 20; i++){
			jaListToInsert.add(new Job_Application__c(
				name = 'test' + i,
				status__c = 'New',
				contact__c = contactToInsert[i].Id
			));
		}

		for(Integer i = 20; i < 100; i++){
			jaListToInsert.add(new Job_Application__c(
				name = 'test' + i,
				status__c = 'Applied',
				contact__c = contactToInsert[i].Id
			));
		}

		for(Integer i = 100; i < 150; i++){
			jaListToInsert.add(new Job_Application__c(
				name = 'test' + i,
				status__c = 'Interview',
				contact__c = contactToInsert[i].Id
			));
		}

		insert jaListToInsert;
	}

	@isTest
	static void testInsert(){

		List<Contact> contactToInsert = new List<Contact>();
		for(Integer i = 200; i < 400; i++){
			contactToInsert.add(new Contact(lastname = 'test' + i));
		}
		insert contactToInsert;

		List<Job_Application__c> jaListToInsert = new List<Job_Application__c>();

		for(Integer i = 200; i < 300; i++){
			jaListToInsert.add(new Job_Application__c(
				name = 'test' + i,
				status__c = 'New',
				contact__c = contactToInsert[i - 200].Id
			));
		}

		for(Integer i = 300; i < 400; i++){
			jaListToInsert.add(new Job_Application__c(
				name = 'test' + i,
				status__c = 'Offer Accepted',
				contact__c = contactToInsert[i - 300].Id
			));
		}

		Test.startTest();
		insert jaListToInsert;
		Test.stopTest();

		List<Contact> hired = [SELECT Id, Is_Hired__c FROM Contact WHERE Is_Hired__c = true];
		System.assertEquals(100, hired.size(), '100 contacts should be hired');
	}

	@isTest
	static void testUpdate(){

		List<Job_Application__c> jaListToUpdate = new List<Job_Application__c>();
		List<Job_Application__c> jaList = [SELECT Id, status__c FROM Job_Application__c WHERE status__c != 'Offer Accepted'];

		for(Job_Application__c ja : jaList){
			ja.status__c = 'Offer Accepted';
			jaListToUpdate.add(ja);
		}

		Test.startTest();
		update jaListToUpdate;
		Test.stopTest();

		List<Contact> hired = [SELECT Id, Is_Hired__c FROM Contact WHERE Is_Hired__c = true];
		System.assertEquals(150, hired.size(), 'All updated contacts should be hired');
	}

	@isTest
	static void testBulk(){

		List<Contact> contacts = [SELECT Id FROM Contact];

		List<Job_Application__c> jaList = new List<Job_Application__c>();
		for(Integer i = 0; i < 200; i++){
			jaList.add(new Job_Application__c(
				name = 'bulk' + i,
				status__c = 'Offer Accepted',
				contact__c = contacts[i].Id
			));
		}

		Test.startTest();
		insert jaList;
		Test.stopTest();

		List<Contact> hired = [SELECT Id, Is_Hired__c FROM Contact WHERE Is_Hired__c = true];
		System.assertEquals(200, hired.size(), 'All 200 contacts should be hired');
	}
}
