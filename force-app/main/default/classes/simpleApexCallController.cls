public with sharing class SimpleApexCallController {

    @AuraEnabled    
    public static void updateAccountName(Id accountId, String newName) {

        // Check read and update access before SOQL/DML
        if (!Schema.sObjectType.Account.isAccessible() || !Schema.sObjectType.Account.isUpdateable()) {
            throw new AuraHandledException('Insufficient permissions to access or update Account.');
        }
        Account acc = [SELECT Id, Name FROM Account WHERE Id = :accountId LIMIT 1];        
        if (acc != null) {            
            acc.Name = newName;            
            update acc;        
        }    
    }
       
    @AuraEnabled    
    public static Account getAccount(Id accountId) { 
        return [SELECT Id, Name, Industry FROM Account WHERE Id = :accountId LIMIT 1];    
    }
}
