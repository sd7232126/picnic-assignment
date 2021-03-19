/**
 * Product Trigger
 */
trigger ProductTrigger on Product2 (before update) {

    // Check if bypass entire trigger
    if (!Bypass_Settings__c.getInstance().Product_Trigger__c) {
        if (Trigger.isBefore) {
            if (Trigger.isUpdate) {
                ProductTriggerHandler.updateSellingPriceBefore(Trigger.new, Trigger.oldMap);
            }
        }
        // if (Trigger.isAfter) { }
    }

}