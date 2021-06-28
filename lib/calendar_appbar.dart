library calendar_appbar;

//adding necesarry packages
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

//Code starts here
class CalendarAppBar extends StatefulWidget implements PreferredSizeWidget {
  //accent color of UI
  final Color? accent;
  //definiton of your specific shade of white
  final Color? white;
  //definiton of your specific shade of black
  final Color? black;
  //the last date shown on the calendar
  final DateTime? lastDate;
  //the first date shown on the calendar
  final DateTime firstDate;
  //list of dates with specific event (shown as a dot above the date)
  final List<DateTime>? events;
  //function which returns currently selected date
  final Function onDateChanged;
  //definition of your custom padding
  final double? padding;
  //definition of the atribute which shows full calendar view when pressing on date
  final bool? fullCalendar;
  //[backButton] shows BackButton in set to true
  final bool? backButton;

  CalendarAppBar({
    Key? key,
    required this.lastDate,
    required this.firstDate,
    required this.onDateChanged,
    this.events,
    this.fullCalendar,
    this.backButton,
    this.accent,
    this.white,
    this.black,
    this.padding,
  }) : super(key: key);

  @override
  _CalendarAppBarState createState() => _CalendarAppBarState();

  @override
  Size get preferredSize => new Size.fromHeight(250.0);
}

class _CalendarAppBarState extends State<CalendarAppBar> {
  DateTime? selectedDate;
  int? position;
  DateTime? referenceDate;
  List<String> datesWithEnteries = [];
  Color? white;
  Color? accent;
  Color? black;
  double? padding;
  bool? fullCalendar;
  bool? backButton;

  //intializing values of atributes which were not defined by user
  @override
  void initState() {
    setState(() {
      widget.accent == null
          ? accent = Color(0xFF0039D9)
          : accent = widget.accent;
      widget.white == null ? white = Colors.white : white = widget.white;
      widget.black == null ? black = Colors.black87 : black = widget.black;
      widget.padding == null ? padding = 25.0 : padding = widget.padding;
      widget.backButton == null
          ? backButton = true
          : backButton = widget.backButton;
      widget.fullCalendar == null
          ? fullCalendar = true
          : fullCalendar = widget.fullCalendar;
      selectedDate = widget.lastDate;
      referenceDate = selectedDate;

      position = 1;
    });
    //changing event list to specific form
    if (widget.events != null) {
      for (var element in widget.events!) {
        datesWithEnteries.add(element.toString().split(" ").first);
      }
    }
    super.initState();
  }

