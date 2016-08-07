def merge(left, right):
    array = left + right
    a, b = 0, 0
    l, r = len(left), len(right)
    for i in range(len(array)):
        if b < r and (a >= l or right[b] < left[a]):
            array[i] = right[b]
            b += 1
        else:
            array[i] = left[a]
            a += 1
    return array

def sort(array):
    if len(array) < 2:
        return array
    m = len(array) / 2
    left = sort(array[:m])
    right = sort(array[m:])
    return merge(left, right)
