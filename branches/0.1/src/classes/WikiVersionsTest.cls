public class WikiVersionsTest {
	public static testMethod void testWiki() {
	WikiVersionsController wiki = new WikiVersionsController();
	WikiVersionsController.InfoRev infoRev = new WikiVersionsController.InfoRev();
    List<WikiVersionsController.InfoRev> listRevisions = wiki.getRevisionsList(); 
	WikiVersionsController.InfoRev infoRev2 = wiki.getRevLeftBody();
	WikiVersionsController.InfoRev infoRev3 = wiki.getRevRightBody();
	 try{
 		wiki.saveLeft ();
		} catch (DmlException e) {
		}
	try{
 		wiki.saveRight ();
		} catch (DmlException e) {
		}
      
  }	
}