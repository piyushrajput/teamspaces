public class WikiTeamOverviewControllerTest {

	public static testMethod void WikiTeamOverviewController() {
		
		WikiTeamOverviewController wtoc = new WikiTeamOverviewController();
		
		wtoc.setTEAMID('a0B30000001vSWJEA2');
		wtoc.genWikiTree();
		wtoc.genTeamData();
		wtoc.genWikiSites();
		wtoc.genCntPagination();
		wtoc.getNumSitesRows();
		wtoc.getFirstRow();
		wtoc.nextPage();
		wtoc.prevPage();
		wtoc.getCurrentPagination();
		wtoc.getLetterFilter();
		wtoc.getTEAMID();
		wtoc.trunkText('aaa ra ra fkjdsaf;lkjdsaf;lkjdsaflkjdsaf;lkjdsalkfjlkdsajflkdsajf;lkdsa');
		wtoc.getWikiSites();
		wtoc.getRecentlyUpdated();
		wtoc.getFavorite();
		wtoc.getCntFav();
		wtoc.getMyRecentChanges();
		wtoc.getCntMyRecentChanges();
		wtoc.filterSites();	
		
	}
}