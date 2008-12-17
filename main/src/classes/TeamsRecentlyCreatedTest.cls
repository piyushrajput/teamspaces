@IsTest private class TeamsRecentlyCreatedTest {
    public static testMethod void TeamsRecentlyCreated (){
        try{
			GenerateEnvironmentTest.gen();
            Test.startTest();            
            
            TeamsRecentlyCreated team = new TeamsRecentlyCreated();
            team.getRecentTeamsList();
            Team__c t = GenerateEnvironmentTest.newTeam;
            TeamsRecentlyCreated.RecentTeams rt = new TeamsRecentlyCreated.RecentTeams(t);
            rt.getCreator();
            rt.getTeamPicture();
            User u = rt.getCreatedBy();
            String pic = rt.getPicture();
            t = rt.getTeam();
            List<TeamsRecentlyCreated.RecentTeams> rtList = team.getRecentTeams();
            
            Test.stopTest();
        }catch(Exception e){
            throw e;
        }
    }
}