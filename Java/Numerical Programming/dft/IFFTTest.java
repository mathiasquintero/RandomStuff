package dft;

import org.junit.Test;

import java.util.Arrays;

import static org.junit.Assert.*;

/**
 * Created by mathiasquintero on 6/19/16.
 */
public class IFFTTest {

	private static final double MIN_FOR_NON_ZERO = Math.pow(10, -12);

	@Test
	public void ifft() throws Exception {
		for (int j = 0; j < 100; j++) {
			int length  = (int) Math.pow(2, 1 + ((int) Math.random() * 10));
			double[] items = new double[length];
			for (int i = 0; i < items.length; i++)
				items[i] = Math.random() * 1000;
			Complex[] dft = DFT.dft(items);
			Complex[] fft = FFT.fft(items);
			Complex[] res = IFFT.ifft(dft);
			for (int i = 0; i < res.length; i++) {
				assertTrue(Math.abs(res[i].getImaginaer()) < MIN_FOR_NON_ZERO);
				assertTrue(Math.abs(res[i].getReal() - items[i]) < MIN_FOR_NON_ZERO);
				assertTrue(Math.abs(dft[i].getImaginaer() - fft[i].getImaginaer()) < MIN_FOR_NON_ZERO);
				assertTrue(Math.abs(dft[i].getReal() - fft[i].getReal()) < MIN_FOR_NON_ZERO);
			}
		}
	}

}