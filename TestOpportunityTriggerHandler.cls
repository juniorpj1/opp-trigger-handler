@IsTest (seeAllData=true)
private class TestOpportunityTriggerHandler {
    @IsTest
    static void testCreateContract() {
        // Crie um registro de teste para Account
        Account acc = new Account(Name='Test Account');
        insert acc;

        // Crie um registro de teste para Contact
        Contact con = new Contact(LastName = 'Test Contact', AccountId = acc.Id);
        insert con;

        // Crie um registro de teste para Product2 do tipo Contrato
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true, Frequencia__c = 1, Validade__c = 12, TipoProduto__c = 'Contrato');
        insert prod;

        // Crie um registro de teste para Opportunity com RecordTypeId do tipo Contrato
        Opportunity opp = new Opportunity(Name='Test Opportunity', 
                                          StageName='Needs Analysis', 
                                          CloseDate=Date.today(), 
                                          AccountId=acc.Id, 
                                          ContactId=con.Id, 
                                          RecordTypeId='012as0000001zuHAAQ');
        insert opp;
        
        // Altere um campo na Opportunity
         opp.StageName = 'Closed Won';
         update opp; 

        // Crie um registro de teste para OpportunityLineItem
        Pricebook2 stdPricebook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true];
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = stdPricebook.Id, Product2Id = prod.Id, UnitPrice = 100, IsActive = true);
        insert pbe;
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, Quantity = 1, TotalPrice = 100);
        insert oli;

        // Chame o método handleOpportunities
        OpportunityTriggerHandler.Params params = new OpportunityTriggerHandler.Params();
        params.oppId = opp.Id;
        params.installDate = Date.today();
        List<OpportunityTriggerHandler.Params> paramsList = new List<OpportunityTriggerHandler.Params>{params};
        Test.startTest();
            List<OpportunityTriggerHandler.Result> results = OpportunityTriggerHandler.handleOpportunities(paramsList);
        Test.stopTest();

        // Verifique se um Contract foi criado
        List<Contract> contracts = [SELECT Id FROM Contract WHERE Oportunidade__c = :opp.Id];
        System.assertEquals(1, contracts.size(), 'Expected one Contract to be created');

    }

    @IsTest
    static void testOpportunityHistoricFields() { // ESSE É O MÉTODO QUE PRECISO DE AJUDA
        Account acc = new Account(Name='Test Account');
        insert acc;

        Contact con = new Contact(LastName = 'Test Contact', AccountId = acc.Id);
        insert con;

        Product2 prod = new Product2(Name = 'Test Product', IsActive = true, Frequencia__c = 1, Validade__c = 12, TipoProduto__c = 'Contrato');
        insert prod;

        Opportunity opp = new Opportunity(Name='Test Opportunity', 
                                          StageName='Needs Analysis', 
                                          CloseDate=Date.today(), 
                                          AccountId=acc.Id, 
                                          ContactId=con.Id, 
                                          RecordTypeId='012as0000001zuHAAQ');
        insert opp;

        Test.startTest();
            opp.StageName = 'Closed Won';
            update opp;
        Test.stopTest();

        // Call the method to be tested
        OpportunityTriggerHandler.Params params = new OpportunityTriggerHandler.Params();
        params.oppId = opp.Id;
        params.installDate = Date.today();
        List<OpportunityTriggerHandler.Params> paramsList = new List<OpportunityTriggerHandler.Params>{params};
        List<OpportunityTriggerHandler.Result> results = OpportunityTriggerHandler.handleOpportunities(paramsList);

        // Verify the results
        List<OpportunityFieldHistory> historyRecords = [SELECT OldValue, NewValue, Field 
                                                        FROM OpportunityFieldHistory 
                                                        WHERE OpportunityId = :opp.Id];
        System.assertEquals(1, historyRecords.size()); // ESSE ASSERT TÁ FALHANDO
    }
    
    @isTest
    public static void testCreateAsset(){
        // Crie um registro de teste para Account
        Account acc = new Account(Name='Test Account');
        insert acc;

        // Crie um registro de teste para Contact
        Contact con = new Contact(LastName = 'Test Contact', AccountId = acc.Id);
        insert con;

        // Crie um registro de teste para Product2 do tipo Contrato
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true, Frequencia__c = 1, Validade__c = 12, TipoProduto__c = 'Ativo');
        insert prod;

        // Crie um registro de teste para Opportunity com RecordTypeId do tipo Contrato
        Opportunity opp = new Opportunity(Name='Test Opportunity', 
                                          StageName='Needs Analysis', 
                                          CloseDate=Date.today(), 
                                          AccountId=acc.Id, 
                                          ContactId=con.Id, 
                                          RecordTypeId='012as0000001zsfAAA');
        insert opp;
        
        // Altere um campo na Opportunity
         opp.StageName = 'Closed Won';
         update opp; 

        // Crie um registro de teste para OpportunityLineItem
        Pricebook2 stdPricebook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true];
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = stdPricebook.Id, Product2Id = prod.Id, UnitPrice = 100, IsActive = true);
        insert pbe;
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, Quantity = 1, TotalPrice = 100);
        insert oli;

        // Chame o método handleOpportunities
        OpportunityTriggerHandler.Params params = new OpportunityTriggerHandler.Params();
        params.oppId = opp.Id;
        params.installDate = Date.today();
        List<OpportunityTriggerHandler.Params> paramsList = new List<OpportunityTriggerHandler.Params>{params};
        Test.startTest();
            List<OpportunityTriggerHandler.Result> results = OpportunityTriggerHandler.handleOpportunities(paramsList);
        Test.stopTest();

        // Verifique se um Asset foi criado
        List<Asset> assets = [SELECT Id FROM Asset WHERE Oportunidade__c = :opp.Id];
        System.assertEquals(1, assets.size(), 'Expected one Asset to be created');
    }

}