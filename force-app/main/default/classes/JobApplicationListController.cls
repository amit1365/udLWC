public with sharing class JobApplicationListController {
    

    @auraEnabled(cacheable =true)
    public static List<Job_Application__c> getJobApplications() {
        return [SELECT Id, Name, Contact__c, contact__r.name, Status__c 
                FROM Job_Application__c
                WHERE ownerId = : UserInfo.getUserId()
                LIMIT 200];
    }

    @auraEnabled
    public static void updateJobStatus( Id jobAppId){

        //Savepoint sp = Database.setSavepoint();
        try{
            Job_Application__c ja = [SELECT Id, Status__c FROM Job_Application__c WHERE Id=:jobAppId LIMIT 1];
            ja.Status__c = 'Offer Accepted';
            update ja;
        }catch(exception e){
            system.debug('Error Occured msg: '+e.getMessage());
            system.debug('at line number: '+e.getLineNumber());
            //Database.rollback(sp);
            throw new AuraHandledException(e.getMessage());
        }

    }
}