  //definition of scroll controller
  ScrollController scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    //changing all dates to correct form for easier
    DateTime first = DateTime.parse(
        "${widget.firstDate.toString().split(" ").first} 00:00:00.000");
    DateTime last = DateTime.parse(
        "${widget.lastDate.toString().split(" ").first} 23:00:00.000");
    DateTime basicDate =
        DateTime.parse("${first.toString().split(" ").first} 12:00:00.000");
    List<DateTime> pastDates = List.generate(
        (last.difference(first).inHours / 24).round(),
        (index) => basicDate.add(Duration(days: index)));
    pastDates.sort((b, a) => a.compareTo(b));
    Widget calendarView() {
      //Ui for calendar scrollview
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 145.0,
        alignment: Alignment.bottomCenter,
        child: NotificationListener(
          onNotification: (dynamic notification) {
            //scrolling mechanism defined
            double width = MediaQuery.of(context).size.width;
            double widthUnit = width / 5 - 4.0;
            double offset = scrollController.offset;

            if (notification is UserScrollNotification &&
                notification.direction == ScrollDirection.idle &&
                // ignore_for_file: invalid_use_of_visible_for_testing_member
                // ignore_for_file: invalid_use_of_protected_member
                scrollController.position.activity is! HoldScrollActivity) {
              if (offset > 0) {
                scrollController.animateTo(
                    (offset / widthUnit).round() * (widthUnit),
                    duration: Duration(milliseconds: 100),
                    curve: Curves.easeInOut);
              }
              if (referenceDate.toString().split(" ").first !=
                  selectedDate.toString().split(" ").first) {
                Future.delayed(Duration(milliseconds: 100), () {
                  widget.onDateChanged(selectedDate);
                });
                setState(() {
                  referenceDate = selectedDate;
                });
              }
            }
            //adding hapric feedback in the future
            if (offset > position! * widthUnit - (widthUnit / 2)) {
              setState(() {
                position = position! + 1;
                selectedDate = selectedDate!.subtract(Duration(days: 1));
                //HapticFeedback.lightImpact();
              });
            } else if (offset + width <
                position! * widthUnit - (widthUnit / 2)) {
              setState(() {
                position = position! - 1;
                selectedDate = selectedDate!.add(Duration(days: 1));
                //HapticFeedback.lightImpact();
              });
            }

            return true;
          },
          //UI for calendar scrollview
          child: ListView.builder(
              padding: pastDates.length < 5
                  ? EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width *
                          (5 - pastDates.length) /
                          10)
                  : const EdgeInsets.symmetric(horizontal: 10),
              scrollDirection: Axis.horizontal,
              reverse: true,
              controller: scrollController,
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: pastDates.length,
              itemBuilder: (context, index) {
                //definition of variables
                DateTime date = pastDates[index];
                bool isSelected = position == index + 1;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: GestureDetector(
                    //if pressed on specific date, set it as selected
                    onTap: () {
                      setState(() {
                        selectedDate = date;
                        referenceDate = selectedDate;
                        position = index + 1;
                      });
                      widget.onDateChanged(selectedDate);
                    },
                    //different UI for nonselected containers and the selected ones
                    //this is the definition of the main container of calendar card
                    child: Container(
                      width: MediaQuery.of(context).size.width / 5 - 4.0,
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5.0),
                          child: Container(
                            height: 120.0,
                            width: MediaQuery.of(context).size.width / 5 - 4.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: isSelected ? white : null,
                              boxShadow: [
                                isSelected
                                    ? BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 10,
                                        offset: Offset(0, 3),
                                      )
                                    : BoxShadow(
                                        color: Colors.grey.withOpacity(0.0),
                                        spreadRadius: 5,
                                        blurRadius: 20,
                                        offset: Offset(0, 3),
                                      )
                              ],
                            ),
                            //definition of content inside of calendar card
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //indicators of event on specific date
                                datesWithEnteries.contains(
                                        date.toString().split(" ").first)
                                    ? Container(
                                        width: 5.0,
                                        height: 5.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isSelected
                                              ? accent
                                              : white!.withOpacity(0.6),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 5.0,
                                      ),
                                SizedBox(height: 10),
                                //date number
                                Text(
                                  DateFormat("dd").format(date),
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      color: isSelected
                                          ? accent
                                          : white!.withOpacity(0.6),
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 5),
                                //day of the week
                                Text(
                                  DateFormat("E").format(date),
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: isSelected
                                          ? accent
                                          : white!.withOpacity(0.6),
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      );
    }

    //this function show full calendar view currently shown as modal bottom sheet
    showFullCalendar() {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        builder: (BuildContext context) {
          double height;
          DateTime? endDate =
              widget.lastDate == null ? DateTime.now() : widget.lastDate;

          if (widget.firstDate.year == endDate!.year &&
              widget.firstDate.month == endDate.month) {
            height =
                ((MediaQuery.of(context).size.width - 2 * padding!) / 7) * 5 +
                    150.0;
          } else {
            height = (MediaQuery.of(context).size.height - 100.0);
          }
          return Container(
            height: height,
            //usage of full calender widget, which is defined below
            child: FullCalendar(
              height: height,
              startDate: widget.firstDate,
              endDate: endDate,
              padding: padding,
              accent: accent,
              black: black,
              white: white,
              events: datesWithEnteries,
              selectedDate: referenceDate,
              onDateChange: (value) {
                //systematics of selecting specific date
                //HapticFeedback.lightImpact();

                //hide modal bottom sheet
                Navigator.pop(context);
                //define new variables
                DateTime referentialDate = DateTime.parse(
                    "${value.toString().split(" ").first} 12:00:00.000");
                int? oldPosition;
                late int positionDifference;
                //calculate new position of scrollview
                setState(() {
                  oldPosition = position;
                  positionDifference =
                      -((referentialDate.difference(referenceDate!).inHours /
                              24)
                          .round());
                });

                double offset = scrollController.offset;

                double widthUnit = MediaQuery.of(context).size.width / 5 - 4.0;
                //wait to modal bottom sheet to hide
                Future.delayed(Duration(milliseconds: 100), () {
                  double maxOffset = scrollController.position.maxScrollExtent;
                  double minOffset = 0.0;
                  double newOffset =
                      (offset + (widthUnit * positionDifference));

                  if (newOffset > maxOffset)
                    newOffset = maxOffset;
                  else if (newOffset < minOffset) newOffset = minOffset;
                  //scroll the calendar scroller to the selected date
                  scrollController.animateTo(newOffset,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut);

                  Future.delayed(Duration(milliseconds: 550), () {
                    setState(() {
                      selectedDate = value;
                      referenceDate = selectedDate;
                      position = oldPosition! + positionDifference;
                    });
                  });
                });

                widget.onDateChanged(value);
              },
            ),
          );
        },
      );
    }

    //UI of the whole appbar
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 240.0,
      //it is based on stack of widgets
      child: Stack(
        children: [
          Positioned(
            top: 0.0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 210.0,
              color: accent,
            ),
          ),
          Positioned(
              top: 59.0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding!),
                child: Container(
                  width: MediaQuery.of(context).size.width - (padding! * 2),
                  child: backButton!
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                child: Icon(
                                  Icons.arrow_back_ios_rounded,
                                  color: white,
                                ),
                                onTap: () => Navigator.pop(context)),
                            GestureDetector(
                              onTap: () =>
                                  fullCalendar! ? showFullCalendar() : null,
                              child: Text(
                                DateFormat("MMMM y").format(selectedDate!),
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: white,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  fullCalendar! ? showFullCalendar() : null,
                              child: Text(
                                DateFormat("MMMM y").format(selectedDate!),
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: white,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                ),
              )),
          Positioned(
            bottom: 0.0,
            // call calendarView function from above
            child: calendarView(),
          ),
        ],
      ),
    );
  }
}

