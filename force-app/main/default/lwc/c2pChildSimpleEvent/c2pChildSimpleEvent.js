import { LightningElement } from 'lwc';

export default class C2pChildSimpleEvent extends LightningElement {

    handleOkay(event) {
        const myEvent= new CustomEvent('close', {
            detail : {
                message : 'child variable value'
            }
        })//always lower case, only underscore used
        this.dispatchEvent(myEvent);// dispatched the event to the parent component to listen to it and do something when the event is fired
        // this event will always start with "on" in the parent component to listen to it, and the name of the event will be the same as the name of the event in the child component but without "on" and in lower case
        // onclose={handleChildClose} written where child is called in parent
        // we pass the data in detail, using this syntax, we can pass any data we want to the parent component
    }

}