public with sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList() {
        return [
            SELECT Id, Name, Title, Phone, Email, Picture__c
            FROM Contact
            WHERE Picture__c != null
            WITH SECURITY_ENFORCED
            LIMIT 10
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<wrapperClass> getContactListWithoutPictute() {
        List<Id> contactIds = new List<Id>();
        List<wrapperClass> contactPictures = new List<wrapperClass>();
        Map<Id,Contact> contacts =new Map<Id,Contact>([
                            SELECT Id, Name, Title, Phone, Email, Picture__c
                            FROM Contact
                            WITH SECURITY_ENFORCED
                            LIMIT 10
                        ]);
        for (Id con : contacts.keySet()){
            contactIds.add(con);
        }  
        
        List<ContentDocumentLink> contentDocumentLinks = [SELECT Id,ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN:contactIds];
        for(ContentDocumentLink docLink : contentDocumentLinks){
            wrapperClass wrapper = new wrapperClass(String.valueOf(docLink.ContentDocumentId),contacts.get(docLink.LinkedEntityId));
            contactPictures.add(wrapper);
        }
        return contactPictures;
    }

    public class wrapperClass{
        @AuraEnabled public String ContentURL;
        @AuraEnabled public Contact contact;
        wrapperClass(String ContentURL, Contact contact){
            this.ContentURL = '/sfc/servlet.shepherd/document/download/'+ContentURL;
            this.contact = contact;
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> findContacts(String searchKey) {
        String key = '%' + searchKey + '%';
        return [
            SELECT Id, Name, Title, Phone, Email, Picture__c
            FROM Contact
            WHERE Name LIKE :key AND Picture__c != null
            WITH SECURITY_ENFORCED
            LIMIT 10
        ];
    }

    @AuraEnabled(cacheable=true)
    public static Contact getSingleContact() {
        return [
            SELECT Id, Name, Title, Phone, Email, Picture__c
            FROM Contact
            LIMIT 1
        ];
    }
}
