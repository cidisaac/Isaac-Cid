using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Linq;
using System.Reflection;
using System.Text;
using NUnit.Framework;

namespace Examples
{
    [TestFixture]
    public class DynamicExamples
    {
        [Test]
        public void Dynamic_Is_A_Contextual_Keyword()
        {
            dynamic text = "hello";
            int length = text.Length;
//            PropertyInfo property = text.GetType().GetProperty("Length");
//            int length = (int) property.GetValue(text, null);

            Assert.That(CallMe(text), Is.EqualTo(2));
            Assert.That(length, Is.EqualTo(5));
        }

        public int CallMe(object x) { return 1; }
        public int CallMe(string x) { return 2; }

        [Test]
        public void Dynamic_With_Generic_Method()
        {
            dynamic ints = new List<int>();
            Type result = CallType(ints);
            
            Assert.That(typeof(int), Is.EqualTo(result));
        }

        private Type CallType<T>(IEnumerable<T> sequence)
        {
            return typeof (T);
        }

        [Test]
        public void Expando_Is_Another_Way_To_See_An_Object()
        {
            dynamic expando = new ExpandoObject();
            IDictionary<string, object> dictionary = expando;

            dictionary["Name"] = "Jon";
            Assert.That(expando.Name, Is.EqualTo("Jon"));

            expando.Age = 35;
            Assert.That(dictionary["Age"], Is.EqualTo(35));

            dictionary["Greeting"] = (Action) (() => Console.WriteLine("Hello"));
            expando.Greeting();

            dictionary["DoubleMe"] = (Func<int, int>) (x => x*2);
            Assert.That(expando.DoubleMe(10), Is.EqualTo(20));
        }

        public dynamic GetProperties()
        {
            var properties = new Dictionary<string, object>
                                 {
                                     {"Name", "Jon"},
                                     {"Age", 35},
                                     {"Town", "Reading"},
                                     {"TimeZone", "Europe/London"}
                                 };

            IDictionary<string, object> expando = new ExpandoObject();
            foreach (var pair in properties)
            {
                expando[pair.Key] = pair.Value;
            }

            return expando;
        }

        [Test]
        public void Expando_Makes_Code_Very_Neat_Without_Casting()
        {
            dynamic properties = GetProperties();

            string name = properties.Name;
            int age = properties.Age;

            Assert.That(name, Is.EqualTo("Jon"));
            Assert.That(age, Is.EqualTo(35));
        }

        [Test]
        public void Dynamic_Sql_Find()
        {
            dynamic sql = new DynamicSql();
            dynamic results = sql.Books(author: "Jon Skeet", year: 2010);

            foreach (var result in results)
            {
                Console.WriteLine(result);
            }
        }
    }

    public class DynamicSql : DynamicObject
    {
        public override bool TryInvokeMember(InvokeMemberBinder binder, object[] args, out object result)
        {
            var callInfo = binder.CallInfo;
            var builder = new StringBuilder("SELECT * FROM " + binder.Name + " WHERE ");
            for (int i = 0; i < callInfo.ArgumentCount; i++)
            {
                if (i != 0)
                    builder.Append(" AND ");
                builder.AppendFormat("{0} = @{0}", callInfo.ArgumentNames[i]);
            }

            Console.WriteLine("Would execute SQL: {0}", builder);
            for (int i = 0; i < callInfo.ArgumentCount; i++)
            {
                Console.WriteLine("Would set parameter {0} to {1}", callInfo.ArgumentNames[i], args[i]);
            }

            result = new[] { new { Title = "C# in depths" } };

            return true;
        }
    }
}
