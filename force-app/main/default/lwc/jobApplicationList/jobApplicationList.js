import { LightningElement, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getJobApplications from '@salesforce/apex/JobApplicationListController.getJobApplications';
import updateJobStatus  from '@salesforce/apex/JobApplicationListController.updateJobStatus';

export default class JobApplicationList extends LightningElement {

    @track jobAppList;
    jobApplicationId;
    isLoading;
    wiredResult;

    @wire (getJobApplications)
    wiredJobApplications(result){
        if(result.data){
            this.wiredResult = result;
            this.jobAppList = result.data;
            this.jobAppList = result.data.map(ja => ({...ja,
                contactName: ja.Contact__c ? ja.Contact__r.Name : 'No Contact',
                isOfferAccepted: ja.Status__c === 'Offer Accepted'
                }));
            this.error = undefined;
        }else{
            this.error = result.error;
            this.jobAppList = undefined;
        }
    }

    async handleChangeStatus(event){
        this.isLoading = true;
        try{
            this.jobApplicationId = event.target.dataset.id;
            await updateJobStatus({jobAppId : this.jobApplicationId});
            await refreshApex(this.wiredResult);
        }catch(error){
            this.error = error;
        }finally{
            this.isLoading = false;
        }
    }
}

//keep cariables in camelCase