import { LightningElement } from 'lwc';

export default class ChildLCH extends LightningElement {
    constructor() {
        super();
        console.log('ChildLCH Constructor called');
    }
    connectedCallback() {
        console.log('ChildLCH connectedCallback called');
    }
    
    renderedCallback() {
        console.log('ChildLCH renderedCallback called');
    }

    disconnectedCallback() {
        alert('ChildLCH disconnectedCallback called');
    }
}