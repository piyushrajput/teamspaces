/**
*@author Gabriel Rilo @ 18/12/2008
*/
public class WikiWidgetMyFavoritesController {
	
	
	/**
	* Costructor
	*/
	public WikiWidgetMyFavoritesController () {

	}
	
 	
   	
	/**
	*@return List<FavoriteWikis__c> 
	*/
   	public List<FavoriteWikis__c> getFavorite () {
   		return	[SELECT WikiPage__r.Team__r.Id, WikiPage__r.Team__r.Name, WikiPage__r.Name, WikiPage__r.Id FROM FavoriteWikis__c WHERE User__c = :UserInfo.getUserId() order by WikiPage__r.Name LIMIT 5];
   	}    	
   	
   	/**
   	*@return Integer
   	*/
   	public Integer getCntFav () {
   		return [select count() from FavoriteWikis__c where User__c = :UserInfo.getUserId()];
   	} 
  	

}