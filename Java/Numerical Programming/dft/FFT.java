package dft;

import java.util.Arrays;

/**
 * Created by mathiasquintero on 6/19/16.
 */
public class FFT {

	private static Complex[] conjugateVector(Complex[] c) {
		Complex[] res = new Complex[c.length];
		for (int i = 0; i < c.length; i++) {
			res[i] = c[i].conjugate();
		}
		return res;
	}

	private static Complex[] multiplyVector(Complex[] c, double factor) {
		Complex[] res = new Complex[c.length];
		for (int i = 0; i < c.length; i++) {
			res[i] = c[i].mul(new Complex(factor));
		}
		return res;
	}

	public static Complex[] fft(Complex[] c) {
		Complex[] conjugated = conjugateVector(c);
		Complex[] postIFFT = IFFT.ifft(conjugated);
		Complex[] conjugatedResult = conjugateVector(postIFFT);
		double f = (1 / ((double) c.length));
		return multiplyVector(conjugatedResult, f);
	}

	public static Complex[] fft(double[] d) {
		Complex[] c = new Complex[d.length];
		for (int i = 0; i < d.length; i++) {
			c[i] = new Complex(d[i]);
		}
		return fft(c);
	}

}
