using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using NUnit.Framework;
using System.Net;

namespace Examples
{
    [TestFixture]
    public class ExtensionMethodExamples
    {
        [Test]
        public void Reverse_String()
        {
            Assert.That("Hello".Reverse(), Is.EqualTo("olleH"));
        }

        [Test]
        public void Read_Fully()
        {
            var request = WebRequest.Create("http://www.google.com");
            using (var response = request.GetResponse())
            {
                using (var responseStream = response.GetResponseStream())
                {
                    byte[] data = responseStream.ReadFully();
                    Console.WriteLine(data.Length);
                }
            }
        }

        [Test]
        public void Linq_With_Custom_Extension_Method()
        {
            IEnumerable<string> names = new[] {"Holly", "Rob", "Jon", "Tom", "William"};

            var query1 = names.CWhere(x => !x.EndsWith("m")).CSelect(x => new { UpperName = x.ToUpper(), NameLength = x.Length });
            foreach (var result in query1) { Console.WriteLine(result); }

            var query2 = from x in names
                         where !x.EndsWith("m")
                         select new {UpperName = x.ToUpper(), NameLength = x.Length};
            foreach (var result in query2) { Console.WriteLine(result); }

        }

        [Test]
        public void DSL_Readable_DateTime_With_Extension_Method()
        {  
            var birthday = 19.June(1976);

            Assert.That(birthday, Is.EqualTo(new DateTime(1976, 6, 19)));
        }
    }

    

    public static class MasteringEnumerable
    {
        public static DateTime June(this int day, int year)
        {
            return new DateTime(year, 6, day);
        }


        public static IEnumerable<TResult> CSelect<TSource, TResult>(this IEnumerable<TSource> source, Func<TSource, TResult> selector)
        {
            foreach (TSource item in source)
            {
                yield return selector(item);
            }
        }

        public static IEnumerable<TSource> CWhere<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate)
        {
            foreach (TSource item in source)
            {
                if (predicate(item)) 
                {
                    yield return item;
                }
            }
        }
    }

    public static class Extensions
    {
        public static string Reverse(this string input)
        {
            char[] chars = input.ToCharArray();
            Array.Reverse(chars);

            return new string(chars);
        }

        public static byte[] ReadFully(this Stream input)
        {
            var output = new MemoryStream();
            var buffer = new byte[8192];
            int bytesRead;

            while ((bytesRead = input.Read(buffer, 0, buffer.Length)) > 0)
            {
                output.Write(buffer, 0, bytesRead);
            }
            return output.ToArray();
        }
    }
}
