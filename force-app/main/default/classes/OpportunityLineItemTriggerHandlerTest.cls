@isTest
private class OpportunityLineItemTriggerHandlerTest {

    // ─── Test Data Factory ────────────────────────────────────────────────────

    private static Opportunity createOpportunity() {
        Opportunity opp = new Opportunity(
            Name        = 'Test Opp',
            StageName   = 'Prospecting',
            CloseDate   = Date.today().addDays(30),
            Amount      = 0
        );
        insert opp;
        return opp;
    }

    private static Product2 createProduct() {
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true);
        insert prod;
        return prod;
    }

    private static PricebookEntry createPricebookEntry(Id productId, Decimal unitPrice) {
        Id stdPricebookId = Test.getStandardPricebookId();
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = stdPricebookId,
            Product2Id   = productId,
            UnitPrice    = unitPrice,
            IsActive     = true
        );
        insert pbe;
        return pbe;
    }

    private static OpportunityLineItem createLineItem(Id oppId, Id pbeId, Integer qty, Decimal unitPrice) {
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId        = oppId,
            PricebookEntryId     = pbeId,
            Quantity             = qty,
            UnitPrice            = unitPrice
        );
        insert oli;
        return oli;
    }

    // ─── Tests ────────────────────────────────────────────────────────────────

    @isTest
    static void testInsert_updatesOpportunityAmount() {
        Opportunity opp     = createOpportunity();
        Product2    prod    = createProduct();
        PricebookEntry pbe  = createPricebookEntry(prod.Id, 100);

        // Link the opportunity to the standard pricebook
        opp.Pricebook2Id = Test.getStandardPricebookId();
        update opp;

        Test.startTest();
        createLineItem(opp.Id, pbe.Id, 2, 100); // TotalPrice = 200
        Test.stopTest();

        Opportunity result = [SELECT Amount FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(200, result.Amount, 'Amount should equal sum of line item TotalPrices after insert');
    }

    @isTest
    static void testInsert_multipleLineItems_sumsCorrectly() {
        Opportunity opp    = createOpportunity();
        Product2    prod   = createProduct();
        PricebookEntry pbe = createPricebookEntry(prod.Id, 50);

        opp.Pricebook2Id = Test.getStandardPricebookId();
        update opp;

        Test.startTest();
        List<OpportunityLineItem> olis = new List<OpportunityLineItem>{
            new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, Quantity = 1, UnitPrice = 50),
            new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, Quantity = 3, UnitPrice = 50)
        };
        insert olis; // TotalPrices: 50 + 150 = 200
        Test.stopTest();

        Opportunity result = [SELECT Amount FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(200, result.Amount, 'Amount should sum all line items');
    }

    @isTest
    static void testUpdate_priceChange_updatesAmount() {
        Opportunity opp    = createOpportunity();
        Product2    prod   = createProduct();
        PricebookEntry pbe = createPricebookEntry(prod.Id, 100);

        opp.Pricebook2Id = Test.getStandardPricebookId();
        update opp;

        OpportunityLineItem oli = createLineItem(opp.Id, pbe.Id, 1, 100); // TotalPrice = 100

        Test.startTest();
        oli.UnitPrice = 250;
        update oli; // TotalPrice = 250
        Test.stopTest();

        Opportunity result = [SELECT Amount FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(250, result.Amount, 'Amount should reflect updated TotalPrice');
    }

    @isTest
    static void testUpdate_noChange_doesNotRecalculate() {
        Opportunity opp    = createOpportunity();
        Product2    prod   = createProduct();
        PricebookEntry pbe = createPricebookEntry(prod.Id, 100);

        opp.Pricebook2Id = Test.getStandardPricebookId();
        update opp;

        OpportunityLineItem oli = createLineItem(opp.Id, pbe.Id, 2, 100); // TotalPrice = 200

        Test.startTest();
        // Update a field that doesn't affect TotalPrice
        oli.Description = 'No price change';
        update oli;
        Test.stopTest();

        Opportunity result = [SELECT Amount FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(200, result.Amount, 'Amount should remain unchanged when TotalPrice did not change');
    }

    @isTest
    static void testDelete_removesLineItemFromTotal() {
        Opportunity opp    = createOpportunity();
        Product2    prod   = createProduct();
        PricebookEntry pbe = createPricebookEntry(prod.Id, 100);

        opp.Pricebook2Id = Test.getStandardPricebookId();
        update opp;

        OpportunityLineItem oli1 = createLineItem(opp.Id, pbe.Id, 1, 100); // 100
        OpportunityLineItem oli2 = createLineItem(opp.Id, pbe.Id, 2, 100); // 200

        Test.startTest();
        delete oli1;
        Test.stopTest();

        Opportunity result = [SELECT Amount FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(200, result.Amount, 'Amount should only reflect remaining line items after delete');
    }

    @isTest
    static void testDelete_lastLineItem_zeroesAmount() {
        Opportunity opp    = createOpportunity();
        Product2    prod   = createProduct();
        PricebookEntry pbe = createPricebookEntry(prod.Id, 100);

        opp.Pricebook2Id = Test.getStandardPricebookId();
        update opp;

        OpportunityLineItem oli = createLineItem(opp.Id, pbe.Id, 3, 100); // 300

        Test.startTest();
        delete oli;
        Test.stopTest();

        Opportunity result = [SELECT Amount FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(0, result.Amount, 'Amount should be 0 after all line items are deleted');
    }

    @isTest
    static void testUndelete_restoresAmount() {
        Opportunity opp    = createOpportunity();
        Product2    prod   = createProduct();
        PricebookEntry pbe = createPricebookEntry(prod.Id, 100);

        opp.Pricebook2Id = Test.getStandardPricebookId();
        update opp;

        OpportunityLineItem oli = createLineItem(opp.Id, pbe.Id, 2, 100); // 200
        delete oli;

        Opportunity afterDelete = [SELECT Amount FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(0, afterDelete.Amount, 'Precondition: amount should be 0 after delete');

        Test.startTest();
        undelete oli;
        Test.stopTest();

        Opportunity result = [SELECT Amount FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(200, result.Amount, 'Amount should be restored after undelete');
    }

    @isTest
    static void testMultipleOpportunities_isolatedUpdates() {
        Opportunity opp1 = createOpportunity();
        Opportunity opp2 = createOpportunity();
        Product2    prod = createProduct();

        PricebookEntry pbe = createPricebookEntry(prod.Id, 100);

        opp1.Pricebook2Id = Test.getStandardPricebookId();
        opp2.Pricebook2Id = Test.getStandardPricebookId();
        update new List<Opportunity>{ opp1, opp2 };

        Test.startTest();
        List<OpportunityLineItem> olis = new List<OpportunityLineItem>{
            new OpportunityLineItem(OpportunityId = opp1.Id, PricebookEntryId = pbe.Id, Quantity = 1, UnitPrice = 100),
            new OpportunityLineItem(OpportunityId = opp2.Id, PricebookEntryId = pbe.Id, Quantity = 3, UnitPrice = 100)
        };
        insert olis;
        Test.stopTest();

        Map<Id, Opportunity> results = new Map<Id, Opportunity>(
            [SELECT Id, Amount FROM Opportunity WHERE Id IN :new Set<Id>{ opp1.Id, opp2.Id }]
        );
        System.assertEquals(100, results.get(opp1.Id).Amount, 'Opp1 amount should be 100');
        System.assertEquals(300, results.get(opp2.Id).Amount, 'Opp2 amount should be 300');
    }
}
