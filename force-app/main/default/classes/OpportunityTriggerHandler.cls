public class OpportunityTriggerHandler {
    
    public static void afterUpdate(Map<id, Opportunity> oldmap, List<Opportunity> newList){
        Map<id, decimal> accountIdToAmtMap = new Map<id, decimal>();
        set<id> accountIdSet = new set<id>();
        
        for(Opportunity opp : newList){
            
            if((opp.StageName !=  oldmap.get(opp.id).StageName)){
                accountIdSet.add(opp.AccountId);
                
                if(opp.StageName == 'Closed/Won'){
                    Decimal existing = accountIdToAmtMap.containsKey(opp.AccountId) ? accountIdToAmtMap.get(opp.AccountId) : 0.0;
                    accountIdToAmtMap.put(opp.AccountId, existing + opp.Amount);
                    
                }else if(oldmap.get(opp.id).StageName == 'Closed/Won'){
                    Decimal existing = accountIdToAmtMap.containsKey(opp.AccountId) ?  accountIdToAmtMap.get(opp.AccountId) : 0.0;
                    accountIdToAmtMap.put(opp.AccountId, opp.Amount - existing - oldmap.get(opp.id).Amount);
                }
            }
        }
        
        Map<id, account> accIdToAccMap = new Map<Id, account>([SELECT Id, Total_Closed_Revenue__c FROM Account where id IN:  accountIdSet]);
        List<account> accountListToUpdate = new List<account>();
        
        for(id accid: accIdToAccMap.keyset()){
            accIdToAccMap.get(accid).Total_Closed_Revenue__c = (accIdToAccMap.get(accid).Total_Closed_Revenue__c == null? 0.0 : accIdToAccMap.get(accid).Total_Closed_Revenue__c)  + accountIdToAmtMap.get(accid);
            accountListToUpdate.add(accIdToAccMap.get(accid));
        }
        
        if(!accountListToUpdate.isempty())
            update accountListToUpdate;
    }
    
    public static void afterDelete(List<opportunity> oldList){
        
        Set<Id> accountIdSet = new Set<Id>();
        Map<Id, decimal> accIdToAmtMap = new Map<Id, decimal>();
        
        for(opportunity opp: oldList){
            if(opp.stagename == 'Closed/Won'){
                accountIdSet.add(opp.AccountId);
                accIdToAmtMap.put(opp.AccountId, opp.Amount);
            }
        }
        
        Map<Id, Account> accIdToAccMap = new Map<Id, Account>([SELECT Id, Total_Closed_Revenue__c FROM Account WHERE Id IN: accountIdSet ]);
        List<account> accountListToUpdate = new List<account>();
        for(id accid : accIdToAccMap.keyset()){
            accIdToAccMap.get(accid).Total_Closed_Revenue__c = accIdToAccMap.get(accid).Total_Closed_Revenue__c - accIdToAmtMap.get(accid);
            accountListToUpdate.add(accIdToAccMap.get(accid));
        }
        if(!accountListToUpdate.isempty())
            update accountListToUpdate;
    }
    
    public static void beforeInsert(List<Opportunity> newList){
        
        set<string> oppNameString = new SET<string>();
        
        for(opportunity opp: newList){
            oppNameString.add(opp.name);
        }
        
        Map<string, Id> oppNameToOppIdMap = new Map<string, Id>();
        Map<string, Id> oppNameToAccIdMap = new Map<string, Id>();
        
        List<opportunity> oppList = new List<opportunity>([SELECT Id, Name, accountId FROM opportunity WHERE Name In: oppNameString AND StageName != 'Closed Lost']);
        for(opportunity opp: oppList){
            oppNameToOppIdMap.put(opp.name, opp.Id);
            oppNameToAccIdMap.put(opp.id, opp.accountId);
        }
        
        for(opportunity opp: newList){
            
            if(oppNameToOppIdMap.containskey(opp.name) && oppNameToAccIdMap.get(oppNameToOppIdMap.get(opp.name)) == opp.AccountId)
                opp.addError('A similar active deal already exists for this account.');
        }
        
        
    }
    
}