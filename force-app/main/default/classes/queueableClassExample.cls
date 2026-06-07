public class queueableClassExample implements Queueable{
    
    public Set<Id> accountIdSet;
    public list<Account> accountList;
    
    //contructor, it can take sObjects as parameters as well
    public queueableClassExample(Set<Id> accountIddSet, List<account> accountList){
        this.accountIdSet = accountIddSet;
        this.accountList = accountList;
    }
    
    //execute method
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
     *Id jobId= System.enqueueJob(new queueableClassExample(accIdSet, accList));
	 */