public class PaginatorController {
	
	public Integer totalItemsNumber= 0;
	public void serTotalItemsNumber(Integer num) {
		totalItemsNumber = num;
	}
	
	public Integer getTotalItemsNumber () {
		return totalItemsNumber;
	}
	
	/* ************************ */
	/*		  Pagination		*/
	/* ************************ */
   	
    /**
   	* Set of Integers to control pagination
   	*/
   	public Integer numberOfItemsToShow = 10;
   	public Integer cntPagination;
   	public Integer currentPagination = 1;
   	public Integer firstRow = 0;
   	
   	/**
   	* Set of Booleans to show or not prev / next links
   	*/
   	public boolean prevPageLinkShow = false;
   	public boolean prevPageShow  = false;
   	public boolean nextPageLinkShow  = false;
   	public boolean nextPageShow  = false;
   	public boolean disabledInput  = false;
   	
   	public boolean getdisabledInput() {
   		if(nextPageShow && prevPageShow){
   			disabledInput = true;
   		}
   		else {
   			disabledInput = false;
   		}
   		return disabledInput;
   	}
   	   	
   	public void genCntPagination() {
   		
   		cntPagination = (totalItemsNumber - (Math.mod(totalItemsNumber, numberOfItemsToShow)))/ numberOfItemsToShow;	
   		if (Math.mod(totalItemsNumber, numberOfItemsToShow) != 0 ) {
   			cntPagination++;
   		} 	
   		
   	}
   	
   	public void nextPage () {
   		currentPagination++;
   		jumpPage = currentPagination;
   		firstRow = firstRow + numberOfItemsToShow;   		
   	}
   	
   	public void prevPage () {
   		currentPagination--;
   		jumpPage = currentPagination;
   		firstRow = firstRow - numberOfItemsToShow;	
   	}

	/* Last Page */
   	public void lastPage () {
   		currentPagination = cntPagination;
		jumpPage = cntPagination;
		firstRow = (jumpPage - 1)* numberOfItemsToShow;		
   	}
   	
   	/* First Page */
   	public void firstPage () {
   		currentPagination = 1;
   		jumpPage = 1;
   		firstRow = (jumpPage - 1)* numberOfItemsToShow;	
   	}

   	public void refreshPages () {
   		
   	}
   	/**
   	* Pagination Integer Getters
   	*/
   	public Integer getFirstItem () {
		return (firstRow);
	}
	
	public Integer getLastItem () {
		Integer lastItem;
		if ((currentPagination == cntPagination) || (currentPagination == 1 && (totalItemsNumber < numberOfItemsToShow))) {
			lastItem = firstRow + Math.mod(totalItemsNumber, numberOfItemsToShow);
		}
		else {
			lastItem = firstRow + 10;
		}
		return lastItem;
	}
   	
   	public Integer getCurrentPagination () {
   		return currentPagination;
   	}
   	
   	public Integer getCntPagination () {
   		return cntPagination;
   	}
   	
   	public Integer getNumberOfItemsToShow () {
   		return numberOfItemsToShow;
   	}
   	
   	public Integer getFirstRow () {
   		return firstRow;
   	}
   	
   	/**
   	* Pagination Boolean Getters
   	*/
   	
	public boolean getPrevPageLinkShow () {
		
		if(currentPagination == 1){ prevPageLinkShow = false;		
		} else {prevPageLinkShow = true;}
		
   		return prevPageLinkShow;
   	}
   	
   	public boolean getPrevPageShow () {
   		
   		if(currentPagination == 1){	prevPageShow = true; 
   		} else {prevPageShow = false;}
   		
   		return prevPageShow;
   	}
   	
   	public boolean getNextPageLinkShow () {
   		
   		
   		if((currentPagination == cntPagination) || (cntPagination == 0)){	nextPageLinkShow = false; 
		} else { nextPageLinkShow = true;}   		
   		
   		return nextPageLinkShow;
   	}
   	
   	public boolean getNextPageShow () {
   		
   		if((currentPagination == cntPagination) || (cntPagination == 0)){ nextPageShow = true; 
		} else { nextPageShow = false;} 
   		
   		return nextPageShow;
   	}	
   	
	/* ************************ */
	/*		  Jump to Page		*/
	/* ************************ */
	
	public Integer jumpPage = 1;
	
	public Integer getJumpPage () {
		return jumpPage;
	}
	
	public void setJumpPage (Integer jumpPage) {
		this.jumpPage = jumpPage;
	}
	
	public void JumpToPage () {
		if (jumpPage > cntPagination) {
			currentPagination = cntPagination;
			jumpPage = cntPagination;
		}
		else {
			if (jumpPage < 1) {
				currentPagination = 1;
				jumpPage = 1;
			}
			else {	
				currentPagination = jumpPage;
			}
		}
		firstRow = (jumpPage - 1)* numberOfItemsToShow;
	}
	
	/* ******************/
	 /*  TEST CLASS      */
	 /* ******************/
	
	public static testMethod void PaginatorController()
	{
		PaginatorController n = new PaginatorController();
		n.serTotalItemsNumber(8);
		Integer totalItem = n.getTotalItemsNumber();
		if(totalItem == null)
		{
				System.assert(false, 'No Items'); 
		}
		boolean disabled = n.getdisabledInput();
		if(disabled == null)
		{
				System.assert(false, 'No set Disabled'); 
		}
		n.genCntPagination();
		n.nextPage();
		n.prevPage();
		n.lastPage();
		n.firstPage();
		n.refreshPages();
		Integer firstI = n.getFirstItem();
		if(firstI == null)
		{
				System.assert(false, 'Error First Item'); 
		}
		Integer lastI = n.getLastItem();
		if(lastI == null)
		{
				System.assert(false, 'Error last Item'); 
		}
		Integer currentP = n.getCurrentPagination();
		if(currentP == null)
		{
				System.assert(false, 'Error Current paginator Item'); 
		}
		Integer cntP = n.getCntPagination();
		if(cntP == null)
		{
				System.assert(false, 'Error cnt paginator Item'); 
		}	
		Integer numberToShow = n.getNumberOfItemsToShow();
		if(numberToShow == null)
		{
				System.assert(false, 'Error number To Show Item'); 
		}
		Integer firstRow = n.getFirstRow();
		if(firstRow == null)
		{
				System.assert(false, 'Error first Row Item'); 
		}
		boolean prevP = n.getPrevPageLinkShow();
		if(prevP == null)
		{
				System.assert(false, 'Error Prev Page Link Show Item'); 
		}
		boolean prevPa = n.getPrevPageShow();
		if(prevPa == null)
		{
				System.assert(false, 'Error Prev Page Item'); 
		}
		boolean NextP = n.getNextPageLinkShow();
		if(NextP == null)
		{
				System.assert(false, 'Error Next Page Link Show Item'); 
		}
		boolean NextPa = n.getNextPageShow();
		if(NextPa == null)
		{
				System.assert(false, 'Error next Page Item'); 
		}
		Integer jumpto = n.getJumpPage();
		if(jumpto == null)
		{
				System.assert(false, 'Error Jump Page Item'); 
		}
		n.setJumpPage(12);
   		n.JumpToPage();
  		
  	
   	}	
		
}