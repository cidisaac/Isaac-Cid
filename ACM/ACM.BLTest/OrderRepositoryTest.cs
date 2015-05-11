using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using ACM.BL;
using System.Collections.Generic;

namespace ACM.BLTest
{
    [TestClass]
    public class OrderRepositoryTest
    {
        [TestMethod()]
        public void RetrieveOrderDisplayTest()
        {
            //Arrange
            var orderRepository = new OrderRepository();
            var expected = new OrderDisplay()
            {
                FirstName = "Bilbo",
                LastName = "Baggins",
                OrderDate = new DateTimeOffset(2014, 4, 14, 10, 00, 00, new TimeSpan(7, 0, 0)),
                ShippignAddress = new Address()
                {
                    AddressType = 1,
                    StreetLine1 = "Bag End",
                    StreetLine2 = "Bagshot row",
                    City = "Hobbiton",
                    State = "Shire",
                    Country = "Middle Earth",
                    PostalCode = "144"
                },
                orderDisplayItemList = new List<OrderDisplayItem>()
                {
                    new OrderDisplayItem()
                    {
                        ProductName = "Sunflowers",
                        PurchasePrice = 15.96M,
                        OrderQuantity = 2
                    },
                    new OrderDisplayItem()
                    {
                        ProductName = "Rake",
                        PurchasePrice = 6M,
                        OrderQuantity = 1
                    }
                }
            };

            //Act
            var actual = orderRepository.RetrieveOrderDisplay(10);

            //Assert
            Assert.AreEqual(expected.FirstName, actual.FirstName);
            Assert.AreEqual(expected.LastName, actual.LastName);
            Assert.AreEqual(expected.OrderDate, actual.OrderDate);

            Assert.AreEqual(expected.ShippignAddress.AddressType, actual.ShippignAddress.AddressType);
            Assert.AreEqual(expected.ShippignAddress.StreetLine1, actual.ShippignAddress.StreetLine1);
            Assert.AreEqual(expected.ShippignAddress.City, actual.ShippignAddress.City);
            Assert.AreEqual(expected.ShippignAddress.State, actual.ShippignAddress.State);
            Assert.AreEqual(expected.ShippignAddress.Country, actual.ShippignAddress.Country);
            Assert.AreEqual(expected.ShippignAddress.PostalCode, actual.ShippignAddress.PostalCode);

            for (int i = 0; i < 1; i++)
            {
                Assert.AreEqual(expected.orderDisplayItemList[i].OrderQuantity, actual.orderDisplayItemList[i].OrderQuantity);
                Assert.AreEqual(expected.orderDisplayItemList[i].ProductName, actual.orderDisplayItemList[i].ProductName);
                Assert.AreEqual(expected.orderDisplayItemList[i].PurchasePrice, actual.orderDisplayItemList[i].PurchasePrice);
            }
        }
    }
}