//definition of full calendar shown in modal bottom sheet
class FullCalendar extends StatefulWidget {
  //same variables as in CalendarAppBar class
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? selectedDate;
  final Color? black;
  final Color? accent;
  final Color? white;
  final double? padding;
  final double? height;

  final List<String>? events;
  final Function onDateChange;

  FullCalendar(
      {Key? key,
      this.accent,
      this.endDate,
      required this.startDate,
      required this.padding,
      this.events,
      this.black,
      this.white,
      this.height,
      this.selectedDate,
      required this.onDateChange})
      : super(key: key);
  @override
  _FullCalendarState createState() => _FullCalendarState();
}

class _FullCalendarState extends State<FullCalendar> {
  late DateTime endDate;
  late DateTime startDate;
  List<String>? events = [];
  //transforming variables to correct form
  void initState() {
    setState(() {
      startDate = DateTime.parse(
          "${widget.startDate.toString().split(" ").first} 00:00:00.000");
      endDate = DateTime.parse(
          "${widget.endDate.toString().split(" ").first} 23:00:00.000");
      events = widget.events != null ? widget.events : null;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //transforming variables to correct form
    List<String> partsStart = startDate.toString().split(" ").first.split("-");
    DateTime firstDate = DateTime.parse(
        "${partsStart.first}-${partsStart[1].padLeft(2, '0')}-01 00:00:00.000");
    List<String> partsEnd = endDate.toString().split(" ").first.split("-");
    DateTime lastDate = DateTime.parse(
            "${partsEnd.first}-${(int.parse(partsEnd[1]) + 1).toString().padLeft(2, '0')}-01 23:00:00.000")
        .subtract(Duration(days: 1));

    double width = MediaQuery.of(context).size.width - (2 * widget.padding!);
    List<DateTime?> dates = [];
    DateTime referenceDate = firstDate;
    //creating list for calendar matrix
    while (referenceDate.isBefore(lastDate)) {
      List<String> referenceParts = referenceDate.toString().split(" ");
      DateTime newDate = DateTime.parse("${referenceParts.first} 12:00:00.000");
      dates.add(newDate);

      referenceDate = newDate.add(Duration(days: 1));
    }

    if (firstDate.year == lastDate.year && firstDate.month == lastDate.month) {
      return Padding(
        padding:
            EdgeInsets.fromLTRB(widget.padding!, 40.0, widget.padding!, 0.0),
        child: month(dates, width),
      );
    } else {
      List<DateTime?> months = [];
      for (int i = 0; i < dates.length; i++) {
        if (i == 0 || (dates[i]!.month != dates[i - 1]!.month)) {
          months.add(dates[i]);
        }
      }
      months.sort((b, a) => a!.compareTo(b!));
      return Padding(
        padding:
            EdgeInsets.fromLTRB(widget.padding!, 40.0, widget.padding!, 0.0),
        child: Container(
          //scrolling of calendar
          child: ListView.builder(
              physics: BouncingScrollPhysics(),
              reverse: true,
              itemCount: months.length,
              itemBuilder: (context, index) {
                DateTime? date = months[index];
                List<DateTime?> daysOfMonth = [];
                for (var item in dates) {
                  if (date!.month == item!.month && date.year == item.year) {
                    daysOfMonth.add(item);
                  }
                }
                bool isLast = index == 0;

                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0.0 : 25.0),
                  child: month(daysOfMonth, width),
                );
              }),
        ),
      );
    }
  }

