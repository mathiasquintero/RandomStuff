import java.util.function.BiFunction;
import java.util.function.Function;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Calculator built using Regular Expressions
 * Just for the lols ;D
 */
public class RegexCalculator {

    private static final String number = "(-)?([ ]*(([0-9]+[.][0-9]+)|([0-9]+))[ ]*)";

    private static String forEachNumberIn(String str, String pattern, Function<Double[], Double> f) {
        Matcher all = Pattern.compile(pattern).matcher(str);
        while (all.find()) {
            String s = all.group(0);
            Matcher m = Pattern.compile(number).matcher(s);
            String n = "";
            while (m.find()) {
                n += m.group(0) + ",";
            }
            String[] numberStrings = n.split(",");
            Double[] numbers = new Double[numberStrings.length];
            for (int i = 0; i < numberStrings.length; i++) {
                numbers[i] = Double.parseDouble(numberStrings[i]);
            }
            str = str.replace(s, f.apply(numbers).toString());
        }
        return str;
    }

    private static String multiOp(String str, String op, BiFunction<Double, Double, Double> f, Double neutral) {
        return forEachNumberIn(str, number + "(" + op + number + ")+", (x) -> {
            double res = neutral;
            for (int i = 0; i < x.length; i++) {
                res = f.apply(res, x[i]);
            }
            return res;
        });
    }

    private static String singleOp(String str, String op, BiFunction<Double, Double, Double> f) {
        return forEachNumberIn(str, number + op + number, (x) -> {
           return f.apply(x[0], x[1]);
        });
    }

    private static String brackets(String str) {
        return forEachNumberIn(str, "[(]" + number + "[)]", (x) -> {
            return x[0];
        });
    }

    private static String sum(String str) {
        return multiOp(str, "[+|-]", (a,b) -> a + b, 0.0);
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

    private static double parse(String str) {
        try {
            double res = Double.parseDouble(str);
            return res;
        } catch (Exception e) {
            String s = str;
            str = pow(str);
            str = div(str);
            str = mult(str);
            str = sum(str);
            str = brackets(str);
            if (s != str) {
                return parse(str);
            } else {
                throw new IllegalArgumentException("The expression you entered could not be parsed");
            }
        }
    }

    public static void main(String[] args) {
        String s = "";
        for (String str : args) {
            s += str;
        }
        double r = parse(s);
        System.out.println(r);
    }

}
