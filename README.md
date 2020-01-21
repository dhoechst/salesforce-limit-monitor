# salesforce-limit-monitor
App for monitoring Salesforce org limits. This app will send push notifications when you are at 80% (default) of a limit or if it increases 20% (default) or more from one snapshot to the next. By default, it snapshots limits once per hour. All options can be changed on a per limit basis.

You can also mute notifications for a certain time period or temporarily increase the alert threshold.

Installation steps

> :warning: There is a known issue that prevents users from opening process builder from unlocked packages. Until this error is fixed, you won't be able to modify them. See https://success.salesforce.com/issues_view?id=a1p3A0000003UVoQAM

1. Clone and deploy using sfdx or as an unlocked package (https://login.salesforce.com/packaging/installPackage.apexp?p0=04t4O000000MjS8QAK)
2. Update the [email alerts](https://github.com/dhoechst/salesforce-limit-monitor/blob/master/force-app/main/default/workflows/LimitSnapshot__c.workflow-meta.xml) with the correct email address.
3. To get push notifications, add users to the Limit Notification Queue.
4. Add Limits records for limits you want to monitor. To add all limits, run this in Execute Anonymous:
```java
Map<String,System.OrgLimit> limitsMap = OrgLimits.getMap();

List<Limit__c> limits = new List<Limit__c>();
for (String lim : limitsMap.keySet()) {
    limits.add(new Limit__c(
    	Name = lim,
    	LimitKey__c = lim
    ));
}

insert limits;
```
6. Schedule the monitoring job using Execute Anonymous. In this case, it is scheduled to run every 15 minutes:
```java
System.schedule('Limits Monitor 1', '0 0 * * * ?', new LimitsSnapshotSchedule());
System.schedule('Limits Monitor 2', '0 15 * * * ?', new LimitsSnapshotSchedule());
System.schedule('Limits Monitor 3', '0 30 * * * ?', new LimitsSnapshotSchedule());
System.schedule('Limits Monitor 4', '0 45 * * * ?', new LimitsSnapshotSchedule());
```