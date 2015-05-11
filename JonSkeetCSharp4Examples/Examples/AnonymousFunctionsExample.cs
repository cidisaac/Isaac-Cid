using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using NUnit.Framework;

namespace Examples
{
    [TestFixture]
    public class AnonymousFunctionsExample
    {
        public delegate void GenericAction<T>(T value);

        private void MethodTakingString(string value)
        {
            Console.WriteLine(value);
        }

        [Test]
        public void Method_Group_Conversion()
        {
            GenericAction<string> action = MethodTakingString;
            action("Hi!");
        }

        private double SquareRoot(int input)
        {
            return Math.Sqrt(input);
        }

        [Test]
        public void ConvertAll_Accepts_Delegate_And_Execute_It_To_Each_Element()
        {
            var original = new List<int> {1, 2, 3};
            var squareRoots = original.ConvertAll(SquareRoot);

            foreach(double value in squareRoots)
            {
                Console.WriteLine(value);
            }
        }

        [Test]
        public void ConvertAll_Can_Accept_Converter_Delegate_As_Anonymous_Method()
        {
            Converter<int, double> converter = delegate(int x) { return Math.Sqrt(x); };
            var original = new List<int> { 1, 2, 3 };
            var squareRoots = original.ConvertAll(converter);

            foreach(double value in squareRoots)
            {
                Console.WriteLine(value);
            }
        }

        [Test]
        public void ConvertAll_Can_Have_Delegate_Within_Method_Call()
        {
            var original = new List<int> { 1, 2, 3 };
            var squareRoots = original.ConvertAll(delegate(int x) { return Math.Sqrt(x); });

            foreach(double value in squareRoots)
            {
                Console.WriteLine(value);
            }
        }

        [Test]
        public void Variables_Can_Be_Captured_In_Anonymous_Methods_Via_Closure()
        {
            int calls = 0;
            double power = 0.5;
            Converter<int, double> converter = delegate(int x)
                                                   {
                                                       calls++; //captured
                                                       return Math.Pow(x, power);
                                                   };

            var original = new List<int> {1, 2, 3};
            var squareRoots = original.ConvertAll(converter);
            foreach (double value in squareRoots)
            {
                Console.WriteLine(value);
            }
            Console.WriteLine("Total calls: {0}", calls);

            power = 2;
            var squares = original.ConvertAll(converter);
            foreach (double value in squares)
            {
                Console.WriteLine(value);
            }
            Console.WriteLine("Total calls: {0}", calls);

        }

        [Test]
        public void Lambda_Simplifies_Delegate_Creation()
        {
            int calls = 0;
            double power = 0.5;
            Converter<int, double> converter = (int x) =>
                                                   {
                                                       calls++; //captured
                                                       return Math.Pow(x, power);
                                                   };

            var original = new List<int> {1, 2, 3};
            var squareRoots = original.ConvertAll(converter);
            foreach (double value in squareRoots)
            {
                Console.WriteLine(value);
            }
            Console.WriteLine("Total calls: {0}", calls);

            power = 2;
            var squares = original.ConvertAll(converter);
            foreach (double value in squares)
            {
                Console.WriteLine(value);
            }
            Console.WriteLine("Total  calls: {0}", calls);

        }

        [Test]
        public void Simplified_Lambda_With_Single_Return_Statement()
        {
            double power = 0.5;
            Converter<int, double> converter = x => Math.Pow(x, power);
 
            var original = new List<int> {1, 2, 3};
            var squareRoots = original.ConvertAll(converter);
            foreach (double value in squareRoots)
            {
                Console.WriteLine(value);
            }

            power = 2;
            var squares = original.ConvertAll(converter);
            foreach (double value in squares)
            {
                Console.WriteLine(value);
            }
        }

        [Test]
        public void Expression_Trees_Is_The_Represent_Of_Code_And_Can_Be_Compiled()
        {
            Expression<Converter<int, double>> converter = x => Math.Pow(x, 0.5);
            Console.WriteLine(converter);

            Converter<int, double> compiled = converter.Compile();
            Console.WriteLine(compiled.Invoke(5));
        }

        [Test]
        public void Action_Will_Keep_Variable_Not_Value()
        {
            var words = new List<string>() {"Danger", "Will", "Robinson"};
            var actions = new List<Action>();

            foreach(string word in words)
            {
                actions.Add(() => Console.WriteLine(word));
            }

            foreach (var action in actions)
            {
                action();
            }
        }

        [Test]
        public void Action_Will_Keep_Valuel_With_Local_Variable()
        {
            var words = new List<string>() {"Danger", "Will", "Robinson"};
            var actions = new List<Action>();

            foreach(string word in words)
            {
                string copy = word;
                actions.Add(() => Console.WriteLine(copy));
            }

            foreach (var action in actions)
            {
                action();
            }
        }

    }

}
