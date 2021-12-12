// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import XCTest
import TrustCore

class TronContractTests: XCTestCase {
    func testTronTransaction() {
        let from = BitcoinAddress(string: "TJRyWwFs9wTFGZg3JbrVriFbNfCug5tDeC")!
        let to = BitcoinAddress(string: "THTR75o8xXAgCTQqpiot2AFRAjvW1tSbVV")!
        let amount = Int64(2000000)
        let type = TronContractType.transferContract(from: from, to: to, amount: amount)
        let contract = TronContract(type: type)
        let timestamp: Int64 = 1539295479000
        let txTrieRoot = Data(hexString: "64288c2db0641316762a99dbb02ef7c90f968b60f9f2e410835980614332f86d")!
        let parentHash =  Data(hexString: "00000000002f7b3af4f5f8b9e23a30c530f719f165b742e7358536b280eead2d")!
        let number = Int64(3111739)
        let witnessAddress = Data(hexString: "415863f6091b8e71766da808b1dd3159790f61de7d")!
        let version = Int32(3)
        let block = TronBlock(timestamp: timestamp, txTrieRoot: txTrieRoot, parentHash: parentHash, number: number, witnessAddress: witnessAddress, version: version)
        let tronTransaction = TronTransaction(tronContract: contract, tronBlock: block, timestamp: Date(timeIntervalSince1970: 1539295479))

        let transaction = try! tronTransaction.transaction()

        var sighn = TronSign(tronTransaction: transaction)
        let privateKey =  PrivateKey(data: Data(hexString: "2d8f68944bdbfbc0769542fba8fc2d2a3de67393334471624364c7006da2aa54")!)!

        try! sighn.sign(hashSigner: { data in
            return Crypto.sign(hash: data, privateKey: privateKey.data)
        })

        XCTAssertEqual(sighn.signature?.hexString, "ede769f6df28aefe6a846be169958c155e23e7e5c9621d2e8dce1719b4d952b63e8a8bf9f00e41204ac1bf69b1a663dacdf764367e48e4a5afcd6b055a747fb200")
    }
}
