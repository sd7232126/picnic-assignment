/**
 * Staging Product Trigger
 */
trigger StagingProductTrigger on Staging_Product__c (after insert, after update) {

    // Check if bypass entire trigger
    if (!Bypass_Settings__c.getInstance().SProduct_Trigger__c) {
        // if (Trigger.isBefore) { }
        if (Trigger.isAfter) {
            if (Trigger.isInsert || Trigger.isUpdate) {
                if (!Bypass_Settings__c.getInstance().SProduct_Trigger_Propagate_SP__c) {
                    StagingProductTriggerHandler.propagateStagingProducts(Trigger.new);
                }
            }
            // if (Trigger.isDelete || Trigger.isUndelete) { }
        }
    }

}