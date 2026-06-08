import { LightningElement, wire, track } from 'lwc';
import getContacts from '@salesforce/apex/ContactBulkUpdateController.getContacts'
import updateContacts from '@salesforce/apex/ContactBulkUpdateController.updateContacts'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class ContactBulkUpdateController extends LightningElement {

    wiredResult;
    @track contactList = [];
    @track draftValues;
    isLoading;

    columns = [
    { label: 'Title', fieldName: 'Title', editable: true },
    { label: 'First Name', fieldName: 'FirstName', editable: true },
    { label: 'Last Name', fieldName: 'LastName', editable: true },
    { label: 'Email', fieldName: 'Email', editable: true },
    { label: 'Phone', fieldName: 'Phone', type: 'phone', editable: true }
    ];

    @wire (getContacts)
    wiredContacts(result){
        this.wiredResult = result;
        if(result.data){
            this.contactList = result.data;
            this.error = undefined;
        }else{
            this.contactList = [];
            this.error = result.error;
        }
    }

    /*async handleSave(event){
        try{
        this.isLoading = true;
        this.draftValues = event.detail.draftValues ;
        await updateContacts({contactsList : this.draftValues});
        await refreshApex(this.wiredResult);
        this.draftValues = [];
        }catch(error){
            this.error = error;
        }finally{
            this.isLoading = false;
        }

    }*/

    errors = {};   
    async handleSave(event) {
        this.isLoading = true;
        this.draftValues = event.detail.draftValues;
        try {
            const result = await updateContacts({ contactsList: this.draftValues });
            const rows = {};
            let failCount = 0;

            result.forEach(r => {     // loop every wrapper Apex sent back
                if (!r.success) {     // only care about the failed ones
                    failCount++;
                    rows[r.recordId] = {                 // key = the row's Id
                        title: 'Error',
                        messages: [r.message],           // must be an array
                        fieldNames: r.fieldNames || []
                    };
                }
            });

            this.errors = { rows };

            const successCount = result.length - failCount;
            this.dispatchEvent(new ShowToastEvent({
                title: 'Save complete',
                message: `${successCount} saved, ${failCount} failed`,
                variant: failCount ? 'warning' : 'success'
            }));

            await refreshApex(this.wiredResult);
            this.draftValues = [];

        } catch (error) {
            this.error = error;
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: 'Something went wrong while saving.',
                variant: 'error'
            }));
        } finally {
            this.isLoading = false;
        }
    }

    get errorMessage() {
        return this.error?.body?.message ?? '';
    }
}