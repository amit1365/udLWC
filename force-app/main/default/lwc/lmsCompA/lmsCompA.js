import { LightningElement, wire } from 'lwc';
import sampleMC from '@salesforce/messageChannel/TestMChannel__c'; // path of your message channel
import {MessageContext, publish} from 'lightning/messageService'; 
export default class LmsCompA extends LightningElement {

        inputValue; // to store the value of the input field

    @wire(MessageContext)
    context //gives a list of all the message channels available in the org, which all cpmonents are using the LMS

    inputHandler(event){
        this.inputValue = event.target.value; // store the value of the input field in the variable
    }

    publishMessage(){
        //publish() method takes 3 parameters, the context, the message channel and the message itself
        const message = { messageContentinMC: { value: this.inputValue } }; // create a message object with the value of the input field
        publish(this.context, sampleMC, message); // publish the message to the message channel
    }

}