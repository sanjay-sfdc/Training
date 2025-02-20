public with sharing class AccountHelperClass {
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountRecords(){
        try {
            List<Account> accList = [Select Name, Phone, Industry, Rating From Account];
            return accList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    @AuraEnabled(cacheable=true)
    public static List<Account> findAccounts(String searchText){
        try {
            String searchKey = '%' + searchText + '%';
            List<Account> accList = [Select Name, Phone, Industry, Rating 
                                    From Account Where Name LIKE :searchKey Limit 10];
            return accList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Id saveAccount(String name, String phone, String rating, String website){      

        try {
            Account acc = new Account();
            acc.Name = name;
            acc.Phone = phone;
            acc.Rating = rating;
            acc.website = website;
            insert acc;

            return acc.Id;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Id saveAccountObject(Account newAccount){      

        try {
            
            insert newAccount;
            return newAccount.Id;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getIndustryPicklistValues() {
        
        // Get the field describe result for the Industry field on the Account object
        Schema.DescribeFieldResult fieldResult = Account.Industry.getDescribe();
        
        // Get the picklist values for the Industry field
        List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
        
        List<Map<String, String>> industryValues = new List<Map<String, String>>();
        
        // Loop through the picklist values and add them to the list
        for (Schema.PicklistEntry entry : picklistEntries) {
            
            // Add only active picklist values 
            if (entry.isActive()) {
                
                
                Map<String, String> industryMap = new Map<String, String>();
                industryMap.put('label', entry.getLabel());
                industryMap.put('value', entry.getValue());

                industryValues.add(industryMap);
            }
        }
        
        return industryValues;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getOwnershipPicklistValues() {
        
        // Get the field describe result for the Industry field on the Account object
        Schema.DescribeFieldResult fieldResult = Account.Ownership.getDescribe();
        
        // Get the picklist values for the Industry field
        List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
        
        List<Map<String, String>> ownershipValues = new List<Map<String, String>>();
        
        // Loop through the picklist values and add them to the list
        for (Schema.PicklistEntry entry : picklistEntries) {
            
            // Add only active picklist values 
            if (entry.isActive()) {
                
                Map<String, String> ownershipMap = new Map<String, String>();
                ownershipMap.put('label', entry.getLabel());
                ownershipMap.put('value', entry.getValue());

                ownershipValues.add(ownershipMap);
            }
        }
        
        return ownershipValues;
    }
}