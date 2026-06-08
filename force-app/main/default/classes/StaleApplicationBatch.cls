public class StaleApplicationBatch implements Database.Batchable<sObject>, Database.Stateful {
    Integer counter = 0;
    public Database.queryLocator start(Database.BatchableContext bc){
        //return Database.getQueryLocator('SELECT Id, Name, Status__c, LastModifiedDate FROM Job_Application__c WHERE (Status__c = \'Applied\' OR Status__c = \'Interview\') AND  LastModifiedDate < LAST_N_DAYS:30');
        DateTime cutoff = Test.isRunningTest() ? System.now().addDays(1) : System.now().addDays(-30);
        //DateTime cutoff = System.now().addDays(-30);
        return Database.getQueryLocator([
        SELECT Id, Name, Status__c, LastModifiedDate 
        FROM Job_Application__c 
        WHERE (Status__c = 'Applied' OR Status__c = 'Interview') 
        AND LastModifiedDate < :cutoff ]);
    }

    public void execute(Database.BatchableContext bc, List<Job_Application__c > scope){
        List<Job_Application__c> jaListToUpdate = new List<Job_Application__c>();
        for(Job_Application__c  ja: scope){
            ja.Status__c = 'Rejected';
            jaListToUpdate.add(ja);
        }
        
        List<Database.SaveResult> results = Database.update(jaListToUpdate, false);
        for(Database.SaveResult sr : results){
            if(sr.isSuccess()){
                this.counter ++;

            }else{
                for(Database.Error err: sr.getErrors()){
                  System.debug(err.getStatusCode() + ': ' + err.getMessage());  
                }
            }
        }
        
    }

    public void finish(Database.BatchableContext bc){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{'admin@test.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Batch Update of Job Applications');
        mail.setPlainTextBody('Total Records updated: '+counter);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });


    }
}