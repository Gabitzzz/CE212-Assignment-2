<jsp:useBean id='basket'
             scope='session'
             class='shop.Basket'
/>

<jsp:useBean id = 'db'
             scope='page'
             class='shop.ShopDB' />


<jsp:include page="header.jsp" />


<% String custName = request.getParameter("name");


    if (custName != null && !custName.isEmpty()) { %>

<h2> Dear <%= custName %> ! Thank you for your order</h2>

<% db.order(basket, custName); %>

<% } else { %>

<h2> Please go back and supply a name </h2>

<% } %>

