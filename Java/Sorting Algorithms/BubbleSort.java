import java.util.Random;
import java.util.Arrays;

public class BubbleSort {

  public static void sort(int[] arr) {
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

  public static int[] createRandomArray(int length){
    int[] random = new int[length];
    for(int i=0;i<length;i++){
      random[i] = new Random().nextInt(100+1);
    }
    return random;
  }

  public static void main(String[] args){
    int n = 20;
    try {
      n = Integer.parseInt(args[0]);
    } catch(Exception e) { }
    int[] arr = createRandomArray(n);
    System.out.println(Arrays.toString(arr));
    sort(arr);
    System.out.println(Arrays.toString(arr));
  }

}
