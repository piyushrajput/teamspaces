/**
*@author Bruno Fagundez @ 07/02/2008
*/
public class PeopleHeaderSearchController {
	//####################################//
	// People Keyword Search 
	//####################################//
	
	//Search Result Page 
    private static PageReference PEOPLE_SEARCH_RESULTS_PAGE = Page.PeopleKeywordSearchResults;
    
    //Search Object Initialization
    PeopleSearch peopleSearchObj = new PeopleSearch();    
    
    /**
    *Constructor
    */
    public PeopleHeaderSearchController(){    
    	
    }
    
    /**
    *Returns PeopleSearch instance
    *@return PeopleSearch
    */
    public PeopleSearch getPeopleSearchObj (){    	
    	return peopleSearchObj;
   	}
    
    /**
    * Forward to searhc result page
    *@return PageReference
    */
    public PageReference findPeople() {
		PageReference pageRef = PEOPLE_SEARCH_RESULTS_PAGE;
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    /**
    *Class PeopleSearch
    *@author Bruno Fagundez
    */
	public class PeopleSearch {
		public String Keyword{ get; set; }
	}
}