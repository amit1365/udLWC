import { LightningElement, wire } from 'lwc';
import sampleMC from '@salesforce/messageChannel/TestMChannel__c'; // path of your message channel
import {MessageContext, subscribe, unsubscribe, APPLICATION_SCOPE} from 'lightning/messageService'; 

export default class LmsCompX extends LightningElement {
        receivedMessage; // to store the value of the received message
        subscription; // to store the subscription object returned by the subscribe() method

         @wire(MessageContext)
         context //gives a list of all the message channels available in the org, which all cpmonents are using the LMS
    
        connectedCallback(){
            this.subscribeMsg(); // call the subscribeMsg() method when the component is inserted into the DOM
        }
        subscribeMsg(){
            //subscribe() method takes 3 parameters, the context, the message channel and a callback function that will be called when a message is received on the message channel
            this.subscription = subscribe(this.context, sampleMC, (message) => {this.handleMessage(message)}, {scope: APPLICATION_SCOPE}); // subscribe to the message channel and specify the scope as APPLICATION_SCOPE to receive messages from all components in the application
        }
        
        handleMessage(message){
            this.receivedMessage = message.messageContentinMC.value? message.messageContentinMC.value : 'No message received'; // store the value of the message in a variable to display it in the component
        }

        unsubscribeMsg(){
            //unsubscribe() method takes 2 parameters, the context and the subscription object returned by the subscribe() method
            unsubscribe(this.subscription); // unsubscribe from the message channel
            this.subscription = null; // set the subscription variable to null to indicate that the component is no longer subscribed to the message channel
            this.receivedMessage = '';
        }

}