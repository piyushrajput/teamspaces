@IsTest private class TeamMembersListTest { 

    public static String idTeam = System.currentPageReference().getParameters().get('id');
    public static Boolean sortByDesc = false;
    
    public static String sortBy = 'User__r.Name';
    User newUser = [select id from User where id !=: UserInfo.getUserId() limit 1];
    
    public static testMethod void testTeam() {
        try{
            
            GenerateEnvironmentTest.gen();
            Test.startTest();

            //List<TeamMember__c> tms = [select Id, User__c, Team__c from TeamMember__c where User__c !=: UserInfo.getUserId() limit 2];
            TeamMembersListController team = new TeamMembersListController();
            
            
            // Team Inner Class
            TeamMembersListController.Member member = new TeamMembersListController.Member();
            member.getYahoo();
            member.getSkype();
            member.getUserId();
            member.getTeamMemberId();
            member.setTeamMemberId(GenerateEnvironmentTest.newTeamMember.Id);
            member.getName();
            member.getMemberImg();
            member.getCompany();
            member.getTitle();
            member.getProfile();
            member.getRole();
            member.setUserId(GenerateEnvironmentTest.newTeamMember.User__c);
            member.setCompany('');
            member.setName('');
            member.setMemberImg(GenerateEnvironmentTest.newTeamMember.User__c);
            member.setProfile('');
            member.setRole('');
            member.setTitle('');
            member.setAdmin(true);
            member.getAdmin();
            
            // Letters Inner Class
            TeamMembersListController.Letters letter = new TeamMembersListController.Letters();
            letter.setLetter('');
            letter.getLetter();
            letter.setContainMembers(0);
            letter.getContainMembers();
            
            // Pagination Methods
            team.genCntPagination();
            team.nextPage();
            team.prevPage();
            team.getCurrentPagination();
            team.getNumberOfItemsToShow();
            team.getFirstRow();
            team.getLastItem();
            team.getTotalItemsNumber();
            
            Boolean b1 = team.getPrevPageLinkShow();
            Boolean b2 = team.getPrevPageShow();
            Boolean b3 = team.getNextPageLinkShow();
            Boolean b4 = team.getNextPageShow();
            
            // Methods without SOQL queries
            team.setIdTeam(GenerateEnvironmentTest.newTeam.Id);
            team.setRemoveMemberId(GenerateEnvironmentTest.newTeamMember.User__c);
            team.getTeamId();
            team.getCurrentUser();
            team.getRemoveMessage();
            team.getDelName();
            team.getItsLastAdmin();
            team.setEditMemberId(GenerateEnvironmentTest.newTeamMember.User__c);
            team.getEditMemberRole();
            team.setEditMemberRole('Foo Role');
            team.getEditMemberProfile();
            team.setEditMemberProfile('Foo Profile');
            team.getEditMember();
            team.getImgEditMember();
            team.getUserPermissions();
            List<TeamMembersListController.Member> mem = team.getMembers();
            team.getFirstItem();
            team.getCntPagination();
             
            // Sort Methods
            team.getSortByDesc();
            team.setSortBy('User__r.Name');
            team.getSortBy();
            team.sortList(); // 1 SOQL
            
            team.setSortBy('User__r.CompanyName');
            team.getSortBy();
            
            team.setSortBy('User__r.Title');
            team.getSortBy();
            
            team.setSortBy('TeamProfile__r.Name');
            team.getSortBy();
            
            team.setSortBy('TeamRole__c');
            team.getSortBy();
            
            // Methods WITH SOQL queries
            team.getAdminCount(); // 1 SOQL
            team.getTeamName(); // 1 SOQL
            team.getUserMemberId(); // 1 SOQL 
            System.currentPageReference().getParameters().put('delId',GenerateEnvironmentTest.newTeamMember.User__c);
            team.assignRemoveId();// 1 SOQL 
            team.getProfilesOptions(); // 1 SOQL
            team.getProfilesOptionsFilter(); // 1 SOQL
            team.getTeamEditProfiles(); // 1 SOQL
            team.genMembers(); // 1 SOQL
            team.getIsTeamAdmin(); // 1 SOQL
           
           	System.currentPageReference().getParameters().put('ltr','true');
           	team.genMembers(); // 1 SOQL
            
            PeopleProfile__c profile = new PeopleProfile__c();
            profile.User__c = GenerateEnvironmentTest.newTeamMember.User__c;
            profile.Name = 'Name';
            insert profile;
            
            // Methods WITH more than 1 SOQL query
            System.currentPageReference().getParameters().put('editId',GenerateEnvironmentTest.newTeamMember.User__c);
            team.assignEditId(); // 4 SOQL
            team.editMemberAction();
            
            team.refresh();
            
            team.removeMember(); // 1 SOQL
            
            //////////////////////////////
            //      92 SOQL AND 74%     //
            //////////////////////////////
                
            /*
            team.setIdTeam(tms[0].Team__c);
            team.setRemoveMemberId(tms[0].User__c);
            
            team.getRemoveMessage();
            PageReference page = team.removeMember();
            
            List<SelectOption> option = team.getProfilesOptions();
            List<SelectOption> option2 = team.getProfilesOptionsFilter();
            
            team.setEditMemberId(newTeamMember.User__c);
            team.setIdTeam(newTeamMember.Team__c);
            team.assignEditId();

            team.getTeamEditProfiles(); 
            team.assignRemoveId ();
            team.getAdminCount();
            team.getUserMemberId();
            
            team.getDelName();
            
            
            team.getIsTeamAdmin();
            
            
                        
            team.setLetter('T');
            team.genMembers();
            
            team.setLetter('ALL');
            team.genMembers();
            
            
            
            List<TeamMembersListController.Letters> letterList = team.getLetterFilter();
            
            String sortBye =  team.getSortBy ();
            team.sortList();
            
            team.setSortBy('User__r.CompanyName');
            team.sortList();            
            
            team.setSortBy('User__r.Title');
            team.sortList();            
            */
            //PageReference pageEdit = team.editMemberAction();
            Test.stopTest();
        }
        catch(Exception e){
            throw e;
        }
    }
    
    public static testMethod void Test1(){
    
    
    }
}