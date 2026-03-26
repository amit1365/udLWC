import { LightningElement } from 'lwc';

export default class C2pParent extends LightningElement {
    showChild = false;

    showChildModal() {
        this.showChild = true;
    }

    handleChildClose() {
        this.showChild = false;
    }
}