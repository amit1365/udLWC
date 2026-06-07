//outbound rest api service, can be edited from webconsole as well
public class EmployeeCalloutService {
     public static string getEmployee(Integer employeeId){
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('https://reqres.in/api/users/' + employeeId);
                        
		Http http = new Http();
        string s='';
		try{
             HttpResponse res = new HttpResponse();
             res = http.send(req);
             System.debug('StatusCode = '+res.getStatusCode());
                   if(res.getStatusCode() == 200){
                        /*p<string, object> returnedRes = (Map<string,object>)JSON.deserializeUntyped(res.getBody());
                        s= (string)returnedRes.get('name') + (string)returnedRes.get('email'); 
						*/
                       
                       
                       Map<String, Object> responseBody =(Map<string,object>)JSON.deserializeUntyped(res.getBody());
                       Map<String, Object> data = (Map<String, Object>) responseBody.get('data');
                       s= (string)data.get('first_name') + ' ' + (string)data.get('last_name')+', '+(string)data.get('email');
                       
					}
                            
                            
			}catch(exception e){
				system.debug('error msg: '+e.getMessage());
                system.debug('error at line '+e.getLineNumber());
			}
             return s;
        }
    
    class EmployeeWrapper{
        string name;
        string job;
    }
    
    public static string createEmployee(String name, String job){
        
        EmployeeWrapper wrp = new EmployeeWrapper();
        wrp.name= name;
        wrp.job= job;
        
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('https://reqres.in/api/users');
        request.setHeader('Content-Type','application/json');
        request.setBody(JSON.serialize(wrp));
        
        Http http = new Http();
        string  empId;
        
        try{
        HttpResponse response = new HttpResponse();
        response = http.send(request);
		System.debug('StatusCode = '+response.getStatusCode());
            if(response.getStatusCode() == 201){
                map<string, object> responseBody = (Map<string, object>) JSON.deserializeUntyped(response.getBody());
                empId = (string)responseBody.get('id');
        	}
        }catch(exception e){
            system.debug('error msg: '+e.getMessage());
            system.debug('error at line '+e.getLineNumber());
        }
        return empId;
    }
    
    public static string updateEmployee(Integer employeeId, String name, String job){
        
        EmployeeWrapper wrp = new EmployeeWrapper();
        wrp.name= name;
        wrp.job= job;
        
        HttpRequest request = new HttpRequest();
        request.setMethod('PUT');
        request.setEndpoint('https://reqres.in/api/users/'+employeeId);
        request.setHeader('Content-Type','application/json');
        request.setbody(JSON.serialize(wrp));
        
        Http http = new Http();
        string timestamp = '';
        
        try{
            
            HttpResponse response = new HttpResponse();
            response = http.send(request);
            System.debug('StatusCode = '+response.getStatusCode());
            
            if(response.getStatusCode() == 200){
                Map<string, object> responseBody = (Map<string, object>)JSON.deserializeUntyped(response.getBody());
                timestamp = (string)responseBody.get('updatedAt');
            }
        }catch(exception e){
            system.debug('error msg: '+e.getmessage());
            system.debug('error line: '+e.getLineNumber());
        }
        
        return timestamp;
        
    }
    
    public static string patchEmployee(Integer employeeId, String newJob){
        
        Map<String, Object> body = new Map<String, Object>{'job' => newJob};
        
        HttpRequest request = new HttpRequest();
        request.setMethod('PATCH');
        request.setBody(JSON.serialize(body));
        request.setEndpoint('https://reqres.in/api/users/'+employeeId);
        request.setHeader('Content-Type','application/json');
        
        Http http = new Http();
        String timestamp = '';
        
        try{
            HttpResponse response = new HttpResponse();
            response = http.send(request);
            System.debug('StatusCode = '+response.getStatusCode());
            
            if(response.getStatusCode()==200){
                 Map<string, object> responseBody = (Map<string, object>)JSON.deserializeUntyped(response.getBody());
                 timestamp = (string) responseBody.get('updatedAt');
            }
        }catch(exception e){
            system.debug('error msg: '+e.getmessage());
            system.debug('error line: '+e.getLineNumber());
        }
        return timestamp;
    }
    
    public static boolean deleteEmployee(Integer employeeId){
        
        HttpRequest request = new HttpRequest();
        request.setMethod('DELETE');
        request.setEndpoint('https://reqres.in/api/users/'+employeeId);
        
        Http http = new Http();
        Boolean deleted = false;
        
        try{
            HttpResponse response = new HttpResponse();
            response = http.send(request);
            System.debug('StatusCode = '+response.getStatusCode());
            
            if(response.getStatusCode() == 204)
                deleted = true;
        }catch(exception e){
            system.debug('error msg: '+e.getmessage());
            system.debug('error line: '+e.getLineNumber());
        }
        return deleted;
    }
}