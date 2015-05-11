using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;

namespace Examples
{
    [TestFixture]
    public class ControlFlowExample
    {
        [Test]
        public void Return_Is_The_Simplest_Form_Of_Flow_Control()
        {
            Console.WriteLine("Hello");

            return;
            Console.WriteLine("This code is not reachable.");
        }

        [Test]
        public void While_Runs_As_Long_As_The_Conditin_Is_Met()
        {
            int x = 10;
            while (x < 15)
            {
                x++;
            }

            Assert.That(x, Is.EqualTo(15));
        }

        [Test]
        public void DoWhile_Evaluate_The_Condition_At_The_End()
        {
            int x = 10;
            do
            {
                x++;
            } while (x < 15);

            Assert.That(x, Is.EqualTo(15));
        }

        [Test]
        public void Break_Will_Terminate_the_Loop()
        {
            int x = 10;
            while (x < 15)
            {
                if (x % 3 == 0)
                    break;

                x++;
            }

            Assert.That(x, Is.EqualTo(12));
        }

        [Test]
        public void Continue_Will_Skip_But_Continue_The_Loop()
        {
            int x = 10;
            while (x < 15)
            {
                if (x % 3 == 0)
                {
                    x += 2;
                    continue;
                }

                x++;
            }

            Assert.That(x, Is.EqualTo(15));
        }

        [Test]
        public void Multiple_Variables_In_For_Loop_Is_Possible()
        {
            for (int x=0, y=0; x + y < 10; x++, y += 2)
            {
                Console.WriteLine("{0} {1}", x, y);
            } 
        }

        [Test]
        public void ForEach_Iterates_Over_Collection()
        {
            var strings = new List<string>() {"Jon", "Holly", "Tom", "Robin", "William"};

            foreach (string value in strings)
            {
                Console.WriteLine(value);
            }

            {
                string value;
                using (IEnumerator<string> iterator = strings.GetEnumerator())
                {
                    while (iterator.MoveNext())
                    {
                        value = iterator.Current;
                        Console.WriteLine(value);
                    }
                }
            }
        }
    }
}
