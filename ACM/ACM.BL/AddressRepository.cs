using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ACM.BL
{
    class AddressRepository
    {
        //Devuelve una direccion

        public Address Retrieve(int addressId)
        {
            //Crea una instancia de la clase address
            Address address = new Address(addressId);

            //Codigo que devuelve la direccion definida

            //Codigo temporal hardcodeado que devuelve una direccion
            if (addressId == 1)
            {
                address.StreetLine1 = "Bag End";
                address.StreetLine2 = "Bagshot row";
                address.City = "Hobbiton";
                address.State = "Shire";
                address.Country = "Middle Earth";
                address.PostalCode = "144";
            }
            return address;
        }

        public IEnumerable<Address> RetrieveByCustomerId(int customerId)
        {
            //Codigo que recupera la direccion definida para un cliente

            //Codigo temporal hardcodeado que setea la direccion para un cliente

            var addressList = new List<Address>();
            Address address = new Address(1)
            {
                AddressType = 1,
                StreetLine1 = "Bag End",
                StreetLine2 = "Bagshot row",
                City = "Hobbiton",
                State = "Shire",
                Country = "Middle Earth",
                PostalCode = "144"
            };
            addressList.Add(address);

            address = new Address(2)
            {
                AddressType = 2,
                StreetLine1 = "Green Dragon",
                City = "Bywater",
                State = "Shire",
                Country = "Middle Earth",
                PostalCode = "146"
            };
            addressList.Add(address);

            return addressList;
        }

        public bool Save(Address address)
        {
            //Codigo que guarda la direccion definida

            return true;
        }
    }
}