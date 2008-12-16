@IsTest private class WikiPageHistoryControllerTest { 
	public static testMethod void testWiki() {
		GenerateEnvironmentTest.gen();
		
		Test.startTest();
		WikiPage__c newWiki = [select id from WikiPage__c order by createdDate desc limit 1];
		System.currentPageReference().getParameters().put('id', newWiki.Id);
		
		WikiPageHistoryController wikiHistory = new WikiPageHistoryController();
		wikiHistory.getWikiSiteName();
		wikiHistory.getBreadCrumbing();
		
		WikiPageHistoryController.Info wikiInfo = new WikiPageHistoryController.Info();
		wikiInfo.getName();
		wikiInfo.getShortDescription();
		wikiInfo.getCreatedBy();
		wikiInfo.getLastModifiedBy();
		wikiInfo.getCreatedDate();
		wikiInfo.getLastModifiedDate();
		
		wikiHistory.getInfoWiki();
		wikiHistory.getSortBy();
		System.currentPageReference().getParameters().put('sb', 'LUB'); 
		wikiHistory.sortBy();
		System.currentPageReference().getParameters().put('sb', 'LUB'); 
		wikiHistory.sortBy();
		System.currentPageReference().getParameters().put('sb', 'U'); 
		wikiHistory.sortBy();
		System.currentPageReference().getParameters().put('sb', 'U'); 
		wikiHistory.sortBy();
		System.currentPageReference().getParameters().put('sb', 'V'); 
		wikiHistory.sortBy();
		System.currentPageReference().getParameters().put('sb', 'V'); 
		wikiHistory.sortBy();
		System.currentPageReference().getParameters().put('sb', 'LUB'); 
		wikiHistory.sortBy();
		
		Test.stopTest();
	}
}