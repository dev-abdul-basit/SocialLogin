
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:intl/intl.dart';
import 'package:socaillogin/constants.dart';
import 'package:socaillogin/helper/keyboard.dart';

import '../../gCalender/calendar_client.dart';
import '../../models/event_info.dart';
import '../../utils/storage.dart';
import '../book_appointment/components/confirmation_dialog.dart';
import '../home/homepage.dart';

class AddEventScreen extends StatefulWidget {
  static String routeName = '/addEvent';
  const AddEventScreen({Key? key}) : super(key: key);
  @override
  State<AddEventScreen> createState() => _AddEventScreenState();

}

class _AddEventScreenState extends State<AddEventScreen> {

  Storage storage = Storage();
  CalendarClient calendarClient = CalendarClient();

  TextEditingController? textControllerDate;
  TextEditingController? textControllerStartTime;
  TextEditingController? textControllerEndTime;
  TextEditingController? textControllerTitle;
  TextEditingController? textControllerDesc;
  TextEditingController? textControllerLocation;
  TextEditingController? textControllerAttendee;

  FocusNode? textFocusNodeTitle;
  FocusNode? textFocusNodeDesc;
  FocusNode? textFocusNodeLocation;
  FocusNode? textFocusNodeAttendee;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();

  String? currentTitle;
  String? currentDesc;
  String? currentLocation;
  String? currentEmail;
  String errorString = '';
  // List<String> attendeeEmails = [];
  List<calendar.EventAttendee> attendeeEmails = [];

  bool isEditingDate = false;
  bool isEditingStartTime = false;
  bool isEditingEndTime = false;
  bool isEditingBatch = false;
  bool isEditingTitle = false;
  bool isEditingEmail = false;
  bool isEditingLink = false;
  bool isErrorTime = false;
  bool shouldNofityAttendees = false;
  bool hasConferenceSupport = false;

