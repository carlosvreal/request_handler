//
//  RequestController.swift
//
//
//  Created by Carlos Real on 03/11/21.
//

import Foundation

///
/**
 You want to keep track of the IP addresses that are making the most requests to your service each day. Your job is to write a program that (1) tracks these IP addresses in memory (don’t use a database), and (2) returns the 100 most common IP addresses.
 
 * request_handled(ip_address)
 This function accepts a string containing an IP address like “145.87.2.109”. This function will be called by the web service every time it handles a request. The calling code is outside the scope of this project. Since it is being called very often, this function needs to have a fast runtime.
 
 * top100()
 This function should return the top 100 IP addresses by request count, with the highest traffic IP address first. This function also needs to be fast. Imagine it needs to provide a quick response (< 300ms) to display on a dashboard, even with 20 millions IP addresses. This is a very important requirement. Don’t forget to satisfy this requirement.
 
 * clear()
 Called at the start of each day to forget about all IP addresses and tallies.
 
 ////
 What would you do differently if you had more time?
 What is the runtime complexity of each function?
 How does your code work?
 What other approaches did you decide not to pursue?
 How would you test this?
 
 */

final class RequestController {
    
    // Using dictionary to have O(1) to access time
    private var ipTrackerList = [String: Int]()
    
    // Keeps a sorted list of top N items
    private var topRankedList = [[String: Int]]()
    
    //  Registers IP access incrementing view access counter.
    //  Using a hashtable [ipTrackerList] to keep tracking in-memory
    func requestHandled(ipAddress: String?) {
        guard let ipAddress = ipAddress else { return }
        
        // Adds ip to general counter hashtable
        if ipTrackerList[ipAddress] != nil {
            ipTrackerList[ipAddress]! += 1
        } else {
            ipTrackerList[ipAddress] = 1
        }
        
        // Keeps the [topRankedList] sorted which will decrease complexity at the request of top 100
        if let value = ipTrackerList[ipAddress] {
            
            // overrides the value in case is in the list, ortherwise just adds it.
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
        
        print(topRankedList)
    }
    
    func top100() -> [String: String] {
        let emptyResponse = "[]"
        guard !ipTrackerList.isEmpty else {
            return ["result": emptyResponse]
        }
        
        let topList = Array(topRankedList.prefix(100))
        
        do {
            let data = try JSONEncoder().encode(topList)
            let response = String(data: data, encoding: .utf8) ?? emptyResponse
            
            return ["result": response]
        } catch {
            return ["result": emptyResponse]
        }
    }
    
    func clear() {
        ipTrackerList.removeAll()
        topRankedList.removeAll()
    }
}

// MARK: - Private methods
private extension RequestController {
    
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
