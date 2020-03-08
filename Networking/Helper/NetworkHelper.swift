//
//  NetworkHelper.swift
//  jobSearch
//
//  Created by MithranN on 08/03/20.
//  Copyright © 2020 MithranN. All rights reserved.
//

import Foundation

enum Result<T, U> where U: Error {
    case success(T)
    case failure(U)
}

func parseNetworkResponse<T: Decodable>(jsonDecoder: JSONDecoder, data: Data?, type _: T.Type) -> T? {
    do {
        if data != nil {
            return try jsonDecoder.decode(T.self, from: data!)
        }
    } catch {
        print(error)
        return nil
    }
    return nil
}
