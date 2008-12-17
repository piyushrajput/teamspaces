trigger WikiPageBeforeDelete on WikiPage__c bulk (before delete) {

	WikiPage__c[] w = Trigger.old;
	//Remove Wiki Links from the Team's Wiki Pages 
	List<WikiLink__c> links = [SELECT Id FROM WikiLink__c WHERE FromLink__c in :Trigger.old AND ToLink__c in :Trigger.old];
    delete links;		
	//Remove Favorite Wikis from the Team's Wiki Pages 
    List<FavoriteWikis__c> favorites = [SELECT Id FROM FavoriteWikis__c WHERE WikiPage__c in :Trigger.old]; 
    delete favorites;		
	//Remove Recently Viewed Wikis from the Team's Wiki Pages 
	List<WikiRecentlyViewed__c> recentlyViewed = [SELECT Id FROM WikiRecentlyViewed__c WHERE WikiPage__c in :Trigger.old];                     
    delete recentlyViewed; 
    //Remove Wiki Versions from the Team's Wiki Pages 
	List<WikiVersions__c> viersions = [SELECT Id FROM WikiVersions__c WHERE WikiPageId__c in :Trigger.old];                     
    delete viersions;         
    //Remove Wiki Comments  from the Team's Wiki Pages 
	List<Comment__c> wikiComments = [SELECT Id FROM Comment__c WHERE ParentWikiPage__c in :Trigger.old];                     
    delete wikiComments;   

}