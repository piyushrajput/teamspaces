trigger MainFeedWiki on WikiPage__c bulk (after insert, after update) {
    /**
    * This happens after insert
    */
    
    if(trigger.isInsert){
    
      List<MiniFeed__c> minifeed = new List<MiniFeed__c>();
      
      
		WikiPage__c[] n = Trigger.new;
		
    
        for(Integer i = 0; i < Trigger.new.size(); i++) {
    
            Team__c Team = [select Name, Id from Team__c where Id =: n[i].Team__c ];
        	// Blurb:
        
            minifeed.add( new MiniFeed__c( Type__c='WikiNewPage',
                                            FeedDate__c=System.now(),
                                            Team__c=n[i].Team__c,
                                            User__c=n[i].CreatedById,
                                            Message__c='created a new wiki page <a href="/apex/WikiPage?idWP=' + n[i].Id + '">' + n[i].Name + '</a> in <a href="/apex/TeamsRedirect?id=' + n[i].Team__c + '">' + Team.Name + '</a>'));
         }        
        
        insert minifeed;
    }   
    
    /**
    * 
    */
    
    if(trigger.isUpdate){
    
    	List<MiniFeed__c> minifeed = new List<MiniFeed__c>();
    	    	
		WikiPage__c[] n = Trigger.new;
		WikiPage__c[] o = Trigger.old;
    
        for(Integer i = 0; i < Trigger.new.size(); i++) {
    
           
            
            Team__c Team = [select Name, Id from Team__c where Id =: n[i].Team__c ];
        	
        	// Blurb:
        	minifeed.add( new MiniFeed__c( 	Type__c = 'WikiEditPage',
                                            FeedDate__c = System.now(),
                                            Team__c = n[i].Team__c,
                                            User__c = n[i].CreatedById,
                                            Message__c = 'updated wiki page <a href="/apex/WikiPage?idWP=' + n[i].Id + '">' + n[i].Name + '</a> in <a href="/apex/TeamsRedirect?id=' + n[i].Team__c + '">' + Team.Name + '</a>'));
        }        
        
        insert minifeed;
    }   
}