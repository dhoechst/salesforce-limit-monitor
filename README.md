# salesforce-limit-monitor
App for monitoring Salesforce org limits. This app will send push notifications when you are at 80% (default) of a limit or if it increases 20% (default) or more from one snapshot to the next. By default, it snapshots limits once per hour. All options can be changed on a per limit basis.

You can also mute notifications for a certain time period or temporarily increase the alert threshold.

Installation steps

1. Install Salesforce Test Factory (https://github.com/dhoechst/Salesforce-Test-Factory)
2. Clone and deploy using sfdx or as an unlocked package (https://login.salesforce.com/packaging/installPackage.apexp?p0=04t2G000000Y1AUQA0)
3. Update the [email alerts](https://github.com/dhoechst/salesforce-limit-monitor/blob/master/force-app/main/default/workflows/LimitSnapshot__c.workflow-meta.xml) with the correct email address.
4. To get push notifications, add users to the Limit Notification Queue.
5. Add Limits records for limits you want to monitor. To add all limits, run this in Execute Anonymous:
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