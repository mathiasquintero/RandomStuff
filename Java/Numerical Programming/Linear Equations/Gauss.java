public class Gauss {

    private static boolean isNull(double x) {
        return Math.abs(x) < Math.pow(10, -10);
    }

	/**
	 * Diese Methode soll die Loesung x des LGS R*x=b durch
	 * Rueckwaertssubstitution ermitteln.
	 * PARAMETER: 
	 * R: Eine obere Dreiecksmatrix der Groesse n x n 
	 * b: Ein Vektor der Laenge n
	 */
	public static double[] backSubst(double[][] R, double[] b) {
		double[][] copyR = copy(R);
        double[] copyB = copy(b);
        for (int i = copyR.length-1; i > 0; i--) {
            for (int j = i - 1; j >= 0; j--) {
                if (copyR[i][i] != 0) {
                    double factor = -(copyR[j][i] / copyR[i][i]);
                    sumRows(copyR, copyB, j, i, factor);
                }
            }
        }
        for (int i = 0; i < copyR.length; i++) {
            if (copyR[i][i] == 0) {
                if (copyB[i] != 0)
                    throw new RuntimeException("Error. Not solvable");
                continue;
            }
            copyB[i] /= copyR[i][i];
        }
        return copyB;
	}

	/**
	 * Diese Methode soll die Loesung x des LGS A*x=b durch Gauss-Elimination mit
	 * Spaltenpivotisierung ermitteln. A und b sollen dabei nicht veraendert werden. 
	 * PARAMETER: A:
	 * Eine regulaere Matrix der Groesse n x n 
	 * b: Ein Vektor der Laenge n
	 */
	public static double[] solve(double[][] A, double[] b) {
        double[][] copyA = copy(A);
        double[] bCopy = copy(b);
        getNormalForm(copyA, bCopy);
        return backSubst(copyA, bCopy);
    }

    /**
     * Copies a single Vector
     * @param b
     * @return
     */
    private static double[] copy(double[] b) {
        double[] res = new double[b.length];
        for (int i = 0; i < b.length; i++)
            res[i] = b[i];
        return res;
    }

    /**
     * Copies a Matrix
     * @param A
     * @return
     */
    private static double[][] copy(double[][] A) {
        double[][] res = new double[A.length][];
        for (int i = 0; i < A.length; i++)
            res[i] = copy(A[i]);
        return res;
    }

    /**
     * Will turn a System of LE's and turn it into the Normal Right Triangle Matrix.
     * Warning: This is done in-place
     * @param A
     * @param b
     */
	private static void getNormalForm(double[][] A, double[] b) {
        pivotColumns(A, b);
        for (int i = 0; i < A.length; i++) {
            if (!isNull(A[i][i])) {
                for (int j = i+1; j < A.length; j++) {
                    double factor = -(A[j][i] / A[i][i]);
                    sumRows(A, b, j, i, factor);
                }
            } else {
                A[i][i] = 0;
            }
        }
    }

    /**
     * Will make sure the biggest main diagonal has the biggest numbers
     * for precision purposes.
     * @param A
     * @param b
     */
    private static void pivotColumns(double[][] A, double[] b) {
        for (int i = 0; i < A.length; i++) {
            int biggestIndex = i;
            for (int j = i; j < A.length; j++)
                if (A[biggestIndex][i] < A[j][i]) biggestIndex = j;
            swapRows(A, b, i, biggestIndex);
        }
    }

    /**
     * Will add factor*rowB to rowA
     * @param A
     * @param b
     * @param rowA
     * @param rowB
     * @param factor
     */
    private static void sumRows(double[][] A, double[] b, int rowA, int rowB, double factor) {
        for (int i = 0; i < A.length; i++)
            A[rowA][i] += factor * A[rowB][i];
        b[rowA] += factor * b[rowB];
    }

    /**
     * Will swap rowA and rowB
     * @param A
     * @param b
     * @param rowA
     * @param rowB
     */
    private static void swapRows(double[][] A, double[] b, int rowA, int rowB) {
        double tmpb = b[rowA];
        double[] tmpA = A[rowA];
        b[rowA] = b[rowB];
        b[rowB] = tmpb;
        A[rowA] = A[rowB];
        A[rowB] = tmpA;
    }

	/**
	 * Diese Methode soll eine Loesung p!=0 des LGS A*p=0 ermitteln. A ist dabei
	 * eine nicht invertierbare Matrix. A soll dabei nicht veraendert werden.
	 * 
	 * Gehen Sie dazu folgendermassen vor (vgl.Aufgabenblatt): 
	 * -Fuehren Sie zunaechst den Gauss-Algorithmus mit Spaltenpivotisierung 
	 *  solange durch, bis in einem Schritt alle moeglichen Pivotelemente
	 *  numerisch gleich 0 sind (d.h. <1E-10) 
	 * -Betrachten Sie die bis jetzt entstandene obere Dreiecksmatrix T und
	 *  loesen Sie Tx = -v durch Rueckwaertssubstitution 
	 * -Geben Sie den Vektor (x,1,0,...,0) zurueck
	 * 
	 * Sollte A doch intvertierbar sein, kann immer ein Pivot-Element gefunden werden(>=1E-10).
	 * In diesem Fall soll der 0-Vektor zurueckgegeben werden. 
	 * PARAMETER: 
	 * A: Eine singulaere Matrix der Groesse n x n 
	 */
	public static double[] solveSing(double[][] A) {
        A = copy(A);
        double[] b = new double[A.length];
        getNormalForm(A, b);
        boolean isFinished = true;
        int lastIndex = A.length - 1;
        for (int i = 0; i < A.length; i++) {
            if (isNull(A[i][i])) {
                A[i][i] = 0;
                isFinished = false;
                lastIndex = Math.min(i, lastIndex);
            }
        }
        if (isFinished)
            return backSubst(A, b);
        double[][] copy = new double[lastIndex][lastIndex];
        double[] v = new double[lastIndex];
        for (int i = 0; i < lastIndex; i++) {
            v[i] = -A[i][lastIndex];
            for (int j = 0; j < lastIndex; j++) {
                copy[i][j] = A[i][j];
            }
        }
        double[] x = solve(copy, v);
        double[] res = new double[A.length];
        for (int i = 0; i < x.length; i++)
            res[i] = x[i];
        res[x.length] = 1;
        return res;
    }

	/**
	 * Diese Methode berechnet das Matrix-Vektor-Produkt A*x mit A einer nxm
	 * Matrix und x einem Vektor der Laenge m. Sie eignet sich zum Testen der
	 * Gauss-Loesung
	 */
	public static double[] matrixVectorMult(double[][] A, double[] x) {
		int n = A.length;
		int m = x.length;
		double[] y = new double[n];
		for (int i = 0; i < n; i++) {
			y[i] = 0;
			for (int j = 0; j < m; j++) {
				y[i] += A[i][j] * x[j];
			}
		}
		return y;
	}

}
