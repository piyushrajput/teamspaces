public class TeamSearchResultTest {


    public static testMethod void testTeam() {
    	TeamSearchResultController team = new TeamSearchResultController();
    	//TeamSearchResultController.searchResult  search= new TeamSearchResultController.searchResult();
        // search.setTitle ('A', 'B');
		//search.setMatches('A', 'B');
        //String title = search.getTitle ();
        //System.assert(title!='A', 'NO OK');
		//String matches= search.getMatches ();
		//System.assert(matches!='A', ' NO OK');
		team.search();
	  } 
}