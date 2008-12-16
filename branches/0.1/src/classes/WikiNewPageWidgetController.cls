public class WikiNewPageWidgetController {
	public String idTeam = System.currentPageReference().getParameters().get('id');
	public String idWikiPage = System.currentPageReference().getParameters().get('idWP');
	public String idTeamOverview = System.currentPageReference().getParameters().get('tid');
	
	public WikiNewPageWidgetController () {
		if (idTeamOverview != null && idTeamOverview != '') {
			idTeam = idTeamOverview;
		}
		
		if (idWikiPage != '' && idWikiPage != null) {
			idTeam = [SELECT Team__r.Id From WikiPage__c WHERE id =:idWikiPage].Team__r.Id;
		}
	}
	
	public String getIdTeam () {
		return idTeam;
	}
	
	public String getIdTeamOverview () {
		return idTeamOverview;
	}
	
	public String getIdWikiPage () {
		return idWikiPage;	
	}
	
	public void refreshWikis () {
		System.debug('\n //////////////////// \n \n Refresh!!! \n /////////////// \n');
	}
		
}