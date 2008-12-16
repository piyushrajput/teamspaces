@IsTest private class TeamsNewMemberTest {
    public static testMethod void testTeam() {
        try{
			GenerateEnvironmentTest.gen();
            Test.startTest();            
            
            Team__c t = GenerateEnvironmentTest.newTeam;
            System.currentPageReference().getParameters().put('id',t.Id);
            
            TeamsNewMemberController team = new TeamsNewMemberController();
            List<SelectOption> option = team.getProfilesOptions ();

            team.setTeamId(t.Id);
            team.getTeamName();
            
            //** getTeamId method
            String id = team.getTeamId();
            
           
           	
            TeamsNewMemberController.Member mem = team.getNewMemberVars();
            
            TeamsNewMemberController.Member member = new TeamsNewMemberController.Member();
            member.setProfileId(t.NewMemberProfile__c);
           	//** Member.getProfile method
           	String profile = member.getProfileId();
           	
            member.getMessage();
            member.setMessage('Some Message');
            member.getTeamRole();
            member.setTeamRole('Some Role');
            member.getColleagueNames();
            
            List<User> users = [select Id, Name, Email from User where isActive = true limit 6];
            String names = null;
            
            Integer i = users.size();
            
            i = i/2;
            
            if( Math.mod(i,2) != 0 && i > 1)
            {
            	i = i-1;
            	i = i/2;
            }else{
            	i = 1;
            }
            
            Integer a = i;
            Integer b = i*2;
            
            for (Integer it = 0; it <= a; it++){
                names += users[it].Name + ',';  
            }           
            member.setColleagueNames(names);
            
            team.setNewMemberVars(member.clone());
            PageReference page = team.saveMembers ();
            
            names = '';
            for (Integer it = a; it < b; it++){
                names += users[it].Name + ',';  
            }   
            team.setNewMemberVars(member.clone());            
            member.setColleagueNames(names);            
            
            team.saveMembersNew();
            team.SendMail(users[0],'Hello Word');   
            
            Test.stopTest();
        }catch(Exception e){
            throw e;
        }
    }
}