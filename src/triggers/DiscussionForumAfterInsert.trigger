trigger DiscussionForumAfterInsert on DiscussionForum__c (after insert) {
/*
	 	
	 for (DiscussionForum__c f : Trigger.new) 
	 {
	 	if (f.Parent_Forum__c != null)
	 	{
	 		DiscussionForum__c parentForum = [SELECT Id, SubForums__c From DiscussionForum__c WHERE id =: f.Parent_Forum__c ];
	  		
	  		parentForum.Has_Sub_Forums__c = true;
	  		 
	  		if (parentForum.SubForums__c != null)
	  		{
	  			parentForum.SubForums__c = parentForum.SubForums__c + 1;
	  		}
	  		else
	  		{
	  			parentForum.SubForums__c = 1;
	  		}
	  			
	  		update parentForum;
	  	}
	}
	  	
	*/ 
}