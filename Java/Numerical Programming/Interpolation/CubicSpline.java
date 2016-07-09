import java.util.Arrays;
import java.util.function.Function;

/**
 * Die Klasse CubicSpline bietet eine Implementierung der kubischen Splines. Sie
 * dient uns zur effizienten Interpolation von aequidistanten Stuetzpunkten.
 * 
 * @author braeckle
 * 
 */
public class CubicSpline implements InterpolationMethod {

	private static void hermite() {
		if (hermite.length == 4)
			return;
		hermite = new Function[4];
		hermite[0] = (x -> 1 - 3 * Math.pow(x, 2) + 2 * Math.pow(x, 3));
		hermite[1] = (x -> 3 * Math.pow(x, 2) - 2 * Math.pow(x, 3));
		hermite[2] = (x -> x - 2 * Math.pow(x, 2) + Math.pow(x, 3));
		hermite[3] = (x -> - Math.pow(x, 2) + Math.pow(x, 3));
	}

	private static Function<Double, Double>[] hermite = new Function[0];

	/** linke und rechte Intervallgrenze x[0] bzw. x[n] */
	double a, b;

	/** Anzahl an Intervallen */
	int n;

	/** Intervallbreite */
	double h;

	/** Stuetzwerte an den aequidistanten Stuetzstellen */
	double[] y;

	/** zu berechnende Ableitunge an den Stuetzstellen */
	double yprime[];

	/**
	 * {@inheritDoc} Zusaetzlich werden die Ableitungen der stueckweisen
	 * Polynome an den Stuetzstellen berechnet. Als Randbedingungen setzten wir
	 * die Ableitungen an den Stellen x[0] und x[n] = 0.
	 */
	@Override
	public void init(double a, double b, int n, double[] y) {
		this.a = a;
		this.b = b;
		this.n = n;
		h = ((double) b - a) / (n);

		this.y = Arrays.copyOf(y, n + 1);

		/* Randbedingungen setzten */
		yprime = new double[n + 1];
		yprime[0] = 0;
		yprime[n] = 0;

		/* Ableitungen berechnen. Nur noetig, wenn n > 1 */
		if (n > 1) {
			computeDerivatives();
		}
	}

	/**
	 * getDerivatives gibt die Ableitungen yprime zurueck
	 */
	public double[] getDerivatives() {
		return yprime;
	}

	/**
	 * Setzt die Ableitungen an den Raendern x[0] und x[n] neu auf yprime0 bzw.
	 * yprimen. Anschliessend werden alle Ableitungen aktualisiert.
	 */
	public void setBoundaryConditions(double yprime0, double yprimen) {
		yprime[0] = yprime0;
		yprime[n] = yprimen;
		if (n > 1) {
			computeDerivatives();
		}
	}

	/**
	 * Berechnet die Ableitungen der stueckweisen kubischen Polynome an den
	 * einzelnen Stuetzstellen. Dazu wird ein lineares System Ax=c mit einer
	 * Tridiagonalen Matrix A und der rechten Seite c aufgebaut und geloest.
	 * Anschliessend sind die berechneten Ableitungen y1' bis yn-1' in der
	 * Membervariable yprime gespeichert.
	 * 
	 * Zum Zeitpunkt des Aufrufs stehen die Randbedingungen in yprime[0] und yprime[n].
	 * Speziell bei den "kleinen" Faellen mit Intervallzahlen n = 2
	 * oder 3 muss auf die Struktur des Gleichungssystems geachtet werden. Der
	 * Fall n = 1 wird hier nicht beachtet, da dann keine weiteren Ableitungen
	 * berechnet werden muessen.
	 */
	public void computeDerivatives() {
		double[] v = new double[n - 1];
		double[] diag = new double[n - 1];
		double[] other = new double[n - 2];
		for (int i = 0; i < v.length; i++) {
			v[i] = 3/h * (y[i+2] - y[0]);
			diag[i] = 4;
		}
		for (int i = 0; i < other.length; i++) {
			other[i] = 1;
		}
		TridiagonalMatrix matrix = new TridiagonalMatrix(other, diag, other);
		double[] res = matrix.solveLinearSystem(v);
		for (int i = 0; i < res.length; i++) {
			yprime[i+1] = res[i];
		}
	}

	private double getX(int i) {
		return a + i * h;
	}

	/**
	 * {@inheritDoc} Liegt z ausserhalb der Stuetzgrenzen, werden die
	 * aeussersten Werte y[0] bzw. y[n] zurueckgegeben. Liegt z zwischen den
	 * Stuetzstellen x_i und x_i+1, wird z in das Intervall [0,1] transformiert
	 * und das entsprechende kubische Hermite-Polynom ausgewertet.
	 */
	@Override
	public double evaluate(double z) {
		int index = (int) ((z - a) / h);
		if (index < 0)
			throw new RuntimeException("Error: Attempt at Extrapolation.");
		if (index == y.length - 1)
			return y[y.length - 1];
		double t = (z - getX(index)) / h;
		hermite();
		double res = 0.0;
		for (int i = 0; i < 2; i++) {
			try {
				res += y[index + i] * hermite[i].apply(t);
				res += h * yprime[index + i] * hermite[2+i].apply(t);
			} catch (Exception e) {
				throw new RuntimeException("Error: Attempt at Extrapolation");
			}

		}
		return res;
	}
}
