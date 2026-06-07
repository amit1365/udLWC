import { LightningElement } from 'lwc';

export default class Parent1 extends LightningElement {

    isChildVisible = false;

    

    handleClick(event) {
        alert('inHandleClick');

        this.isChildVisible = event.target.value;
        alert('isChildVisible: ' + this.isChildVisible);

        if(this.isChildVisible == true){
            alert('Child is visible');
            event.target.value = false;
            
        }else{
            alert('Child is not visible');
            event.target.value = true;
        }
    }
}