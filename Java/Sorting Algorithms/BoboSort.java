public class BoboSort extends SortingAlgorithm {

  public boolean isSorted(int[] arr) {
    for (int i = 0; i < arr.length - 1 ;i++) {
      if (arr[i] > arr[i+1]) return false;
    }
    return true;
  }

  public void swap(int[] arr, int i, int j) {
    arr[i] += arr[j];
    arr[j] = arr[i] - arr[j];
    arr[i] -= arr[j];
  }


  /**
   * Sort with Average Case O(n*n!) and Worts Case of Inf
   * @param arr Beautiful!!!! Array
   */
  public void sort(int[] arr) {
    while (!isSorted(arr)) {
      int i = (int) (Math.random() * arr.length);
      int j = (int) (Math.random() * arr.length);
      swap(arr, i, j);
    }
  }

}
