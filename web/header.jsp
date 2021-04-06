<%--  Header and footer files were created to avoid repeating code/html in other files.  --%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id='basket'
             scope='session'
             class='shop.Basket'
/>

<html>
<head>
    <title>My Shop</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <link rel="stylesheet" href="css/style_1903165.css">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body>
<section id="header">


        <a href="products.jsp"><i class="fa fa-list"></i> Products </a>

    <a href="basket.jsp"><i class="fa fa-shopping-cart"></i>
        <%
            int item_count = basket.getItemCount();
            if (item_count > 0) {
        %>

        (<span id="basket_item_count"><%=item_count%></span>)

        <% } %>

        Basket</a>




</section>


