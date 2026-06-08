public with sharing class ContactBulkUpdateController {

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        return [
            SELECT Id, FirstName, LastName, Email, Phone, Title
            FROM Contact
            WITH USER_MODE
            ORDER BY LastName
            LIMIT 200
            ];
    }

    @AuraEnabled
    public static List<SaveResultWrapper> updateContacts(List<Contact> contactsList) {
        system.debug(contactsList);
        List<SaveResultWrapper> wrpList = new List<SaveResultWrapper>();
        if(contactsList.isempty()){
            system.debug('empty contact list to update');
            return  wrpList;
        }
            
        try{
            Database.SaveResult[] results = Database.Update(contactsList, false, AccessLevel.USER_MODE);
            Integer i=-1;
            for(Database.SaveResult result:  results){
                i++;
                SaveResultWrapper wrp = new SaveResultWrapper();
                if(result.isSuccess()){

                    wrp.recordId = result.getId();   // populated on success
                    wrp.success  = true;
                    wrp.message  = null;             // nothing to say
                    wrp.fieldNames = null;           // no fields errored
                    wrpList.add(wrp);
                }else{
                    //wrp.recordId = result.getId();   // it will be null so dont use this, get it by index
                    wrp.recordId = contactsList[i].Id;  // getId() is null here — use the input by index
                    wrp.success  = false;
                    List<String> msgs = new List<String>();
                    List<String> flds = new List<String>();

                    for(Database.Error err : result.getErrors()){
                        
                        msgs.add(err.getMessage());
                        flds.addAll(err.getFields());
                        
                    }
                    wrp.message    = String.join(msgs, '; ');
                    wrp.fieldNames = flds;
                    wrpList.add(wrp);
                    
                }
            }
            return wrpList;

        }catch(exception e){
            System.debug('Error occured: '+e.getMessage());
            System.debug('At Line: '+e.getLineNumber());
            return wrpList;
        }
    }
    
    public class SaveResultWrapper {
    @AuraEnabled public Id recordId;
    @AuraEnabled public Boolean success;
    @AuraEnabled public String message;
    @AuraEnabled public List<String> fieldNames;
}
}
