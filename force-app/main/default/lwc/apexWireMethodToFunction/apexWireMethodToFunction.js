import { LightningElement, wire } from 'lwc';
import getContactList from '@salesforce/apex/ContactController.getContactListWithoutPictute';

export default class ApexWireMethodToFunction extends LightningElement {
    contacts;
    error;

    @wire(getContactList)
    wiredContacts({ error, data }) {
        if (data) {
            this.contacts = data;
            this.error = undefined;
            console.log('Data is :'+JSON.stringify(data));
        } else if (error) {
            this.error = error;
            this.contacts = undefined;
            console.log('Error is :'+error);
        }
    }

    handleSelect(event){
        event.preventDefault();
    }
}
