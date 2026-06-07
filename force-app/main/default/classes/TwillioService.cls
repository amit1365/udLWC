public with sharing class TwillioService {

    @future(callout=true)
    public static void sendSMS(string msg, string toPhone){
        Twillio_Configuration__mdt twillioConfig = [SELECT Id, whatsapp_from__c, Account_sid__c, Auth_Token__c, fromPhone__c FROM Twillio_Configuration__mdt WHERE DeveloperName = 'Twillio_Config1' LIMIT 1];
        String accountSid = twillioConfig.Account_sid__c;
        String authToken = twillioConfig.Auth_Token__c;
        String fromPhone = twillioConfig.whatsapp_from__c;

        // Logic to send SMS using Twilio API
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('callout:Twillio_Integration_NC/2010-04-01/Accounts/'+accountSid+'/Messages.json');
        request.setHeader('Content-type','application/x-www-form-urlencoded');// body whould be in url encode
        
        string body = 'To=' + EncodingUtil.urlEncode(toPhone, 'UTF-8') + 
                      '&From=' + EncodingUtil.urlEncode(fromPhone, 'UTF-8') + 
                      '&Body=' + EncodingUtil.urlEncode(msg, 'UTF-8');
        request.setBody(body);

        Http http = new Http();
        try{
            HttpResponse response = http.send(request);
            if(response.getStatusCode() == 201){
                System.debug('SMS sent successfully');
            } else {
                System.debug('Failed to send SMS. Status code: ' + response.getStatusCode());
            }
        }catch(exception e){
            system.debug('Error Occured, msg: ' + e.getMessage());
            system.debug('Error Line ' + e.getLineNumber());
        }
        
}

@future(callout=true)
    public static void sendWhatsapp(string msg, string toPhone){
        Twillio_Configuration__mdt twillioConfig = [SELECT Id, Account_sid__c, Auth_Token__c, fromPhone__c FROM Twillio_Configuration__mdt WHERE DeveloperName = 'Twillio_Config1' LIMIT 1];
        String accountSid = twillioConfig.Account_sid__c;
        String authToken = twillioConfig.Auth_Token__c;
        String fromPhone = twillioConfig.fromPhone__c;

        // Logic to send SMS using Twilio API
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('callout:Twillio_Integration_NC/2010-04-01/Accounts/'+accountSid+'/Messages.json');
        request.setHeader('Content-type','application/x-www-form-urlencoded');// body whould be in url encode
        
        string body = 'To=' + EncodingUtil.urlEncode('whatsapp:'+toPhone, 'UTF-8') + 
                      '&From=' + EncodingUtil.urlEncode('whatsapp:'+fromPhone, 'UTF-8') + 
                      '&Body=' + EncodingUtil.urlEncode(msg, 'UTF-8');
        request.setBody(body);

        Http http = new Http();
        try{
            HttpResponse response = http.send(request);
            if(response.getStatusCode() == 201){
                System.debug('SMS sent successfully');
            } else {
                System.debug('Failed to send SMS. Status code: ' + response.getStatusCode());
            }
        }catch(exception e){
            system.debug('Error Occured, msg: ' + e.getMessage());
            system.debug('Error Line ' + e.getLineNumber());
        }
        
}

}