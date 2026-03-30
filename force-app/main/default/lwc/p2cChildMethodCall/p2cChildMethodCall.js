import { LightningElement, api } from 'lwc';

export default class P2cChildMethodCall extends LightningElement {
     val=20;

    handleSliderChange(event){
        this.val = event.target.value;
    }

    @api resetSlider(){
        this.val = 20;
    }
}