using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ACM.BL
{
    public class ProductRepository
    {

        //Recupera un producto
        public Product Retrieve(int productId)
        {
            //Crea la instancia de la clase Product
            Product product = new Product(productId);

            Object myObject = new Object();

            Console.WriteLine("Object: " + myObject.ToString());
            Console.WriteLine("Product: " + product.ToString());


            //Codigo que recupera el producto definido
            //Codigo temporal hardcodeado
            if (productId == 2)
            {
                product.ProductName = "Sunflowers";
                product.ProductDescription = "Flores de sol";
                product.CurrentPrice = 15.96M;
            }
            return product;
        }

        //Guardar el producto actual
        public bool Save(Product product)
        {
            var success = true;
            if (product.HasChanges && product.IsValid)
            {
                if (product.IsNew)
                {
                    //Llamar al procedimiento insertar
                }
                else
                {
                    //Llamar al procedimiento actualizar
                }
            }
            return success;
        }

    }
}