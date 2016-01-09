package Blatt07;

public class BinarySearch<T extends Comparable> {

    T[] values;

    public BinarySearch(T[] values) {
        this.values = values;
    }

    /**
     *
     * @param value Value you're looking for
     * @param low Lower Bound
     * @param high Higher Bound
     * @return boolean if the value is in the array
     */
    public T search(T value, int low, int high) {
        if (values.length <= high) throw new IllegalArgumentException();
        
        int m = low / 2 + high / 2;
        int result = value.compareTo(values[m]);

        if (result == 0) return values[m];
        if (low == high) return null;

        low = result < 0 ? low : m + 1;
        high = result < 0 ? m - 1 : high;
        return search(value, low, high);
    }

    /**
     *
     * @param value Value you're looking for in the array
     * @return boolean if the value is in the array
     */
    public T search(T value) {
        return search(value, 0, values.length - 1);
    }

}
