/**
 * Staging Product Trigger Handler
 */
public with sharing class StagingProductTriggerHandler {

    public static void propagateStagingProducts(List<Staging_Product__c> newStagingProducts) {

        List<Product2> productsToUpsert = new List<Product2>();
        
        /*
         * If external system could do delta load, only load necessary changes
         * Upsert everything
        for (Staging_Product__c sp : newStagingProducts) {
            Product2 product = new Product2(
                GTIN__c = sp.GTIN__c,
                Name = sp.Name,
                Purchasing_Price__c = sp.Purchasing_Price__c,
                Selling_Price__c = sp.Selling_Price__c
            );
            productsToUpsert.add(product);
        }
        */

        /* If external system load everything */
        Set<String> GTINs = new Set<String>();
        for (Staging_Product__c sp : newStagingProducts) {
            GTINs.add(sp.GTIN__c);
        }
        Map<String, Product2> productMap = new Map<String, Product2>();
        for (Product2 p : [SELECT Id, GTIN__c, Name, Purchasing_Price__c, Selling_Price__c FROM Product2 WHERE GTIN__c IN :GTINs]) {
            productMap.put(p.GTIN__c, p);
        }
        for (Staging_Product__c sp : newStagingProducts) {
            if (productMap.get(sp.GTIN__c) == null || 
                productMap.get(sp.GTIN__c).Name != sp.Name || 
                productMap.get(sp.GTIN__c).Purchasing_Price__c != sp.Purchasing_Price__c || 
                productMap.get(sp.GTIN__c).Selling_Price__c != sp.Selling_Price__c) 
            {
                Product2 productToUpsert = new Product2(
                    GTIN__c = sp.GTIN__c,
                    Name = sp.Name,
                    Purchasing_Price__c = sp.Purchasing_Price__c,
                    Selling_Price__c = sp.Selling_Price__c
                );
                productsToUpsert.add(productToUpsert);
            }
        }
        try {
            Database.upsert(productsToUpsert, Product2.GTIN__c);
        } catch (DmlException e) {
            // Todo: Options of Error Handling
            // Save logs to custom log object
            // Use SaveResult if partial success
            // Send notifications
        }
        // Todo: if user manually update price on product, should overwrite or not?

    }
}
