library sample_pi_/*%UNIQUE_ID%*/;

import 'dart:math';

/*%IMPORT%*/

class PiCalc/*%UNIQUE_ID%*/ {
  String calcSpigot(final int n) {
    var pi = new List<int>();
    int boxes = (n * 10 / 3).truncate();
    var reminders = new List<int>(boxes);
    for (int i = 0; i < boxes; i++) {
      reminders[i] = 2;
    }
    int heldDigits = 0;
    for (int i = 0; i < n; i++) {
      int carriedOver = 0;
      int sum = 0;
      for (int j = boxes - 1; j >= 0; j--) {
        reminders[j] *= 10;
        sum = reminders[j] + carriedOver;
        int quotient = (sum / (j * 2 + 1)).truncate();
        reminders[j] = sum % (j * 2 + 1);
        carriedOver = quotient * j;
      }
      reminders[0] = sum % 10;
      int q = (sum / 10).truncate();
      if (q == 9) {
        heldDigits++;
      } else if (q == 10) {
        q = 0;
        for (int k = 1; k <= heldDigits; k++) {
          int replaced = /*int.parse(*/pi[i - k] /*.substring(i - k, i - k + 1)*/ /*)*/;
          if (replaced == 9) {
            replaced = 0;
          } else {
            replaced++;
          }
          pi.removeAt(i - k);
          pi.insert(i - k, replaced);
        }
        heldDigits = 1;
      } else {
        heldDigits = 1;
      }
      pi.add(q);
    }
    return pi.join('');
  }

  String defaultPreset(){
    return calcSpigot(99);
  }

  String random(){
    if (new DateTime.now().millisecond % 2 == 0){
      return defaultPreset();
    } else{
      return calcSpigot(new Random().nextInt(99));
    }
  }
}

String main(){
  StringBuffer result = new StringBuffer();
  int COUNT = new Random().nextInt(999999);
  var results = <String>[
    new PiCalc/*%UNIQUE_ID%*/().random(),
    /*%CALL%*/
  ];
  for(int i=0; i<= COUNT; i++) {
    result.writeln(results[i]);
  }
  /*%LAST_CALL%*/
  print(result.toString());
  return result.toString();
}