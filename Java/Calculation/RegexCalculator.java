import java.util.function.BiFunction;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Calculator built using Regular Expressions
 * Just for the lols ;D
 */
public class RegexCalculator {

    private static final String number = "([ ]*(([0-9]+[.][0-9]+)|([0-9]+))[ ]*)";

    private static String multiOp(String str, String op, BiFunction<Double, Double, Double> f, Double neutral) {
        Matcher all = Pattern.compile(number + "(" + op + number + ")+").matcher(str);
        while (all.find()) {
            String s = all.group(0);
            Matcher m = Pattern.compile(number).matcher(s);
            String n = "";
            while (m.find()) {
                n += m.group(0) + ",";
            }
            String[] numbers = n.split(",");
            double res = neutral;
            for (int i = 0; i < numbers.length; i++) {
                res = f.apply(res, Double.parseDouble(numbers[i]));
            }
            str = str.replace(s, res + "");
        }
        return str;
    }

    private static String singleOp(String str, String op, BiFunction<Double, Double, Double> f) {
        Matcher all = Pattern.compile(number + op + number).matcher(str);
        while (all.find()) {
            String s = all.group(0);
            Matcher m = Pattern.compile(number).matcher(s);
            String n = "";
            while (m.find()) {
                n += m.group(0) + ",";
            }
            String[] numbers = n.split(",");
            double res = f.apply(Double.parseDouble(numbers[0]), Double.parseDouble(numbers[1]));
            str = str.replace(s, res + "");
        }
        return str;
    }

    private static String sum(String str) {
        return multiOp(str, "[+]", (a,b) -> a + b, 0.0);
    }

    private static String min(String str) {
        return singleOp(str, "[-]", (a,b) -> a - b);
    }

    private static String mult(String str) {
        return multiOp(str, "[*]", (a,b) -> a * b, 1.0);
    }

    private static String div(String str) {
        return singleOp(str, "[/]", (a,b) -> a / b);
    }

    private static String pow(String str) {
        return singleOp(str, "^", (a,b) -> Math.pow(a,b));
    }

    private static String brackets(String str) {
        Matcher all = Pattern.compile("[(]" + number + "[)]").matcher(str);
        while (all.find()) {
            String s = all.group(0);
            Matcher m = Pattern.compile(number).matcher(s);
            String n = "";
            while (m.find()) {
                n += m.group(0);
            }
            str = str.replace(s, n);
        }
        return str;
    }

    private static double parse(String str) {
        try {
            double res = Double.parseDouble(str);
            return res;
        } catch (Exception e) {
            String s = str;
            str = pow(str);
            str = div(str);
            str = mult(str);
            str = min(str);
            str = sum(str);
            if (s != str) {
                return parse(str);
            } else {
                return 0.0;
            }
        }
    }

    public static void main(String[] args) {
        String s = "";
        for (String str : args) {
            s += str;
        }
        Double r = parse(s);
        System.out.println(r);
    }

}
