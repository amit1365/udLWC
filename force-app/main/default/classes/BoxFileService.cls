public with sharing class BoxFileService {
    
    // Called by LWC to list files in Account's Box folder
    @AuraEnabled
    public static List<Map<String, String>> listFiles(String accountId) {
        
        // Step 1 — Get folder ID from Account
        Account acc = [
            SELECT Box_Folder_Id__c, Name 
            FROM Account 
            WHERE Id = :accountId 
            LIMIT 1
        ];
        
        // Step 2 — Check if folder exists
        if (String.isBlank(acc.Box_Folder_Id__c)) {
            throw new AuraHandledException(
                'No Box folder found for this Account. Please create a folder first.'
            );
        }
        
        // Step 3 — Get access token
        String accessToken = BoxTokenService.getAccessToken();
        
        // Step 4 — Call Box API
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Box_API/2.0/folders/' + acc.Box_Folder_Id__c + '/items');
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        req.setHeader('Content-Type', 'application/json');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        // Step 5 — Parse response
        if (res.getStatusCode() == 200) {
            Map<String, Object> responseMap =
                (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            List<Object> entries = (List<Object>) responseMap.get('entries');
            
            // Step 6 — Build file list to return to LWC
            List<Map<String, String>> fileList = new List<Map<String, String>>();
            
            for (Object entry : entries) {
                Map<String, Object> fileMap = (Map<String, Object>) entry;
                
                Map<String, String> fileInfo = new Map<String, String>{
                    'id'   => (String) fileMap.get('id'),
                    'name' => (String) fileMap.get('name'),
                    'type' => (String) fileMap.get('type')
                };
                fileList.add(fileInfo);
            }
            
            return fileList;
            
        } else {
            throw new AuraHandledException(
                'Error fetching files: ' + res.getStatusCode() + ' ' + res.getBody()
            );
        }
    }
    
    // Called by LWC to trigger folder creation
    @AuraEnabled
    public static void createFolder(String accountId, String accountName) {
        
        // Check if folder already exists
        Account acc = [
            SELECT Box_Folder_Id__c 
            FROM Account 
            WHERE Id = :accountId 
            LIMIT 1
        ];
        
        if (String.isNotBlank(acc.Box_Folder_Id__c)) {
            throw new AuraHandledException(
                'A Box folder already exists for this Account. Cannot create another.'
            );
        }
        
        // Enqueue the job
        System.enqueueJob(new BoxQueueable(
            'createFolder',
            accountId,
            accountName,
            null,
            null
        ));
    }
    
    // Called by LWC to trigger file upload
    @AuraEnabled
    public static void uploadFile(String accountId, String fileName, String base64Data) {
        
        // Check if folder exists before uploading
        Account acc = [
            SELECT Box_Folder_Id__c 
            FROM Account 
            WHERE Id = :accountId 
            LIMIT 1
        ];
        
        if (String.isBlank(acc.Box_Folder_Id__c)) {
            throw new AuraHandledException(
                'No Box folder found for this Account. Please create a folder first.'
            );
        }
        
        // Convert base64 string from LWC to Blob
        Blob fileContent = EncodingUtil.base64Decode(base64Data);
        
        // Enqueue upload job
        System.enqueueJob(new BoxQueueable(
            'uploadFile',
            accountId,
            null,
            fileName,
            fileContent
        ));
    }
}