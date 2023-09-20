class EmptyStatesService {
  List<String> instrumentsEmptyStateSentences = [
    "High-five! All instruments are settled up! 🙌",
    "No lent or misplaced instruments in sight! 🥳",
    "Your instrument inventory is shining bright ✨",
    "Nice work! Your instrument inventory is on point 🪥",
    "All tools are in place ... for now 😉"
  ];

  List<String> patientssEmptyStateSentences = [
    "All patients are keeping doctors away today! 🍏 \nAdd a patient to keep doctors busy! 😄",
    "Patients are as rare as doctors on vacation! 🏖️ \nAdd a patient to liven things up! 😁",
  ];

  String generateInstrumentsEmptyState() {
    instrumentsEmptyStateSentences.shuffle();
    return instrumentsEmptyStateSentences.first;
  }

  String generatePatientsEmptyState() {
    patientssEmptyStateSentences.shuffle();
    return patientssEmptyStateSentences.first;
  }
}
