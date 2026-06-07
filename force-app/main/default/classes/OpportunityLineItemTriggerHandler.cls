public class OpportunityLineItemTriggerHandler {

    public static void updateOpportunityAmount(List<OpportunityLineItem> lineItems, Map<Id, OpportunityLineItem> oldMap) {

        Set<Id> oppIds = new Set<Id>();

        for (OpportunityLineItem oli : lineItems) {
            if (oldMap == null || oli.TotalPrice != oldMap.get(oli.Id).TotalPrice) {
                oppIds.add(oli.OpportunityId);
            }
        }

        if (oppIds.isEmpty()) return;

        // Sum TotalPrice of all active line items per opportunity
        Map<Id, Decimal> oppIdToTotal = new Map<Id, Decimal>();
        for (Id oppId : oppIds) {
            oppIdToTotal.put(oppId, 0.0);
        }

        for (AggregateResult ar : [
            SELECT OpportunityId, SUM(TotalPrice) total
            FROM OpportunityLineItem
            WHERE OpportunityId IN :oppIds
            GROUP BY OpportunityId
        ]) {
            Id oppId = (Id) ar.get('OpportunityId');
            Decimal total = (Decimal) ar.get('total');
            oppIdToTotal.put(oppId, total != null ? total : 0.0);
        }

        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        for (Id oppId : oppIdToTotal.keySet()) {
            oppsToUpdate.add(new Opportunity(
                Id = oppId,
                Amount = oppIdToTotal.get(oppId)
            ));
        }

        if (!oppsToUpdate.isEmpty()) {
            update oppsToUpdate;
        }
    }
}
