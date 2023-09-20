class EmptyStatesService {
  List<String> instrumentsEmptyStateSentences = [
    "High-five! All instruments are settled up! 🙌",
    "No lent or misplaced instruments in sight! 🥳",
    "Your instrument inventory is shining bright ✨",
    "Nice work! Your instrument inventory is on point 🪥",
    "All tools are in place ... for now 😉"
  ];

  List<String> patientsEmptyStateSentences = [
    "All patients are keeping doctors away today! 🍏 \nAdd a patient to keep doctors busy! 😄",
    "Patients are as rare as doctors on vacation! 🏖️ \nAdd a patient to liven things up! 😁",
  ];

  List<String> todayAppointmentsEmptyStateSentences = [
    "Today's Schedule is Clear 📅. \nBook an Appointment?",
    "No Appointments for Today 🌞. \nTime to Add One?",
    "Today's a Blank Canvas 🎨. \nAdd an Appointment to Color Your Day!",
    "Clear Schedule, Full Potential! 💪 \nWhy Not Add an Appointment?"
  ];

  List<String> weekAppointmentsEmptyStateSentences = [
    "Your Weekly Calendar awaiting Adventures 🌟. \nBegin with an Appointment!",
    "No Future Plans? 📅 \nWhy Not Start by Booking an Appointment?",
    "Missing Appointments This week ⌛. \nTime to Fill the Gaps!",
    "This Week is like The Quiet Before the Storm 🌩️. \nMake It Thunder with an Appointment!",
    "This Week's Schedule is as Empty as a Desert 🌵. \nSpice It Up with an Appointment!",
    "Upcoming Appointments: Zero 📉. \nTime to Refill the Fun Meter!"
  ];

  String generateInstrumentsEmptyState() {
    instrumentsEmptyStateSentences.shuffle();
    return instrumentsEmptyStateSentences.first;
  }

  String generatePatientsEmptyState() {
    patientsEmptyStateSentences.shuffle();
    return patientsEmptyStateSentences.first;
  }

  String generateTodayAppointmentsEmptyState() {
    todayAppointmentsEmptyStateSentences.shuffle();
    return todayAppointmentsEmptyStateSentences.first;
  }

  String generateWeekAppointmentsEmptyState() {
    weekAppointmentsEmptyStateSentences.shuffle();
    return weekAppointmentsEmptyStateSentences.first;
  }
}
