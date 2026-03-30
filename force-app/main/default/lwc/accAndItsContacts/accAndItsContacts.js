import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccAndItsContactsController.getAccounts';
import getContacts from '@salesforce/apex/AccAndItsContactsController.getContacts';

export default class AccAndItsContacts extends LightningElement {

    accounts;
    selectedAccount;
    contacts;
    showContacts = false;



    @wire(getAccounts)
    wiredAccounts({data,error}){
        if(data){
            this.accounts = data;
            this.error = undefined;
        }else{
            this.accounts = undefined;
            this.error = error;
        }
    }

    accountColumns = [
        {label: 'Account Name', fieldName: 'Name'}
    ]

    childColumns = [
        {label: 'Contact Name', fieldName: 'Name'},
        {label: 'Email', fieldName: 'Email'},
        {label: 'Phone', fieldName: 'Phone'}
    ]

    handleAccountSelection(event){
        this.showContacts = !this.showContacts;

        if(this.showContacts){
        this.selectedAccount = event.detail.selectedRows[0].Id;

        getContacts({ accId: this.selectedAccount})
        .then(result => {
            this.contacts = result;
            this.error = undefined;
        })
        .catch(error => {
            this.contacts = undefined;
            this.error = error;
        });
    }
    }
}