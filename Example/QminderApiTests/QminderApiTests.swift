//
//  QminderApiTests.swift
//  QminderApiTests
//
//  Created by Kristaps Grinbergs on 04/11/2016.
//  Copyright © 2016 Qminder. All rights reserved.
//

import Quick
import Nimble
import QminderAPI

class QminderApiTests : QuickSpec {

  override func spec() {
    
    describe("Qminder API tests") {
      it("Getting pairing code and secret") {
        
        var code:String?
        var secret:String?
        var error:NSError?
        
        waitUntil(action: {
          done in
            QminderAPI.getPairingCodeAndSecret(completionHandler: {
              (c, s, e) in
                code = c
                secret = s
                error = e as NSError?
              
                print("TESTS Pairing code: \(code)")
                print("TESTS Secret key: \(secret)")
                print("TESTS Secret key: \(error)")
              
                done()
            })
        })
        
        expect(code).toEventuallyNot(beEmpty())
        expect(secret).toEventuallyNot(beEmpty())
        expect(error).toEventually(beNil())
        
      }
    }
  }
}
