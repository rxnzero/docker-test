<script language="javascript">
	// not use in new dashboard
    var redirectPage = "<%=(String)session.getAttribute("redirectPage")%>" ;
    document.location.href="<%=request.getContextPath()%>/gfm/dashboard/dashboard04.gfm?redirectPage=" + redirectPage ;
</script>