  //definiton of week
  Widget daysOfWeek(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        dayName(width / 7, "Mon"),
        dayName(width / 7, "Tue"),
        dayName(width / 7, "Wed"),
        dayName(width / 7, "Thu"),
        dayName(width / 7, "Fri"),
        dayName(width / 7, "Sat"),
        dayName(width / 7, "Sun"),
      ],
    );
  }

  //definition of day widget
  Widget dayName(double width, String text) {
    return Container(
      width: width,
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            color: widget.black!.withOpacity(0.8)),
      ),
    );
  }

  //definition of date in Calendar widget
  Widget dateInCalendar(
      DateTime date, bool outOfRange, double width, bool event) {
    bool isSelectedDate = date.toString().split(" ").first ==
        widget.selectedDate.toString().split(" ").first;
    return Container(
      child: GestureDetector(
        onTap: () => outOfRange ? null : widget.onDateChange(date),
        child: Container(
          width: width / 7,
          height: width / 7,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelectedDate ? widget.accent : Colors.transparent),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 5.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  DateFormat("dd").format(date),
                  style: TextStyle(
                      //UI of full calendar shows also the dates that are out
                      //of the range defined by first and last date, although
                      //the UI is different for the dates out of range
                      color: outOfRange
                          ? isSelectedDate
                              ? widget.white!.withOpacity(0.9)
                              : widget.black!.withOpacity(0.4)
                          : isSelectedDate
                              ? widget.white
                              : widget.black),
                ),
              ),
              //if there is an event on the specific date, UI will show dot in accent color
              event
                  ? Container(
                      height: 5.0,
                      width: 5.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelectedDate ? widget.white : widget.accent),
                    )
                  : SizedBox(height: 5.0),
            ],
          ),
        ),
      ),
    );
  }

  //definition of month widget

  Widget month(List dates, double width) {
    DateTime first = dates.first;
    while (DateFormat("E").format(dates.first) != "Mon") {
      dates.add(dates.first.subtract(Duration(days: 1)));
      dates.sort();
    }
    //logically show all the dates in the month
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //name of the month
          Text(
            DateFormat("MMMM y").format(first),
            style: TextStyle(
                fontSize: 18.0,
                color: widget.black,
                fontWeight: FontWeight.w400),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: daysOfWeek(width),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              //calculate the number of rows with dates based on number of days in the month
              height: dates.length > 28
                  ? dates.length > 35
                      ? 6 * width / 7
                      : 5 * width / 7
                  : 4 * width / 7,
              width: MediaQuery.of(context).size.width - 2 * widget.padding!,
              //show all days in the month
              child: GridView.builder(
                itemCount: dates.length,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7),
                itemBuilder: (context, index) {
                  DateTime date = dates[index];
                  bool outOfRange =
                      date.isBefore(startDate) || date.isAfter(endDate);
                  if (date.isBefore(first)) {
                    return Container(
                      width: width / 7,
                      height: width / 7,
                      color: Colors.transparent,
                    );
                  } else {
                    return dateInCalendar(
                      date,
                      outOfRange,
                      width,
                      events!.contains(date.toString().split(" ").first) &&
                          !outOfRange,
                    );
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

//end of code