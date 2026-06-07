global class AccountSoapwebService {
    
    webservice static string getAccountName( Id accountid){
        List<account> accountList = [Select Id, Name 
                                     from account
                                     where id=: accountid ];
        return accountList[0].name;
    }
    
    webservice static id insertAccout ( String Name, string Industry){
        Account acc= new Account();
        acc.Name = Name;
        acc.Industry = Industry;
        
        insert acc;
        return acc.id;
    }
}