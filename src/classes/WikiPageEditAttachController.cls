public class WikiPageEditAttachController {
	/* ---------------------------- */
   	/*  CREATE A NEW ATTACHMENT		*/
   	/* ---------------------------- */	
   	
   	public String idWikiPage = System.currentPageReference().getParameters().get('id'); 
   	
    public Attachment attach = new Attachment();
    
    public Attachment getAttach () {
    	return attach;
    }
    
    public String imagePath = '';
    
    public String getImagePath () {
    	if (imagePathList.size() > 0) {
    		imagePath = imagePathList[0];
    		imagePathList.remove(0);
    	}
    	else {
    		imagePath = '';
    	}
    	return imagePath;
    }
    
    public void setImagePath (String imagePath) {
    	this.imagePath = imagePath;
    }
    
    public String html = '';
    
    public String getHtml () {
    	return html;
    }
    
    public void setHtml (String html) {
    	this.html = html;	
    }
    
    public List<String> imagePathList = new List<String>();
    public Map<String, String> imagePathMap = new Map<String, String>();
    
    public List<String> getImagePathList () {
    	return imagePathList;
    }
    
    public Integer imagePathListSize = 0;
    
    public Integer getImagePathListSize () {
    	return imagePathListSize;
    }
    
    public void dummyRefresh () {}
    
    public void proccessHtml () {
    	// <img src="file:///C:/DOCUME%7E1/MSolari/LOCALS%7E1/Temp/msohtml1/01/clip_image004.jpg"/> 
    	
    	imagePathList= new List<String>();
    	imagePathMap = new Map<String, String>();
    	
    	String imgString = 'src="file:///';
    	
    	while (html.split('(?i)' + imgString, 2).size() > 1) {
    		List<String> parts = html.split('(?i)' + imgString, 2);
    		String path = '';
    		List<String> tailParts = parts[1].split('"', 2);
    		if (tailParts.size() > 1) {
    			path = tailParts[0];
    		}
    			
    		if (path != '' && imagePathMap.get(path) == null) {
    			imagePathList.add(path);
    			imagePathMap.put(path, path);
    		}
    		
    		html = parts[0] + 'src="' + parts[1];
    		
    		System.debug('\n\n////////////////////////////////////\n HTML: ' + html + '\n/////////////////////////////////\n\n');
    	}
    	
    	imagePathListSize = imagePathList.size();
    	
    	System.debug('\n\n////////////////////////////////////\n IMAGES PATHS LIST: ' + imagePathList + '\n/////////////////////////////////\n\n');
    	
    }
    
    public void createAttach () {
  		attach.ParentId = idWikiPage;
  		insert attach;
    }
	
}