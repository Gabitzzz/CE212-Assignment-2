<%--
Removes item from basket (to be called with ajax)

Returns the new total price of items in basket.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page import="shop.Product" %>

<jsp:useBean id='basket'
             scope='session'
             class='shop.Basket'
/>

<%
    String itemPID = request.getParameter("itemPID");

    if (itemPID != null) {
        System.out.println(String.format("removeProduct.jsp - removing item (pid=%s)", itemPID));
        basket.removeItem(itemPID);
    } else {
        System.out.println("itemPID received in removeProduct.jsp was null.");
    }

    out.print(basket.getTotalString());
%>
