using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;

namespace Examples
{
    [TestFixture]
    public class AnonymousTypesExample
    {
        [Test]
        public void Anonymous_Type_Is_Statically_Typed()
        {
            var person = new {FirstName = "Jon", LastName = "Skeet"};

            string name = person.FirstName;
            //int number = person.FirstName; Doesn't compile

            Assert.That(name, Is.EqualTo("Jon"));
        }

        [Test]
        public void Anonymous_Types_ToString_Is_Overriden_Conveniently()
        {
            var person = new { FirstName = "Jon", LastName = "Skeet" };

            Assert.That(person.ToString(), Is.EqualTo("{ FirstName = Jon, LastName = Skeet }"));
        }

        [Test]
        public void Two_Anonymous_Types_With_The_Same_Structure_Are_Different_As_They_Have_Clever_Equality_Operation()
        {
            var person1 = new {FirstName = "Jon", LastName = "Skeet"};
            var person2 = new {FirstName = "Dave", LastName = "Skeet"};

            Assert.That(person1, Is.Not.EqualTo(person2));
            Assert.That(person1.GetHashCode(), Is.Not.EqualTo(person2.GetHashCode()));
        }

        [Test]
        public void Type_Inference_Can_Handle_Anonymous_Types()
        {
            var person = new { FirstName = "Dave", LastName = "Skeet" };
            DoSomething(person);
        }

        private void DoSomething<T>(T value)
        {
            Console.WriteLine(typeof(T));
        }
    }
}
 