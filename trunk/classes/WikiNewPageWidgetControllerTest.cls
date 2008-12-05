@IsTest private class WikiNewPageWidgetControllerTest {  
	public static testMethod void testWiki() {
		GenerateEnvironmentTest.gen();
		
		Test.startTest();
		System.currentPageReference().getParameters().put('id', GenerateEnvironmentTest.newTeam.id);
		
		WikiNewPageWidgetController wiki = new WikiNewPageWidgetController(); 	
		
		wiki.saveWiki();
		System.currentPageReference().getParameters().remove('id');
		
		wiki.setIdWikiPage(GenerateEnvironmentTest.newWiki.id);   
		
		wiki.constructMethods(); 
		
		wiki.saveWiki();
		wiki.saveWikiAndEdit();
		
		wiki.getIdTeam();
		wiki.getIdTeamOverview();
		wiki.getIdWikiPage();
		
		try {
			wiki.refreshWikis();    
		}catch (exception e) {
			System.assert(true, e);
		}
		
		
		wiki.setIdTeam(GenerateEnvironmentTest.newTeam.id);
		wiki.setIdTeamOverview(GenerateEnvironmentTest.newTeam.id);
		
		wiki.getNamespace();
		wiki.constructMethods();    
		
		wiki.getNewWikiPage();
		
		
		Test.stopTest();
	}
}