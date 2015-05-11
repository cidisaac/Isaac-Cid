using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;

namespace Examples
{
    [TestFixture]
    public class CollectionsExample
    {
        [Test]
        public void Generic_Type_Can_Handle_Multiple_Types()
        {
            var fred = new Fred<string>("Hello");
            Assert.That(fred.Foo(), Is.EqualTo("Hello"));

            var fred2 = new Fred<int>(100);
            Assert.That(fred2.Foo(), Is.EqualTo(100));

        }


    }

    public class Fred<T>
    {
        private T _greeting;

        public Fred(T greeting)
        {
            _greeting = greeting;
        }

        public T Foo()
        {
            return _greeting;
        }
    }
}
