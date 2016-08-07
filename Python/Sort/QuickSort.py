def recursive(a, l, r):
    if r - l > 1:
        pivot = r - 1
        wall = l
        for i in range(l, r - 1):
            if a[i] < a[pivot]:
                a[wall], a[i] = a[i], a[wall]
                wall += 1
        a[wall], a[pivot] = a[pivot], a[wall]
        recursive(a, l, wall)
        recursive(a, wall + 1, r)

def sort(a):
    res = a[:]
    recursive(res, 0, len(res))
    return res
