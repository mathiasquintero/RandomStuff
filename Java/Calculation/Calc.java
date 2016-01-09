//package pfz;

public class Calc {

    public final int meaningOfLifeTheUniverseAndEverything = 42; //Just in case you're asking...

    //Is i a prime number

    public static boolean isPrime(long i){
        for(long a=2;a<Math.sqrt(i)+1;a++){
            if(i%a==0){
                return false;
            }
        }
        return true;
    }

    //Finds first prime i can be divided by

  public static int findPrimeDivider(int i) {
    for (int a=2;a<=Math.sqrt(i);a++) {
      if (i%a == 0) {
        return a;
      }
    }
    return i;
  }

    //Prim Faktor Zerlegung

  public static String pfz(int n) {
    String returnString = "";
    while (n != 1) {
      int i = findPrimeDivider(n);
      returnString += i;
      n /= i;
      if (n != 1)
        returnString += " * ";
    }
    return returnString;
  }

    //

    public static long stirlingZahl(int i,int j){
        if(i==j){
            return 1;
        }
        if(i==j-1){
            return bin(i,2);
        }
        if(j==0 && i>0){
            return 0;
        }
        if(j>0 && j>i){
            return 0;
        } else {
            return stirlingZahl(i-1,j-1)+(i-1)*stirlingZahl(i-1,j);
        }
    }
    public static int stirlingZahlZwei(int i,int j){
        if(i==0 && j==0){
            return 1;
        }
        if(j==0 && i>0){
            return 0;
        }
        if(j>0 && j>i){
            return 0;
        } else {
            return stirlingZahlZwei(i-1,j-1)+j*stirlingZahlZwei(i-1,j);
        }
    }

    public static int zahlPartition(int n, int k){
        if(k==0 && n==0){
            return 1;
        }
        if(k==0 || k>n){
            return 0;
        }
        int result = 0;
        for(int i=0;i<=k;i++){
            result+=zahlPartition(n-k,i);
        }
        return result;
    }

    public static int bin(int a, int b){
        return fak(a)/(fak(a-b)*fak(b));
    }

    public static int fak(int x){
        if (x < 0) throw new IllegalArgumentException();
        return x > 1 ? x*fak(x-1) : 1;
    }

    public static int ggT(int x, int y){
        int a = Math.min(Math.abs(x), Math.abs(y));
        int b = Math.max(Math.abs(x), Math.abs(y));
        return a == 0 ? b : ggT(b - a, a);
    }

    public static String translateToBase(long value, int base) {
        if(value < 0) return "-" + translateToBase(-value, base);
        String result = "";
        long temporaryValue = value;
        while(temporaryValue != 0) {
            char newDigit;
            if(temporaryValue % base < 10) {
                newDigit = (char) (temporaryValue % base + 48);
            } else {
                newDigit = (char) (temporaryValue % base + 87);
            }
            result = newDigit + result;
            temporaryValue /= base;
        }
        return result;
    }

    public static long fromBaseToDecimal(String value, int base) {
        if (base == 10) return Integer.parseInt(value);
        if (value.charAt(0) == '-') return - fromBaseToDecimal(value.substring(1), base);
        long result = 0;
        long decimalValueForMultiplication = 1;
        for (int i=value.length()-1;i>=0;i--) {
            char digit = value.charAt(i);
            int valueForDigit = Character.getNumericValue(digit);
            result += valueForDigit * decimalValueForMultiplication;
            decimalValueForMultiplication *= base;
        }
        return result;
    }

    public static void main(String[] args) {
        System.out.println(pfz(-42));
    }
}
