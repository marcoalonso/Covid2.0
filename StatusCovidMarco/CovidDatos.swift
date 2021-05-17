//
//  CovidDatos.swift
//  StatusCovidMarco
//
//  Created by marco rodriguez on 17/05/21.
//

import Foundation

struct CovidDatos: Decodable {
    let country: String
    let cases: Double
    let deaths: Double
    let recovered: Double
    let countryInfo: CountryInfo
}

struct CountryInfo: Decodable {
    let flag: String
}
