@IsTest private class TeamsSidebarMeetPeopleControllerTest {
    public static testMethod void test() {
        try{
			GenerateEnvironmentTest.gen();
            Test.startTest(); 
		
			TeamsSidebarMeetPeopleController sidebar = new TeamsSidebarMeetPeopleController();
			sidebar.getUserList();
			
            Test.stopTest(); 
        }catch(Exception e){
            throw e;
        }
    }             
}