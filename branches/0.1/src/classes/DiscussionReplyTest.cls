public class DiscussionReplyTest {
	public static String deleteReplyId = System.currentPageReference().getParameters().get('idR'); 	
		 
		 
		 public static testMethod void testDiscussion() {
		
			
	
	DiscussionReplyController dis = new DiscussionReplyController();
	System.assert(dis==null,'No se pudo crear el objeto DiscussionReplyController');
	String param = System.currentPageReference().getParameters().get('id');
	System.assert(param==null,'El parametro es nulo');
	dis.getTopic(param);
	User u = new User();
	DiscussionMessage__c d = new DiscussionMessage__c ();
	DiscussionForum__c f = new DiscussionForum__c();
	DiscussionReplyController.UserTopic ut= new DiscussionReplyController.UserTopic(u,d,f);
	System.assert(ut!=null, 'No se pudo crear el objeto UserTopic');
	String topicSubject= ut.getShowShortTopicName();
	System.assert(topicSubject==null, 'No devolvio String');
	DiscussionReplyController.UserReplys ur = new DiscussionReplyController.UserReplys(d);
	System.assert(ur==null, 'No se pudo crear el objeto UserReplys');		
	DiscussionMessage__c delMessage = [select Id, Message__c from  DiscussionMessage__c where Id =:deleteReplyId];
	try{
	delete delMessage;
	} catch (DmlException e) {
		System.assert(e.getDmlMessage(0).indexOf('No se pudo eliminar el Mensaje') > -1);
	}
	 boolean groupMember = dis.getIsTeamAdminMember();
	 System.assert(groupMember==true, 'No es correcto');			
	}
	

}