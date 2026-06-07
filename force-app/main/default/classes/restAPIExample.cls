public class restAPIExample {
    
    /*Setup → Security → Remote Site Settings → New
* https://jsonplaceholder.typicode.com
*/
    public class post{
        public Integer userId;
        public Integer id;
        public String title;
        public String body;
        
    }
    @future (callout = true) // it is required when calling from a trigger or required to run it asynchronously
    public static void getExample(){
        Http http = new Http();
        HttpRequest  request = new HttpRequest ();
        request.setMethod('GET');
        request.setEndpoint('https://jsonplaceholder.typicode.com/posts/1');
        
        try{
            
            HttpResponse response = new HttpResponse();
            response = http.send(request);
            System.debug('StatusCode = '+response.getStatusCode());
            
            if(response.getStatusCode() == 200){
                System.debug('Success');
                System.debug('response.getBody() '+ response.getBody());
                
                /*Post post = (Post)JSON.deserialize(response.getBody(), Post.class);
System.debug('UserId ' +post.UserId );
System.debug('Id ' + post.id);
System.debug('Title ' + post.title);
System.debug('Body ' + post.body);
*/
                
            }else{
                System.debug('Failed with StatusCode = '+response.getStatusCode());
            }
        }
        catch( exception e){
            System.debug('Failed');
            System.debug('Error Msg: '+ e.getMessage());
            
        }
    }
    
    @future (callout=true)
    public static void postExample(){
        
        Map<string, string> postMap = new Map<string, string>{
            'id' => '23',
                'userId' => '23221',
                'body' => 'testing the post rest api example',
                'title' => 'Test'
                
                }; 
                    
                    Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('https://jsonplaceholder.typicode.com/posts');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(JSON.serialize(postMap));
        
        try{
            HttpResponse response  =  new HttpResponse();
            response = http.send(request);
            
            if(response.getStatusCode() == 201){
                //201 means new resource has been created
                System.debug('Success');
                System.debug('response.getBody() '+ response.getBody());
            }else{
                System.debug('Failed with StatusCode = '+response.getStatusCode());
            }
            
        }catch(exception e){
            System.debug('Failed');
            System.debug('Error Msg: '+ e.getMessage());
            
        }
    }
    
    @future (callout = true)
    public static void deleteExample(){
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('DELETE');
        request.setEndPoint('https://jsonplaceholder.typicode.com/posts/1');
        
        try{
            HttpResponse response  = new HttpResponse();
            response = http.send(request);
            
            if(response.getStatusCode() == 200){
                //200, 204 means succesful deletion
                System.debug('Success');
            }else{
                System.debug('Failed with StatusCode = '+response.getStatusCode());
            }
            
        }catch(exception e){
            System.debug('Failed');
            System.debug('Error Msg: '+ e.getMessage());
            
        }
        
    }
    
    @future (callout = true)
    public static void patchExample(){
        Map<String, String> mapToUpdate = new Map<String, String>{
            'title' => 'I think',
                'id' => '24'
                };
                    
                    Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndPoint('https://jsonplaceholder.typicode.com/posts/1');
        request.setMethod('PATCH');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(JSON.serialize(mapToUpdate));
        
        try{
            
            HttpResponse response = new HttpResponse();
            response = http.send(request);
            System.debug('status code: '+response.getStatusCode());
            System.debug('response.body: '+response.getBody());
            
        }catch(exception e){
            System.debug('Failed');
            System.debug('Error Msg: '+ e.getMessage());
            
        }
    }
}