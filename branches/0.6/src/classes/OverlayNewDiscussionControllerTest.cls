@IsTest private class OverlayNewDiscussionControllerTest {
    public static testMethod void test() {
        try{
			GenerateEnvironmentTest.gen();
            Test.startTest(); 
			System.currentPageReference().getParameters().put('id', GenerateEnvironmentTest.newTeam.Id);
			
			OverlayNewDiscussionController overlay = new OverlayNewDiscussionController();
			overlay.getForumData();
			overlay.getTeamId();
			overlay.genPermissions();
			
			OverlayNewDiscussionController.Topic topic = new OverlayNewDiscussionController.Topic();
			topic.setForum(GenerateEnvironmentTest.newForum.Id);
			topic.getForum();
			topic.getId();
			topic.setId(GenerateEnvironmentTest.newTopic.Id);
			topic.getContent();
			topic.setContent('Foo Content');
			topic.getSubject();
			topic.setSubject('Foo Subject');
			
			overlay.setNewTopic(topic);  
			overlay.saveNewTopic();
			overlay.getNewTopic();
			
            Test.stopTest(); 
        }catch(Exception e){
            throw e;
        }   
    } 
}