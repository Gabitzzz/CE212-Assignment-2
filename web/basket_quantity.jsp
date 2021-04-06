<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page import="shop.Product" %>
<jsp:useBean id='basket'
             scope='session'
             class='shop.Basket'
/>

<%
    String itemPID = request.getParameter("itemPID");
    int quantity = 1;
    String quant = "";
    if (itemPID != null) {
        quant = request.getParameter("quantity");
        if (quant != null) {
            quantity = Integer.parseInt(quant);
        } else {
            System.out.println("basket_quantity.jsp - quantity param was null.");
        }

        basket.updateItem(itemPID, quantity);
        System.out.println(String.format("basket_quantity.jsp - Item (pid=%s) quantity should be updated to %d", itemPID, quantity));
    } else {
        System.out.println("basket_quantity.jsp - itemPID param was null.");
    }

    out.print(basket.getTotalString());
%>