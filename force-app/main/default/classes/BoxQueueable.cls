public class BoxQueueable implements Queueable, Database.AllowsCallouts {
    
    private String operation;
    private String accountId;
    private String accountName;
    private String fileName;
    private Blob fileContent;
    
    // Constructor
    public BoxQueueable(String operation, String accountId, String accountName,
                        String fileName, Blob fileContent) {
        this.operation   = operation;
        this.accountId   = accountId;
        this.accountName = accountName;
        this.fileName    = fileName;
        this.fileContent = fileContent;
    }
    
    // Entry point
    public void execute(QueueableContext context) {
        String accessToken = BoxTokenService.getAccessToken();
        
        if (operation == 'createFolder') {
            createFolder(accessToken);
        } else if (operation == 'uploadFile') {
            uploadFile(accessToken);
        }
    }
    
    // Operation 1 — Create Box folder for Account
    private void createFolder(String accessToken) {
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Box_API/2.0/folders');
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        req.setHeader('Content-Type', 'application/json');
        
        Map<String, Object> body = new Map<String, Object>{
            'name'   => accountName,
            'parent' => new Map<String, String>{ 'id' => '0' }
        };
        req.setBody(JSON.serialize(body));
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 201) {
            Map<String, Object> responseMap =
                (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            String folderId = (String) responseMap.get('id');
            
            // Save folder ID on Account
            Account acc = new Account(Id = accountId);
            acc.Box_Folder_Id__c = folderId;
            update acc;
            
        } else {
            throw new CalloutException(
                'Create Folder Error: ' + res.getStatusCode() + ' ' + res.getBody()
            );
        }
    }
    
    // Operation 2 — Upload file to Account's Box folder
    private void uploadFile(String accessToken) {
        
        Account acc = [SELECT Box_Folder_Id__c FROM Account WHERE Id = :accountId LIMIT 1];
        String folderId = acc.Box_Folder_Id__c;
        
        String boundary = '----BoxFormBoundary';
        String attributes = '{"name":"' + fileName + '","parent":{"id":"' + folderId + '"}}';
        
        String header = '--' + boundary + '\r\n' +
            'Content-Disposition: form-data; name="attributes"\r\n\r\n' +
            attributes + '\r\n' +
            '--' + boundary + '\r\n' +
            'Content-Disposition: form-data; name="file"; filename="' + fileName + '"\r\n' +
            'Content-Type: application/octet-stream\r\n\r\n';
        
        String footer = '\r\n--' + boundary + '--';
        
        // Combine all parts as Base64 then decode to Blob
        String bodyEncoded = EncodingUtil.base64Encode(Blob.valueOf(header)) +
                             EncodingUtil.base64Encode(fileContent) +
                             EncodingUtil.base64Encode(Blob.valueOf(footer));
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Box_API/2.0/files/content');
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        req.setHeader('Content-Type', 'multipart/form-data; boundary=' + boundary);
        req.setBodyAsBlob(EncodingUtil.base64Decode(bodyEncoded));
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 201) {
            System.debug('File uploaded successfully to Box: ' + res.getBody());
        } else {
            throw new CalloutException(
                'Upload Error: ' + res.getStatusCode() + ' ' + res.getBody()
            );
        }
    }
}