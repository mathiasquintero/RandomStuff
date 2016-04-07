public class InsertionSort extends SortingAlgorithm {

  private static void insert(int[] array, int element, int limit) {
    for (int i=0;i<limit;i++) {
      if (array[i] > element) {
        int tmp = array[i];
        array[i] = element;
        element = tmp;
      }
    }
  }

  public void sort(int[] array) {
    for (int i=0;i<array.length;i++) {
      insert(array, array[i], i);
    }
  }

}
