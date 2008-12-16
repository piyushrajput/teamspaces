@IsTest private class TeamMembersWidgetTest {
    public static testMethod void testTeam() {
        try{ 
            
            GenerateEnvironmentTest.gen();
            Test.startTest();            
                    
            TeamMembersWidgetController team = new TeamMembersWidgetController();
            String curUser = team.getCurrentUser(); 
            
            team.getNamespace();
            Team__c t = GenerateEnvironmentTest.newTeam;
            team.setIdTeam(t.Id);
            team.setTeam(t.Id);
            team.setTypeList('test');
            String result = team.getComponentHeader ();
            team.setTypeList('adminList');
            result = team.getComponentHeader ();
            Boolean render = team.getRenderLinkAction ();
            String teamName = team.getTeam();
            String teamId = team.getTeamId();
            team.getIsTeamAdmin();
            String typeList = team.getTypeList();
            
            TeamMember__c m = GenerateEnvironmentTest.newTeamMember;
            TeamMembersWidgetController.TeamMember teamMember= new TeamMembersWidgetController.TeamMember(m, null);
            m = teamMember.getMember();
            String userName = teamMember.getUsername();
            String yahoo = teamMember.getYahoo();
            String skype = teamMember.getSkype();
            String status = teamMember.getStatus();
            PeopleProfile__c profile = teamMember.getProfile();
            String pic = teamMember.getImage(); 
            
            TeamMembersWidgetController.Member member = new TeamMembersWidgetController.Member();
            member = team.getNewMemberVars();
            
            Profile p = [select id from profile where name='System Administrator'];
            User newUser1 = new User(alias = 'test1', email='test1@testorg.com', 
                                    emailencodingkey='UTF-8', lastname='Testing2', languagelocalekey='en_US', 
                                    localesidkey='en_US', profileid = p.Id, 
                                    timezonesidkey='America/Los_Angeles', username='test1@testorg.com');
            insert newUser1;
            
            User newUser2 = new User(alias = 'test2', email='test2@testorg.com', 
                                    emailencodingkey='UTF-8', lastname='Testing2', languagelocalekey='en_US', 
                                    localesidkey='en_US', profileid = p.Id, 
                                    timezonesidkey='America/Los_Angeles', username='test2@testorg.com');
            
            insert newUser2;
            
            User newUser3 = new User(alias = 'test3', email='test3@testorg.com', 
                                    emailencodingkey='UTF-8', lastname='Testing3', languagelocalekey='en_US', 
                                    localesidkey='en_US', profileid = p.Id, 
                                    timezonesidkey='America/Los_Angeles', username='test3@testorg.com');
            
            insert newUser3;
            
            List<User> users = new User[3];
            users[0] = newUser1;
            users[1] = newUser2;
            users[2] = newUser3;
            
            
            String names = null;
            for (User u : users){
                names += u.Name + ',';  
            }
    
            member.setColleagueNames(names);
            team.setNewMemberVars(member);
            
            team.setTypeList('test');
            team.getTeamspaceMembers();
            team.setTypeList('adminList');
            team.getTeamspaceMembers();
            
            List<SelectOption> options = team.getProfilesOptions();
            List<TeamMember__c> members = team.getMemberListToolkit();
            Integer cnt = team.getMemberListToolkitCount();
            
			team.saveMembersNew();
            team.saveMembers();            
            
            team.syncSaveMembers();
            User user = [select Name, Email from User limit 1];
            team.SendMail(user, 'Message');

            Test.stopTest();
        }catch(Exception e){
            throw e;
        }
    }
}