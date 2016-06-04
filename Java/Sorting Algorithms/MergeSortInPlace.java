import java.util.Arrays;

public class MergeSortInPlace extends SortingAlgorithm {

	public void sort(int[] a) {
		sort(a, 0, a.length-1);
	}


	/**
	 * MergeSort.
	 * @param a array
	 * @param l lower bound (Inclusive)
	 * @param r higher bound (Inclusive)
	 */
	private static void sort(int[] a, int l, int r) {
		if (l == r) return;
		int m = (int) (l/2 + r/2);
		sort(a, l, m);
		sort(a, m+1, r);
		merge(a, l, r);
	}

	/**
	 * Duh!
	 * @param a array
	 * @param i place
	 * @param j place
	 */
	private static void swap(int[] a, int i, int j) {
		int tmp = a[i];
		a[i] = a[j];
		a[j] = tmp;
	}

	/**
	 * Real Modulo Operation. I hate that % returns negative numbers!
 	 * @param a value
	 * @param b base
	 * @return
	 */
	private static int mod(int a, int b) {
		return ((a % b) + b) % b;
	}

	/**
	 * Will merge two sorted parts of the array in place!
	 * @param a array
	 * @param l lower bound of the first
	 * @param r higher bound of the second
	 */
	private static void merge(int[] a, int l, int r) {
		int m = ((int) (l/2 + r/2) + 1);
		int over = 0;
		int counter = 0;
		for (int i = l; i < r; i++) {
			if (i <= m + over && m + over <= r) {
				int right = a[m+over];
				int left = over > 0 ? a[m + counter] : a[i];
				if (right < left) {
					swap(a, m + over, i);
					if (i >= m) {
						m++;
						counter = over > 0 ? mod(counter - 1, over) : 0;
					} else {
						if (counter == over-1 && over > 1) {
							swap(a, m + counter, m + over);
							counter = over;
						} else if (counter != 0 && over > 1) {
							swap(a, m, m + over);
						}
						over++;
					}
				} else if (over > 0) {
					swap(a, m + counter, i);
					if (i >= m) {
						m++;
						int nextCounter = mod(counter + 1, over);
						over--;
						counter = over > 0 ? mod(nextCounter-1, over) : 0;
					} else {
						counter = (counter + 1) % over;
					}
 				}
			} else if (m + counter < r + 1) {
				int right = a[m+counter];
				int left = a[i];
				if (right < left && i < m + counter) {
					swap(a, i, m + counter);
					m++;
				}
			}
		}
	}

	public static void main(String[] args) {
		int[] a = Test.createRandomArray(10);
        SortingAlgorithm alg = new MergeSortInPlace();
		alg.sort(a);
		System.out.println(Arrays.toString(a));
	}

}