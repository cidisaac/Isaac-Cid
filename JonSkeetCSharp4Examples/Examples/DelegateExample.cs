using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;

namespace Examples
{
    [TestFixture]
    public class DelegateExample
    {
        [Test]
        public void Method_Can_Be_Invoked_Via_Delegate()
        {
            var target = new Target("Jon");
            var action = new Int32Action(target.RandomRob);

            action.Invoke(5); //Invoke can be omitted.
            action(6);
        }

        [Test]
        public void Static_Method_Can_Be_Called_Via_Delegate()
        {
            var action = new Int32Action(Target.StaticRob1);

            action(5);
        }

        [Test]
        public void Delegates_Can_Be_Combined_For_Multicast()
        {
            var action1 = new Int32Action(Target.StaticRob1);
            var action2 = new Int32Action(Target.StaticRob2);

            var action3 = action1 + action2;
            action3(20);
        }

        private void ReportToConsole(string text)
        {
            Console.WriteLine("Called: {0}", text);
        }

        [Test]
        public void Delegate_Can_Invoke_Private_Method()
        {
            FakeEventHandler handler = ReportToConsole;

            var raiser = new FakeEventRaiser();
            raiser.DoSomething("Not subscribed.");
            
            raiser.AddHandler(handler);
            raiser.DoSomething("Subscribed.");

            raiser.AddHandler(handler);
            raiser.DoSomething("Subscribed twice.");

            raiser.RemoveHandler(handler);
            raiser.RemoveHandler(handler);
            raiser.DoSomething("Unbscribed.");

        }

        private void ShortReportToConsole(object sender, EventArgs e)
        {
            Console.WriteLine("An event is Called");
        }

        [Test]
        public void Event_Makes_It_Simpler()
        {
            ClickHandler handler = ShortReportToConsole;

            var raiser = new ShortEventHandler();
            raiser.OnClick();

            raiser.Click += handler;
            raiser.OnClick();

            raiser.Click += handler;
            raiser.OnClick();

            raiser.Click -= handler;
            raiser.Click -= handler;
            raiser.OnClick();

        }

    }

    public delegate void ClickHandler(object sender, EventArgs e);
    public class ShortEventHandler
    {
        public void OnClick()
        {
            ClickHandler clickHandler = Click;
            if (clickHandler != null)
                clickHandler.Invoke(this, EventArgs.Empty);
        }

        public event ClickHandler Click;

    }

    public delegate void FakeEventHandler(string reason);
    public class FakeEventRaiser
    {
        private FakeEventHandler _currentHandler = null;
        public void AddHandler(FakeEventHandler handler)
        {
            _currentHandler = _currentHandler + handler;
        }

        public void RemoveHandler(FakeEventHandler handler)
        {
            _currentHandler = _currentHandler - handler;
        }

        public void DoSomething(string text)
        {
            if (_currentHandler != null)
                _currentHandler.Invoke(text);
        }
    }

    public delegate void Int32Action(int value);
    public class Target
    {
        private readonly string _name;

        public Target() : this("Unknown"){}
        public Target(string name)
        {
            _name = name;
        }

        public void RandomRob(int value)
        {
            Console.WriteLine("{0}: Delegate implementation: {1}", _name, value);
        }

        public static void StaticRob1(int value)
        {
            Console.WriteLine("Static method 1: {0}", value);
        }

        public static void StaticRob2(int value)
        {
            Console.WriteLine("Static method 2: {0}", value);
        }
    }
}
