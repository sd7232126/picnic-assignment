/**
 * Test class for StagingProductTrigger and StagingProductTriggerHandler
 */
@isTest
private class StagingProductTriggerHandler_Test {

    // Todo: TestDataFactory class, General Create Object method

    @testSetup
    static void testSetup() {
        // Create admin user and commercial director users
        // Todo: No DeveloperName column on Profile object
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' OR Name = 'Systeembeheerder'];
        List<User> users = new List<User>();
        User sysAdmin = new User(   Alias = 'sysadmin', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US',
                                    TimeZoneSidKey = 'Europe/Amsterdam', LocaleSidKey = 'nl_NL',
                                    FirstName = 'System', LastName = 'Admin', ProfileId = sysAdminProfile.Id, 
                                    Username = 'system.admin@mail.com', Email = 'system.admin@mail.com');
        User comDirector = new User(Alias = 'director', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US',
                                    TimeZoneSidKey = 'Europe/Amsterdam', LocaleSidKey = 'nl_NL',
                                    FirstName = 'Commercial', LastName = 'Director', ProfileId = sysAdminProfile.Id,
                                    Username = 'commercial.director@mail.com', Email = 'commercial.director@mail.com');
        users.add(sysAdmin);
        users.add(comDirector);
        Database.insert(users);

        // Create 100 existing products
        List<Product2> products = new List<Product2>();
        for (Integer i = 1; i <= 100; i++) {
            products.add(new Product2(
                Name = 'Product ' + i,
                GTIN__c = String.valueOf(i),
                Purchasing_Price__c = 1,
                Selling_Price__c = 1
            ));
        }
        Database.insert(products);

        // Set bypass settings for commercial head user (integration user)
        insert new Bypass_Settings__c(SetupOwnerId = comDirector.Id, SProduct_VR__c = true);
    }

    @isTest
    static void testPropagateStagingProductsSuccess() {
        // test with commercial director (or integration user), load 200 staging products
        // 100 exists, 100 not exist
        User comDirector = [SELECT Id FROM User WHERE Username = 'commercial.director@mail.com'];
        System.runAs(comDirector) {
            List<Staging_Product__c> stagingProducts = new List<Staging_Product__c>();
            for (Integer i = 1; i <= 200; i++) {
                stagingProducts.add(new Staging_Product__c(
                    Name = 'Product ' + i,
                    GTIN__c = String.valueOf(i),
                    Purchasing_Price__c = i,
                    Selling_Price__c = i
                ));
            }
            Test.startTest();
                Database.upsert(stagingProducts, Staging_Product__c.GTIN__c);
            Test.stopTest();
            System.assertEquals(200, [SELECT Id FROM Product2].size(), 'Staging Products are not upserted correctly.');
        }
    }

    @isTest
    static void testPropagateStagingProductsFail() {
        // test with system admin, load one staging product with data issue
        // Todo: This only tests the validation rule, not the catch exception part in handler
        User sysAdmin = [SELECT Id FROM User WHERE Username = 'system.admin@mail.com'];
        System.runAs(sysAdmin) {
            Staging_Product__c sProduct = new Staging_Product__c(
                Name = 'Product',
                GTIN__c = 'TEST_GTIN',
                Purchasing_Price__c = 10,
                Selling_Price__c = 10
            );
            Test.startTest();
                DmlException unexpectedException;
                try {
                    Database.upsert(sProduct, Staging_Product__c.GTIN__c);
                } catch (DmlException e) {
                    unexpectedException = e;
                }
            Test.stopTest();
            System.assertNotEquals(null, unexpectedException, 'DmlException should be caught.');
        }
    }

}
