// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import XCTest
import TrustCore

class TronAssetContractTest: XCTestCase {
    func testAssetTronTransaction() {
        let from = BitcoinAddress(string: "TJRyWwFs9wTFGZg3JbrVriFbNfCug5tDeC")!
        let to = BitcoinAddress(string: "THTR75o8xXAgCTQqpiot2AFRAjvW1tSbVV")!
        let amount = Int64(4)
        let assetName = "IPFS"
        let type = TronContractType.transferAssetContract(from: from, to: to, amount: amount, assetName: assetName)
        let contract = TronContract(type: type)
        let timestamp: Int64 = 1541890116000
        let txTrieRoot = Data(hexString: "845ab51bf63c2c21ee71a4dc0ac3781619f07a7cd05e1e0bd8ba828979332ffa")!
        let parentHash =  Data(hexString: "00000000003cb800a7e69e9144e3d16f0cf33f33a95c7ce274097822c67243c1")!
        let number = Int64(3979265)
        let witnessAddress = Data(hexString: "41b487cdc02de90f15ac89a68c82f44cbfe3d915ea")!
        let version = Int32(3)
        let block = TronBlock(timestamp: timestamp, txTrieRoot: txTrieRoot, parentHash: parentHash, number: number, witnessAddress: witnessAddress, version: version)
        let tronTransaction = TronTransaction(tronContract: contract, tronBlock: block, timestamp: Date(timeIntervalSince1970: 1539295479))

        let transaction = try! tronTransaction.transaction()

        var sighn = TronSign(tronTransaction: transaction)
        let privateKey =  PrivateKey(data: Data(hexString: "2d8f68944bdbfbc0769542fba8fc2d2a3de67393334471624364c7006da2aa54")!)!

        try! sighn.sign(hashSigner: { data in
            return Crypto.sign(hash: data, privateKey: privateKey.data)
        })

        XCTAssertEqual(sighn.signature?.hexString, "dafb40c26a31bd90c13fff181bd0b8bcbe286b53a0f3da28c594bca85e0635b930a66075ff12fbe562e453c6a7bc704be45cf8c157c37ea019b4df0a81dd842100")
    }
}
