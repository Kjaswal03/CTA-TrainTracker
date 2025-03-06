//
//  NetworkManager.swift
//  CTA-TrainTracker
//
//  Created by Kashev Jaswal on 4/1/25.
//

import Foundation



// Top-level response structure
struct TrainArrivalsResponse: Codable {
    let ctatt: CTATT
}

// Contains the actual train arrival data
struct CTATT: Codable {
    let tmst: String
    let errCd: String
    let errNm: String?
    let eta: [ETA]?
}

// Details for each train arrival
struct ETA: Codable {
    let staId: String
    let stpId: String
    let staNm: String
    let stpDe: String
    let rn: String
    let rt: String
    let destSt: String
    let destNm: String
    let trDr: String
    let prdt: String
    let arrT: String
    let isApp: String?
    let isSch: String?
    let isDly: String
    let isFlt: String?
    let flags: String?
    let lat: String?
    let lon: String?
    let heading: String?
}


struct ArrivalDetail {
    let arrivalTime: String
    let destinationName: String
}
   

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL =  "http://lapi.transitchicago.com/api/1.0"
    
    private init() {}

    func fetchArrivalDetails(forStationId stationId: Int, completion: @escaping (Result<[ETA], Error>) -> Void) {
        let urlString = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=\(CTA_SECRET_KEY)&mapid=\(stationId)&outputType=JSON"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Network error"])))
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(TrainArrivalsResponse.self, from: data)
                if let etas = response.ctatt.eta {
                    completion(.success(etas))
                } else {
                    completion(.success([])) // Return an empty array if 'eta' is not present
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
 


