import 'package:flutter/material.dart';
import 'package:sissifit/models/logged_session.dart';

class StatusGraph extends StatelessWidget {
  final List<LoggedSession> sessionsData;
  const StatusGraph({super.key, required this.sessionsData});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    var gridCellHeight = (size.height * 0.3 - (7.0 * 1)) / 7;
    List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return SizedBox(
      height: size.height * 0.3,
      width: size.width,
      child: Row(
        children: [
          Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //mainAxisSize: MainAxisSize.max,
            children: List.generate(7, (index) {
              return Container(
                height: gridCellHeight,
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(),
                child: Text(days[index], style: TextStyle(color: Colors.white)),
              );
            }),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: 287,
              itemBuilder: (_, i) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color.fromARGB(255, 5, 60, 7),
                    ),
                    borderRadius: BorderRadius.circular(4),
                    color:
                        i % 2 == 0
                            ? const Color.fromARGB(255, 32, 175, 37)
                            : const Color.fromARGB(255, 107, 233, 172),
                  ),
                  child: Text("$i", style: TextStyle(color: Colors.white)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
