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
		Bucket[] buckets = new Bucket[10];
		for (int i = 0; i < 10; i++) 
			buckets[i] = new Bucket();
		int prev = 1;
		for (int pow = 10; pow > 0; pow *= 10) {
			for (int i = 0; i < array.length; i++) {
				int bucketIndex = (array[i] % pow - array[i] % prev) / prev;
				buckets[bucketIndex].add(array[i]);
			}
			int at = 0;
			for (Bucket bucket : buckets) 
				at = bucket.emptyBucket(array, at);
			prev = pow;
		}
	}

}
