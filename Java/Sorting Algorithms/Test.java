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
    System.out.println("Comparing Mergesort to RadixSort");
    System.out.println("RadixSort");
    int[] i = createRandomArray(n);
    long start = System.nanoTime();
    SortingAlgorithm algorithm = new RadixSort();
    algorithm.sort(i);
    long stop = System.nanoTime();
    System.out.println("Sorted!");
    System.out.println("Time: " + (stop - start));
    System.out.println("MergeSort");
    i = createRandomArray(n);
    start = System.nanoTime();
    algorithm = new MergeSort();
    algorithm.sort(i);
    stop = System.nanoTime();
    System.out.println("Sorted!");
    System.out.println("Time: " + (stop - start));
  }

}
