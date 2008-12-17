public class BookmarkOverlayNewController{
  // COLLABSUITE-883
    Bookmark__c bookmark;
    boolean noImage;
    boolean emailTeamspace;
    String  error = '';
    boolean showError = false;
    Id teamspaceId;
    
    public BookmarkOverlayNewController(){
        
        bookmark = new Bookmark__c(); 
        String idParam = System.currentPageReference().getParameters().get('id');
       	teamspaceId = System.currentPageReference().getParameters().get('id');
    
        System.debug('idParam: '+idParam);
        
        /*
        if (idParam == null) {
            bookmark.BookmarkURL__c = System.currentPageReference().getParameters().get('url');
            noImage = false;        
        }
        else {
            bookmark = [SELECT  p.Id, 
                            p.type__c, 
                            p.title__c, 
                            p.Body__c, 
                            p.BookmarkURL__c, 
                            p.imageUrl__c, 
                            p.videoURL__c,
                           
                            p.Team__c, 
                            p.Name
                    FROM Bookmark__c p
                    WHERE id= :idParam];
                    
            noImage = (bookmark.imageUrl__c == null);        
        }   
        
        */
    }

	
    public Bookmark__c getBookmark(){        
        return bookmark;
    }

    public boolean getNoImage(){
        return noImage; 
    }
    
    public void setNoImage(boolean bImage){
        noImage = bImage; 
    }
    
    public String getUrlPost(){
        
        return bookmark.BookmarkURL__c;
        
        String url = System.currentPageReference().getParameters().get('url');
        if (url != null) {
            String urlTmp = url.substring(7, url.length()); // http://
            
            return url.substring(7, urlTmp.indexOf('/') + 7);
        }
        else
           return '';       
    }
    
    public String getShowLink(){
        if (bookmark.BookmarkURL__c.length() > 40)
           return bookmark.BookmarkURL__c.substring(0, 40) + '...';
        else 
           return bookmark.BookmarkURL__c;         
    }
    
    public void save(){ 
        /*system.debug(bookmark.Team__c);
        if (bookmark.Team__c == null) {
            system.debug(showError);
            error = 'Post to teamspace not should be null.';
            showError = true;
            return null;
        }*/
        
        bookmark.Team__c  = teamspaceId ;
        insert bookmark;
        
        if (emailTeamspace)
            SendMail();
            
        bookmark =  new Bookmark__c();
           
    }
    
    public String getSave(){
        /*if (bookmark.Team__c == null) {
            system.debug(showError);
            error = 'Post to teamspace not should be null.';
            showError = true;
            //return null;
        }*/
        
        upsert bookmark;
        
        if (emailTeamspace)
            SendMail();
        return null;
    }
    
    public PageReference cancel (){
        PageReference pageRef = new PageReference('/a03/o');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public PageReference copyUrl(){
        return null;
    }
    
    public boolean getEmailTeamspace(){
        return emailTeamspace;  
    }

    public void setEmailTeamspace(boolean sel){
        emailTeamspace = sel;  
    }
    
    public String getError(){
        return error;   
    }
    
    public boolean getShowError(){
        return showError;   
    }
    
    private String htmlToSend(){
        String htmlToSend = '<b>' + bookmark.CreatedBy.Name + ' posted ';
        if (bookmark.type__c != null)
            htmlToSend += 'a ' + bookmark.type__c;
        if (bookmark.Team__r.Name != null)
            htmlToSend += ' to ' + bookmark.Team__r.Name;
            
        htmlToSend += '</b><br></br><table><tr><td>';
        
        if (bookmark.imageUrl__c != null) {
            htmlToSend += '<img id="image" src="'+bookmark.imageUrl__c+'" />';            
        } else {
            String page = bookmark.videoUrl__c.substring(7, bookmark.videoUrl__c.length());
            page = bookmark.videoUrl__c.substring(0, page.indexOf('/')+7);
            String imageurl = '';
            
            if (page.equals('http://www.youtube.com')) { //for youtube
                imageurl = bookmark.videoUrl__c.substring(0, 7) + 'i.ytimg.com/vi/' + bookmark.videoUrl__c.substring(bookmark.videoUrl__c.lastIndexof('/'), bookmark.videoUrl__c.length()) + '/default.jpg';
                //htmlToSend += '<img id="image" src="http://i.ytimg.com/vi/'+bookmark.imageUrl__c.substring(match[0].length, bookmark.imageUrl__c.length)+'/default.jpg"/>';
                //htmlToSend += '<div><object width="100" height="100" style="display: block;"><embed width="100" height="100" wmode="transparent" src="'+bookmark.imageUrl__c+'" type="application/x-shockwave-flash"/></object></div>';
            } 
            bookmark.imageUrl__c = imageurl;
            htmlToSend += '<img id="image" src="'+imageurl+'" />';
        }

        htmlToSend += '</td><td>';
       
        if (bookmark.Body__c != null)
            htmlToSend += '<div>'+bookmark.Body__c+'</div>';
           
     //   if (bookmark.comment__c != null)
     //       htmlToSend +=  '<div style="color:grey; font-family:arial,courier,times; font-size:x-small;">' + bookmark.comment__c + '</div>';
     //   htmlToSend += '<div style="color:grey; font-family:arial,courier,times; font-size:x-small;">'+bookmark.BookmarkURL__c+'</div></td>';
        
        return htmlToSend;         
    }
    
    public void SendMail() {
        // recharge bookmark
        bookmark = [SELECT  p.Id, 
                        p.type__c, 
                        p.title__c, 
                        p.Body__c, 
                        p.BookmarkURL__c, 
                        p.imageUrl__c, 
                       
                        p.Team__c,
                        p.Team__r.Name, 
                        p.Name,
                        p.CreatedBy.Name
                FROM Bookmark__c p
                WHERE id = :bookmark.id];
            
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        list<TeamMember__c> teamspaceMembers = [Select User__r.Email
                                                      From TeamMember__c
                                                      Where Team__c = :bookmark.Team__c];
        
        list<String> toAddresses = new list<String>();
        for(TeamMember__c teamspaceMember: teamspaceMembers) {
            toAddresses.add(teamspaceMember.User__r.Email);         
        } 
                
        // Assign the addresses for the To and CC lists to the mail object.
        mail.setToAddresses(toAddresses);
                
        // Specify the address used when the recipients reply to the email. 
        //mail.setReplyTo(user.Email);
        
        // Specify the name used as the display name.
        mail.setSenderDisplayName(bookmark.CreatedBy.Name);
        
        // Specify the subject line for your email address.
        mail.setSubject(bookmark.title__c);
        
        // Set to True if you want to BCC yourself on the email.
        mail.setBccSender(false);
        
        // Optionally append the salesforce.com email signature to the email.
        // The email address of the user executing the Apex Code will be used.
        mail.setUseSignature(false);
        
        // Specify the html version of the content as well.
        mail.setHtmlBody(htmlToSend());
        
        // Send the email you have created.        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

}