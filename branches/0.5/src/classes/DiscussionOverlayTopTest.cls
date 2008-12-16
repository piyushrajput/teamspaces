@IsTest private class DiscussionOverlayTopTest {
    
    
    public static String TEAMID =null;
    
    public static testMethod void testDiscussion() {
            
		GenerateEnvironmentTest.gen();
        Test.startTest();
		
		System.currentPageReference().getParameters().put('id', GenerateEnvironmentTest.newTeam.Id);
		DiscussionOverlayTopicEdit discussion = new DiscussionOverlayTopicEdit();
    	DiscussionOverlayTopicEdit.DiscussionTopic topic = new DiscussionOverlayTopicEdit.DiscussionTopic();
    	topic.Name = 'Test';
    	topic.TopicIdToUpdate = GenerateEnvironmentTest.newTopic.Id;
    	topic.MessageIdToUpdate = GenerateEnvironmentTest.newMessage.Id;
    	discussion.setTopic(topic);
    	discussion.saveTopic();
    	discussion.updateTopic();
    	discussion.getTeamId();
    	discussion.getTopic();
    	
    	Test.stopTest();
    }
}