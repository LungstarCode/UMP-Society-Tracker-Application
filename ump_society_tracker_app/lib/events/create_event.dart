import 'package:flutter/material.dart';
import 'package:ump_society_tracker_app/events/events_db.dart';
import 'package:uuid/uuid.dart';

class CreateEventPage extends StatefulWidget {
  final String societyId;

  const CreateEventPage({super.key, required this.societyId});

  @override
  // ignore: library_private_types_in_public_api
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _venueController = TextEditingController();
  final _seatsController = TextEditingController();
  final _themeController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int? _selectedDuration;
  final List<int> _durations = [30, 60, 90, 120]; // Duration options in minutes

  @override
  void dispose() {
    _nameController.dispose();
    _venueController.dispose();
    _seatsController.dispose();
    _themeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _createEvent() {
    if (_formKey.currentState!.validate()) {
      final event = Event(
        id: const Uuid().v4(),
        name: _nameController.text,
        date: _selectedDate?.toLocal().toString() ?? '',
        time: _selectedTime?.format(context) ?? '',
        venue: _venueController.text,
        duration: _selectedDuration?.toString() ?? '',
        seats: int.parse(_seatsController.text),
        theme: _themeController.text,
        description: _descriptionController.text,
        societyId: widget.societyId,
      );

      EventsDB.createEvent(event).then((_) {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Event',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0), // Dark Blue
        iconTheme: const IconThemeData(color: Colors.white), // Icons in AppBar
      ),
      body: Container(
        color: const Color.fromRGBO(0, 0, 41, 1.0), // Dark Blue Background
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _nameController,
                labelText: 'Event Name',
                icon: Icons.event,
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: _buildTextField(
                    controller: TextEditingController(
                      text: _selectedDate == null
                          ? 'Select Date'
                          : '${_selectedDate!.toLocal()}',
                    ),
                    labelText: 'Date',
                    icon: Icons.calendar_today,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _selectTime(context),
                child: AbsorbPointer(
                  child: _buildTextField(
                    controller: TextEditingController(
                      text: _selectedTime == null
                          ? 'Select Time'
                          : _selectedTime!.format(context),
                    ),
                    labelText: 'Time',
                    icon: Icons.access_time,
                  ),
                ),
              ),
              _buildTextField(
                controller: _venueController,
                labelText: 'Venue',
                icon: Icons.location_on,
              ),
              DropdownButtonFormField<int>(
                value: _selectedDuration,
                items: _durations.map((duration) {
                  return DropdownMenuItem<int>(
                    value: duration,
                    child: Text('$duration minutes'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDuration = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Duration',
                  prefixIcon: Icon(Icons.timer, color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a duration';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _seatsController,
                labelText: 'Seats',
                icon: Icons.event_seat,
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                controller: _themeController,
                labelText: 'Theme',
                icon: Icons.palette,
              ),
              _buildTextField(
                controller: _descriptionController,
                labelText: 'Description',
                icon: Icons.description,
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createEvent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(3, 169, 244, 1), 
                  minimumSize: const Size(double.infinity, 50), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), 
                  ),
                ),
                child: const Text('Create Event', style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: Icon(icon, color: Colors.white),
        border: const UnderlineInputBorder(),
      ),
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }
}
