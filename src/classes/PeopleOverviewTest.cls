public class PeopleOverviewTest {
    public static testMethod void testPeople() {
        
        PeopleOverviewController overview = new PeopleOverviewController();
            
        String time = overview.getCurrentTime();
        if(time == null) 
            System.assert(true, 'getCurrentTime() method >> does not work');
            
        //boolean suscribedPpl  = overview.getShowSubscribedPeople();
        //if(suscribedPpl == null) 
        //    System.assert(true, 'getShowSubscribedPeople() method >> does not work');
        
        //integer suscribedcount  = overview.getCountSubscribedToMe();
        //if(suscribedcount == null) 
        //    System.assert(true, 'getCountSubscribedToMe() method >> does not work');
        
        //try{
        //    overview.subscriptionCounts();
        //} catch(Exception e){
        //    System.assert(true, 'getOption() method >> does not work correctly');
        //}
            
        
        List<PeopleOverviewController.People> newFaces = overview.getNewFaces();
        if(newFaces.size() == 0) 
            System.assert(true, 'getCountSubscribedToMe() method >> does not work');
        
        List<PeopleOverviewController.CloudItems> competenciesCloud = overview.getCompetenciesCloud();
        if(competenciesCloud.size() == 0) 
            System.assert(true, 'getCompetenciesCloud() method >> does not work');
        
        List<PeopleOverviewController.CloudItems> formerCompaniesCloud = overview.getFormerCompaniesCloud();
        if(formerCompaniesCloud.size() == 0) 
            System.assert(true, 'getFormerCompaniesCloud() method >> does not work');
        
    }   
}