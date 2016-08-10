//
//  Heap.swift
//  DoubleEndedRouteHeap
//
//  Created by Mathias Quintero on 8/10/16.
//  Copyright © 2016 Mathias Quintero. All rights reserved.
//

import Foundation

class Heap<T: Comparable, V> {
    
    var data = [(prio: T, data: V)]()
    
    var size: Int {
        get {
            return data.count
        }
    }
    
    var min: V? {
        get {
            return data.first?.data
        }
    }
    
    var max: V? {
        get {
            return data.last?.data
        }
    }
    
    private var bufferSize: Int {
        get {
            let quarter = Double(size) / 4
            let buffer = ceil(quarter)
            return Int(buffer)
        }
    }
    
    private func siftLeft(_ index: Int) -> Int {
        if size > 1 {
            if size - index < bufferSize {
                let invertedIndex = size - index - 1
                let left = size - (2 * invertedIndex + 1) - 1
                let right = size - (2 * invertedIndex + 2) - 1
                let neighbourWithBiggestPriority = right < 0 ? left : (data[left].prio > data[right].prio ? left : right)
                if data[neighbourWithBiggestPriority].prio > data[index].prio {
                    swap(&data[neighbourWithBiggestPriority], &data[index])
                    return siftLeft(neighbourWithBiggestPriority)
                } else {
                    return index
                }
            } else {
                let parent = (index - 1) / 2
                if data[parent].prio > data[index].prio {
                    swap(&data[parent], &data[index])
                    return siftLeft(parent)
                } else {
                    return index
                }
            }
        }
        return index
    }
    
    private func siftRight(_ index: Int) -> Int {
        if size > 1 {
            if index < bufferSize {
                let left = 2 * index + 1
                let right = 2 * index + 2
                let neighbourWithSmallestPriority = right >= size ? left : (data[left].prio < data[right].prio ? left : right)
                if data[neighbourWithSmallestPriority].prio < data[index].prio {
                    swap(&data[neighbourWithSmallestPriority], &data[index])
                    return siftRight(neighbourWithSmallestPriority)
                } else {
                    return index
                }
            } else {
                let invertedIndex = size - index - 1
                let invertedParent = (invertedIndex - 1) / 2
                let parent = size - invertedParent - 1
                if data[parent].prio < data[index].prio {
                    swap(&data[parent], &data[index])
                    return siftRight(parent)
                } else {
                    return index
                }
            }
        }
        return index
    }
    
    func insert(priority: T, data: V) {
        self.data.append((priority, data))
        var index = siftLeft(size - 1)
        index = siftRight(index)
        let _ = siftLeft(index)
    }
    
    func popMin() -> V? {
        if size > 1 {
            swap(&data[0], &data[size - 1])
            let min = data.popLast()
            let index = siftRight(0)
            let _ = siftLeft(index)
            return min?.data
        }
        return data.popLast()?.data
    }
    
    func popMax() -> V? {
        if size > 0 {
            let max = data.popLast()
            let index = siftLeft(size - 1)
            let _ = siftRight(index)
            return max?.data
        }
        return nil
    }
    
}
