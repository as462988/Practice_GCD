//
//  ViewController.swift
//  Practice_GCD
//
//  Created by yueh on 2019/8/22.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
//
//struct Info {
//    let road: String
//    let limit: String
//
//    init(road:String,limit: String){
//        self.road = road
//        self.limit = limit
//    }
//}
//
class ViewController: UIViewController, MyUIViewDelegate {
    
    let provider = Provider()
    
    @IBOutlet weak var myUIView: MyUIView! {
        
        didSet {
            
            myUIView.delegate = self
        }
    }
    
    var array: [Results] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    let group = DispatchGroup()
    
    func useGroupGetData(){
        
        let group = DispatchGroup()
        let queueFirst = DispatchQueue(label: "queueFirst", attributes: .concurrent)
        
        group.enter()
        
        queueFirst.async(group: group) {
            
            self.provider.fetchDataOfset0 { [weak self] (result) in
                
                switch result {
                    
                case .success(let response):

                    self?.array.append(Results(speedLimit: response.result.results[0].speedLimit,
                                              road: response.result.results[0].road))
                    
                    // 這裡會拿到資料後才離開
                    group.leave()
                    
                case .failure:
                    print("error")
                    
                }
            }
        }
        
        // 這裡只是呼叫 API 取資料，尚未拿到資料，此時離開的話會沒有資料存起來
        //        group.leave()
        
        let queueSecond = DispatchQueue(label: "queueSecond", attributes: .concurrent)
        
        group.enter()
        
        queueSecond.async(group: group) {
            
            self.provider.fetchDataOfset10{ [weak self] (result) in
                
                switch result {
                    
                case .success(let response):

                    self?.array.append(Results(speedLimit: response.result.results[0].speedLimit,
                    road: response.result.results[0].road))
                    
                    group.leave()
                    
                case .failure:
                    print("error")
                    
                }
            }
        }
        
        //        group.leave()
        
        let queueThird = DispatchQueue(label: "queueThird", attributes: .concurrent)
        
        group.enter()
        
        queueThird.async(group: group) {
            
            self.provider.fetchDataOfset20{ [weak self] (result) in
                
                switch result {
                    
                case .success(let response):

                    self?.array.append(Results(speedLimit: response.result.results[0].speedLimit,
                                              road: response.result.results[0].road))
                    
                    group.leave()
                    
                case .failure:
                    print("error")
                    
                }
            }
        }
        
        //        group.leave()
        
        group.notify(queue: DispatchQueue.main) {
            // 完成所有 Call 後端 API 的動作
            print("完成所有 Call 後端 API 的動作")
            print(self.array)
            
            self.myUIView.setMyview(firstRoadText: self.array[0].road,
                                  secondRoadText: self.array[1].road,
                                  thirdRoadText: self.array[2].road,
                                  firstLimitText: self.array[0].speedLimit,
                                  secondLimitText: self.array[1].speedLimit,
                                  thirdLimitText: self.array[2].speedLimit)
        }
        
    }
    
    func useSemaphoreGetData() {
        
        // Ｑ1: value 的數字差別？
        let semaphore = DispatchSemaphore(value: 1)
        

        // DispatchQueue.global().async {
//            print("Ofset0 API 出發")
////            semaphore.wait()
//
//            self.provider.fetchDataOfset0 { (result) in
//
//                switch result {
//
//                    case .success(let response):
//
//                        print("Ofset0 - wait")
//                        semaphore.wait()
//                        self.myUIView.setSemaphoreFirst(firstRoadText: response.result.results[0].road,
//                                                        firstLimitText: response.result.results[0].speedLimit)
//
//                        semaphore.signal()
//                        print("Ofset0  - done")
//
//                    case .failure:
//                        print("error")
//
//                        }
//                    }
//
//            print("Ofset10 API 出發")
//
//            self.provider.fetchDataOfset10{ (result) in
//
//                switch result {
//
//                case .success(let response):
//
//                    print("Ofset10 - wait")
//                    semaphore.wait()
//                    self.myUIView.setSemaphoreSecond(secondRoadText: response.result.results[0].road,
//                                                     secondLimitText: response.result.results[0].speedLimit)
//                    semaphore.signal()
//                    print("Ofset10  - done")
//
//                case .failure:
//                    print("error")
//
//                }
//            }
//
//            print("Ofset20 API 出發")
//
//            self.provider.fetchDataOfset20 { (result) in
//
//                switch result {
//
//                case .success(let response):
//
//                    semaphore.wait()
//                    print("Ofset20 - wait")
//
//                    // sleep(1)
//                    self.myUIView.setSemaphoreThired(thirdRoadText: response.result.results[0].road,
//                                                     thirdLimitText: response.result.results[0].speedLimit)
//                    semaphore.signal()
//                    print("Ofset20  - done")
//
//                case .failure:
//                    print("error")
//
//                }
//            }
//
//        }
        
        // Ｑ: Qos 的用法
        DispatchQueue.global().async {

            print("Ofset0 API 出發")
            //這裡是叫 api 等，不會同時發
            //  semaphore.wait()

            self.provider.fetchDataOfset0 {[weak self] (result) in

                switch result {

                case .success(let response):

                    semaphore.wait()
                    print("Ofset0 - wait")

                    self?.myUIView.setSemaphoreFirst(firstRoadText: response.result.results[0].road,
                                                    firstLimitText: response.result.results[0].speedLimit)

                    semaphore.signal()
                    print("Ofset0  - done")

                case .failure:
                    print("error")

                }
            }
        }

        DispatchQueue.global().async {

            print("Ofset10 API 出發")

            self.provider.fetchDataOfset10{ [weak self](result) in

                switch result {

                case .success(let response):
                    
                    print("Ofset10 - wait")
                    semaphore.wait()
                    
                    sleep(1)
                    self?.myUIView.setSemaphoreSecond(secondRoadText: response.result.results[0].road,
                                                     secondLimitText: response.result.results[0].speedLimit)
                    semaphore.signal()
                    print("Ofset10  - done")

                case .failure:
                    print("error")

                }
            }
        }

        DispatchQueue.global().async {

            print("Ofset20 API 出發")
           
            self.provider.fetchDataOfset20 {[weak self] (result) in

                switch result {

                case .success(let response):
                    
                    print("Ofset20 - wait")
                    semaphore.wait()

                    sleep(1)
                    self?.myUIView.setSemaphoreThired(thirdRoadText: response.result.results[0].road,
                                                     thirdLimitText: response.result.results[0].speedLimit)
                    semaphore.signal()
                    print("Ofset20  - done")

                case .failure:
                    print("error")

                }
            }
        }
    }
    
    func clearData() {
    
        self.myUIView.setMyview(firstRoadText: "Road", secondRoadText: "Road", thirdRoadText: "Road", firstLimitText: "Limit", secondLimitText: "Limit", thirdLimitText: "Limit")
        self.array = []
    }
    
}

