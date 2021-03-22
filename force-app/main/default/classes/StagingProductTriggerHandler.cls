/**
 * Staging Product Trigger Handler
 */
public with sharing class StagingProductTriggerHandler {

    public static void propagateStagingProducts(List<Staging_Product__c> newStagingProducts) {

        List<Product2> productsToUpsert = new List<Product2>();
        for (Staging_Product__c sp : newStagingProducts) {
            Product2 product = new Product2(
                GTIN__c = sp.GTIN__c,
                Name = sp.Name,
                Purchasing_Price__c = sp.Purchasing_Price__c,
                Selling_Price__c = sp.Selling_Price__c
            );
            productsToUpsert.add(product);
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
