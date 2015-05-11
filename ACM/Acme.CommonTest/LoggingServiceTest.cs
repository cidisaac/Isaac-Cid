using System;
using System.Text;
using System.Collections.Generic;
using ACM.BL;
using Acme.Common;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Acme.CommonTest
{
    /// <summary>
    /// Summary description for LoggingServiceTest
    /// </summary>
    [TestClass]
    public class LoggingServiceTest
    {

        [TestMethod]
        public void WriteFileTest()
        {
            //Arrange
            var changedItems = new List<ILoggable>();

            var customer = new Customer(1)
            {
                EmailAddress = "fbaggins@hobbiton.me",
                FirstName = "Frodo",
                LastName = "Baggins",
                AddressList = null
            };
            changedItems.Add(customer as ILoggable);

            var product = new Product(2)
            {
                ProductName = "Rake",
                ProductDescription = "Garden Rake with Steel Head",
                CurrentPrice = 6M
            };
            changedItems.Add(product as ILoggable);


            //Act
            LoggingService.WriteToFile(changedItems);

            //Assert
            //Nothing to assert
        }
    }
}
