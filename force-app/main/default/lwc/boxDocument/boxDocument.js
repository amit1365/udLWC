import { LightningElement, api, track, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import listFiles    from '@salesforce/apex/BoxFileService.listFiles';
import createFolder from '@salesforce/apex/BoxFileService.createFolder';
import uploadFile   from '@salesforce/apex/BoxFileService.uploadFile';

export default class BoxDocuments extends LightningElement {

    @api recordId;

    @track files          = [];
    @track error          = null;
    @track successMessage = null;
    @track isLoading      = false;
    @track noFiles        = false;

    // ─── Get Account Name via Wire ────────────────────────────────────

    @wire(getRecord, { recordId: '$recordId', fields: [NAME_FIELD] })
    account;

    get accountName() {
        return getFieldValue(this.account.data, NAME_FIELD);
    }

    // ─── Getter for file list condition ───────────────────────────────

    get hasFiles() {
        return this.files && this.files.length > 0;
    }

    // ─── Create Folder ────────────────────────────────────────────────

    handleCreateFolder() {
        this.clearMessages();
        this.isLoading = true;

        createFolder({ accountId: this.recordId, accountName: this.accountName })
            .then(() => {
                this.successMessage = 'Folder created successfully in Box!';
            })
            .catch(error => {
                this.error = error.body.message;
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    // ─── Show Files ───────────────────────────────────────────────────

    handleShowFiles() {
        this.clearMessages();
        this.isLoading = true;
        this.files     = [];
        this.noFiles   = false;

        listFiles({ accountId: this.recordId })
            .then(result => {
                if (result && result.length > 0) {
                    this.files = result;
                } else {
                    this.noFiles = true;
                }
            })
            .catch(error => {
                this.error = error.body.message;
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    // ─── Open File in Box ─────────────────────────────────────────────

    handleOpenFile(event) {
        const fileId = event.target.dataset.id;
        window.open('https://app.box.com/file/' + fileId, '_blank');
    }

    // ─── Upload Click — Trigger Hidden Input ──────────────────────────

    handleUploadClick() {
        this.clearMessages();
        this.template.querySelector('[data-id="fileInput"]').click();
    }

    // ─── File Selected for Upload ─────────────────────────────────────

    handleFileChange(event) {
        const file = event.target.files[0];
        if (!file) return;

        this.clearMessages();
        this.isLoading = true;

        const reader = new FileReader();
        reader.onload = () => {
            const base64Data = reader.result.split(',')[1];

            uploadFile({
                accountId : this.recordId,
                fileName  : file.name,
                base64Data: base64Data
            })
            .then(() => {
                this.successMessage = file.name + ' uploaded successfully to Box!';
            })
            .catch(error => {
                this.error = error.body.message;
            })
            .finally(() => {
                this.isLoading = false;
            });
        };
        reader.readAsDataURL(file);
    }

    // ─── Helper ───────────────────────────────────────────────────────

    clearMessages() {
        this.error          = null;
        this.successMessage = null;
    }
}