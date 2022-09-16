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

<html>
  <head>
    <script type="text/javascript"
      src="<c:url value="/js/prototype.js"/>"></script>
    <script type="text/javascript">
    function findDetails(parent) {
        new Ajax.Updater('detailSpan',
                '<c:url value="/common/logging/detail.do" />', {
                    parameters : {
                        parent :parent,
                        hostName :$('hostName').value,
                        instanceName :$('instanceName').value
                    }
                });
    }

    function changeSessionKey(selectBox) {
        var hostName = selectBox.options[selectBox.selectedIndex].title;
        var instanceName = selectBox.value;
        $('sessionKeyForm').hostName.value = hostName;
        $('sessionKeyForm').instanceName.value = instanceName;
    }
</script>
  </head>

  <body>
    <h1>
      <%= localeMessage.getString("view.msg1") %>
    </h1>
    <form name="sessionKeyForm"
      action="<%=request.getContextPath()%>/common/logging/view.do">
      <select id="sessionKey" name="sessionKey"
        onchange="changeSessionKey(this)">
        <option value="">
          <%= localeMessage.getString("view.msg2") %>
        </option>
        <c:forEach items="${sessionKeys}" var="sessionKey">
          <option title="<c:out value="${sessionKey.keys[0]}" />"
            value="<c:out value="${sessionKey.keys[1]}" />"
            <c:if
              test="${sessionKey.keys[0] == param.hostName && sessionKey.keys[1] == param.instanceName}">
              selected='selected'
            </c:if>>
            <c:out
              value="HOSTNAME=${sessionKey.keys[0]}, INSTANCENAME : ${sessionKey.keys[1]}" />
          </option>
        </c:forEach>
      </select>

      <input type="hidden" name="hostName"
        value="<c:out value="${param.hostName}" />" />
      <input type="hidden" name="instanceName"
        value="<c:out value="${param.instanceName}" />" />
      <input type="submit" name="search">
    </form>
    <h1>
      <%= localeMessage.getString("view.msg3") %>
    </h1>

    <form action="<c:url value="/common/logging/newLogger.do" />"
      method="post">
      <input type="hidden" name="hostName"
        value="<c:out value="${param.hostName}" />" />
      <input type="hidden" name="instanceName"
        value="<c:out value="${param.instanceName}" />" />
      <input type="text" size="80" name="newLogger" value="">
      <input type="submit" value="<%= localeMessage.getString("view.submit") %>">
    </form>

    <hr>

    <h1>
      <%= localeMessage.getString("view.msg4") %>
    </h1>

    <form action="<c:url value="/common/logging/edit.do" />"
      method="get">
      <input type="hidden" name="hostName"
        value="<c:out value="${param.hostName}" />" />
      <input type="hidden" name="instanceName"
        value="<c:out value="${param.instanceName}" />" />

      <input type="submit" value="<%= localeMessage.getString("view.update") %>" />

      <table border="1" width="100%">
        <tr>
          <th>
            category
          </th>
          <th>
            <select name="foreceLevel">
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
        <c:forEach items="${categorys}" var="category">
          <tr>
            <td>
              <a href="javascript:findDetails('${category.key}')">${category.key
                }</a>
              <input type="hidden" name="category"
                value="${category.key }">
            </td>
            <td>
              <select name="categoryLevel">
                <option value="DEBUG"
                  <c:if test="${category.value == DEBUG}">selected='selected'</c:if>>
                  DEBUG
                </option>
                <option value="INFO"
                  <c:if test="${category.value == INFO}">selected='selected'</c:if>>
                  INFO
                </option>
                <option value="WARN"
                  <c:if test="${category.value == WARN}">selected='selected'</c:if>>
                  WARN
                </option>
                <option value="ERROR"
                  <c:if test="${category.value == ERROR}">selected='selected'</c:if>>
                  ERROR
                </option>
                <option value="FATAL"
                  <c:if test="${category.value == FATAL}">selected='selected'</c:if>>
                  FATAL
                </option>
              </select>
            </td>
          </tr>
        </c:forEach>
      </table>
      <br />
      DETAIL
      <span id="detailSpan"></span>
      <br />
    </form>
  </body>
</html>