//  Gumroad.swift
//  airsync-mac
//
//  Created by Sameera Sandakelum on 2025-07-31.
//

import Foundation

func checkLicenseKeyValidity(key: String) async throws -> Bool {
    // Production licensing path; test bypass removed
    let productID = GumroadConfig.productID
    let url = URL(string: "https://api.gumroad.com/v2/licenses/verify")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    let bodyComponents = [
        "product_id": productID,
        "license_key": key
    ]
    let bodyString = bodyComponents
        .map { "\($0.key)=\($0.value)" }
        .joined(separator: "&")

    request.httpBody = bodyString.data(using: .utf8)
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
        throw NSError(domain: "InvalidResponse", code: 0, userInfo: nil)
    }

    if httpResponse.statusCode == 404 {
        AppState.shared.isPlus = false
        AppState.shared.licenseDetails = nil
        return false
    }

    guard
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
        let success = json["success"] as? Bool,
        success,
        let purchase = json["purchase"] as? [String: Any]
    else {
        AppState.shared.isPlus = false
        AppState.shared.licenseDetails = nil
        return false
    }

    AppState.shared.isPlus = true

    AppState.shared.licenseDetails = LicenseDetails(
        key: key,
        email: purchase["email"] as? String ?? "unknown",
        productName: purchase["product_name"] as? String ?? "unknown",
        orderNumber: purchase["order_number"] as? Int ?? 0,
        purchaserID: purchase["purchaser_id"] as? String ?? ""
    )

    return true
}
