package dft;

import org.junit.Test;
import org.omg.CORBA.DoubleHolder;

import static org.junit.Assert.*;

/**
 * Created by mathiasquintero on 6/19/16.
 */
public class ComplexTest {

	private static final double MIN_FOR_NON_ZERO = Math.pow(10, -10);

	@Test
	public void add() throws Exception {

	}

	@Test
	public void sub() throws Exception {

	}

	@Test
	public void mul() throws Exception {

	}

	@Test
	public void power() throws Exception {
		Complex i = new Complex(0, 1);
		Tuple<Double>[] res = new Tuple[4];
		res[0] = new Tuple<Double>(1.0, 0.0);
		res[1] = new Tuple<Double>(0.0, 1.0);
		res[2] = new Tuple<Double>(-1.0, 0.0);
		res[3] = new Tuple<Double>(0.0, -1.0);
		for (int j = -16; j < 16; j++) {
			Complex r = i.power(j);
			Tuple<Double> t = res[(j % 4 + 4) % 4];
			double re = t.__1;
			double im = t.__2;
			assertTrue(re == r.getReal());
			assertTrue(im == r.getImaginaer());
		}
		for (int j = 0; j < 100; j++) {
			double re = Math.random() * 100;
			double im = Math.random() * 100;
			int pow = 2 + (int) (Math.random() * 10);
			Complex c = new Complex(re, im);
			Complex poweredResult = c.power(pow);
			System.out.println(poweredResult);
		}
	}

	@Test
	public void conjugate() throws Exception {
		for (int i = 0; i < 100; i++) {
			double re = Math.random() * 100;
			double im = Math.random() * 100;
			Complex f = new Complex(re, im);
			Complex co = f.conjugate();
			Complex doublyConj = co.conjugate();
			assertTrue(f.getReal() == doublyConj.getReal());
			assertTrue(f.getImaginaer() == doublyConj.getImaginaer());
		}
	}

	@Test
	public void fromPolar() throws Exception {
		for (int i = 0; i < 100; i++) {
			double phi = Math.random() * 2 * Math.PI - Math.PI;
			double radius = Math.random() * 100;
			Complex c = Complex.fromPolar(radius, phi);
			double ophi = c.getPhi();
			double oradius = c.getRadius();
			assertTrue(Math.abs(phi - ophi) < MIN_FOR_NON_ZERO);
			assertTrue(Math.abs(radius - oradius) < MIN_FOR_NON_ZERO);
		}
	}

}