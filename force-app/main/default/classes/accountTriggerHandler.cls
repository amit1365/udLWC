public class accountTriggerHandler {
    
    public static void beforeInsert(List<Account> newList){
        for(account acc : newList){
            if(acc.Phone == null || acc.Phone == ''){
                acc.addError('You cannot insert account with phone field empty');
            }
        }
    }
    
    public static void createContacts(List<Account> newList){
        List<Contact> contactsToInsert = new List<Contact>();
        for(account acc : newList){
            
            if(acc.Create_New_Contact__c == true){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Phone = acc.Phone;
                con.FirstName = acc.Name;
                con.LastName = 'Contact';
                contactsToInsert.add(con);
                
            }
        }
        
        if(!contactsToInsert.isempty())
            INSERT contactsToInsert;
    }
    
    public static void checkBeforeDelete(List<Account> accountList){
        for(account acc : accountList){
            if(acc.Active__c == 'Yes'){
                acc.addError ('This is an active account! You cannot delete and active account.');
            }
        }
    }

}