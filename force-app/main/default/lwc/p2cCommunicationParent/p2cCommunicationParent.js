import { LightningElement } from 'lwc';

export default class P2cCommunicationParent extends LightningElement {

boolValue = true;
stringValue = 'This is a simple string from parent';

arrayOfStructures = [

    {   Text: 'This is first item',
        Number: 1,
        src : 'https://www.lightningdesignsystem.com/assets/images/carousel/carousel-01.jpg'},

    {   Text: 'This is second item',
        Number: 2,
        src : 'https://www.lightningdesignsystem.com/assets/images/carousel/carousel-02.jpg' },

    {   Text: 'This is third item',
        Number: 3,
        src : 'https://www.lightningdesignsystem.com/assets/images/carousel/carousel-03.jpg' }
]

percentageNumber = 20;
numberChangeHandler(event){
    this.percentageNumber = event.target.value;
}
}