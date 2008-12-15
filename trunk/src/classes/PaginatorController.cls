/**
* Class for create pagination list
*@author Martin Prado @ 07/01/2008
*/
public class PaginatorController {
    
    public Integer totalItemsNumber= 0;
    
    /**
    * Set total num of items
    *@param Integer num
    */
    public void setTotalItemsNumber(Integer num) {
        totalItemsNumber = num;
    }
    
    /**
    * Get total items num
    *@return Integer totalItemNumber
    */
    public Integer getTotalItemsNumber () {
        return totalItemsNumber;
    }
    
    /**
    * Set of Integers to control pagination
    */
    public Integer numberOfItemsToShow = 10;
    public Integer cntPagination;
    public Integer currentPagination = 1;
    public Integer firstRow = 0;
    
    /**
    * Set total items to show
    *@param Integer noits
    */
    public void setNumberOfItemsToShow (Integer noits) {
    	numberOfItemsToShow = noits;	
    }
    
    /**
    * Set current page num
    *@param Integer cp
    */
    public void setCurrentPagination (Integer cp) {
    	currentPagination = cp;
    }
    
    /**
    * Set total num of pages
    *@param Integer i
    */
    public void setCntPagination (Integer i){
        cntPagination = i;
    }
    
    
    /**
    * Set of Booleans to show or not prev / next links
    */
    public boolean prevPageLinkShow = false;
    public boolean prevPageShow  = false;
    public boolean nextPageLinkShow  = false;
    public boolean nextPageShow  = false;
    public boolean disabledInput  = false;
    
    /**
    * Set next page to show
    *@param Boolean nps
    */
    public void setNextPageShow (Boolean nps) {
    	nextPageShow = nps;
    }
    
    /**
    * Set previus page to show
    *@param Boolean pps
    */
    public void setPrevPageShow (Boolean pps) {
    	prevPageShow = pps; 
    }
    
    /**
    * Get disabled input (uses in jump to page)
    *@return Boolean disbledInput
    */
    public boolean getdisabledInput() {
        if(nextPageShow && prevPageShow){
            disabledInput = true;
        }else {
            disabledInput = false;
        }
        return disabledInput;
    }
        
    /**
    * Set total num of pages
    */
    public void genCntPagination() {
        cntPagination = (totalItemsNumber - (Math.mod(totalItemsNumber, numberOfItemsToShow)))/ numberOfItemsToShow;    
        if (Math.mod(totalItemsNumber, numberOfItemsToShow) != 0 ) {
            cntPagination++;
        }   
    }
    
    /**
    * Clear pagination for re-use instance
    */
    public void clearPagination(){
        firstRow = 0;
        currentPagination = 1;
    }
    
    /**
    * Move to next page
    */
    public void nextPage () {
        currentPagination++;
        jumpPage = currentPagination;
        firstRow = firstRow + numberOfItemsToShow;          
    }
    
    /**
    * Move to previus page
    */
    public void prevPage () {
        currentPagination--;
        jumpPage = currentPagination;
        firstRow = firstRow - numberOfItemsToShow;  
    }

    /**
    * Move to last page
    */
    public void lastPage () {
        currentPagination = cntPagination;
        jumpPage = cntPagination;
        firstRow = (jumpPage - 1)* numberOfItemsToShow;     
    }
    
    /**
    * Move to first page
    */
    public void firstPage () {
        currentPagination = 1;
        jumpPage = 1;
        firstRow = (jumpPage - 1)* numberOfItemsToShow; 
    }

    public void refreshPages () {}
    
    /**
    * Get first item
    *@return Integer firstRow
    */
    public Integer getFirstItem () {
        return (firstRow);
    }
    
    /**
    * Returns last item
    *@return Integer lastItem
    */
    public Integer getLastItem () {
        Integer lastItem;
        if ((currentPagination == cntPagination) || (currentPagination == 1 && (totalItemsNumber < numberOfItemsToShow))) {
            lastItem = firstRow + Math.mod(totalItemsNumber, numberOfItemsToShow);
        }else {
            lastItem = firstRow + 10;
        }
        return lastItem;
    }
    
    /**
    * Get current page num
    *@return Integer currentPagination
    */
    public Integer getCurrentPagination () {
        return currentPagination;
    }
    
    /**
    * Get total num of pages
    *@return Integer cntPagination
    */
    public Integer getCntPagination () {
        return cntPagination;
    }
    
    /**
    * Returns total number of items to show
    @return Integer num
    */
    public Integer getNumberOfItemsToShow () {
        return numberOfItemsToShow;
    }
    
    /**
    * Get first row
    *@return Integer firstRow
    */
    public Integer getFirstRow () {
        return firstRow;
    }
    
    /**
    * Pagination Boolean Getters
    */
    
    /**
    * Get show previus page link
    *@return Boolean prevPageLinkShow
    */
    public boolean getPrevPageLinkShow () {
        if(currentPagination == 1){ 
        	prevPageLinkShow = false;       
        } else {
        	prevPageLinkShow = true;
        }
        return prevPageLinkShow;
    }
    
    /**
    * Get show previus page
    *@return Boolean prevPageShow
    */
    public boolean getPrevPageShow () {
        if(currentPagination == 1){ 
        	prevPageShow = true; 
        } else {
        	prevPageShow = false;
        }
        return prevPageShow;
    }
    
    /**
    * Get show next page
    *@return Boolean prevPageShow
    */
    public boolean getNextPageLinkShow () {
        if((currentPagination == cntPagination) || (cntPagination == 0)){   
        	nextPageLinkShow = false; 
        } else { 
        	nextPageLinkShow = true;
        }          
        return nextPageLinkShow;
    }
    
    /**
    * Get show next page link
    *@return Boolean prevPageShow
    */    
    public boolean getNextPageShow () {
        if((currentPagination == cntPagination) || (cntPagination == 0)){ 
        	nextPageShow = true; 
        } else { 
        	nextPageShow = false;
        } 
        return nextPageShow;
    }   
    

    
    public Integer jumpPage = 1;
	/**
	* Jump to page
	*@return Integer jumpPage
	*/    
    public Integer getJumpPage () {
        return jumpPage;
    }
    
    /**
    * Set jumpo to page
    *@param Integer jumpPage
    */
    public void setJumpPage (Integer jumpPage) {
        this.jumpPage = jumpPage;
    }
    
    /**
    * Jump to page
    */
    public void JumpToPage () {
        if (jumpPage > cntPagination) {
            currentPagination = cntPagination;
            jumpPage = cntPagination;
        }else{
            if (jumpPage < 1) {
                currentPagination = 1;
                jumpPage = 1;
            }else {  
                currentPagination = jumpPage;
            }
        }
        firstRow = (jumpPage - 1)* numberOfItemsToShow;
    }
        
}