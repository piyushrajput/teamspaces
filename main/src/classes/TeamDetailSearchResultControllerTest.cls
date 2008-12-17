@isTest private class TeamDetailSearchResultControllerTest { 
    public static testMethod void test() {
        GenerateEnvironmentTest.gen();
        Test.startTest();
        
        System.currentPageReference().getParameters().put('key', 'Foo');
        System.currentPageReference().getParameters().put('id', GenerateEnvironmentTest.newTeam.Id);
        
        Id[] fixedSearchResultsList = new Id[4];
        
        fixedSearchResultsList.add(GenerateEnvironmentTest.newTeamMember.Id);
        fixedSearchResultsList.add(GenerateEnvironmentTest.newWiki.Id);
        fixedSearchResultsList.add(GenerateEnvironmentTest.newMessage.Id); 
        fixedSearchResultsList.add(GenerateEnvironmentTest.newTask.Id);
        
        Test.setFixedSearchResults(fixedSearchResultsList);
        
        
        TeamDetailSearchResultController searchTD = new TeamDetailSearchResultController();
        
        searchTD.setTeamId(GenerateEnvironmentTest.newTeam.Id);
        searchTD.getTeamId();
        searchTD.getCriteria();
        searchTD.setCriteria('Foo');
        
        // TEST SearchResult INNER CLASS
        TeamDetailSearchResultController.SearchResult searchClass = new TeamDetailSearchResultController.SearchResult();
        searchClass.getId();
        searchClass.getResultType();
        searchClass.getMatches(); 
        searchClass.getName();
        searchClass.getRealName();
        
        searchTD.getTotalItemsNumber();
        searchTD.getNoMatches();
        searchTD.getSearchResultList();
        searchTD.refreshPages();
        
        // TEST SEARCH METHOD
        searchTD.search();
        
        // TEST PAGINATION AND JUMP TO PAGE
        searchTD.genCntPagination();
        searchTD.getFirstItem();
        searchTD.getLastItem();
        searchTD.getCurrentPagination();
        searchTD.getCntPagination();
        searchTD.getNumberOfItemsToShow();
        searchTD.getFirstRow();
        searchTD.getPrevPageLinkShow();
        searchTD.getPrevPageShow();
        searchTD.getNextPageLinkShow();
        searchTD.getNextPageShow();
        searchTD.nextPage();
        searchTD.prevPage();
        searchTD.lastPage();
        searchTD.firstPage();
        
        searchTD.getJumpPage();
        searchTD.setJumpPage(1);
        searchTD.getCurrentUser();
        
        Test.stopTest();    
    }
}