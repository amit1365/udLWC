global class batchClassExample implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Rating FROM Account WHERE Rating = NULL');
    }
    
    global void execute(Database.BatchableContext bc, List<Account> accList) {
        for (Account acc : accList) {
            acc.Rating = 'Warm';
        }
        update accList;
    }
    
    global void finish(Database.BatchableContext bc) {
        System.debug('Batch job completed.');
    }
    
}


/*
        batchClassExample b = new batchClassExample();
        Database.executeBatch(b, 200); // 200 = batch size
    
*/