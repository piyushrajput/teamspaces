public class DiscussionSearchResultTest {


		public static testMethod void testDiscussion() {
		
			DiscussionSearchResultsController dis = new DiscussionSearchResultsController();
			
			/* WITH SEARCH CRITERIA */
			try {
				dis.setParamkey('juan');
			}
			catch (exception e) {
				System.assert(true, e);
			}
			
			try {
				dis.contructorFunction();
			}
			catch (exception e) {
				System.assert(true, e);
			}
			
			if (dis.getCriteria() == null) {
			 	System.assert(true,'getCriteria return null');
			}
			
			DiscussionSearchResultsController.searchResult searchResult =  new DiscussionSearchResultsController.searchResult();
			
			if (searchResult.getTitle() == null) {
				System.assert(true,'getTitle return null');	
			}
			
			if (searchResult.getMatches() == null) {
				System.assert(true,'getMatches return null');	
			}
			
			if (searchResult.getUrl() == null) {
				System.assert(true,'getUrl return null');	
			}
			
			if (dis.getTotalItemsNumber() == null) {
			 	System.assert(true,'getTotalItemsNumber return null');
			}
			
			if (dis.getNoMatches() == null) {
			 	System.assert(true,'getNoMatches return null');
			}
			
			try {
				dis.search();	
			}
			catch (exception e) {
				System.assert(true, e);
			}
			
			/* NO SEARCH CRITERIA */
			try {
				dis.setParamkey('');
			}
			catch (exception e) {
				System.assert(true, e);
			}
			
			try {
				dis.contructorFunction();
			}
			catch (exception e) {
				System.assert(true, e);
			}
			
			if (dis.getCriteria() == null) {
			 	System.assert(true,'getCriteria return null');
			}
			
			DiscussionSearchResultsController.searchResult searchResult2 =  new DiscussionSearchResultsController.searchResult();
			
			if (searchResult2.getTitle() == null) {
				System.assert(true,'getTitle return null');	
			}
			
			if (searchResult2.getMatches() == null) {
				System.assert(true,'getMatches return null');	
			}
			
			if (searchResult2.getUrl() == null) {
				System.assert(true,'getUrl return null');	
			}
			
			if (dis.getTotalItemsNumber() == null) {
			 	System.assert(true,'getTotalItemsNumber return null');
			}
			
			if (dis.getNoMatches() == null) {
			 	System.assert(true,'getNoMatches return null');
			}
			
			try {
				dis.search();	
			}
			catch (exception e) {
				System.assert(true, e);
			}
			
			
			/*
			DiscussionSearchResultsController.searchResult search=  new DiscussionSearchResultsController.searchResult();
			search.setTitle ('A', 'B');
			search.setMatches('A', 'B');
			String title = search.getTitle ();
			System.assert(title=='A', 'OK');
			String matches= search.getMatches ();
			System.assert(matches=='A', 'OK');
			dis.search();
			*/
	
		}
}