using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ACM.BL
{
    public class OrderRepository
    {

        //Recupera una orden
        public Order Retrieve(int orderId)
        {
            //Crea la instancia de la clase Order
            Order order = new Order(orderId);

            //Codigo que recupera el producto definido
            //Codigo temporal hardcodeado
            if (orderId == 10)
            {
                order.OrderDate = new DateTimeOffset(2014, 02, 06, 04, 35, 21, new TimeSpan(1, 0, 0));
            }
            return order;
        }

        //Guarda la orden actual
        public bool Save()
        {
            return true;
        }

        public OrderDisplay RetrieveOrderDisplay(int orderId)
        {
            OrderDisplay orderDisplay = new OrderDisplay();

            //Codigo que recupera los campos de la orden definida

            //Codigo temporal hardcodeado
            if (orderId == 10)
            {
                orderDisplay.FirstName = "Bilbo";
                orderDisplay.LastName = "Baggins";
                orderDisplay.OrderDate = new DateTimeOffset(2014, 4, 14, 10, 00, 00, new TimeSpan(7, 0, 0));
                orderDisplay.ShippignAddress = new Address()
                {
                    AddressType = 1,
                    StreetLine1 = "Bag End",
                    StreetLine2 = "Bagshot row",
                    City = "Hobbiton",
                    State = "Shire",
                    Country = "Middle Earth",
                    PostalCode = "144"
                };
            }
            orderDisplay.orderDisplayItemList = new List<OrderDisplayItem>();

            //Codigo que recupera la order item

            //Codigo temporal hardcodeado
            if (orderId == 10)
            {
                var orderDisplayItem = new OrderDisplayItem()
                {
                    ProductName = "Sunflowers",
                    PurchasePrice = 15.96M,
                    OrderQuantity = 2
                };
                orderDisplay.orderDisplayItemList.Add(orderDisplayItem);

                orderDisplayItem = new OrderDisplayItem()
                {
                    ProductName = "Rake",
                    PurchasePrice = 6M,
                    OrderQuantity = 1
                };
                orderDisplay.orderDisplayItemList.Add(orderDisplayItem);
            }

            return orderDisplay;
        }
    }
}
