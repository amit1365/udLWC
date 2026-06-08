public class StaleApplicationScheduler implements Schedulable{
    public void execute(SchedulableContext  sc){
        Id jobId = Database.executeBatch(new StaleApplicationBatch(), 200);
    }

    public static void scheduleJobAppBatch(){
        string cron = '00 00 21 * * ?';
        System.schedule('Job Applicatio Batch', cron, new StaleApplicationScheduler());

    }
}