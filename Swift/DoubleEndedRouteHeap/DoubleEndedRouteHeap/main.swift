//
//  main.swift
//  DoubleEndedRouteHeap
//
//  Created by Mathias Quintero on 8/10/16.
//  Copyright © 2016 Mathias Quintero. All rights reserved.
//

import Foundation

let heap = SimpleHeap<UInt32>()

var items = [UInt32]()

for i in 1...50 {
    let item = arc4random()
    items.append(item)
    _ = heap.insert(item)
}

let sorted = items.sorted()

for i in sorted {
    let data = heap.popMin()
    if data != i {
        print("Mismatch!!!! :")
        print("Sorted: \(i)")
        print("Heap: \(heap.popMin())")
    }
    
}
