import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/SearchAccountsController.getAccounts';

export default class SearchAccounts extends LightningElement {
    searchKey = '';
    accounts;

    handleSearchKeyChange(event) {
    this.searchKey = event.target.value;
}

columns = [
    { label: 'Account Name', fieldName: 'Name' }
];

    @wire(getAccounts, {searchName : '$searchKey'})
    wiredAccounts({data, error}){
        if(data){
            this.accounts = data;
            this.error = undefined;
        }else{
            this.accounts = undefined;
            this.error = error;
        }
    }

}