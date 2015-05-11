using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Acme.Common;

namespace ACM.BL
{
    public class Product : EntityBase, ILoggable
    {
        public Product()
        {

        }
        public Product(int productId)
        {
            this.ProductId = productId;
        }

        public Decimal? CurrentPrice { get; set; }
        public int ProductId { get; private set; }
        public string ProductDescription { get; set; }
        private string _ProductName;

        public string ProductName
        {
            get
            {
                return _ProductName.InsertSpaces();
            }
            set { string _ProductName = value; }
        }




        //Valida los datos del producto
        public override bool Validate()
        {
            var isValid = true;
            if (string.IsNullOrWhiteSpace(ProductName)) isValid = false;
            if (CurrentPrice == null) isValid = false;

            return isValid;
        }


        public override string ToString()
        {
            return ProductName;
        }

        public string Log()
        {
            var logString = this.ProductId + ": " + this.ProductName + " " + "Detail: " + this.ProductDescription + " " + "Status: " +
                            this.EntityState.ToString();
            return logString;
        }


    }
}
