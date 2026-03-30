import { LightningElement } from 'lwc';

export default class C2pParent extends LightningElement {
    showChild = false;
    messageFromChild

    showChildModal(event) {
        this.showChild = true;
        
    }

    handleChildClose(event) {
         // we can access the data passed from the child component using event.detail
        this.showChild = false;
        this.messageFromChild = event.detail.message;
    }
}