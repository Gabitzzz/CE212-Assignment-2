<%@ page import="shop.Product"%>
<%@ page import="java.util.Collection" %>

<jsp:useBean id='db'
             scope='session'
             class='shop.ShopDB' />


<jsp:include page="header.jsp" />

<div class="table_container">
    <table>
        <thead>
            <tr>
                <th>Title</th>
                <th>Price</th>
                <th>Thumbnail Image</th>
            </tr>
        </thead>
        <tbody id="products_table_body">

        <jsp:include page="products_table.jsp" />
        </tbody>
    </table>
</div>

<div id="filter_container">
    <input type="checkbox"
           class="largerCheckbox"
           onclick="toggleFilter(this)"
           id="filter"
           name="filter"
           value="filter">
    <label for="filter">
        Filter
    </label>

    <br>

    <div id="filter_input_container" style="display:none;">
        <label for="filter_select">
            Filter by:
        </label>
        <select id="filter_select">
            <option value="artist">
                Artist
            </option>
            <option value="price_range">
                Price range (pounds)
            </option>
        </select>

        <label for="filter_input">
            Input:
        </label>
        <input type="text"
               id="filter_input"
               name="filter_input"
               placeholder="e.g. Simon">
<%--        <br>--%>
        <input type="button"
               id="button_filter"
               name="button_filter"
               value="Apply filter">

        <br>
    </div>
</div>

<script>
    function toggleFilter(checkbox) {
        if (checkbox.checked) {
            $('#filter_input_container').fadeIn(300);
        } else {
            $('#filter_input_container').fadeOut(300);
            location.reload();
        }
    }

    $('#filter_select').on('change', function() {
        $('#filter_input').val('');
        var filter_by = $('#filter_select option:selected').val();
        var placeholder = '';
        if (filter_by == 'artist')
            placeholder = 'e.g. Simon';
        else if
            (filter_by == 'price_range') placeholder = 'Min-Max';

        $('#filter_input').attr('placeholder',  placeholder);
    });


    $('#button_filter').click( function() {
        var filter_by = $('#filter_select option:selected').val();
        var filter_input = $('#filter_input').val();
        console.log(filter_by);
        console.log(filter_input);

        $.get('products_table.jsp',
            {
                'filter_by'     : filter_by,
                'filter_input'  : filter_input
            },
            function(data) {
                $('#products_table_body').fadeOut(200,function() {
                    $('#products_table_body').html(data);

                    $('#products_table_body').fadeIn(200);
                });
            }
        );
    });

</script>
