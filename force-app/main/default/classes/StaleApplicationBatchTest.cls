@isTest
public class StaleApplicationBatchTest {

    @testSetup
    static void setupData(){
        // Create contacts
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 0; i < 200; i++){
            contacts.add(new Contact(LastName = 'Test ' + i));
        }
        insert contacts;

        // 100 Applied + 100 Interview = 200 stale records
        List<Job_Application__c> staleApps = new List<Job_Application__c>();
        for(Integer i = 0; i < 100; i++){
            staleApps.add(new Job_Application__c(
                Name = 'Stale App ' + i,
                Status__c = 'Applied',
                Contact__c = contacts[i].Id
            ));
        }
        for(Integer i = 100; i < 200; i++){
            staleApps.add(new Job_Application__c(
                Name = 'Stale App ' + i,
                Status__c = 'Interview',
                Contact__c = contacts[i].Id
            ));
        }
        insert staleApps;

        // 50 New records - should be untouched
        List<Job_Application__c> freshApps = new List<Job_Application__c>();
        for(Integer i = 0; i < 50; i++){
            freshApps.add(new Job_Application__c(
                Name = 'Fresh App ' + i,
                Status__c = 'New'
            ));
        }
        insert freshApps;
    }

    @isTest
    static void testBatch(){
        Test.startTest();
        Database.executeBatch(new StaleApplicationBatch(), 200);
        Test.stopTest();

        // Assert all stale records are rejected
        List<Job_Application__c> rejectedApps = [
            SELECT Id, Status__c 
            FROM Job_Application__c 
            WHERE Status__c = 'Rejected'
        ];
        System.assertEquals(200, rejectedApps.size(), '200 stale records should be rejected');

        // Assert New records were untouched
        List<Job_Application__c> freshApps = [
            SELECT Id, Status__c 
            FROM Job_Application__c 
            WHERE Status__c = 'New'
        ];
        System.assertEquals(50, freshApps.size(), 'Fresh records should be untouched');
    }

    @isTest
    static void testScheduler(){
        Test.startTest();
        StaleApplicationScheduler.scheduleJobAppBatch();
        Test.stopTest();

        // Assert job was scheduled correctly
        CronTrigger ct = [
            SELECT Id, CronExpression, State 
            FROM CronTrigger 
            WHERE CronJobDetail.Name = 'Job Application Batch'
            LIMIT 1
        ];
        System.assertNotEquals(null, ct, 'Scheduled job should exist');
        System.assertEquals('0 0 21 * * ?', ct.CronExpression, 'Cron should be 9 PM daily');
    }
}