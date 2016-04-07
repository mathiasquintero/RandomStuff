public class BubbleSort extends SortingAlgorithm {

  public void sort(int[] arr) {
    for (int _ : arr) {
      for (int i=0;i<arr.length-1;i++) {
        if (arr[i] > arr[i+1]) {
          arr[i] += arr[i+1];
          arr[i+1] = arr[i] - arr[i+1];
          arr[i] -= arr[i+1];
        }
      }
    }
  }

}
