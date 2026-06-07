@RestResource(urlMapping='/services/apexrest/accounts/*')
global class RestResourceExample {
    
    @HttpGet
    global static void getAccounts() {
        RestRequest  req = RestContext.request;
        RestResponse res = RestContext.response;
        
        try {
            // Extract last segment from URI
            List<string> uriParts = req.requestURI.split('/');
            String accId = uriParts[uriParts.size() - 1];
            
            // ── Fetch ALL accounts ──────────────────────────────────────
            if (String.isBlank(accId) || accId.equalsIgnoreCase('accounts')) {
                List<Account> accList = [SELECT Id, Name, Phone, Industry FROM Account LIMIT 200];
                
                if (accList.isEmpty()) {
                    res.statusCode = 404;
                    res.responseBody = Blob.valueOf('{"error":"No accounts found"}');
                    return;
                }
                
                res.statusCode    = 200;
                res.responseBody  = Blob.valueOf(JSON.serialize(accList));
                
                // ── Fetch SINGLE account by Id ──────────────────────────────
            } else {
                // Validate Id format before querying
                try {
                    Id validatedId = (Id) accId;
                } catch (StringException e) {
                    res.statusCode   = 400;
                    res.responseBody = Blob.valueOf('{"error":"Invalid Account Id"}');
                    return;
                }

                //another easy way to validate id
                /*
                if(!Id.isValid(accId)){
                    res.statuscode = 400;
                    res.responsebody = Blob.Valueof('{"error":"invalid account id"}');
                    return;
                }*/
                
                List<Account> accList = [SELECT Id, Name, Phone, Industry FROM Account WHERE Id = :accId LIMIT 1];
                
                if (accList.isEmpty()) {
                    res.statusCode   = 404;
                    res.responseBody = Blob.valueOf('{"error":"Account not found"}');
                    return;
                }
                
                res.statusCode   = 200;
                res.responseBody = Blob.valueOf(JSON.serialize(accList[0]));
            }
            
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage() + '\n' + e.getStackTraceString());
            res.statusCode   = 500;
            res.responseBody = Blob.valueOf('{"error":"Internal server error"}');
        }
    }
    
    @HttpPost
    global static void post(){
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        try{
            string jsonstring = req.requestBody.toString();// it is in blob form so we need to convert it in string form
            Account acc = (Account)Json.deserialize(jsonstring, Account.class);
            insert acc;
            res.statusCode=201;
            res.responseBody = Blob.valueof('{"Success": "account created successfully"}');
        }catch(exception e){
            res.statusCode   = 500;
            res.responseBody = Blob.valueOf('{"error":"Internal server error"}');
            
        }
        
    }
    
    @HttpPatch
    global static void patch(){
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        try{
            
            List<string> URIparts = req.requestURI.split('/');
            String accId = URIParts[URIParts.size()-1];
            if(String.isBlank(accId)){
                res.statusCode   = 400;
                res.responseBody = Blob.valueOf('{"error":"Invalid Account Id"}');
                return;
            }
            List<Account> existing = [SELECT Id FROM Account WHERE Id = :accId LIMIT 1];
            if (existing.isEmpty()) {
                res.statusCode   = 404;
                res.responseBody = Blob.valueOf('{"error":"Account not found"}');
                return;
            }
            
            try{
                Id validateId = (Id)accId;
                
            }catch(exception e){
                res.statusCode   = 400;
                res.responseBody = Blob.valueOf('{"error":"Invalid Account Id"}');
                return;
            }
            
            string jsonstring = req.requestBody.tostring();
            Account acc = (Account)JSON.deserialize(jsonstring, Account.class);
            acc.id= accId;
            update acc;
            
            res.statusCode = 200;
            res.responseBody = Blob.valueOf('{"OK":"Account updated successfully"}');
            
        }catch(exception e){
            res.StatusCode =500;
            res.responseBody = Blob.valueOf('{"Failed":"Error Occured"}');
        }
    }
    
    @httpDelete
    global static void Deletemethod(){
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        try{
            List<string> stringList = req.requestURI.split('/');
            string accId = stringList[stringList.size()-1];
            
            try{
                Id validatedId = (Id) accId;
                
            }catch(exception e){
                res.StatusCode = 400;
                res.responseBody = Blob.valueOf('{"error":"No accounts found"}');
                return;
            }
            
            List<account> accList = [SELECT Id FROM Account WHERE Id=: accId limit 1];
            DELETE accList;
            
            res.statusCode = 204;
            res.responseBody = Blob.ValueOf('{"deleted":"no content found"}'); 
            
        }catch(exception e){
            res.StatusCode =500;
            res.responseBody = Blob.valueOf('{"Failed":"Error Occured"}');
        }
    }   
}