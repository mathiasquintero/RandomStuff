public class SelectionSort extends SortingAlgorithm {

  /**
   * Gives the the index of the min in the array starting from from
   * @param   array to search
   * @param   index of from where to start
   * @return  index of the smalles element in array from from
   */
  private static int findMinimum(int[] array, int from) {
    int index = from;
    for (int i=from;i<array.length;i++) {
      if(array[i] < array[index]) index = i;
    }
    return index;
  }

  /**
   * Will swap elements a and b in an array
   * @param  array where the swaping will take place
   * @param  index of element a
   * @param  index of element b
   */
  private static void swap(int[] array, int a, int b) {
    int temp = array[a];
    array[a] = array[b];
    array[b] = temp;
  }

  public void sort(int[] unsorted) {
    for (int i=0; i<unsorted.length; i++) {
      int min = findMinimum(unsorted,i);
      swap(unsorted,i,min);
    }
  }

}
