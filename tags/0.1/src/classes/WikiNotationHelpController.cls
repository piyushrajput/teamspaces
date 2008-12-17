public class WikiNotationHelpController {
	public String idTeam = System.currentPageReference().getParameters().get('id');
	
	public List<WikiPage__c> getWikiHomes () {
		return [select id, name from WikiPage__c where parent__c = null and team__c =: idTeam order by name];	
	}
	
}