using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;

namespace Examples
{
    [TestFixture]
    public class InterfaceExample
    {
        [Test]
        public void Inteface_Can_Have_Suffix_Able_To_Make_It_More_Meaningful()
        {
            var startAndStopper = new StartAndStopper();
            startAndStopper.StartAndStop(new Dancer());

        }
    }

    public class StartAndStopper
    {
        public void StartAndStop(IControllable controllable)
        {
            controllable.Start();
            controllable.Stop();
        }
    }

    public interface IControllable
    {
        void Stop();
        void Start();
    }

    public class Dancer : IControllable
    {
        public void Stop()
        {
            Console.WriteLine("..");
        }

        public void Start()
        {
            Console.WriteLine("Cha cha cha");
        }
    }

    public class ChainSaw : IControllable
    {
        public void Stop()
        {
            Console.WriteLine("...");
        }

        public void Start()
        {
            Console.WriteLine("Brmmm, Thudder der der");
        }
    }
}
