public class MergeSort extends SortingAlgorithm {

  private static int[] merge(int[] a, int[] b){
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

  public void sort(int[] a){
    if(a.length == 1) return;
    int[] left = new int[a.length/2], right = new int[a.length - left.length];
    for (int i=0;i<left.length;i++) left[i] = a[i];
    for (int i=0;i<right.length;i++) right[i] = a[left.length + i];
    sort(left);
    sort(right);
    int[] res = merge(left, right);
    for (int i = 0;i<a.length;i++) {
      a[i] = res[i];
    }
  }

}
