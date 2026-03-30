public with sharing class SearchAccountsController {

    @AuraEnabled(cacheable = true)
    public static List<Account> getAccounts( String searchName){
       searchName = '%' + searchName + '%';
      List<Account> accountsListToReturn = new List<Account>();

        if (!Schema.sObjectType.Account.isAccessible()) {
            throw new AuraHandledException('You do not have permission to access Account records.');
        }else {
            accountsListToReturn = [SELECT Id, Name 
                                    FROM Account
                                    WHERE Name like :searchname];
        }
        return accountsListToReturn;
    }
}