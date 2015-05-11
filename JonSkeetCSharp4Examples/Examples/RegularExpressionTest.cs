using System.Text.RegularExpressions;
using NUnit.Framework;
namespace Examples
{
    [TestFixture]
    public class RegularExpressionTest
    {
        //http://msdn.microsoft.com/en-us/library/az24scfc(v=vs.110).aspx
         
        private string _sampleLine;

        [SetUp]
        public void BeforeEachTest() 
        {
            _sampleLine = "WARNING 05/10/2011 13:15:15.000 ---FooBar--- The foo has been barred.";
        }

        [Test]
        public void Regex_Can_Have_Name()
        {
            var pattern = new Regex(@"(?<level>\S+) ");
            var match = pattern.Match(_sampleLine);

            Assert.That(match.Groups["level"].Value, Is.EqualTo("WARNING"));
        }

        [Test]
        public void First_Word_In_A_Line()
        {
            var pattern = new Regex(@"(?<level>\S+) ");
            var match = pattern.Match(_sampleLine);

            Assert.That(match.Groups["level"].Value, Is.EqualTo("WARNING"));
        }

        [Test]
        public void Time_Stamp()
        {
            var pattern = new Regex(@"(?<timestamp>\d{2}/\d{2}/\d{4} \d{2}:\d{2}:\d{2}\.\d{3}) ");
            var match = pattern.Match(_sampleLine);

            Assert.That(match.Groups["timestamp"].Value, Is.EqualTo("05/10/2011 13:15:15.000"));
        }

        [Test]
        public void Anything_But()
        {
            var pattern = new Regex(@"---(?<category>[^-]+)--- ");
            var match = pattern.Match(_sampleLine);

            Assert.That(match.Groups["category"].Value, Is.EqualTo("FooBar"));
        }

        [Test]
        public void Replace()
        {
            string line = "Hello, world!";
            var pattern = new Regex("[aeiou]");

            string noVowels = pattern.Replace(line, "?");

            Assert.That(noVowels, Is.EqualTo("H?ll?, w?rld!"));
        }
    }
}