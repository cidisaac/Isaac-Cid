using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;

namespace Examples
{
    [TestFixture]
    public class ArrayExample
    {
        [Test]
        public void Array_Is_Zero_Based()
        {
            int[] numbers = new int[5];

            numbers[0] = 5;

            Assert.That(numbers[0], Is.EqualTo(5));
            Assert.That(numbers.Length, Is.EqualTo(5));
        }

        [Test]
        public void Array_Support_ForEach_Loop()
        {
            var numbers = new int[10];
            for (int i=0; i<numbers.Length; i++)
            {
                numbers[i] = i;
            }

            int sum = 0;
            foreach(int value in numbers)
            {
                sum += value;
            }

            Assert.That(sum, Is.EqualTo(45));
        }
    }
}
