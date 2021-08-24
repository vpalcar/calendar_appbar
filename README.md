# Calendar AppBar

Flutter package for custom AppBar with calendar view.

*The package is currently optimized for mobile devices, therefore used only for mobile devices is prefered. It also works for larger screens, although it does not follow the rules of good UI. It is planned to be optimized shortly.*

| ![Image](https://user-images.githubusercontent.com/76632000/113698151-6f54e580-96d4-11eb-9ae6-d49693065f72.png) | ![Image](https://user-images.githubusercontent.com/76632000/113698568-e25e5c00-96d4-11eb-9533-b8ff2a285be3.png) | ![Image](https://user-images.githubusercontent.com/76632000/113703658-703d4580-96db-11eb-9454-4f6e228036f7.png) |
| :------------: | :------------: | :------------: |


## Features

* Define your custom color scheme
* Enable or disable full-screen calendar view
* Provide a list of dates that will be marked on the calendar view
* Manipulate with a range of displayed dates

## Installation and Basic Usage

Add to pubspec.yaml:

```yaml
dependencies:
  calendar_appbar: ^0.0.3
```

Then import it to your project:

```dart
import 'package:calendar_appbar/calendar_appbar.dart';
```

Finaly add **CalendarAppBar** in `Scaffold`:

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
      appBar: CalendarAppBar(
        onDateChanged: (value) => print(value),
        firstDate: DateTime.now().subtract(Duration(days: 140)),
        lastDate: DateTime.now(),
      ),
    );
}
```

There are three required attributes of class **CalendarAppBar**. Attribute `onDateChange` is a function, which defines what happens when the user selects a date. `firstDate` attribute defines the first date, which will be available for selection. The date saved in `lastDate` attribute is the last date available for selection. At first initialization of the object, the date provided as `lastDate` will be selected, but will not be returned with `onDateChange` function.


## More Custom Usage

### Hide Full Screen Calendar View

This package enables the usage of a full-screen calendar view. It is displayed when the user presses on month and year text in the top right corner of the AppBar. It comes in two different versions. If the first and last date are part of the same month the full-screen calendar will be displayed as seen on the third image at the top of this file. In the other way, it will be displayed as seen in the second image. It is possible to disable the full-screen view (which is enabled by default) by adding the following code:

```dart
    fullCalendar: false,
```

### Define Your Custom Color Scheme

You can define your custom color scheme by defining `white`, `black` and `accent` color. Those three colors are set to `Colors.white`, `Colors.black87` and `Color(0xFF0039D9)` by default. It is possible to customize those three colors as shown below.

```dart
    white: Colors.white,
    black: Colors.black,
    accent: Colors.blue,
```

*The design is currently optimized for light mode and therefore also suggested to be used in that way to achieve better UX. Dark mode will be added soon.* 

### Custom Padding

The horizontal padding can be customized (default it is set to 25px) by adding the following code: 

```dart
    padding: 10.0,
```

### Mark Dates with Events

It is possible to provide the list of dates of type `List<DateTime>`, which will be marked on calendar view with a dot.

```dart
    events: List.generate(
            10, (index) => DateTime.now().subtract(Duration(days: index * 2))),
```

The code above will generate the list of 10 dates for every second day from today backwards.

### Back Button

The last attribute of **CalendarAppbar** is `backButton`, which is default set to `true`. Customize that feature by setting this attribute to false.

```dart
    backButton: false,
```

### Internationalization

The newest feature the **CalendarAppbar** package is offering is local support for different languages. Use atribute `locale` to customize the language used for the plugin by adding the language code as shown below.

```dart
    locale: 'en',
```

## Thank you
Special thanks goes to all contributors to this package. Make sure to check them out.<br />

<a href="https://github.com/vpalcar/calendar_appbar/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=vpalcar/calendar_appbar" />
</a><br />
Make sure to check out [example project](https://github.com/vpalcar/calendar_appbar/tree/master/example).
If you find this package useful, star my GitHub [repository](https://github.com/vpalcar/calendar_appbar).


## Getting Started with Flutter

For help getting started with Flutter, view Flutter official documentation 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

