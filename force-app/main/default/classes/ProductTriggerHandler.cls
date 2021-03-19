/**
 * Product Trigger Handler
 */
public with sharing class ProductTriggerHandler {

    public static void updateSellingPriceBefore(List<Product2> newProducts, Map<Id, Product2> oldProductsMap) {

        for (Product2 p : newProducts) {
            if (oldProductsMap.get(p.Id).Selling_Price__c != p.Selling_Price__c) {
                p.Selling_Price_Before__c = oldProductsMap.get(p.Id).Selling_Price__c;
            }
        }

    }

}
