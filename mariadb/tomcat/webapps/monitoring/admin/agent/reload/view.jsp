<%@ page language="java"%>
<%@ page contentType="text/html; charset=euc-kr"%>
<%@ taglib uri="/WEB-INF/tld/c.tld" prefix="c"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title></title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <script type="text/javascript"
      src="<c:url value="/js/prototype.js"/>"></script>

    <script type="text/javascript">
    function changeSessionKey(selectBox) {
        var hostName = selectBox.options[selectBox.selectedIndex].title;
        var instanceName = selectBox.value;
        $('reloadForm').hostName.value = hostName;
        $('reloadForm').instanceName.value = instanceName;
    }
</script>
  </head>

  <body>
    <h1>
      Client�� ��⵿ �� ��� ������ Ŭ���̾�Ʈ�� ���� �ϰ� RELOAD ��ư�� Ŭ�� �ϼ���.
    </h1>
    <form name="reloadForm" id="reloadForm" method="post"
      action="<%=request.getContextPath()%>/admin/agent/reload/reload.do">

      <select id="sessionKey" name="sessionKey"
        onchange="changeSessionKey(this)">
        <option value="">
          RMS CLIENT�� RELOAD �մϴ�.
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

      <br />

      ȣ��Ʈ��
      <input type="text" name="hostName" value="${param.hostName }" />
      �ν��Ͻ���
      <input type="text" name="instanceName"
        value="${param.instanceName}" />

      <input type="hidden" name="target" value="refresh">
      <input type="submit" value="RELOAD" />
    </form>

  </body>
</html>
