class NameService {
  static String getFullName(String short) {
    if (short == "baginski") {
      return "Lukas Baginski";
    } else if (short == "engel") {
      return "Simon Engel";
    } else if (short == "boettger") {
      return "Friedrich Böttger";
    } else if (short == "krinke") {
      return "Lukas Krinke";
    } else if (short == "thomas") {
      return "Jan Thomas";
    } else if (short == "soentgerath") {
      return "Julius Söntgerath";
    } else if (short == "wendland") {
      return "Sebastian Wendland";
    } else if (short == "albrecht") {
      return "Michael Albrecht";
    } else if (short == "buch") {
      return "Jahrbuch";
    } else {
      return "Fehler";
    }
  }

  static int getId(String short) {
    if (short == "baginski") {
      return 1;
    } else if (short == "engel") {
      return 2;
    } else if (short == "boettger") {
      return 4;
    } else if (short == "krinke") {
      return 3;
    } else if (short == "thomas") {
      return 5;
    } else if (short == "soentgerath") {
      return 6;
    } else if (short == "wendland") {
      return 7;
    } else if (short == "albrecht") {
      return 8;
    } else if (short == "buch") {
      return 9;
    } else {
      return -1;
    }
  }

  static String getImagePath(String short) {
    if (short == "baginski") {
      return "assets/images/baginski.png";
    } else if (short == "engel") {
      return "assets/images/engel.png";
    } else if (short == "boettger") {
      return "assets/images/boettger.png";
    } else if (short == "krinke") {
      return "assets/images/krinke.png";
    } else if (short == "thomas") {
      return "assets/images/thomas.png";
    } else if (short == "soentgerath") {
      return "assets/images/baginski.png";
    } else if (short == "wendland") {
      return "assets/images/user.png";
    } else if (short == "albrecht") {
      return "assets/images/user.png";
    } else if (short == "buch") {
      return "assets/images/engel.png";
    } else {
      return "Fehler";
    }
  }
}
