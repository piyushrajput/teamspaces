public class DiscussionWidgetActivePeopleTest {


	public static testMethod void testDiscussion() {
	
	DiscussionWidgetActivePeopleController dis = new DiscussionWidgetActivePeopleController(); 
  	DiscussionWidgetActivePeopleController.Actives actives = new  DiscussionWidgetActivePeopleController.Actives();
	List<DiscussionWidgetActivePeopleController.Actives> listActives = dis.getActivePeople();
	System.assert(listActives.size()==0,' No exite personas activas');
	
	}
}