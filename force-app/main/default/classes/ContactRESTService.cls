@RestResource(urlMapping = '/services/apexrest/contacts/*')
    global class ContactRESTService {
    
        @HttpGet
        global static Contact doGet(){
            
            RestRequest request = RestContext.request;
            
            string contactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
            return[SELECT Id, FirstName, LastName, Email, Phone
                  FROM Contact
                  WHERE Id=: contactId];
            
        }
        
      
        @HttpPatch
        global static string doPatch(){
    		RestRequest request = RestContext.request;
            
            Map<string,Object> body = (Map<string,Object>)JSON.deserializeUntyped(request.requestBody.toString());
            List<contact> contactList = [SELECT Id, Email, Phone
                                        FROM Contact
                                        Where Id=: (string)body.get('contactId')];
            if(contactList.isempty())
                return 'Contact Record not Found';
            
            contact c = contactList[0];
            c.email = (string)body.get('email');
            c.phone = (string)body.get('phone');
            
            update c;
            return 'Contact updated successfully';
		}
    }