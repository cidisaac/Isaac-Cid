using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using System.IO;

namespace Examples
{
    [TestFixture]
    public class InheritanceExample
    {
        [Test]
        public void Using_The_Lowest_Common_Denominator_To_Ease_Testing_Code()
        {
            var data = new byte[] {1, 2, 3};

            using (var memoryStream = new MemoryStream(data))
            {
                var summer = new StreamSummer();
                
                Assert.That(summer.Sum(memoryStream), Is.EqualTo(6));
            }
        }


    }

    public class StreamSummer
    {
        public int Sum(Stream stream)
        {
            int total = 0;
            int value;

            while ((value = stream.ReadByte()) != -1)
            {
                total += value;
            }

            return total;
        }
    }
    
}
