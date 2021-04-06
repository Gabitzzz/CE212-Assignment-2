
<%@ page import="shop.Product" %>
<%@ page import="java.util.Collection" %>
<jsp:useBean  id='db'
              scope='session'
              class='shop.ShopDB' />
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String filter_by = request.getParameter("filter_by");
    String filter_input = request.getParameter("filter_input");

    Collection<Product> products = null;
    if (filter_by == null || filter_input == null)
        products = db.getAllProducts();
    else
        products = db.getFilteredProducts(filter_by, filter_input);

    for (Product prd : products) {
%>
<tr>
    <td> <%= prd.title %> </td>
    <td> <%= prd.getFormattedPrice() %> </td>
    <td> <a href = '<%="product_page.jsp?pid="+prd.PID%>'> <img src="<%= prd.thumbnail %>" width="50" /> </a> </td>
</tr>
<% } %>