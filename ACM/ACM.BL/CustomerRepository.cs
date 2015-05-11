using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ACM.BL
{
    public class CustomerRepository
    {
        private AddressRepository addressRepository { get; set; }

        public CustomerRepository()
        {
            addressRepository = new AddressRepository();
        }


        //Recupera el cliente actual
        public Customer Retrieve(int customerId)
        {
            //Crea la instancia de la clase Customer
            Customer customer = new Customer(customerId);
            customer.AddressList = addressRepository.RetrieveByCustomerId(customerId).ToList();

            //Codigo que recupera el cliente definido
            //Codigo temporal hardcodeado
            if (customerId == 1)
            {
                customer.EmailAddress = "fbaggins@hobbiton.me";
                customer.FirstName = "Frodo";
                customer.LastName = "Baggins";
            }
            return customer;
        }

        //Recupera todos los clientes
        public List<Customer> Retrieve()
        {
            return new List<Customer>();
        }
        //Guarda el cliente actual
        public bool Save()
        {
            return true;
        }
    }
}