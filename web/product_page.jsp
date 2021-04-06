<%@ page import="shop.Product"%>

<jsp:useBean id='db'
             scope='session'
             class='shop.ShopDB' />


<jsp:include page="header.jsp" />

<%  String pid = request.getParameter("pid");
    Product product = db.getProduct(pid);
    if (product == null) {
        out.println( "The product with this PID does not exist in the database.");
    } else {  %>

<div align="center">
    <h2> <%= product.title %> (<%= product.getFormattedPrice() %>) by <%= product.artist %> </h2>
    <img src="<%= product.fullimage %>" width="400" />
    <p> <%= product.description %> </p>
    <a href="basket.jsp?addItem=<%= product.PID %>" class="basket_button">Add to basket</a>
</div>

<%  }  %>

