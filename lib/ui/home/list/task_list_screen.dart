import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/ui/home/list/task_item.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Blue Header background overlapping Calendar Timeline
        Stack(
          children: [
            Container(
              color: Colors.blue,
              height: 50,
              width: double.infinity,
            ),
            EasyDateTimeLine(
              initialDate: DateTime.now(),
              onDateChange: (newDate) {
                setState(() {
                  selectedDate = newDate;
                });
              },
              headerProps: const EasyHeaderProps(
                showHeader: false,
              ),
              dayProps: const EasyDayProps(
                dayStructure: DayStructure.dayStrDayNum,
                height: 80,
                width: 60,
                activeDayStyle: DayStyle(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.08),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  dayStrStyle: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  dayNumStyle: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                inactiveDayStyle: DayStyle(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  dayStrStyle: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  dayNumStyle: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        // List of tasks
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 90),
            children: const [
              TaskItem(
                title: 'Play basket ball',
                time: '10:30 AM',
                isDone: false,
              ),
              TaskItem(
                title: 'Play basket ball',
                time: '10:30 AM',
                isDone: true,
              ),
              TaskItem(
                title: 'Play basket ball',
                time: '10:30 AM',
                isDone: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
