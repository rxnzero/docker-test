<%@ page import="
             org.springframework.web.context.*,
             org.springframework.web.context.support.*,
             com.eactive.eai.rms.common.spring.LocaleMessage" %>
<%
   ServletContext ctx = pageContext.getServletContext();
   WebApplicationContext wac = 
         WebApplicationContextUtils.getRequiredWebApplicationContext(ctx);
  	LocaleMessage localeMessage = (LocaleMessage) wac.getBean("localeMessage");
%>
