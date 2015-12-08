package sort;
import java.util.Arrays;
import java.util.Random;
public class MergeSort {
    public static void main(String[] args){
        int[] unsorted = createRandomArray(100000,1000000);
        System.out.println(Arrays.toString(unsorted));
        int[] sorted = sort(unsorted);
        System.out.println(Arrays.toString(sorted));
    }
    public static int[] merge(int[] a, int[] b){
        int[] merged = new int[a.length + b.length];
        int aIndex = 0;
        int bIndex = 0;
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
        if(a.length == 1){
            return a;
        }
        return merge(sort(Arrays.copyOfRange(a, 0, (int) a.length/2)),
                sort(Arrays.copyOfRange(a, (int) a.length/2, a.length)));
    }
    public static int[] createRandomArray(int length,int maxNumber){
        int[] random = new int[length];
        for(int i=0;i<length;i++){
            random[i] = new Random().nextInt(maxNumber+1);
        }
        return random;
    }
}