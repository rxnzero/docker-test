//package com.eactive.eai.rms.onl.vo;
//
//public aspect PagingSupportVoAspect {
//
//    /** The total count. */
//    private int PagingSupportVo.totalCount;
//
//    /** The current page num. */
//    private int PagingSupportVo.currentPageNum;
//
//    /** The display count. */
//    private int PagingSupportVo.displayCount;
//
//    /* (non-Javadoc)
//     * @see com.eactive.eai.rms.vo.PagingSupportVo#getDisplayCount()
//     */
//    public int PagingSupportVo.getDisplayCount() {
//        return displayCount > 0 ? displayCount : 20;
//    }
//
//    /* (non-Javadoc)
//     * @see com.eactive.eai.rms.vo.PagingSupportVo#setDisplayCount(int)
//     */
//    public void PagingSupportVo.setDisplayCount(int pagingSize) {
//        this.displayCount = pagingSize;
//    }
//
//    /* (non-Javadoc)
//     * @see com.eactive.eai.rms.vo.PagingSupportVo#getCurrentPageNum()
//     */
//    public int PagingSupportVo.getCurrentPageNum() {
//        return currentPageNum == 0 ? 1 : currentPageNum;
//    }
//
//    /* (non-Javadoc)
//     * @see com.eactive.eai.rms.vo.PagingSupportVo#setCurrentPageNum(int)
//     */
//    public void PagingSupportVo.setCurrentPageNum(int currentPage) {
//        this.currentPageNum = currentPage;
//    }
//
//    /* (non-Javadoc)
//     * @see com.eactive.eai.rms.vo.PagingSupportVo#getStartNum()
//     */
//    public int PagingSupportVo.getStartNum() {
//        return (getCurrentPageNum() - 1) * getDisplayCount() + 1;
//    }
//
//    /* (non-Javadoc)
//     * @see com.eactive.eai.rms.vo.PagingSupportVo#getEndNum()
//     */
//    public int PagingSupportVo.getEndNum() {
//        return getCurrentPageNum() * getDisplayCount();
//    }
//
//    /* (non-Javadoc)
//     * @see com.eactive.eai.rms.vo.PagingSupportVo#getTotalCount()
//     */
//    public int PagingSupportVo.getTotalCount() {
//        return totalCount;
//    }
//
//    /* (non-Javadoc)
//     * @see com.eactive.eai.rms.vo.PagingSupportVo#setTotalCount(int)
//     */
//    public void PagingSupportVo.setTotalCount(int totalCount) {
//        this.totalCount = totalCount;
//    }
//
//}
