@IsTest private class TeamsCreateNewTeamTest {
    
    /**
    *@testMethod
    *@void
    */
    public static testMethod void testTeam() {
        try{
            GenerateEnvironmentTest.gen();
            Test.startTest();
            
            System.currentPageReference().getParameters().put('id', GenerateEnvironmentTest.newTeam.Id);
            
            GenerateEnvironmentTest.createTeamType();
            
            GenerateEnvironmentTest.newTeam.PublicProfile__c = GenerateEnvironmentTest.newTeamProfile.Id;
            
            update GenerateEnvironmentTest.newTeam;
            
            
            TeamsCreateNewTeamController team = new TeamsCreateNewTeamController();
            List<SelectOption> optionType = team.getTypes();
            List<SelectOption>  optionProfile = team.getProfiles();
            Team__c t = GenerateEnvironmentTest.newTeam;
            team.saveTeam();
            TeamsCreateNewTeamController.teamProfile tProfile = new TeamsCreateNewTeamController.teamProfile();
            team.setParam(t.Id);
            team.setTeam(t);
            team.setTeam(t.Id);
            team.saveTeam();
            t = team.getTeam();
            team.getnewProfile();
            team.getTeamImage();
            team.setdocument(new Attachment(Name = 'Name', Body = Crypto.generateMac('HMacSHA1', Blob.valueOf('String'), Blob.valueOf('String'))));
            team.getdocument();
            String picture = team.getTeamPicture();

                        
            Test.stopTest();
        }catch(Exception e){
            throw e;
        }
    }
}