import { LightningElement } from 'lwc';

export default class ConditionalRendering extends LightningElement {

    showImageVar = true;
    imageURL = "https://picsum.photos/200/300?random=1"

    hideImage(event){
        this.showImageVar = false;
    }

    showImage(event){
        this.showImageVar = true;
    }
}