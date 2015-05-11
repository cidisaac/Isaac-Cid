using System;
using System.Collections.Generic;
using System.Linq;
using NUnit.Framework;
using System.Text.RegularExpressions;
using System.Linq.Expressions;
using System.IO;

namespace Examples
{
    [TestFixture]
    public class LinqExamples
    {
        private List<string> _names;
        private Regex _pattern;

        [SetUp]
        public void BeforeEachTest()
        {
            _names = new List<string> { "Rob, Friend", "Holly, Family", "This isn't a name", "Malcolm, Colleague", "Tom, Family" };
            _pattern = new Regex("([^,]*), (.*)");
        }

        [Test]
        public void Linq_With_Introduced_Variable()
        {
            var query = from line in _names
                        let match = _pattern.Match(line)
                        where match.Success
                        select new
                                   {
                                       Name = match.Groups[1].Value,
                                       Relationship = match.Groups[2].Value
                                   }
                        into association
                        group association.Name by association.Relationship;

            foreach (var group in query)
            {
                Console.WriteLine("Relationship: {0}", group.Key);
                foreach (var name in group)
                {
                    Console.WriteLine("  {0}", name);
                }
            }

        }

        [Test]
        public void Join()
        {
            var lengths = new List<int> {15, 10, 13, 14};
            var query = from line in _names
                        join length in lengths on line.Length equals length
                        where line.StartsWith("T")
                        select new
                                   {
                                       Name = line.ToUpper(),
                                       DoubleLength = length * 2
                                   };

            foreach (var value in query)
            {
                Console.WriteLine(value);
            }
        }

        [Test]
        public void Linq_With_Introduced_Variable_Method_Chaining()
        {
            var query = _names.Select(line => new {line, match = _pattern.Match(line)})
                              .Where (z => z.match.Success)
                              .Select(z => new
                                                 {
                                                     Name = z.match.Groups[1].Value,
                                                     Relationship = z.match.Groups[2].Value
                                                 })
                              .GroupBy( association => association.Relationship, 
                                        association => association.Name);

            foreach (var group in query)
            {
                Console.WriteLine("Relationship: {0}", group.Key);
                foreach (var name in group)
                {
                    Console.WriteLine("  {0}", name);
                }
            }
        }

        [Test]
        public void LookUp()
        {
            var firstLetters = _names.ToLookup(name => name[0]);

            foreach (var letter in firstLetters)
            {
                Console.WriteLine(letter.Key);
            }
            
        }

        [Test]
        public void Expression_Code_As_Data()
        {
            Func<string, bool> lengthFilter = text => text.Length < 10;
            Expression<Func<string, bool>> lengthFilter2 = text => text.Length < 10;

            Console.WriteLine(lengthFilter);
            Console.WriteLine(lengthFilter2);
        }

        [Test]
        public void Handle_Files_With_Linq()
        {
            var lines = from file in Directory.GetFiles("*.log")
                        from line in File.ReadAllLines(file)
                        where line.Contains("ERROR")
                        select line.Substring(10);
        }
    }
}
