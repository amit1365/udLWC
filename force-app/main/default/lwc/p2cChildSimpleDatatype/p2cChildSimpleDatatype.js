import { api, LightningElement } from 'lwc';

export default class P2cChildSimpleDatatype extends LightningElement {

    @api numberValue
    @api boolValue
    @api stringValue
}