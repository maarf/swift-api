import Foundation
import QminderAPI

public func prettyPrint<V: Codable>(_ title: String, _ result: Result<V>){
  print("-- \(title) --")
  
  switch result {
  case .success(let value):
    print(value)
  case .failure(let error):
    print(error)
  }
  
  print("")
}
