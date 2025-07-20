# salesforce-limit-monitor
App for monitoring Salesforce org limits. This app will send push notifications when you are at 80% (default) of a limit or if it increases 20% (default) or more from one snapshot to the next. By default, it snapshots limits once per hour. All options can be changed on a per limit basis.

You can also mute notifications for a certain time period or temporarily increase the alert threshold.

Installation steps

1. Clone and deploy using sfdx or as an unlocked package (https://login.salesforce.com/packaging/installPackage.apexp?p0=04tKW0000002BYjYAM)
2. If you want to send emails people or systems not in Salesforce. Update the [email alerts](https://github.com/dhoechst/salesforce-limit-monitor/blob/master/force-app/main/default/workflows/LimitSnapshot__c.workflow-meta.xml) with the correct email address.
3. To get emails and push notifications, add users to the Limit Notification Queue.
4. Add Limits records for limits you want to monitor. Make the owner be the Limit Notification Queue to send an email to all members of the queue. To add all limits, run this in Execute Anonymous:
```java
Id limitsQueue = [SELECT Id FROM Group WHERE DeveloperName = 'Limit_Notification_Queue'].Id;
Map<String,System.OrgLimit> limitsMap = OrgLimits.getMap();

List<Limit__c> limits = new List<Limit__c>();
for (String lim : limitsMap.keySet()) {
    limits.add(new Limit__c(
        OwnerId = limitsQueue,
    	Name = lim,
    	LimitKey__c = lim
    ));
}

insert limits;
```
5. Schedule the monitoring job using Execute Anonymous. In this case, it is scheduled to run every 15 minutes:
```java
System.schedule('Limits Monitor 1', '0 0 * * * ?', new LimitsSnapshotSchedule());
System.schedule('Limits Monitor 2', '0 15 * * * ?', new LimitsSnapshotSchedule());
System.schedule('Limits Monitor 3', '0 30 * * * ?', new LimitsSnapshotSchedule());
System.schedule('Limits Monitor 4', '0 45 * * * ?', new LimitsSnapshotSchedule());
```
