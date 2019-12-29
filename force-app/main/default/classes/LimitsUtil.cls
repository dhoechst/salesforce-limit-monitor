public with sharing class LimitsUtil {
    public static void retrieveLimits() {
        // get the current org limits
        Map<String,System.OrgLimit> limitsMap = OrgLimits.getMap();

        List<LimitSnapshot__c> snapshots = new List<LimitSnapshot__c>();
        List<Limit__c> limitsToUpdate = new List<Limit__c>();
        
        // Query the limits to track and loop through them to record them
        for (Limit__c lim : [SELECT Id, LimitKey__c FROM Limit__c WHERE NextRetrieveTime__c = null OR NextRetrieveTime__c < :System.now() ]) {
            if (!limitsMap.containsKey(lim.LimitKey__c)) {
                lim.Errors__c = INVALID_LIMIT;
                limitsToUpdate.add(lim);
            } else {
                System.OrgLimit orgLimit = limitsMap.get(lim.LimitKey__c);
                snapshots.add(new LimitSnapshot__c(
                    Limit__c = lim.Id,
                    MaximumValue__c = orgLimit.getLimit(),
                    Value__c = orgLimit.getValue()
                ));
            }
        }

        insert snapshots;
        update limitsToUpdate;
    }

    public static void deleteLimits() {
        // Delete all snapshots older than the retention days set on each limit
        Database.delete([SELECT Id FROM LimitSnapshot__c WHERE PastRetentionPeriod__c = true]);
    }

    private static final String INVALID_LIMIT = 'The limit key is invalid. Please check the key and update.'; 

}
