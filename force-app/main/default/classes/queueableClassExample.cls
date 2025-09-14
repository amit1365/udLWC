public class queueableClassExample implements Queueable{
    
    public Set<Id> accountIdSet; 
    
    public queueableClassExample(Set<Id> accountIddSet){
        this.accountIdSet = accountIddSet;
    }
    
    public void execute(QueueableContext context){
        List <account> accList = [SELECT Id, Name, Description 
                                  FROM Account 
                                  Where Id IN: accountIdSet];
        
        for(account acc: accList){
            acc.Description = 'Testing Queuable Apex';
        }
        if(!accList.isempty()){
            update accList;
        }
    }
    
    List <account> accList = [SELECT Id, Name, Description 
                          FROM Account
                          LIMIT 10];

}

	/*In Dev Console, or from any other apex
     * 
     * Set<Id> accIdSet = new Set<Id>();
     *for(account acc: accList)
     *accIdSet.add(acc.Id);
     *System.enqueueJob(new queueableClassExample(accIdSet));
	 */