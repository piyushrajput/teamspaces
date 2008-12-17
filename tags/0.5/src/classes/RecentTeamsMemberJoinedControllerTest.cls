public class RecentTeamsMemberJoinedControllerTest {
    public static testMethod void test(){
        try{
			GenerateEnvironmentTest.gen();
	        Test.startTest();            
            
            RecentTeamsMemberJoinedController recent = new RecentTeamsMemberJoinedController();
        	RecentTeamsMemberJoinedController.RecentlyTeams recentTeams = new RecentTeamsMemberJoinedController.RecentlyTeams(GenerateEnvironmentTest.newTeam); 
        	
        	Test.stopTest();
        }catch(Exception e){
            throw e;
        }
    }
}