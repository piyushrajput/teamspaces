trigger MainFeedEducationHistory on EducationHistory__c (after update, after delete, after insert) {

// This happens after update
if(trigger.isUpdate){

    List<MiniFeed__c> minifeed = new List<MiniFeed__c>();

    for(Integer i = 0; i < Trigger.old.size(); i++) {

        EducationHistory__c o = Trigger.old[i];
        EducationHistory__c n = Trigger.new[i];

         // We need to:
        if((n.Status__c != o.Status__c) ||
           (n.SecondConcentration__c != o.SecondConcentration__c) ||
           (n.Name != o.Name) ||
           (n.Concentration__c != o.Concentration__c) ||
           (n.SecondConcentration__c != o.SecondConcentration__c) ||
           (n.ClassYear__c != o.ClassYear__c) ||
           (n.AttendedFor__c != o.AttendedFor__c) ) {

            minifeed.add( new MiniFeed__c( Type__c='PeopleEducationChange',
            								FeedDate__c=System.now(),
                                           User__c=n.User__c,
                                           Message__c='has updated their education history' ));
        }
    }

    insert minifeed;
    }

////////////////////////////////////////////////////////////////
// This happens after insert
////////////////////////////////////////////////////////////////

if(trigger.isInsert){
    List<MiniFeed__c> minifeed = new List<MiniFeed__c>();

    for(Integer i = 0; i < Trigger.new.size(); i++) {

       EducationHistory__c n = Trigger.new[i];

        // We need to:
         minifeed.add( new MiniFeed__c( Type__c='PeopleEducationChange',
                                           User__c=n.User__c,
                                           FeedDate__c=System.now(),
                                           Message__c='has updated their education history' ));
        

    }

    insert minifeed;
    }

////////////////////////////////////////////////////////////////
// This happens after delete
////////////////////////////////////////////////////////////////

if(trigger.isDelete){

    List<MiniFeed__c> minifeed = new List<MiniFeed__c>();

    for(Integer i = 0; i < Trigger.old.size(); i++) {

       EducationHistory__c o = Trigger.old[i];

        // We need to:
         minifeed.add( new MiniFeed__c( Type__c='PeopleEducationChange',
                                           User__c=o.User__c,
                                           FeedDate__c=System.now(),
                                           Message__c='has updated their education history' ));
        

    }

    insert minifeed;
    }

}