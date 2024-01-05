//
//  Utils.swift
//  
//
//  Created by Rajat verma on 08/10/23.
//

import Crypto
import Foundation
import JWTKit

struct PayloadHash: JWTPayload {
    func verify(using signer: JWTKit.JWTSigner) throws {
        if payload_hash == nil {
            throw ErrorUtil.payloadMismatch(message: "")
        }
    }
    
    let payload_hash: String?
}

func sha256(data: Data) -> String {
    let hashed = SHA256.hash(data: data)
    return hashed.compactMap { String(format: "%02hhx", $0 as CVarArg) }.joined()
}

enum ErrorUtil: Error {
    case internalServerError(message: String)
    case unauthorized(message: String)
    case badRequest(message: String)
    case payloadMismatch(message: String)
}

let indexHTMLString = """

<head>
<meta charset="UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>WhatsApp Bot with Vonage</title>

<link rel="stylesheet" href="https://unpkg.com/@appwrite.io/pink" />
<link rel="stylesheet" href="https://unpkg.com/@appwrite.io/pink-icons" />
</head>
<body>
<main class="main-content">
  <div class="top-cover u-padding-block-end-56">
    <div class="container">
      <div
        class="u-flex u-gap-16 u-flex-justify-center u-margin-block-start-16"
      >
        <h1 class="heading-level-1">WhatsApp Bot with Vonage</h1>
        <code class="u-un-break-text"></code>
      </div>
      <p
        class="body-text-1 u-normal u-margin-block-start-8"
        style="max-width: 50rem"
      >
        This function listens to incoming webhooks from Vonage regarding
        WhatsApp messages, and responds to them. To use the function, send
        message to the WhatsApp user provided by Vonage.
      </p>
    </div>
  </div>
</main>
</body>
"""

