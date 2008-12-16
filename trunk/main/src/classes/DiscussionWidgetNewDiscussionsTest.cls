@IsTest private class DiscussionWidgetNewDiscussionsTest {

    public static testMethod void testDiscussion() {
        try{
            DiscussionWidgetNewDiscussionsController dis = new DiscussionWidgetNewDiscussionsController();
            List<DiscussionWidgetNewDiscussionsController.Topics> topics = dis.getNewDiscussionTopics();
            DiscussionWidgetNewDiscussionsController.Topics topic = new DiscussionWidgetNewDiscussionsController.Topics();
            topic.setId('Test');
            String id = topic.getId();
            topic.setSubject('Test');
            String subject = topic.getSubject();
            Boolean topLstCnt = dis.getTopicListCount();
        }catch(Exception e){
            throw e;
        }
    }   
}