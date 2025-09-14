public class contactTriggerHandler {
    
    public static void checkNumberOfContacts(List<contact> newContactList){
        set<Id> accountIdSet = new Set<Id>();
        Map<Id, integer> accIdToNoOfCont= new Map<Id, Integer>();
        
        for(contact con : newContactList){
            if(con.AccountId != null){
                accountIdSet.add(con.AccountId);
            }
        }
        
        List<AggregateResult> aggrList = [SELECT COUNT(Id) numberOfContatcts
                                          FROM Contact 
                                          WHERE AccountId IN: accountIdSet 
                                          Group By AccountId ];
        
        for(AggregateResult agr : aggrList){
            accIdToNoOfCont.put((Id)agr.get('AccountId'), (Integer)agr.get('numberOfContatcts'));
        }
        
        for(contact con : newContactList){
            if(accIdToNoOfCont.containskey(con.AccountId) && accIdToNoOfCont.get(con.AccountId) >= 2){
                con.addError('This contact already has 2 contacts');
            }
        }
    }
}