package shop;

import java.util.*;

public class Basket {

    Map<Product, Integer> items;
    ShopDB db;

    public static void main(String[] args) {
        Basket bas = new Basket();

        bas.addItem("art1");
        System.out.println( bas.getTotalString() );
        System.out.println( bas.getTotalString() );
        String pid = null;
        bas.addItem( pid );
        System.out.println( bas.getTotalString() );
    }

    public Basket() {
        db = ShopDB.getSingleton();

        items = new HashMap<Product, Integer>();
    }

    /**
     *
     * @return Collection of Product items that are stored in the basket
     *
     * Each item is a product object - need to be clear about that...
     *
     * When we come to list the Basket contents, it will be much more
     * convenient to have all the product details as items in this way
     * in order to calculate that product totals etc.
     *
     */
    public Map<Product, Integer> getItems() {
        return items;
    }

    /**
     * empty the basket - the basket should contain no items after calling this method
     */
    public void clearBasket() {
        items.clear();
    }

    /**
     *
     *  Adds an item specified by its product code to the shopping basket
     *
     * @param pid - the product code
     */

    public void addItem(String pid) {
        addItem(pid, 1);
    }

    public void addItem(Product p) {
        addItem(p, 1);
    }

    public void addItem(String pid, int quantity)
    {
        addItem( db.getProduct( pid ),
                quantity );
    }

    /*  It loops over the items map, searching for an object with the same pid.
        If such object is found then supplied quantity is added to the previous quantity.
        If such object is not found then it's added to the items map with supplied quantity.  */
    public void addItem(Product p, int quantity) {
        if (p != null ) {

            boolean found = false;
            for (HashMap.Entry<Product, Integer> entry : items.entrySet()) {
                Product prod = entry.getKey();

                if (prod.PID.equals(p.PID)) {
                    int prev_q = items.get(prod);
                    items.put(prod, prev_q + quantity);
                    found = true;
                    break;
                }
            }
            if (!found)
                items.put(p, quantity);
        }
    }

    public void updateItem(String pid, int quantity) {
        updateItem( db.getProduct( pid ), quantity );
    }

    public void updateItem(Product p, int quantity) {
        if (p != null ) {
            boolean found = false;
            for (HashMap.Entry<Product, Integer> entry : items.entrySet()) {
                Product prod = entry.getKey();
                if (prod.PID.equals(p.PID)) {
                    items.put(prod, quantity);
                    found = true;
                    break;
                }
            }
            if (!found)
                items.put(p, quantity);
        }
    }

    public void removeItem(String pid) {
        for (HashMap.Entry<Product, Integer> entry : items.entrySet()) {
            Product prd = entry.getKey();
            if (prd.PID.equals(pid)) {
                items.remove(prd);
                return;
            }
        }

        System.out.println("WARNING: " + pid + " itemPID was not found in the items map...");
    }



    /**
     *
     * @return the total value of items in the basket in pence
     */
    public int getTotal() {
        int total = 0;
        for (Map.Entry<Product, Integer> entry : items.entrySet()) {
            var prd = entry.getKey();
            int quantity = entry.getValue();
            total +=  prd.price * quantity;
        }
        return total;
    }

    /**
     *
     * @return the total value of items in the basket as
     * a pounds and pence String with two decimal places - hence
     * suitable for inclusion as a total in a web page
     */
    public String getTotalString() {
        int pence = getTotal();
        return String.format("£%d.%02d", pence / 100, pence % 100);
    }

    public int getItemCount() {
        return items.size();
    }
}
