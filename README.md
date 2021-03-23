# Picnic Assignment - Product Propagation

This is a Salesforce DX package which contains the automated solution for Product Propagation in Picnic Assignment.

## Package Components

- Custom object `Staging Product`, and custom fields on `Product` and `Staging Product` objects
- Custom Application `Picnic` with two tabs (Product, Staging Product)
- Apex Trigger and Trigger Handler on `Staging Product` object
- Custom Setting `Bypass Settings`
- Validation Rule `Cannot_Edit_If_Purchasing_Price_Over_5` on Staging Product object
- Workflow Rule `Inform Price Sensitivity` on Product object
- Screen Flow `More Product Info` and quick action `Show more product info` on Product object

## Considerations

- Should Staging Products overwrite manual price changes made by the users on Product object?
- Delete and undelete staging product?
- Mass updates with price sensitivity?
- Staging Product updated without any changes, age field might become inaccurate.
- Data Modelling
  - Will GTIN ever longer than 13 digits?
  - Will Product Name ever longer than 80 characters?
  - Should enable multiple currencies?

## Improvements

- Custom Label for Localisation
- Better Error Handling, DML Result Handling and Logging (both Trigger and Flow)
- Test Data Factory and Helper Functions
- Better code coverage on Staging Product Trigger
- Better Page Layout Design
- Include Test Data Import/Export in DX Package
- If price sensitivity is frequent, add a new field storing previous selling price used for reporting
- Set up CI for package development model from one of the [Sample CI Repos](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ci_package_dev.htm)

## Developer Sandbox

Org URL: [https://picnic-jiedong-dev-ed.my.salesforce.com](https://picnic-jiedong-dev-ed.my.salesforce.com)  
Org ID: 00D09000007Sh6u  
Org User | Username | Email
------------ | ------------- | -------------
Commercial Director (Jiedong) | jiedong.ding@gmail.com.picnic | jiedong.ding@gmail.com
System Admin (Picnic) | system.admin@gmail.com.picnic | sfrecruitment@teampicnic.com
