//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by Gaurav Oka on 11/21/17.
//  Copyright © 2017 Gaurav Oka. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit


class ViewController: UIViewController {
    var btnnext = UIButton()
    var btnrxswift = UIButton()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - btnnext
         btnnext.setTitle("Next Page", for: .normal)
         btnnext.setTitleColor(UIColor .black, for: .normal)
         btnnext.layer.borderWidth = 1
         btnnext.layer.cornerRadius = 10
        btnnext.addTarget(self, action: #selector(nextpage), for: .touchUpInside)
        view.addSubview(btnnext)
         btnnext.frame = CGRect(x:200,y:200,width:150,height:60)
        btnnext.snp.makeConstraints{(make) in
            make.centerX.equalTo(view)
            make.center.equalTo(view)
            make.width.equalTo(150)
        }
        
        //MARK:- btnrxswift
        
        btnrxswift.setTitle("Go to Reactive Swift", for: .normal)
        btnrxswift.setTitleColor(UIColor .black, for: .normal)
        btnrxswift.layer.borderWidth = 1
        btnrxswift.layer.cornerRadius = 10
        btnrxswift.addTarget(self, action:#selector(goToRxSwift), for: .touchUpInside)
        view.addSubview(btnrxswift)
        btnrxswift.snp.makeConstraints{(make) in
            make.top.equalTo(btnnext.snp.bottom).offset(50)
            make.width.equalTo(200)
            //make.height.equalTo(60)
            make.centerX.equalTo(view)
        }
        
        //***ReactiveX Swift Starts***
    
        //MARK:-Creating Observable
    let helloSequence = Observable.from([1,1,2,3,5,8,13,21,34])
    print("Obervable Example \n")
    helloSequence.subscribe{
        event in
            print(event)
    
    }
        // Creating a DisposeBag so subscribtion will be cancelled correctly
        let bag = DisposeBag()
        // Creating an Observable Sequence that emits a String value
        let observable = Observable.just("Hello Rx!")
        // Creating a subscription just for next events to emit observables.
        let subscription = observable.subscribe (onNext:{
            
           print($0)
        })
        // Adding the Subscription to a Dispose Bag
        subscription.disposed(by: bag)
        
        //type of subjects with examples
        //MARK:PublishSubject
        // 1)PublishSubject it returns all events of observables after it subscribed
        let publishSubject = PublishSubject<String>()
        
        print("\n PublsihSubject Examlple \n")
        
        publishSubject.onNext("Hello")
        publishSubject.onNext("Adriane")
        
        let subscription1 = publishSubject.subscribe(onNext:{
            print($0)
        }).disposed(by: bag)
        
        // Subscription1 receives these 2 events, Subscription2 won't
        publishSubject.onNext("Hello")
        publishSubject.onNext("Again")
        
        // Sub2 will not get "Hello" and "Again" because it susbcribed later
        let subscription2 = publishSubject.subscribe(onNext:{
            print(#line,$0)
        })
    
        publishSubject.onNext("Both Subscriptions receive this message")
        //MARK:-BehaviorSubject
        // 2)BehaviorSubject it returns most  recent event after subscription of observable.
        
        let behaviorSubject = BehaviorSubject<String>(value: "Hey This is initial element")
        behaviorSubject.onNext("Hello in behaviorSubject")
        behaviorSubject.onNext("world in behaviorSubject")
        
        print("\n BehaviorSubject Examlple \n")
        
        let behavesub = behaviorSubject.subscribe(onNext: {
            print($0)
        })
        
        //MARK:-ReplaySubject
        //3) ReplaySubject it returns  more than most recent event of observable , we have to set no of items we want to emit from observable.
        
        let replaySubject = ReplaySubject<String>.create(bufferSize: 2)
        replaySubject.onNext("Hello in replaySubject")
        replaySubject.onNext("world in replaySubject")
        replaySubject.onNext("Adriane in replaySubject")
        
        print("\n ReplaySubject Examlple \n")
        
        let replaysub = replaySubject.subscribe(onNext: {
            print($0)
        })
        
        
        //MARK: - Transformations Map
        //-it sets condition to observable before it gets subscribed
        
        let sequence = Observable.from([1,2,3,4])
        
        print("\n Map Transformation Examlple \n")
        
        sequence.map({
            value in
            return  value * 10
            
        }).subscribe({
            event in
            print(event)
            
        })
        
        
        //MARK:-Transformations FlatMaps
        //-it merges results of two different observables in new observable.
        
        let flatmapseq1 = Observable<Int>.of(1,2)
        let flatmapseq2 = Observable<Int>.of(1,2)
        
        let flatmapseq3 = Observable.of(flatmapseq1,flatmapseq2)
        
        print("\n FlatMap Transformation Examlple \n")
        
        flatmapseq3.flatMap{return $0}.subscribe(onNext:{
            print($0)
        })
        
        
        //MARK:-Transformations Scan
        //-it starts with initial seed and it gets add next value in observable in seed and sotres result back in seed, just like reduce in swift
        
        let scanseq = Observable.of(1,2,3,4,5)
        
        print("\n Transformation Scan Examlple \n")
        scanseq.scan(0){seed,value in
            return seed + value}.subscribe(onNext:{
                print($0)
            })
        
        
        //Buffer ?
//        let  bufferseq = Observable.of(1,2,3,4,5,6,7)
//        bufferseq.buffer(timeSpan: 150, count: 3,
//        scheduler:SchedulerType.self as! SchedulerType).subscribe(onNext:{
//            print($0)
//
//        })
    
   
        //MARK: - Filter
        //-if you  only want to react on next event  you use filter.bag
        
        let filterseq = Observable.of(1,4,20,32,50,9,6)
        
        print("\n Transformation Filter Examlple \n")
        
        filterseq.filter{ $0 > 10 }.subscribe(onNext:{
            print($0)
        })
        
        //MARK:-distinctUntilChanged
        //if we want to emit next event only if value changed from previous event we use distinctUntilChanged
        
        let distseq = Observable.of(1,1,1,2,2,2,3,4,4,5,5,5,6,6,7)
        
        print("\n Transformation distincttilchanged Examlple \n")
        distseq.distinctUntilChanged().subscribe(onNext:{
            print($0)
        })
        
        
        
        //MARK:-combine startwith
        //- if we want obsevable to emit specific sequence of item before it emit its normal sequence we use startwith.
        
        let startwithseq = Observable.of(5,6,7)
        print("\n Combine Start With Example \n")
        startwithseq.startWith(1).subscribe(onNext:{
            print($0)
        })
        
        //MARK:-Merge
        //- when we want to combine emitions of   multiple obsevables in one we use merge
        
        let mergeseq1 = Observable.of(1,2,3,4)
        let mergeseq2 = Observable.of(10,20,30,40)
        let mergeseq3 = Observable.of(mergeseq1,mergeseq2)
        
        print("\n Combine Merge Example \n")
        mergeseq3.merge().subscribe(onNext:{
            print($0)
        })
        
        //MARK:- Zip
        //- we use zip  when we want to merge items from different sequence to one observer.
        // zip will emit elements in strict manner so first element emit by zip is first element from first sequence and first element from second sequence.
        
        let zipseq1 = Observable.of(1,2,3,4)
        let zipseq2 = Observable.of("a","b","c","d")
        print("\n Zip Example \n")
        Observable.zip(zipseq1,zipseq2){return ($0,$1) }.subscribe(onNext:{
            print($0)
        })
        
        
        //MARK: - do
        //- when we want to register callback  which will executed after specific  events takes place  on an Observable sequence we use do
        let doseq =  Observable.of(1,2,3,4,5)
        
        print("\n Side Effect - do Example \n")
        doseq.do(onNext:{
            $0 * 10 // This has no effect on the actual subscription
        }).subscribe(onNext:{
            print($0)
        })
        
        
        // MARK: - Scheduler
        //operators will work on the same thread where subscription is made we can assign specific queues to operator as well as subscription. we use observeOn and subscribeOn for those tasks.
        
        
        let scheduleseq1 = PublishSubject<Int>()
        let scheduleseq2 = PublishSubject<Int>()
        let scheduleseq3 = Observable.of(scheduleseq1,scheduleseq2)
        
        let concurentscheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        
        print(" \n Scheduler Example \n")
        scheduleseq3.observeOn(concurentscheduler).merge().subscribeOn(MainScheduler()).subscribe(onNext:{
            print($0)
        })
        
       
        scheduleseq1.onNext(20)
        scheduleseq1.onNext(40)
        
    }
    
    @objc func goToRxSwift()
    {
        let viewcon = rxSwiftViewController()
        
        self.navigationController?.pushViewController(viewcon, animated: true)
        
        
        
    }
    
    @objc func nextpage()
    {
        let viewcon = BLEViewController()
        self.navigationController?.pushViewController(viewcon, animated: true)
        
    }
    
    



}

