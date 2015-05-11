using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;

namespace Examples
{
    [TestFixture]
    public class ListAndDictionaryExample
    {
        [Test]
        public void List_Has_Dynamic_Size()
        {
            var names = new List<string>();

            names.Add("fred");
            Assert.That(names.Count, Is.EqualTo(1));

            names.Add("betty");
            Assert.That(names.Count, Is.EqualTo(2));

            names.RemoveAt(0);
            Assert.That(names.Count, Is.EqualTo(1));
        }

        [Test]
        public void List_Can_Be_Defined_And_Initialised()
        {
            var numbers = new List<int>() {10, 20};

            Assert.That(numbers[1], Is.EqualTo(20));
        }

        [Test]
        public void Dictionary_Can_Be_Iterated()
        {
            var map = new Dictionary<string, int>();
            map.Add("foo", 10);
            map["bar"] = 20;

            foreach (var entry in map)
            {
                Console.WriteLine("{0}: {1}", entry.Key, entry.Value);
            }
        }

        [Test]
        public void Dictionary_Gets_Value_By_Key()
        {
            var map = new Dictionary<string, int>();
            map.Add("foo", 10);

            Assert.That(map["foo"], Is.EqualTo(10));
        }

        [Test]
        public void HashCode_Is_A_Numerical_Representation_Of_Variable_Length_String()
        {
            int code = "a".GetHashCode();

            Assert.That(code, Is.EqualTo(372029373));
        }

        [Test]
        public void Dictionarh_Can_Be_Initialised_On_Declaration()
        {
            var map = new Dictionary<string, int>
                          {
                              {"Andy", 1},
                              {"Sue", 2}
                          };

            Assert.That(map["Andy"], Is.EqualTo(1));
        }
    }
}
