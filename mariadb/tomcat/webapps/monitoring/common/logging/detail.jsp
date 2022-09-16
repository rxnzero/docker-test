<%@ page language="java"%>
<%@ page contentType="text/html; charset=euc-kr"%>
<%@page import="org.apache.log4j.Level"%>
<%@ taglib uri="/WEB-INF/tld/c.tld" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ include file="/jsp/common/include/localemessage.jsp" %>

<c:set var="DEBUG" value="<%=Level.DEBUG_INT%>" />
<c:set var="INFO" value="<%=Level.INFO_INT%>" />
<c:set var="WARN" value="<%=Level.WARN_INT%>" />
<c:set var="ERROR" value="<%=Level.ERROR_INT%>" />
<c:set var="FATAL" value="<%=Level.FATAL_INT%>" />


<table border="1" width="100%">
	<tr>
		<th>
			category
		</th>
		<th>
			<select name="forceDetailLevel">
				<option value="">
					<%= localeMessage.getString("detail.msg1") %>
				</option>
				<option value="DEBUG">
					DEBUG
				</option>
				<option value="INFO">
					INFO
				</option>
				<option value="WARN">
					WARN
				</option>
				<option value="ERROR">
					ERROR
				</option>
				<option value="FATAL">
					FATAL
				</option>
			</select>
		</th>
	</tr>
	<c:forEach items="${details}" var="detailCategory">
		<tr>
			<td>
				${detailCategory.key }
				<input type="hidden" name="detailCategory"
					value="${detailCategory.key }">
			</td>
			<td>
				<select name="detailCategoryLevel">
					<option value="DEBUG"
						<c:if test="${detailCategory.value == DEBUG}">selected='selected'</c:if>>
						DEBUG
					</option>
					<option value="INFO"
						<c:if test="${detailCategory.value == INFO}">selected='selected'</c:if>>
						INFO
					</option>
					<option value="WARN"
						<c:if test="${detailCategory.value == WARN}">selected='selected'</c:if>>
						WARN
					</option>
					<option value="ERROR"
						<c:if test="${detailCategory.value == ERROR}">selected='selected'</c:if>>
						ERROR
					</option>
					<option value="FATAL"
						<c:if test="${detailCategory.value == FATAL}">selected='selected'</c:if>>
						FATAL
					</option>
				</select>
			</td>
		</tr>
	</c:forEach>
</table>


