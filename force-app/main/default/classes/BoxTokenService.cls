public class BoxTokenService {
    
    // Read credentials from Custom Metadata
    private static Box_Configuration__mdt getConfig() {
        return [
            SELECT Client_ID__c, Client_Secret__c, Private_Key__c,
                   Passphrase__c, Public_Key_ID__c, Enterprise_ID__c
            FROM Box_Configuration__mdt
            WHERE DeveloperName = 'Box_Config1'
            LIMIT 1
        ];
    }
    
    // Main method — returns Access Token
    public static String getAccessToken() {
        
        Box_Configuration__mdt config = getConfig();
        
        String header  = buildHeader(config.Public_Key_ID__c);// base64URL
        String payload = buildPayload(config.Client_ID__c, config.Enterprise_ID__c);
        String jwt     = signJWT(header, payload, config.Private_Key__c);
        String token   = callBoxTokenEndpoint(jwt, config.Client_ID__c, config.Client_Secret__c);
        
        return token;
    }
    
    // Build JWT Header
    private static String buildHeader(String publicKeyId) {
        Map<String, String> headerMap = new Map<String, String>{
            'alg' => 'RS256',
            'typ' => 'JWT',
            'kid' => publicKeyId
        };
        return base64UrlEncode(Blob.valueOf(JSON.serialize(headerMap)));//headerMap -> json -> blob -> base64URL
    }
    
    // Build JWT Payload
    private static String buildPayload(String clientId, String enterpriseId) {
        Long now = DateTime.now().getTime() / 1000;
        Map<String, Object> payloadMap = new Map<String, Object>{
            'iss'          => clientId,
            'sub'          => enterpriseId,
            'box_sub_type' => 'enterprise',
            'aud'          => 'https://api.box.com/oauth2/token',
            'jti'          => EncodingUtil.base64Encode(Crypto.generateAesKey(128)),
            'exp'          => now + 60
        };
        return base64UrlEncode(Blob.valueOf(JSON.serialize(payloadMap)));// payloadMap-> json-> blob-> base64URL
    }
    
    // Sign JWT with Private Key
    private static String signJWT(String header, String payload, String privateKey) {
        String signingInput = header + '.' + payload; // header, payload both are in base64URL
        
        // Clean the private key — remove headers and line breaks
        String cleanKey = privateKey
            .replace('-----BEGIN ENCRYPTED PRIVATE KEY-----', '')
            .replace('-----END ENCRYPTED PRIVATE KEY-----', '')
            .replace('-----BEGIN PRIVATE KEY-----', '')
            .replace('-----END PRIVATE KEY-----', '')
            .replace('\n', '')
            .replace('\r', '')
            .trim();
        
        Blob privateKeyBlob = EncodingUtil.base64Decode(cleanKey); //privateKey -> base64
        Blob signature = Crypto.sign('RSA-SHA256', Blob.valueOf(signingInput), privateKeyBlob);// signinginput is in base64URL
        
        return signingInput + '.' + base64UrlEncode(signature);//base64URL
    }
    
    // Call Box token endpoint and return access token
    private static String callBoxTokenEndpoint(String jwt, String clientId, String clientSecret) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Box_API/oauth2/token');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');// Data is formatted as key=value pairs joined by &
        req.setBody(
            'grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer' +
            '&client_id='     + clientId +
            '&client_secret=' + clientSecret +
            '&assertion='     + jwt
        );
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            Map<String, Object> responseMap = 
                (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            return (String) responseMap.get('access_token');
        } else {
            throw new CalloutException(
                'Box Token Error: ' + res.getStatusCode() + ' ' + res.getBody()
            );
        }
    }
    
    // Helper — Base64 URL encode (JWT standard requires this format)
    private static String base64UrlEncode(Blob input) {
        return EncodingUtil.base64Encode(input)
            .replace('+', '-')
            .replace('/', '_')
            .replace('=', '');
    }
}