  bool isDataStorageInProgress = false;

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        textControllerDate!.text = DateFormat.yMMMMd().format(selectedDate);
      });
    }
  }

  _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );
    if (picked != null && picked != selectedStartTime) {
      setState(() {
        selectedStartTime = picked;
        textControllerStartTime!.text = selectedStartTime.format(context);
      });
    } else {
      setState(() {
        textControllerStartTime!.text = selectedStartTime.format(context);
      });
    }
  }

  _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
    );
    if (picked != null && picked != selectedEndTime) {
      setState(() {
        selectedEndTime = picked;
        textControllerEndTime!.text = selectedEndTime.format(context);
      });
    } else {
      setState(() {
        textControllerEndTime!.text = selectedEndTime.format(context);
      });
    }
  }


  User? user;
 final  FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  void initState() {

    user = _auth.currentUser;
    textControllerDate = TextEditingController();
    textControllerStartTime = TextEditingController();
    textControllerEndTime = TextEditingController();
    textControllerTitle = TextEditingController();
    textControllerDesc = TextEditingController();
    textControllerLocation = TextEditingController();
    textControllerAttendee = TextEditingController();

    textFocusNodeTitle = FocusNode();
    textFocusNodeDesc = FocusNode();
    textFocusNodeLocation = FocusNode();
    textFocusNodeAttendee = FocusNode();

    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.grey, //change your color here
        ),
        title:const Text(
          'Create Event',
          style: TextStyle(
            color: kPrimaryColor,
            fontSize: 22,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              physics:const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     const Text(
                        'This will add a new event to the events list. You can also add video conferencing option and choose to notify the attendees of this event.',
                        style: TextStyle(
                          color: Colors.black87,
                          fontFamily: 'Raleway',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                     const SizedBox(height: 10),
                   const   Text(
                        'You will have access to modify or remove the event afterwards.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Raleway',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      RichText(
                        text: const TextSpan(
                          text: 'Select Date',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontFamily: 'Raleway',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '*',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        cursorColor: kPrimaryColor,
                        controller: textControllerDate,
                        textCapitalization: TextCapitalization.characters,
                        onTap: () => _selectDate(context),
                        readOnly: true,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        decoration:  InputDecoration(
                          disabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: kPrimaryColor, width: 1),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: kPrimaryColor, width: 1),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: kPrimaryColor, width: 2),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.redAccent, width: 2),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          contentPadding: const EdgeInsets.only(
                            left: 16,
                            bottom: 16,
                            top: 16,
                            right: 16,
                          ),
                          hintText: 'eg: September 10, 2020',
                          hintStyle: TextStyle(
                            color: Colors.grey.withOpacity(0.6),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                          errorText: isEditingDate && textControllerDate!.text != null
                              ? textControllerDate!.text.isNotEmpty
                              ? null
                              : 'Date can\'t be empty'
                              : null,
                          errorStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          text: 'Start Time',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontFamily: 'Raleway',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '*',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        cursorColor: kPrimaryColor,
                        controller: textControllerStartTime,
                        onTap: () => _selectStartTime(context),
                        readOnly: true,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        decoration: InputDecoration(
                          disabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: kPrimaryColor, width: 1),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: kPrimaryColor, width: 1),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: kPrimaryColor, width: 2),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.redAccent, width: 2),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          contentPadding: const EdgeInsets.only(
                            left: 16,
                            bottom: 16,
                            top: 16,
                            right: 16,
                          ),
                          hintText: 'eg: 09:30 AM',
                          hintStyle: TextStyle(
                            color: Colors.grey.withOpacity(0.6),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                          errorText: isEditingStartTime && textControllerStartTime!.text != null
                              ? textControllerStartTime!.text.isNotEmpty
                              ? null
                              : 'Start time can\'t be empty'
                              : null,
                          errorStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          text: 'End Time',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontFamily: 'Raleway',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '*',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        cursorColor:kPrimaryColor,
                        controller: textControllerEndTime,
                        onTap: () => _selectEndTime(context),
                        readOnly: true,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        decoration: InputDecoration(
                          disabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: kPrimaryColor, width: 1),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: kPrimaryColor, width: 1),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: kPrimaryColor, width: 2),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.redAccent, width: 2),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          contentPadding: const EdgeInsets.only(
                            left: 16,
                            bottom: 16,
                            top: 16,
                            right: 16,
                          ),
                          hintText: 'eg: 11:30 AM',
                          hintStyle: TextStyle(
                            color: Colors.grey.withOpacity(0.6),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                          errorText: isEditingEndTime && textControllerEndTime!.text != null
                              ? textControllerEndTime!.text.isNotEmpty
                              ? null
                              : 'End time can\'t be empty'
                              : null,
                          errorStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          text: 'Title',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontFamily: 'Raleway',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '*',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        enabled: true,
                        cursorColor: kPrimaryColor,
                        focusNode: textFocusNodeTitle,
                        controller: textControllerTitle,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          setState(() {
                            isEditingTitle = true;
                            currentTitle = value;
                          });
                        },
                        onSaved: (newValue) => currentTitle = newValue!,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          textFocusNodeTitle!.unfocus();
                          FocusScope.of(context).requestFocus(textFocusNodeDesc);
                        },
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        decoration:  InputDecoration(
                          disabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.grey, width: 1),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: kPrimaryColor, width: 1),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color:kPrimaryColor, width: 2),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.redAccent, width: 2),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          contentPadding: const EdgeInsets.only(
                            left: 16,
                            bottom: 16,
                            top: 16,
                            right: 16,
                          ),
                          hintText: 'eg: Birthday party of John',
                          hintStyle: TextStyle(
                            color: Colors.grey.withOpacity(0.6),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),

                          errorStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          text: 'Description',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontFamily: 'Raleway',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' ',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        enabled: true,
                        maxLines: null,
                        cursorColor: kPrimaryColor,
                        focusNode: textFocusNodeDesc,
                        controller: textControllerDesc,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          setState(() {
                            currentDesc = value;
                          });
                        },
                        onSaved: (newValue) => currentDesc = newValue!,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter description';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          textFocusNodeDesc!.unfocus();
                          FocusScope.of(context).requestFocus(textFocusNodeLocation);
                        },
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        decoration:  InputDecoration(
                          disabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.grey, width: 1),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: kPrimaryColor, width: 1),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: kPrimaryColor, width: 2),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.redAccent, width: 2),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          contentPadding: const EdgeInsets.only(
                            left: 16,
                            bottom: 16,
                            top: 16,
                            right: 16,
                          ),
                          hintText: 'eg: Some information about this event',
                          hintStyle: TextStyle(
                            color: Colors.grey.withOpacity(0.6),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          text: 'Location',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontFamily: 'Raleway',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' ',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        enabled: true,
                        cursorColor: kPrimaryColor,
                        focusNode: textFocusNodeLocation,
                        controller: textControllerLocation,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          setState(() {
                            currentLocation = value;
                          });
                        },
                        onSaved: (newValue) => currentLocation = newValue!,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter location';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          textFocusNodeLocation!.unfocus();
                          FocusScope.of(context).requestFocus(textFocusNodeAttendee);
                        },
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        decoration:  InputDecoration(
                          disabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.grey, width: 1),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color:kPrimaryColor, width: 1),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: kPrimaryColor, width: 2),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.redAccent, width: 2),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          contentPadding: const EdgeInsets.only(
                            left: 16,
                            bottom: 16,
                            top: 16,
                            right: 16,
                          ),
                          hintText: 'Place of the event',
                          hintStyle: TextStyle(
                            color: Colors.grey.withOpacity(0.6),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          text: 'Attendees',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontFamily: 'Raleway',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' ',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const PageScrollPhysics(),
                        itemCount: attendeeEmails.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  attendeeEmails[index].email!,
                                  style: const TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      attendeeEmails.removeAt(index);
                                    });
                                  },
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              enabled: true,
                              cursorColor: kPrimaryColor,
                              focusNode: textFocusNodeAttendee,
                              controller: textControllerAttendee,
                              textCapitalization: TextCapitalization.none,
                              textInputAction: TextInputAction.done,
                              onSaved: (newValue) => currentEmail = newValue!,

                              onFieldSubmitted: (value) {
                                textFocusNodeAttendee!.unfocus();
                              },

                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  setState(() {
                                    currentEmail = value;
                                      _formKey.currentState!.validate();
                                  });
                                } else if (emailValidatorRegExp.hasMatch(value)) {

                                   _formKey.currentState!.validate();
                                }
                                return;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return kEmailNullError;
                                } else if (!emailValidatorRegExp.hasMatch(value)) {
                                  return kInvalidEmailError;
                                }
                                return null;
                              },
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                              decoration: InputDecoration(
                                disabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: Colors.grey, width: 1),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: kPrimaryColor, width: 1),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color:kPrimaryColor, width: 2),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: Colors.redAccent, width: 2),
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                contentPadding: const EdgeInsets.only(
                                  left: 16,
                                  bottom: 16,
                                  top: 16,
                                  right: 16,
                                ),
                                hintText: 'Enter attendee email',
                                hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.6),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),

                                errorStyle: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.check_circle,
                              color:kPrimaryColor,
                              size: 35,
                            ),
                            onPressed: () {
                              setState(() {
                                isEditingEmail = true;
                              });
                              if (emailValidatorRegExp.hasMatch(currentEmail!)) {
                                setState(() {
                                  textFocusNodeAttendee!.unfocus();
                                  calendar.EventAttendee eventAttendee = calendar.EventAttendee();
                                  eventAttendee.email = currentEmail;

                                  attendeeEmails.add(eventAttendee);

                                  textControllerAttendee!.text = '';
                                  currentEmail = null;
                                  isEditingEmail = false;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      Visibility(
                        visible: attendeeEmails.isNotEmpty,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Notify attendees',
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontFamily: 'Raleway',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Switch(
                                  value: shouldNofityAttendees,
                                  onChanged: (value) {
                                    setState(() {
                                      shouldNofityAttendees = value;
                                    });
                                  },
                                  activeColor: kPrimaryColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Add video conferencing',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontFamily: 'Raleway',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Switch(
                            value: hasConferenceSupport,
                            onChanged: (value) {
                              setState(() {
                                hasConferenceSupport = value;
                              });
                            },
                            activeColor: kPrimaryColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Container(
                        width: double.maxFinite,
                        child: ElevatedButton(

                          onPressed: isDataStorageInProgress
                              ? null
                              : () async {
                            setState(() {
                              isErrorTime = false;
                              isDataStorageInProgress = true;
                            });

                            textFocusNodeTitle!.unfocus();
                            textFocusNodeDesc!.unfocus();
                            textFocusNodeLocation!.unfocus();
                            textFocusNodeAttendee!.unfocus();

                            if (_formKey.currentState!.validate() &&
                                selectedDate != null &&
                                selectedStartTime != null &&
                                selectedEndTime != null &&
                                currentTitle != null) {
                              _formKey.currentState!.save();
                              int startTimeInEpoch = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedStartTime.hour,
                                selectedStartTime.minute,
                              ).millisecondsSinceEpoch;

                              int endTimeInEpoch = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedEndTime.hour,
                                selectedEndTime.minute,
                              ).millisecondsSinceEpoch;

                              print('DIFFERENCE: ${endTimeInEpoch - startTimeInEpoch}');

                              print('Start Time: ${DateTime.fromMillisecondsSinceEpoch(startTimeInEpoch)}');
                              print('End Time: ${DateTime.fromMillisecondsSinceEpoch(endTimeInEpoch)}');

                              if (endTimeInEpoch - startTimeInEpoch > 0) {
                                print('here:1');
                                if (_formKey.currentState!.validate() && user != null) {
                                  _formKey.currentState!.save();
                                  KeyboardUtil.hideKeyboard(context);
                                  print('here:2');
                                  await calendarClient
                                      .insert(
                                      title: currentTitle!,
                                      description: currentDesc ?? '',
                                      location: currentLocation!,
                                      attendeeEmailList: attendeeEmails,
                                      shouldNotifyAttendees: shouldNofityAttendees,
                                      hasConferenceSupport: hasConferenceSupport,
                                      startTime: DateTime.fromMillisecondsSinceEpoch(startTimeInEpoch),
                                      endTime: DateTime.fromMillisecondsSinceEpoch(endTimeInEpoch))
                                      .then((eventData) async {
                                    String eventId = eventData['id']!;
                                    String eventLink = eventData['link']!;

                                    List<String> emails = [];

                                    for (int i = 0; i < attendeeEmails.length; i++) {
                                      emails.add(attendeeEmails[i].email!);
                                    }

                                    EventInfo eventInfo = EventInfo(
                                      id: eventId,
                                      name: currentTitle!,
                                      description: currentDesc ?? '',
                                      location: currentLocation!,
                                      link: eventLink,
                                      date: textControllerDate!.text,
                                      attendeeEmails: emails,
                                      shouldNotifyAttendees: shouldNofityAttendees,
                                      hasConfereningSupport: hasConferenceSupport,
                                      startTimeInEpoch: startTimeInEpoch,
                                      endTimeInEpoch: endTimeInEpoch,
                                      status: 'Booked'
                                    );

                                    await storage
                                        .storeEventData(eventInfo,user!.uid.toString())
                                        .whenComplete(() =>   showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return DialogConfirmation(
                                            details:
                                            'Your appointment is being confirmed  with Dr.Crypto on 3rd Sept',
                                            subTitle: 'Your Appointment Successful',
                                            title: 'Thank you!',
                                            press: () {
                                              Navigator.of(context).pushNamedAndRemoveUntil(
                                                  HomePage.routeName, (route) => false);
                                            },
                                          );
                                        }))
                                        .catchError(
                                          (e) => print(e),
                                    );
                                  }).catchError(
                                        (e) => print(e),
                                  );

                                  setState(() {
                                    isDataStorageInProgress = false;
                                  });
                                } else {
                                  setState(() {
                                    isEditingTitle = true;
                                    isEditingLink = true;
                                  });
                                }
                              } else {
                                setState(() {
                                  isErrorTime = true;
                                  errorString = 'Invalid time! Please use a proper start and end time';
                                });
                              }
                            } else {
                              setState(() {
                                isEditingDate = true;
                                isEditingStartTime = true;
                                isEditingEndTime = true;
                                isEditingBatch = true;
                                isEditingTitle = true;
                                isEditingLink = true;
                              });
                            }
                            setState(() {
                              isDataStorageInProgress = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(  shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8.0))),),


                          child: Padding(
                            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                            child: isDataStorageInProgress
                                ? const SizedBox(
                              height: 28,
                              width: 28,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                                : const Text(
                              'ADD',
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: isErrorTime,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              errorString,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
