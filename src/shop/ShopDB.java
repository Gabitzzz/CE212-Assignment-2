
package shop;

import com.sun.org.apache.xerces.internal.xs.StringList;

import java.sql.*;
import java.util.*;

public class ShopDB {

    Connection con;
    static int nOrders = 0;
    static ShopDB singleton;


    public ShopDB() {
        try {
            Class.forName("org.hsqldb.jdbc.JDBCDriver");
            System.out.println("loaded class");
//            con = DriverManager.getConnection("jdbc:hsqldb:file:\\xampp\\tomcat\\webapps\\ass2\\database/shopdb", "sa", "");
            con = DriverManager.getConnection("jdbc:hsqldb:file:\\tomcat\\webapps\\ass2\\shopdb", "sa", "");
            System.out.println("created con");
        } catch (Exception e) {
            System.out.println("Exception: " + e);
        }
    }

    public static ShopDB getSingleton() {
        if (singleton == null) {
            singleton = new ShopDB();
        }
        return singleton;
    }

    public ResultSet getProducts() {
        try {
            Statement s = con.createStatement();
            System.out.println("Created statement");
            ResultSet rs = s.executeQuery("Select * from Product");
            System.out.println("Returning result set...");
            return rs;
        }
        catch(Exception e) {
            System.out.println( "Exception in getProducts(): " + e );
            return null;
        }
    }

    public Collection<Product> getAllProducts() {
        try { return getProductCollection("Select * from Product"); }
        catch (Exception e) { System.out.println( "Exception in getFilteredProducts(String filter_by, String filter_input): " + e ); }
        return null;
    }

    public Product getProduct(String pid) {
        try {
            // re-use the getProductCollection method
            // even though we only expect to get a single Product Object
            String query = "Select * from Product where PID = '" + pid + "'";
            Collection<Product> c = getProductCollection( query );
            Iterator<Product> i = c.iterator();
            return i.next();
        }
        catch(Exception e) {
            // unable to find the product matching that pid
            return null;
        }
    }

    public Collection<Product> getFilteredProducts(String filter_by, String filter_input) {
        filter_input = filter_input.toLowerCase();
        PreparedStatement state = null;
        try {
            if (filter_by.equals("artist")) {
                state = con.prepareStatement("SELECT * FROM PRODUCT WHERE LOWER(artist) = ?");
                state.setString(1, filter_input);
            } else if (filter_by.equals("price_range")) {
                String[] range = filter_input.split("-");
                int lower = Integer.parseInt(range[0]) * 100;
                int upper = Integer.parseInt(range[1]) * 100;
                state = con.prepareStatement("SELECT * FROM PRODUCT WHERE price >= ? AND price <= ?");
                state.setInt(1, lower);
                state.setInt(2, upper);
            } else {
                return null;
            }

            return getProductCollection( state );
        }
        catch (Exception e) {
            return null;
        }
    }


    public Collection<Product> getProductCollection(String query) throws SQLException {
        return getProductCollection( con.prepareStatement(query) );
    }

    public Collection<Product> getProductCollection(PreparedStatement stmt) throws SQLException {
        LinkedList<Product> list = new LinkedList<Product>();
        ResultSet res = stmt.executeQuery();
        while ( res.next() ) {
            Product product = new Product(
                    res.getString("PID"),
                    res.getString("Artist"),
                    res.getString("Title"),
                    res.getString("Description"),
                    res.getInt("price"),
                    res.getString("thumbnail"),
                    res.getString("fullimage")
            );
            list.add( product );
        }
        return list;
    }


    public void order(Basket basket , String customer) {
        String orderId = "";
        try {
            // create a unique order id
            orderId = System.currentTimeMillis() + ":" + nOrders++;
            for (Map.Entry<Product, Integer> entry : basket.getItems().entrySet()) {
                Product product = entry.getKey();
                int quantity = entry.getValue();
                order( con, product, orderId, customer, quantity );
            }

            basket.clearBasket();
        }
        catch(Exception e) {
            System.out.println("Your order could not be completed.");
            e.printStackTrace();

            if (!orderId.isEmpty()) {
                try {
                    Statement state = con.createStatement();
                    ResultSet result = state.executeQuery("DELETE FROM ORDERS WHERE ORDERID=" + orderId);
                } catch (Exception e2) {
                    e2.printStackTrace();
                }
            }
        }
    }

    private void order(Connection con, Product p, String orderId, String customer, int quantity) throws Exception {
        String name = customer;

        PreparedStatement statement = con.prepareStatement("INSERT INTO ORDERS (PID, ORDERID, NAME, QUANTITY, PRICE) VALUES(?,?,?,?,?)");
        statement.setString(1, p.PID);
        statement.setString(2, orderId);
        statement.setString(3, name);
        statement.setDouble(4, quantity);
        statement.setDouble(5, p.price);
        statement.execute();
    }


}
