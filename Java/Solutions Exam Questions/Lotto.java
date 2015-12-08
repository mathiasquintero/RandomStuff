public class Lotto {

  public static int sumRec(int n) {
    if (n<=0) return 0;
    else return n + sumRec(n-1);
  }

  public static boolean isAlreadyInArray(int[] a, int n) {
    for (int i=0;i<a.length;i++) {
      if(a[i]==n) return true;
    }
    return false;
  }

  public static int[] ziehung() {
    int[] zug = new int[6];
    for (int i = 0;i<zug.length;i++) {
      boolean didWrite = false;
      while(!didWrite) {
        int r = (int) (Math.random() * 50);
        if (!isAlreadyInArray(zug,r)) {
          zug[i] = r;
          didWrite = true;
        }
      }
    }
    return zug;
  }

  public static int[] schnitt(int[] ziehung, int[] tipp) {
    int[] s = new int[Math.min(ziehung.length,tipp.length)];
    int a = 0;
    for (int i=0;i<ziehung.length;i++) {
      for (int j=0;j<tipp.length;j++) {
        if (ziehung[i] == tipp[j]) {
          s[a] = ziehung[i];
          a++;
        }
      }
    }
    int[] schnitt = new int[a];
    for (int i=0;i<a;i++) {
      schnitt[i] = s[i];
    }
    return schnitt;
  }

  /**
   * Will print an Array to the console!
   * @param array you want to print
   */
  public static void printArray(int[] array) {
    for(int i=0;i<array.length;i++) {
      System.out.println(i + ": " + array[i]);
    }
  }

  public static void main(String[] args) {
    int[] zug = ziehung();
    int[] gewonnen = ziehung();
    printArray(zug);
    System.out.println();
    printArray(gewonnen);
    System.out.println();
    int[] same = schnitt(zug,gewonnen);
    printArray(same);
  }

}
