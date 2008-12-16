@IsTest private class TeamSearchResultTest {

    public static testMethod void testTeam() {
        try{
            GenerateEnvironmentTest.gen();
            Test.startTest();
            
            Id[] fixedSearchResultsList = new Id[1];
        
            fixedSearchResultsList.add(GenerateEnvironmentTest.newTeam.Id); 
            Test.setFixedSearchResults(fixedSearchResultsList);

            
            TeamSearchResultController team = new TeamSearchResultController();
            
            team.setCriteria('Foo');
            team.search();
            String criteria = team.getCriteria();
            List<Team__c> results = team.getResults();
                        
            TeamMember__c tm = GenerateEnvironmentTest.newTeamMember;
            
            TeamSearchResultController.sr srch = new TeamSearchResultController.sr();
            List<TeamSearchResultController.sr> srchList = team.getsrList();
            srch.setTeamName('Team', 'Tea');
            srch.setMatches('Tea', 'Tea');
            srch.setIsMember(true);
            srch.setIdTeamMember(tm.Id);
            srch.setCloseTeam(tm.Id);           
            Id idMember = srch.getIdTeamMember();
            Boolean closeTeam = srch.getCloseTeam();
            Boolean isMember = srch.getIsMember();
            String teamId = srch.getTeamId();
            String matches = srch.getMatches();
            String url = srch.getUrl();
            String teamName = srch.getTeamName();
            
            team.setTeamId(tm.Team__c);
            srch.setIdTeamMember(tm.Id);
            srch.setTeamId(tm.Team__c);
            team.genCntPagination();
            team.nextPage();
            team.prevPage();
            team.lastPage();
            team.firstPage();
            
            Boolean b1 = team.getPrevPageLinkShow();
            Boolean b2 = team.getPrevPageShow();
            Boolean b3 = team.getNextPageLinkShow();
            Boolean b4 = team.getNextPageShow();
            Boolean b5 = team.getNoMatches();
            team.getLastItem();
            team.getFirstItem();
            Integer totalNumers = team.getTotalItemsNumber();
            Integer firstRow = team.getFirstRow();
            Integer leaveTeam = team.getLeaveTeamCnt();
            
            team.setJumpPage(1);
            team.JumpToPage();
            //team.leaveTeam();
            team.assignLeaveTeamId();
            team.setTeamId(tm.Team__c);
            PageReference pr = team.joinTeam();         
        
            Test.stopTest();
        
        } catch (Exception e){
            throw e;
        }
    } 
}