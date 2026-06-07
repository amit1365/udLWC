global class OrderManagementSOAPInbound {
    
    webservice static opportunitywrapper createOrder
        (string accountId, string productName, integer quantity){
        
        List<Account> accList = [SELECT Id FROM Account WHERE Id=: accountId];
        if(accList.isempty())
            throw new calloutException ('Account with such Id does not exixst');
        
        decimal discount= 0;
        if(quantity > 100 )
            discount= 10;
        if(quantity > 500)
            discount= 20;
        
        Opportunity opp = new Opportunity();
        opp.name = productName + ' Order';
        opp.Amount = quantity*(500 - (500*discount/100));
        opp.CloseDate = date.today()+30;
        opp.StageName = 'Prospecting';
        opp.AccountId = accountId;
        
        insert opp;
        
        opportunitywrapper oppwrp = new opportunitywrapper();
        oppwrp.opportunityId = opp.id;
        oppwrp.totalPrice = opp.Amount;
        oppwrp.discountApplied = discount > 0 ? true : false; 
        // oppwrp.discountApplied = discount > 0; is also correct
        
        return oppwrp;
    }
    
    global class opportunitywrapper{
        webservice string opportunityId;
        webservice decimal totalPrice;
        webservice boolean discountApplied;
    }

}