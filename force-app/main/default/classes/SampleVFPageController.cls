public class SampleVFPageController {

    public List<Account> accountList {get;set;}
    
    public SampleVFPageController(){
        accountList = new List<Account>();
        accountList = [SELECT Id, Name, OwnerId, Owner.Name FROM Account];
    }
}