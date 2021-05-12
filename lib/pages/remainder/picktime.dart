import 'package:flutter/material.dart';

class SelectTime extends StatefulWidget {
  @override
  _SelectTimeState createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  TimeOfDay _time = TimeOfDay(hour: 0, minute: 00);
  bool _clicked = false;

  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
        _clicked = true;
        // _newEntryBloc.updateTime("${convertTime(_time.hour.toString())}" +
        //     "${convertTime(_time.minute.toString())}");
      });
    }
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0, bottom: 4),
        child: FlatButton(
          color: Color(0xFF3EB16F),
          shape: StadiumBorder(),
          onPressed: () {
            _selectTime(context);
          },
          child: Center(
            child: Text(
              _clicked == false
                  ? "Pick Time"
                  : "", //${convertTime(_time.hour.toString())}:${convertTime(_time.minute.toString())}
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
