using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;

namespace Examples
{
    public interface IEdile {}
    public abstract  class Fruit : IEdile  {}
    public class Apple : Fruit {}
    public class Banana : Fruit {}
    public class Pizza : IEdile {}

    public interface IFoo<out T> // this T is covariant
    {
        T GiveMeFoo();
    }

    public abstract class Shape
    {
        public abstract double Area { get; }
    }

    public class Circle : Shape
    {
        private readonly double _radius;
        public Circle(double radius)
        {
            _radius = radius;
        }

        public override double Area
        {
            get { return Math.PI*_radius*_radius; }
        }
    }

    public class Square : Shape
    {
        private readonly double _side;
        public Square(double side)
        {
            _side = side;
        }

        public override double Area
        {
            get { return _side*_side; }
        }
    }

    public class AreaComparer : IComparer<Shape>
    {
        public int Compare(Shape x, Shape y)
        {
            return x.Area.CompareTo(y.Area);
        }
    }

    [TestFixture]
    public class VarianceExamples
    {
        [Test]
        public void Shape_Example()
        {
            var shapes = new List<Shape>
                             {
                                 new Circle(10),
                                 new Square(5),
                                 new Circle(20)
                             };
            shapes.Sort(new AreaComparer());

            var circles = new List<Circle>
                             {
                                 new Circle(10),
                                 new Circle(20)
                             };
            circles.Sort(new AreaComparer());

        }

        [Test]
        public void Going_To_General_From_Specific_Is_Covariant()
        {
            IFoo<string> foos = null;
            IFoo<object> general = foos;
        }

        [Test]
        public void IEnumerable_Is_Covariant()
        {
            var bananas = new List<Banana>();

            IEnumerable<Fruit> fruits = bananas; //IEnumerable is co-variant
            EatAll(fruits);
        }

        private void EatAll(IEnumerable<IEdile> edibles)
        {
            Console.WriteLine(edibles.GetType());
            foreach (var edible in edibles)
            {
                // do something in here
            }
        }
    }
}
