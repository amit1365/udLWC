Trigger accountTrigger on Account (after Update){
    if(trigger.isAfter && trigger.isUpdate){
        Map<Id, Id> accountIdToOwnerId = new Map<Id, Id>();
        Set<Id> accountIdSet = new Set<Id>();
        
        for(account acc: trigger.new){
            if(acc.ownerId != trigger.oldMap.get(acc.Id).ownerId){
                accountIdSet.add(acc.Id);
                accountIdToOwnerId.put(acc.Id, acc.OwnerId);
            }
        }
        
        if(!accountIdSet.isempty()){
            List<Contact> contactListToUpdate = [Select Id, AccountId, ownerId FROM Contact Where AccountId IN: accountIdSet ];
            List<Contact> newcontactListToUpdate = new List<Contact> ();
            if(!contactListToUpdate.isempty()){
                for(contact con : contactListToUpdate ){
                    if(accountIdToOwnerId.containskey(con.AccountId)){
                        con.OwnerId =accountIdToOwnerId.get(con.AccountId);
                        newcontactListToUpdate .add(con); 
                    }
                    
                }
                
                if(!newcontactListToUpdate .isempty()){
                    Update newcontactListToUpdate;
                }
                
                
            }
            
            
        }
    }
}