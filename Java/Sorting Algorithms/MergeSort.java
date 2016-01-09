import java.util.Random;
import java.util.Arrays;
public class MergeSort {

  public static int[] merge(int[] a, int[] b){
    int[] merged = new int[a.length + b.length];
    int aIndex = 0, bIndex = 0;
    for(int i=0;i<merged.length;i++){
      if(bIndex>=b.length || (aIndex<a.length && a[aIndex]<=b[bIndex])){
        merged[i] = a[aIndex];
        aIndex++;
      } else {
        merged[i] = b[bIndex];
        bIndex++;
      }
    }
    return merged;
  }

  public static int[] sort(int[] a){
    if(a.length == 1) return a;
    int[] left = new int[a.length/2], right = new int[a.length - left.length];
    for (int i = 0;i<left.length;i++) left[i] = a[i];
    for(int i=0;i<right.length;i++) right[i] = a[left.length + i];
    return merge(sort(left),sort(right));
  }


  public static int[] createRandomArray(int length,int maxNumber){
    int[] random = new int[length];
    for(int i=0;i<length;i++){
      random[i] = new Random().nextInt(maxNumber+1);
    }
    return random;
  }

  public static void main(String[] args){
    int[] unsorted = createRandomArray(100,100);
    System.out.println(Arrays.toString(unsorted));
    int[] sorted = sort(unsorted);
    System.out.println(Arrays.toString(sorted));
  }

}
