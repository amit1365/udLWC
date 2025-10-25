//LifeCycle Hooks in Parent Component
import { LightningElement } from 'lwc';

export default class ParentLCH extends LightningElement {
   
    isChildVisible = false;

    constructor() {
        super();
        
        console.log('ParentLCH Constructor called');
    }

    connectedCallback() {
        console.log('ParentLCH connectedCallback called');
    }

    renderedCallback() {
        console.log('ParentLCH renderedCallback called');
    }

    toggleChildCmp() {
        this.isChildVisible = !this.isChildVisible;
    }
}
