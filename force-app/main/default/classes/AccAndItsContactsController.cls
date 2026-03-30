public with sharing class AccAndItsContactsController {
    
    @AuraEnabled(cacheable = true)
    public static List<Account> getAccounts(){
      List<Account> accountsListToReturn = new List<Account>();

        if (!Schema.sObjectType.Account.isAccessible()) {
            throw new AuraHandledException('You do not have permission to access Account records.');
        }else {
            accountsListToReturn = [SELECT Id, Name 
                                    FROM Account];
        }
        return accountsListToReturn;
    }

    @AuraEnabled
    public static List<Contact> getContacts(string accId) {
       List<contact> contactList = new List<contact>();
       
        if (!Schema.sObjectType.Contact.isAccessible()) {
            throw new AuraHandledException('You do not have permission to access Contact records.');
        }else {
            contactList = [SELECT Id, Name, email, phone
                                    FROM Contact
                                    WHERE AccountId = :AccId];
        }
        return contactList;
    }
}