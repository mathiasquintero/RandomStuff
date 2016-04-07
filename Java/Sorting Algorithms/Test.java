public class Test {

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
    int n = 20;
    try {
      n = Integer.parseInt(args[0]);
    } catch(Exception e) { }
    int[] i = createRandomArray(n);
    SortingAlgorithm algorithm = new RadixSort();
    System.out.println("Unsorted: ");
    printArray(i);
    algorithm.sort(i);
    System.out.println("Sorted!");
    printArray(i);
  }

}
