//
//  MainViewModel.swift
//  Hive
//
//  Created by Tushar Tayal on 05/10/23.
//

import Foundation

class MainViewModel {
    
    let urlString = """
https://en.wikipedia.org/w/api.php?format=json&action=query&generator=search&gsrnamespace=0&gsrsearch=apple&gsrlimit=10&prop=pageimagesextracts&pilimit=max&exintro&explaintext&exsentences=1&exlimit=max
"""
    
    func searchTableData(completionHandler: @escaping (WikipediaResponse) -> Void) {
        guard let url = URL(string: urlString) else {
            return
        }
        NetworkHelper.fetchData(from: url, responseType: WikipediaResponse.self) { result in
            switch result {
            case .success(let response):
                print(response)
                completionHandler(response)
            case .failure(let error):
                print(error)
            }
        }
    }
}
