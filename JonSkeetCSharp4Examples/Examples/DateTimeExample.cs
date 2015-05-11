using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using NUnit.Framework;

namespace Examples
{
    [TestFixture]
    public class DateTimeExample
    {
        [Test]
        public void Parse_Exact()
        {
            var date = DateTime.ParseExact("05/10/2011 13:15:15.000", "dd/MM/yyyy HH:mm:ss.fff", CultureInfo.InvariantCulture);

            Assert.That(date.Month, Is.EqualTo(10));
            Assert.That(date.Year, Is.EqualTo(2011));
            Assert.That(date.Day, Is.EqualTo(05));
        }

        [Test]
        public void TimeSpan_From_Is_More_Readable()
        {
            var fiveSeconds1 = TimeSpan.FromSeconds(5);
            var fiveSeconds2 = new TimeSpan(0, 0, 5);

            Assert.That(fiveSeconds1, Is.EqualTo(fiveSeconds2));

        }

        [Test]
        public void TimeSpan_Milliseconds_Returns_Only_Milliseconds_Part()
        {
            var tenMinute = TimeSpan.FromMinutes(10);

            Assert.That(tenMinute.Milliseconds, Is.EqualTo(0));
        }

        [Test]
        public void TimeSpan_TotalMilliseconds_Convert_Its_Value_To_Milliseconds()
        {
            var fiveSeconds = TimeSpan.FromSeconds(5);

            Assert.That(fiveSeconds.TotalMilliseconds, Is.EqualTo(5000d));
        }

        [Test]
        public void TimeSpan_Overrides_Plus_Operator()
        {
            var fiveSeconds = TimeSpan.FromSeconds(5);
            var halfAMinute = TimeSpan.FromMinutes(.5);

            Assert.That(TimeSpan.FromMilliseconds(35000), Is.EqualTo(fiveSeconds + halfAMinute));
        }

        [Test]
        public void Time_Can_Be_Converted_To_Local_Or_Universal_Using_Os_Default_Time_Zone()
        {
            var jonsTime = new DateTime(2011, 4, 1, 21, 24, 0, DateTimeKind.Local);
            var robsTime = new DateTime(2011, 4, 1, 10, 24, 0, DateTimeKind.Local);
            var utcTime = new DateTime(2011, 4, 1, 20, 24, 0, DateTimeKind.Utc);

            Assert.That(jonsTime.ToUniversalTime(), Is.EqualTo(utcTime));
            Assert.That(utcTime.ToLocalTime(), Is.EqualTo(jonsTime));
        }

        [Test]
        public void DateTime_Is_Value_Type_Immutable_And_Compared_By_Its_Value()
        {
            var jonsTime = new DateTime(2011, 4, 1, 21, 24, 0, DateTimeKind.Local);
            var bedTime = jonsTime + TimeSpan.FromHours(2);

            Assert.That(bedTime, Is.EqualTo(new DateTime(2011, 4, 1, 23, 24, 0, DateTimeKind.Local)));
        }

        [Test]
        public void DateTimeOffset_Can_Specifity_Your_Local_Time_From_Utc_Point_Of_View()
        {
            var jonsTime = new DateTimeOffset(2011, 4, 1, 21, 24, 0, TimeSpan.FromHours(1));
            var localTime = new DateTime(2011, 4, 1, 20, 24, 0);
            
            Assert.That(jonsTime.ToUniversalTime().Hour, Is.EqualTo(localTime.Hour));
        }

        [Test]
        public void DateTimeOffset_Can_Represent_The_Same_Time_In_Different_Time_Zone()
        {
            var jonsTime = new DateTimeOffset(2011, 4, 1, 21, 24, 0, TimeSpan.FromHours(1));
            var robsTime = new DateTimeOffset(2011, 4, 1, 10, 24, 0, TimeSpan.FromHours(-10));

            Assert.That(jonsTime, Is.EqualTo(robsTime));
        }

        [Test]
        public void TimeZoneInfo_Knows_Your_Daylight_Saving_Change()
        {
            var zone = TimeZoneInfo.Local;

            Assert.That(zone.GetUtcOffset(new DateTime(2011, 3, 27, 0, 0, 0)), Is.EqualTo(TimeSpan.FromHours(0)));
            Assert.That(zone.GetUtcOffset(new DateTime(2011, 3, 27, 2, 0, 0)), Is.EqualTo(TimeSpan.FromHours(1)));
        }
    }
}
