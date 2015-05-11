using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Acme.Common;

namespace ACM.BL
{
    public class Order : EntityBase, ILoggable
    {
        public Order()
        {

        }
        public Order(int OrderId)
        {
            this.OrderId = OrderId;
        }

        public int CustomerId { get; set; }
        public int ShippingAddressId { get; set; }

        public DateTimeOffset? OrderDate { get; set; }
        public int OrderId { get; private set; }

        public List<OrderItem> orderItem { get; set; }

        //Valida los datos de la orden
        public override bool Validate()
        {
            var isValid = true;
            if (OrderDate == null) isValid = false;

            return isValid;
        }

        public override string ToString()
        {
            return OrderDate.Value.Date + " (" + OrderId + ")";
        }

        public string Log()
        {
            var logString = this.OrderId + ": " + "Date: " + this.OrderDate.Value.Date + " " + "Status: " +
                            this.EntityState.ToString();
            return logString;
        }
    }
}
