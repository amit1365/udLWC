import { LightningElement, track} from 'lwc';

export default class TrackProperty extends LightningElement {

    //track decorator is used to make a property reactive
    //when the property value changes, the component re-renders, it is used to track the changes in the property of array or object
    
    @track addressObj = {
        city: 'Bangalore',
        state: 'Karnataka',
        country: 'India',
        pin: '560001'
    };

    callHandler(event){
        this.addressObj = {...this.addressObj, "city":event.target.value};
    }

    callHandler2(event){
        this.addressObj = {...this.addressObj, "state":event.target.value};
    }

    callHandler3(event){
        this.addressObj = {...this.addressObj, "country":event.target.value};
    }

    callHandler4(event){
        this.addressObj = {...this.addressObj, "pin":event.target.value};
    }
}