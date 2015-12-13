package uebung05;

import java.util.LinkedList;

public class InsertionSort {

  public static void insert(LinkedList<Integer> list, int element) {
    for (int i=0;i<list.size();i++) {
      if (element < list.get(i)) {
        list.add(i, element);
        return;
      }
    }
    list.addLast(element);
  }

  public static LinkedList<Integer> sort(LinkedList<Integer> unsorted) {
    LinkedList<Integer> sorted = new LinkedList<Integer>();
    for(int i=0;i<unsorted.size();i++) {
        insert(sorted,unsorted.get(i));
    }
    return sorted;
  }
  
  public static void main(String[] args) {
      
      LinkedList<Integer> a = new LinkedList();
      a.add(5);
      a.add(7);
      a.add(3);
      a.add(1);
      a.add(10);
      System.out.println(sort(a));
      
  }

}
