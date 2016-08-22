//
//  Heap.swift
//  DoubleEndedRouteHeap
//
//  Created by Mathias Quintero on 8/10/16.
//  Copyright © 2016 Mathias Quintero. All rights reserved.
//

import Foundation

class Heap<T: Comparable, V> {
    
    var data = [(prio: T, data: V, handle: Int)]()
    
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
    
    private var handle = 0
    
    private var tracking = [Int:Int]()
    
    private func swapInternalData(_ a: Int, _ b: Int) {
        swap(&data[a], &data[b])
        tracking[data[a].handle] = a
        tracking[data[b].handle] = b
    }

    private func siftLeft(_ index: Int) {
        var index = index
        if size > 1 {
            let invertedIndex = size - index - 1
            let left = size - (2 * invertedIndex + 1) - 1
            let right = size - (2 * invertedIndex + 2) - 1
            if left >= 0 {
                let neighbourWithBiggestPriority = right < 0 ? left : (data[left].prio > data[right].prio ? left : right)
                if data[neighbourWithBiggestPriority].prio > data[index].prio {
                    let currentHandle = data[index].handle
                    let neighbourHandle = data[neighbourWithBiggestPriority].handle
                    swapInternalData(neighbourWithBiggestPriority, index)
                    siftLeft(neighbourWithBiggestPriority)
                    if let neighbourIndex = tracking[neighbourHandle] {
                        siftLeft(neighbourIndex)
                    }
                    index = tracking[currentHandle] ?? index
                }
            }
            if index > 0 {
                let parent = (index - 1) / 2
                if data[parent].prio > data[index].prio {
                    swapInternalData(parent, index)
                    siftLeft(parent)
                }
            }
        }
    }
    
    private func siftRight(_ index: Int){
        var index = index
        if size > 1 {
            let left = 2 * index + 1
            let right = 2 * index + 2
            if left < size {
                let neighbourWithSmallestPriority = right >= size ? left : (data[left].prio < data[right].prio ? left : right)
                if data[neighbourWithSmallestPriority].prio < data[index].prio {
                    let currentHandle = data[index].handle
                    let neighbourHandle = data[neighbourWithSmallestPriority].handle
                    swapInternalData(neighbourWithSmallestPriority, index)
                    siftRight(neighbourWithSmallestPriority)
                    if let neighbourIndex = tracking[neighbourHandle] {
                        siftLeft(neighbourIndex)
                    }
                    index = tracking[currentHandle] ?? index
                }
            }
            if index < size - 1 {
                let invertedIndex = size - index - 1
                let invertedParent = (invertedIndex - 1) / 2
                let parent = size - invertedParent - 1
                if data[parent].prio < data[index].prio {
                    swapInternalData(parent, index)
                    siftRight(parent)
                }
            }
        }
    }
    
    func insert(priority: T, data: V) -> Int {
        self.data.append((priority, data, handle))
        handle += 1
        tracking[handle - 1] = size - 1
        siftLeft(size - 1)
        siftRight(tracking[handle - 1] ?? 0)
        siftLeft(tracking[handle - 1] ?? 0)
        return handle - 1
    }
    
    func get(handle: Int) -> V? {
        if let index = tracking[handle] {
            return data[index].data
        }
        return nil
    }
    
    func popMin() -> V? {
        if size > 1 {
            swapInternalData(0, size - 1)
            let min = data.popLast()
            let handle = data[0].handle
            siftRight(0)
            siftLeft(tracking[handle] ?? 0)
            return min?.data
        }
        return data.popLast()?.data
    }
    
    func popMax() -> V? {
        if size > 0 {
            let max = data.popLast()
            return max?.data
        }
        return nil
    }
    
}
