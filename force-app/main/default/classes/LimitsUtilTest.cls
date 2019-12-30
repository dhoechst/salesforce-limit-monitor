@isTest
public with sharing class LimitsUtilTest {
  @isTest
  static void testRetrieveLimits() {
    Limit__c testLimit = (Limit__c) TestFactory.createSObject(
      new Limit__c(
        Name = 'API',
        LimitKey__c = 'DailyApiRequests',
        AlertThreshold__c = .8,
        ChangeThreshold__c = .2
      ),
      true
    );

    Test.startTest();
    LimitsUtil.retrieveLimits();
    Test.stopTest();

    List<LimitSnapshot__c> snapshots = [
      SELECT Id
      FROM LimitSnapshot__c
      WHERE Limit__c = :testLimit.Id
    ];
    System.assert(
      !snapshots.isEmpty(),
      'A limits snapshot should have been recorded'
    );
  }

  @isTest
  static void testRetrieveLimitsError() {
    Limit__c testLimit = (Limit__c) TestFactory.createSObject(
      new Limit__c(
        Name = 'API',
        LimitKey__c = 'BadLimitName',
        AlertThreshold__c = .8,
        ChangeThreshold__c = .2
      ),
      true
    );

    Test.startTest();
    LimitsUtil.retrieveLimits();
    Test.stopTest();

    testLimit = [
      SELECT Id, Errors__c, (SELECT Id FROM Limit_Snapshots__r)
      FROM Limit__c
      WHERE Id = :testLimit.Id
      LIMIT 1
    ];
    System.assert(
      testLimit.Limit_Snapshots__r.isEmpty(),
      'No limits snapshots should have been recorded'
    );
    System.assert(
      testLimit.Errors__c != null,
      'An error should have been added to the limit record'
    );
  }

  @isTest
  static void testDeleteLimits() {
    Limit__c testLimit = (Limit__c) TestFactory.createSObject(
      new Limit__c(
        Name = 'API',
        LimitKey__c = 'DailyApiRequests',
        AlertThreshold__c = .8,
        ChangeThreshold__c = .2,
        SnapshotRetentionDays__c = 0
      ),
      true
    );

    LimitsUtil.retrieveLimits();

    Test.startTest();
    LimitsUtil.deleteLimits();
    Test.stopTest();

    List<LimitSnapshot__c> snapshots = [
      SELECT Id
      FROM LimitSnapshot__c
      WHERE Limit__c = :testLimit.Id
    ];
    System.assert(
      snapshots.isEmpty(),
      'All limits snapshots should have been deleted'
    );
  }
}
