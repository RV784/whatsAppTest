import Foundation
import AsyncHTTPClient
import Appwrite
import AppwriteModels
import JWTKit
import Crypto

func main(context: RuntimeContext) async throws -> RuntimeOutput {
    // CHECK API KEYS
    guard let vonageApiKey = ProcessInfo.processInfo.environment["VONAGE_API_KEY"],
          let vonageAccountSecret = ProcessInfo.processInfo.environment["VONAGE_ACCOUNT_SECRET"],
          let vonageSignatureSecret = ProcessInfo.processInfo.environment["VONAGE_SIGNATURE_SECRET"],
          let vonageWhatsAppNumber = ProcessInfo.processInfo.environment["VONAGE_WHATSAPP_NUMBER"] else {
        throw ErrorUtil.internalServerError(message: "Missing environment variables")
    }
    
    if context.req.method == "GET" {
        return try context.res.send(indexHTMLString, statusCode: 200, headers: [
            "content-type": "text/html"
        ])
    }
    
    var token = ""
    guard let authorizationToken = context.req.headers["authorization"] else {
        throw ErrorUtil.internalServerError(message: "Missing authorization token")
    }
    
    let tokenArr = authorizationToken.components(separatedBy: " ")
    
    guard tokenArr.count > 1 else {
        throw ErrorUtil.internalServerError(message: "Proper Token not provided")
    }
    token = tokenArr[1]
    context.log("Token \(token)")
    
//    let signers = JWTSigners()
//    signers.use(.hs256(key: vonageSignatureSecret))
//    let payload = try signers.verify(token, as: PayloadHash.self)
//    if let payloadData = context.req.bodyRaw.data(using: .utf8) {
//        let reqPayload = try sha256(data: payloadData)
//        if payload.payload_hash! != reqPayload {
//            throw ErrorUtil.payloadMismatch(message: "Payload was not matched")
//        }
//    } else {
//        throw ErrorUtil.internalServerError(message: "Request payload not found")
//    }
    
    let basicAuthToken = "\(vonageApiKey):\(vonageAccountSecret)".data(using: .utf8)?.base64EncodedString()
    
    let payload = context.req.body as? [String: Any]
    guard let from = (payload?["from"] as? String),
          let text = (payload?["text"] as? String) else {
        throw ErrorUtil.internalServerError(message: "From/Text not found")
    }
    
    let params: [String: Any] = [
        "from": vonageWhatsAppNumber,
        "to": from,
        "message_type": "text",
        "text": "Hi there! You sent me: \(text)",
        "channel": "whatsapp"
    ]
    
    let bodyData = try? JSONSerialization.data(withJSONObject: params, options: [])
    
    var httpClient = HTTPClient(eventLoopGroupProvider: .createNew)
    var newRequest = HTTPClientRequest(url: "https://messages-sandbox.nexmo.com/v1/messages")
    newRequest.headers.add(name: "Content-Type", value: "application/json")
    newRequest.headers.add(name: "Authorization", value: "Basic \(basicAuthToken)")
    newRequest.method = .POST
    newRequest.body =  .bytes(.init(data: bodyData ?? Data()))
    let response = try await httpClient.execute(newRequest, timeout: .seconds(30))
    context.log(response.status.code)
    let responseData = try await response.body.collect(upTo: 1024 * 1024)
    let responseDict = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
    context.log(responseDict)
    
    return try context.res.json([
        "ok": true
    ])
}
