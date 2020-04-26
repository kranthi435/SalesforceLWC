import { LightningElement,track } from 'lwc';

export default class ContentView extends LightningElement {
    @track imageUrl;
    inputChange(e) {
        if (e.target.value)
            this.imageUrl = '/sfc/servlet.shepherd/document/download/'  + e.target.value
    }

}