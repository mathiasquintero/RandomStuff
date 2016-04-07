public class RadixSort extends SortingAlgorithm {

	private static class Bucket {

		private static class Element {
			int data;
			Element next = null;
			public Element(int data) {
				this.data = data;
			}
		}

		private Element head = null;
		private Element last = null;

		public void add(int data) {
			if (head == null) {
				head = new Element(data);
				last = head;
			} else {
				Element newLast = new Element(data);
				last.next = newLast;
				last = newLast;
			}
		}

		public int emptyBucket(int[] array, int at) {
			while (head != null) {
				array[at] = head.data;
				head = head.next;
				at++;
			}
			return at;
		}

	}

	public void sort(int[] array) {
		int to = (int) Math.log10(Integer.MAX_VALUE), pow = 10, prev = 1;
		Bucket[] buckets = new Bucket[10];
		for (int i = 0; i < 10; i++) {
			buckets[i] = new Bucket();
		}
		for (int i = 0; i < to; i++) {
			for (int j = 0; j < array.length; j++) {
				int bucketIndex = (array[j] % pow - array[j] % prev) / prev;
				buckets[bucketIndex].add(array[j]);
			}
			int at = 0;
			prev = pow;
			pow *= 10;
			for (Bucket bucket : buckets) {
				at = bucket.emptyBucket(array, at);
			}
		}
	}

}
