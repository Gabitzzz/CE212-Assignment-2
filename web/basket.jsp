<%@ page import="java.util.Collection,
                 java.util.Iterator,
                 java.util.Map,
                 shop.Product" %>

<jsp:useBean id='basket'
             scope='session'
             class='shop.Basket'
            />

<%
    String empty = request.getParameter("emptyBasket");
    if (empty!=null) {
        basket.clearBasket();
    }
    String item = request.getParameter("addItem");
    int quantity = 1;
    if (item != null) {
        String quant = request.getParameter("quantity");
        if (quant != null)
            quantity = Integer.parseInt(quant);

        basket.addItem(item, quantity);
        System.out.println(String.format("item should be added to basket", item, quantity));
    }
%>


<jsp:include page="header.jsp" />
<div class="table_container">
    <table id="basket_table">
        <thead>
            <tr>
                <th>Name</th>
                <th>Price</th>
                <th>Quantity</th>
                <th><!-- remove button --></th>
            </tr>
        </thead>
        <% for (Map.Entry<Product, Integer> entry : basket.getItems().entrySet()) {
            Product prod;
            prod = entry.getKey();
            int quantity_ = entry.getValue(); %>

        <tr>
            <td>
                <img src="<%= prod.thumbnail %>"
                     style="margin-right: 10px; width: 50px;" /> <%= prod.title %>
            </td>
            <td>
                <%= prod.getFormattedPrice() %>
            </td>
            <td>
                <input class="quantity_input"
                        id="quantity_input_<%= prod.PID %>"
                        type="number"
                        min="1"
                        max="100"
                        step="1"
                        value="<%= quantity_%>"
                        onchange="updateQuantity('<%= prod.PID %>');">
            </td>
            <td class="remove"
                data-pid="<%= prod.PID %>">
                X
            </td>
        </tr>
        <% } %>
    </table>
</div>



<% if ( basket.getTotal() > 0) { %>
<div id="order_forms">
    <div id="total_container">
        Order total = <span id="total"><%= basket.getTotalString() %></span>
    </div>

    <form action="order.jsp"
          method="post">
        <input type="text"
               name="name"
               size="30"
               placeholder="Please write your name here">
        <input type="submit"
               value="Place Your Order"
        />
    </form>

    <form action="basket.jsp"
          method="get">
        <input type="hidden"
               name="emptyBasket"
               value="yes">
        <input type="submit"
               value="Empty Basket" />
    </form>
</div>
<% } %>

<script>

    function updateQuantity(itemPID) {
        var value = $('#quantity_input_' + itemPID).val();
        $.post('updateBasketItemQuantity.jsp',
            {
                itemPID : itemPID,
                quantity : value
            },
            function (data) {
                $('#total').html(data.trim());
            }
        );
    }

    $(".remove").on("click", function(){
        var row = $(this).parent("tr:first");
        $.post('removeProduct.jsp',
            {
                itemPID : $(this).attr('data-pid')
            },
            function (data) {
                data = data.trim();
                console.log("response received after removing" + data);
                row.fadeIn(300, function() {
                    this.remove();

                    $('#total').html(data);

                    var item_count = parseInt($('#basket_item_count').html()) - 1;
                    if (item_count == 0) {
                        removeNumberOfItemsFromViewBasketButton();
                    } else {
                        $('#basket_item_count').html(item_count.toString());
                    }
                });
            }
        );
    });

    function removeNumberOfItemsFromViewBasketButton() {
        $('.fa-shopping-basket').get(0).nextSibling.remove();
        $('.fa-shopping-basket').get(0).nextSibling.remove();
        $('.fa-shopping-basket').get(0).nextSibling.remove();
        $('.fa-shopping-basket').after('View Basket');
    }

    $(function(){
        const orig_url = window.location.href;
        const params_removed_url = window.location.href.replace(window.location.search, '');
        if (orig_url !== params_removed_url)
            window.location.href = params_removed_url;
    });

</script>


