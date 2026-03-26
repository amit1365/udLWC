trigger LeadsTrigger on Lead (after update) {

    if(LeadsTriggerStaticVar.isFirstRun){
        LeadsTriggerStaticVar.isFirstRun  false;
    if(trigger.isUpdate && trigger.isAfter){
        system.debug('testing Leads trigger');
    }
}

}