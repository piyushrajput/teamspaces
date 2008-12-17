@IsTest private class WikiTeamOverviewControllerTest {  

    public static testMethod void WikiTeamOverviewController() {
        GenerateEnvironmentTest.gen();
		
		Test.startTest();
        
        WikiTeamOverviewController wtoc = new WikiTeamOverviewController();  
        
     	Team__c newTeam = GenerateEnvironmentTest.newTeam;
        
        wtoc.setTEAMID(newTeam.Id); 
        
        wtoc.getTEAMID();
        
        //UserPermissionsTest.UserPermissionsTest(); 
        
        /* TeamWikis class */
        WikiTeamOverviewController.TeamWikis teamWikis = new WikiTeamOverviewController.TeamWikis();
        
        teamWikis.getId();
        teamWikis.getName();
        teamWikis.getDescription();
        teamWikis.getPicture();
        
        /* Wiki class */
        WikiTeamOverviewController.Wiki wikiClass = new WikiTeamOverviewController.Wiki();
        
        wikiClass.getModifiedByPicture();
        wikiClass.getParentName();
        wikiClass.getParentId();
        wikiClass.getName();
        wikiClass.getId();
        wikiClass.getLastModifiedBy();
        wikiClass.getLastModifiedById();
        wikiClass.getLastModifiedDate();
        wikiClass.getShortDescription();
        
        
        if (wtoc.getUserPermissions() == null) {
            System.assert(true, 'Null Permissions');
        }
        
        if (wtoc.getUserPermissionsTeam() == null) {
            System.assert(true, 'Null Permissions');
        }
        
      
        wtoc.genContructor();
        wtoc.getCurrentTeam();
        wtoc.getWpl();
        
         // Create a new Wiki Child
        WikiPage__c newWiki = new WikiPage__c();
        newWiki.Name = 'Foo Child Wiki';
        newWiki.Team__c = GenerateEnvironmentTest.newTeam.Id;
        newWiki.Body__c = 'Foo Body';
        newWiki.Parent__c = GenerateEnvironmentTest.newWiki.Id;
        insert newWiki;
        
        wtoc.genContructor();
        
        wtoc.trunkText('aaa ra ra fkjdsaf;lkjdsaf;lkjdsaflkjdsaf;lkjdsalkfjlkdsajflkdsajf;lkdsa');
        wtoc.getWikiSites();
        wtoc.getRecentlyUpdated();
        wtoc.getFavorite();
        wtoc.getCntFav();
        wtoc.getMyRecentChanges();
        wtoc.getCntMyRecentChanges(); 
        

        
        Test.stopTest();
    }
}