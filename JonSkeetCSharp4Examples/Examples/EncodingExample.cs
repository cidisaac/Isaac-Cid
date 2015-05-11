using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using NUnit.Framework;

namespace Examples
{
    [TestFixture]
    public class EncodingExample
    {
        [Test]
        public void UTF8_Represend_A_Char_In_One_Byte()
        {
            string text = "ABC";
            byte[] binary = Encoding.UTF8.GetBytes(text);

            Assert.That(binary[0], Is.EqualTo(65));
            Assert.That(binary[1], Is.EqualTo(66));
            Assert.That(binary[2], Is.EqualTo(67));
        }

        [Test]
        public void UTF16_Represend_A_Char_In_Two_Bytes()
        {
            string text = "ABC";
            byte[] binary = Encoding.Unicode.GetBytes(text);

            Assert.That(binary[0], Is.EqualTo(65));
            Assert.That(binary[2], Is.EqualTo(66));
            Assert.That(binary[4], Is.EqualTo(67));
        }

        [Test]
        public void Different_Encoding_Leads_To_Different_Strings()
        {
            string text = "ABC";
            byte[] binary = Encoding.Unicode.GetBytes(text);

            string recoveredText = Encoding.UTF8.GetString(binary);

            Assert.That(text, Is.Not.EqualTo(recoveredText));
        }

        [Test]
        public void ToBase64String_Can_Convert_Hash_Bytes_To_String()
        {
            using (var md5 = MD5.Create())
            {
                byte[] hash = md5.ComputeHash(new byte[10]);
                string hashAsText = Convert.ToBase64String(hash);

                Assert.That(Convert.FromBase64String(hashAsText), Is.EqualTo(hash));
            }
        }

    }
}
