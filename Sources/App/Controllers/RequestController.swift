//
//  RequestController.swift
//
//
//  Created by Carlos Real on 03/11/21.
//

import Foundation
import Network

public protocol RequestControllerProtocol {
    func requestHandled(ipAddress: String?)
    func top100() -> [String: [[String: Int]]]
    func clear()
}

public final class RequestController: RequestControllerProtocol {
    
    // Using dictionary to have O(1) to access time
    private var ipTrackerList = [String: Int]()
    
    // Keeps a sorted list of top N items
    private var topRankedList = [[String: Int]]()
    
    // MARK: Init
    public init() {}
    
    //  Registers IP access incrementing view access counter.
    //  Using a hashtable [ipTrackerList] to keep tracking in-memory
    public func requestHandled(ipAddress: String?) {
        guard let ipAddress = ipAddress, isAddressValid(ipAddress) else { return }
        
        // Adds ip to general counter hashtable
        if ipTrackerList[ipAddress] != nil {
            ipTrackerList[ipAddress]! += 1
        } else {
            ipTrackerList[ipAddress] = 1
        }
        
        // Keeps the [topRankedList] sorted which will decrease complexity at the request of top 100
        guard let value = ipTrackerList[ipAddress] else { return }
            
        // overrides the value in case is in the list, ortherwise just adds it at the same place.
        if let index = topRankedList.firstIndex(where: { $0.first?.key == ipAddress}) {
            topRankedList[index] = [ipAddress: value]
        } else {
            topRankedList.append([ipAddress: value])
        }
        
        topRankedList = sorteList(list: topRankedList, validation: { lhs, rhs in
            guard let lhsValue = lhs.first?.value, let rhsValue = rhs.first?.value else { return false }
            return lhsValue > rhsValue
        })
    }
    
    public func top100() -> [String: [[String: Int]]] {
        // Get first 100 top ranked
        let topList = Array(topRankedList.prefix(100))
        return ["result": topList]
    }
    
    public func clear() {
        ipTrackerList.removeAll()
        topRankedList.removeAll()
    }
}

// MARK: - Private methods
private extension RequestController {
    // Validate ip address using language helpers
    func isAddressValid(_ address: String) -> Bool {
        if let _ = IPv4Address(address) {
            return true
        } else if let _ = IPv6Address(address) {
            return true
        }
        return false
    }
    
    // Insertion sort - O(n^2)
    // Since the array is being sorted gradually I believe it attends the requirements for small size, 100 in this case
    // Considering a small array, the solution covers what is needed. . However, in order to scale better
    // I would move it to something for permatic as Quick sort.
    func sorteList(list: [[String: Int]], validation: ([String: Int], [String: Int]) -> Bool) -> [[String: Int]] {
        var updatedList = list
        
        for index in 1..<updatedList.count {
            let currentItem = updatedList[index]
            var position = index
            
            while position > 0 && validation(currentItem, updatedList[position - 1]) {
                updatedList[position] = updatedList[position - 1]
                position -= 1
            }
            
            updatedList[position] = currentItem
        }
        
        return updatedList
    }
}
