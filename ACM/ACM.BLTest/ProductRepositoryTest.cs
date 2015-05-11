using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using ACM.BL;

namespace ACM.BLTest
{
    [TestClass]
    public class ProductRepositoryTest
    {
        [TestMethod]
        public void RetrieveTest()
        {
            //Arrange
            Product product = new Product();
            Object myObject = new Object();
            var expected = product.ToString();

            //Act
            var actual = product.ToString();

            //Assert
            Assert.AreEqual(expected, actual);
        }

    }
}
