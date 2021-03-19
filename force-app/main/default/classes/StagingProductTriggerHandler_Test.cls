/**
 * Test class for StagingProductTrigger and StagingProductTriggerHandler
 */
@isTest
private class StagingProductTriggerHandler_Test {

    // TestDataFactory class
    // General Create Object method

    @testSetup
    static void testSetup() {
        // Create admin user and commercial director users
        // Create 200 products
    }

    @isTest
    static void testPropagateStagingProductsSuccess() {
        // Test with admin, load 200 staging products
        // 100 exists, 100 not exist
    }

    @isTest
    static void testPropagateStagingProductsFail() {
        // Test with admin, load 200 staging products with duplicate id
        // 
    }

    // We could unit test validation rule and bypassing if needed

}
