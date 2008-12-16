trigger MainFeedUser on User (after insert, after update, after delete) {
    
    /**
    * This happens after insert
    */  
    if(trigger.isInsert){
    
      List<MiniFeed__c> minifeed = new List<MiniFeed__c>();
    
        for(Integer i = 0; i < Trigger.new.size(); i++) {
    
            User n = Trigger.new[i];
            
            
        // Blurb:
    
        minifeed.add( new MiniFeed__c( Type__c='TeamMemberJoin',
                                            User__c=n.Id,
                                            FeedDate__c=System.now(),
                                            Message__c='welcome to Saleforce Teams!  Joins the ' + n.Department + ' as ' +  n.Title + '.'));
        
        
        }        
        
        insert minifeed;
    }
}