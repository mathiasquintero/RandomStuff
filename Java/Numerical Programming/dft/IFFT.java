package dft;

import java.util.Arrays;

/**
 * Schnelle inverse Fourier-Transformation
 *
 * @author Sebastian Rettenberger
 */
public class IFFT {

	/**
	 * Schnelle inverse Fourier-Transformation (IFFT).
	 *
	 * Die Funktion nimmt an, dass die Laenge des Arrays c immer eine
	 * Zweierpotenz ist. Es gilt also: c.length == 2^m fuer ein beliebiges m.
	 */
	public static Complex[] ifft(Complex[] c) {
		if (c.length == 1) return c;
		int m = c.length / 2;
		Complex[] left = new Complex[m];
		Complex[] right = new Complex[m];
		for (int i = 0; i < c.length; i+=2) {
			left[i/2] = c[i];
			right[i/2] = c[i+1];
		}
		left = ifft(left);
		right = ifft(right);
		return merge(left, right);
	}

	public static Complex[] merge(Complex[] left, Complex[] right) {
		Complex[] c = new Complex[2 * left.length];
		Complex w = Complex.createWForIFFT(2 * left.length);
		for (int i = 0; i < left.length; i++) {
			Tuple<Complex> butterflyResult = butterfly(left[i], right[i], w, i);
			c[i] = butterflyResult.__1;
			c[left.length + i] = butterflyResult.__2;
		}
		return c;
	}

	public static Tuple<Complex> butterfly(Complex a, Complex b, Complex w, int pow) {
		Complex wp = w.power(pow);
		Complex mul = b.mul(wp);
		Complex resA = a.add(mul);
		Complex resB = a.sub(mul);
		return new Tuple<>(resA, resB);
	}

}
