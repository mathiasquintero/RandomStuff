public class SelectionSort {

  /**
   * Gives the the index of the min in the array starting from from
   * @param   array to search
   * @param   index of from where to start
   * @return  index of the smalles element in array from from
   */
  public static int findMinimum(int[] array, int from) {
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
  public static void swap(int[] array, int a, int b) {
    int temp = array[a];
    array[a] = array[b];
    array[b] = temp;
  }

  /**
   * Will Sort an Array using Selection Sort
   * @param unsorted array
   */
  public static void sort(int[] unsorted) {
    for (int i=0; i<unsorted.length; i++) {
      int min = findMinimum(unsorted,i);
      swap(unsorted,i,min);
    }
  }

  /**
   * Will print an Array to the console!
   * @param array you want to print
   */
  public static void printArray(int[] array) {
    for(int i=0;i<array.length;i++) {
      System.out.print(i + ": " + array[i] + "\t");
      if ((i+1)%10==0) {
        System.out.println();
      }
    }
  }

  /**
   * will create an array of ints with random numbers
   * @param   length of the array
   * @return  array with random elements
   */
  public static int[] createRandomArray(int length) {
    int[] array = new int[length];
    for (int i=0;i<length;i++) {
      array[i] = (int) (Math.random() * 100);
    }
    return array;
  }

  public static void main(String[] args) {
    int[] i = createRandomArray(100);
    System.out.println("Unsorted: ");
    printArray(i);
    sort(i);
    System.out.println("Sorted!");
    printArray(i);
  }

}
