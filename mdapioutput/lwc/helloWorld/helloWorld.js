import { LightningElement } from 'lwc';

    export default class HelloWorld extends LightningElement {

        fullname = 'Salesforce India'
        courseName = 'TestCourse'
        user = ['user1', 'user2', 'user3']
        course ={
        name: 'Testing Name1',
        subject: 'Testing Subject1',
        }

        callHandler(event){
            this.courseName = event.target.value;
        }
    }