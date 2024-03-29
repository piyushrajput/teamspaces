/**
*@author German Barrios @ 12-1-2008
*/
public class SearchController {
	// Parameter with action
	private String module = null;
	
	// Parameter with search string
	private String key = null;
	
	// Parameter for seach in team
	private String teamId = null;
	
	// Text of search label
	private String label = '';
	
	// Default input field text value
	private String defText = '';
	
	// Map with action=>PageReference
	private Map<String, PageReference> searchIn = new Map<String, PageReference>{
		'discussion'=> Page.DiscussionSearchResults, 
		'people_keyword' => Page.PeopleKeywordSearchResults,
		'team' => Page.TeamSearchResult,
		'team_detail' => Page.TeamDetailSearchResult,
		'wiki' => Page.WikiSearchResult
		};
	
	/**
	* Redirect to the specific result
	*@return PageReference
	*/
	public PageReference searchKey(){
		if(this.module != null && this.module != ''){
			PageReference pageRef = searchIn.get(module);
			pageRef.getParameters().put('key', this.key);
			if(this.teamId != null || this.teamId != '')
				pageRef.getParameters().put('id', this.teamId);
			pageRef.setRedirect(true);
			return pageRef;
		}else {
			return null;
		}
	}
	
	/**
	*@param String action
	*/
	public void setModule(String mod){
		this.module = mod;
	}
	
	/**
	*@return String
	*/
	public String getModule(){
		return this.module;
	}
	
	/**
	*@return String
	*/
	public String getKey(){
		return this.key;
	}
	
	/**
	*@param String
	*/
	public void setKey(String k){
		this.key = k;
	}
	
	/**
	*@return String
	*/
	public String getTeamId(){
		return this.teamId;
	}
	
	/**
	*@param String
	*/
	public void setTeamId(String id){
		this.teamId = id;
	}
	
	/**
	* Get value of label
	*@return String label
	*/
	public String getLabel(){
		String txt;
		if(module == 'discussion'){
			txt = 'Discussions';
		}else if(module == 'people_keyword'){
			txt = 'People';
		}else if(module == 'team'){
			txt = 'Teams';
		}else if(module == 'team_detail'){
			txt = 'in Teams';
		}else if(module == 'wiki'){
			txt = 'wiki';
		}else {
			txt = '';
		}
		this.label = txt;
		return this.label;
	}
	
	/**
	* Get value of default input field value
	*@return String text
	*/
	public String getDefaultText(){
		String txt = 'Enter ';
		if(module == 'discussion'){
			txt = txt + 'name or description...';
		}else if(module == 'people_keyword'){
			txt = txt + 'name, competency, experiences...';
		}else if(module == 'team'){
			txt = txt + 'Team name...';
		}else if(module == 'team_detail'){
			txt = txt + 'Team\'s content...';
		}else if(module == 'wiki'){
			txt = txt + 'wiki page...';	
		}else {
			txt = '';
		}
		this.defText = txt;
		return this.defText;
	}
}