import { LightningElement, api } from 'lwc';
import updateAccountName from '@salesforce/apex/SimpleApexCallController.updateAccountName';
import getAccount from '@salesforce/apex/SimpleApexCallController.getAccount'; // Import to fetch updated data

export default class AccountUpdateForm extends LightningElement {
    @api recordId; // Assumes this is set from a record page
    accountName = '';
    accountIndustry = '';

    connectedCallback() {
        this.fetchAccount(); // Fetch initial data
    }

    fetchAccount() {
        getAccount({ accountId: this.recordId })
            .then(result => {
                this.accountName = result.Name;
                this.accountIndustry = result.Industry;
            })
            .catch(error => {
                console.error('Error fetching account:', error);
            });
    }

    handleNameChange(event) {
        this.accountName = event.target.value;
    }

    handleUpdateClick() {
        updateAccountName({
            accountId: this.recordId,
            newName: this.accountName
        })
        .then(() => {
            // Optionally refresh the data after update
            this.fetchAccount(); // Re-fetch to show the update
        })
        .catch(error => {
            console.error('Error updating account:', error);
        });
    }
}