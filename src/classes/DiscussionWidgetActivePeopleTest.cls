@IsTest private class DiscussionWidgetActivePeopleTest {

    public static testMethod void testDiscussion() {
        try{
        	GenerateEnvironmentTest.gen();   
    		Test.startTest();
            DiscussionWidgetActivePeopleController dis = new DiscussionWidgetActivePeopleController(); 
            
            DiscussionWidgetActivePeopleController.Actives actives = new  DiscussionWidgetActivePeopleController.Actives();
            List<DiscussionWidgetActivePeopleController.Actives> listActives = dis.getActivePeople();

            String aName = actives.getName();
            String aId = actives.getId();
            actives.setPicture(UserInfo.getUserId());
            String pic = actives.getPicture();
            String userId = actives.getUserId();
            actives.setUserId('');
            actives.setSubject('Subject');
            actives.getSubject();
            
            dis.refreshActivePeople();
            
            Integer sizeList = dis.getActivePeopleSizeList();
        
        	Test.stopTest();
        	
        }catch(Exception e){
            throw e;            
        }
    }
}