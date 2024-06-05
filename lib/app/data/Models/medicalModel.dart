import 'package:cloud_firestore/cloud_firestore.dart';
// ignore_for_file: file_names

// ignore_for_file: non_constant_identifier_names

class MedicalModel {
  final String date;
  final String meetingStatus;
  final String Fphone;
  final bool count;
  final String FMname1;
  final String Token;
  final Doctor doctor;
  final String uid;
  final String FMname;
  final String FMphone;
  final String FMphone1;
  final bool prescription;
  final Patient patient;
  final int pressedTime;
  final String time;
  final String Fname;

  MedicalModel({
    required this.date,
    required this.meetingStatus,
    required this.Fphone,
    required this.count,
    required this.FMname1,
    required this.Token,
    required this.doctor,
    required this.uid,
    required this.FMname,
    required this.FMphone,
    required this.FMphone1,
    required this.prescription,
    required this.patient,
    required this.pressedTime,
    required this.time,
    required this.Fname,
  });

  factory MedicalModel.fromJson(Map<String, dynamic> data) {
    return MedicalModel(
      date: data['date'] ?? '',
      meetingStatus: data['meetingStatus'] ?? '',
      Fphone: data['Fphone'] ?? '',
      count: data['count'] ?? false,
      FMname1: data['FMname1'] ?? '',
      Token: data['Token'] ?? '',
      doctor: Doctor.fromJson(data['doctor'] ?? {}),
      uid: data['uid'] ?? '',
      FMname: data['FMname'] ?? '',
      FMphone: data['FMphone'] ?? '',
      FMphone1: data['FMphone1'] ?? '',
      prescription: data['prescription'] ?? false,
      patient: Patient.fromJson(data['patient'] ?? {}),
      pressedTime: (data['pressedTime'] as Timestamp).millisecondsSinceEpoch,
      time: data['time'] ?? '',
      Fname: data['Fname'] ?? '',
    );
  }
}

class Doctor {
  final String DoctorID;
  final String patientName;
  final String patientEmail;
  final String description;
  final String meetingId;
  final String patientAddress;
  final String patientPhone;

  Doctor({
    required this.DoctorID,
    required this.patientName,
    required this.patientEmail,
    required this.description,
    required this.meetingId,
    required this.patientAddress,
    required this.patientPhone,
  });

  factory Doctor.fromJson(Map<String, dynamic> data) {
    return Doctor(
      DoctorID: data['DoctorID'] ?? '',
      patientName: data['patientName'] ?? '',
      patientEmail: data['patientEmail'] ?? '',
      description: data['description'] ?? '',
      meetingId: data['meetingId'] ?? '',
      patientAddress: data['patientAddress'] ?? '',
      patientPhone: data['patientPhone'] ?? '',
    );
  }
}

class Patient {
  final String disease;
  final String thingsToDo;
  final String PatientID;
  final String medicine;
  final String testNeeded;

  Patient({
    required this.disease,
    required this.thingsToDo,
    required this.PatientID,
    required this.medicine,
    required this.testNeeded,
  });

  factory Patient.fromJson(Map<String, dynamic> data) {
    return Patient(
      disease: data['disease'] ?? '',
      thingsToDo: data['thingsToDo'] ?? '',
      PatientID: data['PatientID'] ?? '',
      medicine: data['medicine'] ?? '',
      testNeeded: data['testNeeded'] ?? '',
    );
  }
}
