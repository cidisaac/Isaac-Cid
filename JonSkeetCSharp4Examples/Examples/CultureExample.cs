using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using System.Globalization;
using System.Threading;

namespace Examples
{
    [TestFixture]
    public class CultureExample
    {
        [Test]
        public void ToUpper_Is_Affected_By_Current_Culture()
        {
            var turkish = CultureInfo.CreateSpecificCulture("tr");
            Thread.CurrentThread.CurrentCulture = turkish;

            string header = "mail";

            Assert.That(header.ToUpper(), Is.Not.EqualTo("MAIL"));
            Assert.That(header.ToUpperInvariant(), Is.EqualTo("MAIL"));
        }

        [Test]
        public void Invariant_Culture_Ignores_Current_Culture()
        {
            var turkish = CultureInfo.CreateSpecificCulture("tr");
            Thread.CurrentThread.CurrentCulture = turkish;

            string header = "mail";

            Assert.That(header.Equals("MAIL", StringComparison.InvariantCultureIgnoreCase), Is.True);
            
        }

    }
}
