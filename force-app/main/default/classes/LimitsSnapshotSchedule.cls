global with sharing class LimitsSnapshotSchedule implements Schedulable{
    global void execute(SchedulableContext sc) {
        LimitsUtil.retrieveLimits();
        LimitsUtil.deleteLimits();
    }
}
