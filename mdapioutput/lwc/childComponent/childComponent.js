import { LightningElement } from 'lwc';

export default class ChildComponent extends LightningElement {

    handleClick(){
        console.log('Button clicked');
        const elem = this.template.querySelector('.test12class');
        console.log(elem);
        if (elem) {
            console.log(elem.innerHTML)
            elem.style.backgroundColor = 'yellow';
            elem.style.color = 'red';
            elem.style.fontSize = '20px';
            elem.style.fontWeight = 'bold';
            elem.style.textAlign = 'center';
            elem.style.border = '2px solid black';
            elem.style.padding = '10px';
            elem.style.borderRadius = '5px';
        }
}
}