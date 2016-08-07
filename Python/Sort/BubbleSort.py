def sort(a):
    res = a[:]
    for j in range(len(res)):
        for i in range(len(res) - j - 1):
            if res[i+1] < res[i]:
                res[i], res[i+1] = res[i+1], res[i]

    return res
