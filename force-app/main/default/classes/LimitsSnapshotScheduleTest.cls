@isTest
public with sharing class LimitsSnapshotScheduleTest {
    @isTest static void LimitsSnapshotScheduleTest() {
        LimitsSnapshotSchedule lss = new LimitsSnapshotSchedule();
        // Just execute the schedulable class for test coverage
        lss.execute(null);
    }
}
