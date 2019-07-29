//
//  ViewController.swift
//  Lapsha
//
//  Created by Мурат Камалов on 25/07/2019.
//  Copyright © 2019 Мурат Камалов. All rights reserved.
//

import UIKit

var time: Double = 0

class ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        //1430 / start
        //1439 / strart
        // <0 быть не может
        
        var secondArray = [["start": 1, "end" : 10],
                           ["start": 2, "end" : 102],
                           ["start": 4, "end" : 103],
                           ["start": 5, "end" : 90],
                           ["start": 1, "end" : 100 ]
        ]
        
        //function for create frame for all events in group
        func getFrameOfEvents(arrayForOverloppingevents : [Int], arrayWIthBegin: [[String : Int]], widht: Int) -> [[String:Int]]{
            var arrayWIthEvents = arrayWIthBegin
            if arrayForOverloppingevents.count != 0{
                let weightForAllElements = Int(UIScreen.main.bounds.width) / widht //по-моему вот тут!
                
                arrayWIthEvents[arrayForOverloppingevents[0]]["x"] = 0
                arrayWIthEvents[arrayForOverloppingevents[0]]["wight"] = weightForAllElements
                
                for i in 1..<arrayForOverloppingevents.count{
                    
                    if arrayWIthEvents[arrayForOverloppingevents[i]]["end"]! > arrayWIthEvents[arrayForOverloppingevents[i - 1]]["start"]!{
                        
                        arrayWIthEvents[arrayForOverloppingevents[i]]["x"] = arrayWIthEvents[arrayForOverloppingevents[i - 1]]["x"]! + weightForAllElements
                        
                        arrayWIthEvents[arrayForOverloppingevents[i]]["wight"] = weightForAllElements
                    } else {
                        
                        arrayWIthEvents[arrayForOverloppingevents[i]]["x"] = arrayWIthEvents[arrayForOverloppingevents[i - 1]]["x"]!
                        
                        arrayWIthEvents[arrayForOverloppingevents[i]]["wight"] = weightForAllElements
                    }
                    
                    
                }
                //задаем все x
                
            }
            return arrayWIthEvents
        }
        
        func addIndexInGroup (arrayForOverloppingevents: [Int], array: [[String : Int]], index: Int) -> [Int]{
            
            var list = arrayForOverloppingevents
            var indexMin = list.startIndex
            var indexMax = list.endIndex-1
            var oldindexMid = 0
            
            let value = array[index]["end"]! - array[index]["start"]!
            
            while indexMin <= indexMax{
                
                let indexMid = indexMin + (indexMax - indexMin)/2
                
                if indexMid == 0 || indexMid == oldindexMid{
                    var indexOfMax = indexMid
                    
                    while
                        ( array[list[indexOfMax]]["end"]! - array[list[indexOfMax]]["start"]! ) > value {
                            
                            indexOfMax += 1
                            
                            if indexOfMax == list.count{
                                
                                break
                            }
                    }
                    
                    list.insert(index, at: indexOfMax)
                    return list
                }
                
                
                print(indexMid)
                guard let begin = array[list[indexMid]]["start"] else {
                    return list
                }
                
                guard let end = array[list[indexMid]]["end"] else {
                    return list
                }
                
                guard let beginOfnext = array[list[indexMid + 1]]["start"] else {
                    return list
                }
                
                guard let endOfNext = array[list[indexMid + 1]]["end"] else {
                    return list
                }
                let lengthOfNext = endOfNext -  beginOfnext
                
                let length = end - begin
                
                if length >= value && value >= lengthOfNext{
                    list.insert(index, at: indexMid + 1)
                    return list
                }
                
                if value < length{
                    
                    indexMin = indexMid
                    
                }
                else{
                    
                    indexMax = indexMid
                    
                }
                oldindexMid = indexMid
            }
            //}
            print("return nil")
            return list
        }
        
        func createFrameOfEvent(arrayWityBegin: [[String: Int]] ) -> [[String: Int]]{
            
            
            
            var arrayForOverloppingevents = [Int]()
            var oldMaxHeightIndex = 0
            var maxHeightIndex = 0 //index for the most height event
            var widht: Int = 0 //variable for counting overlloping ; this varuable is used for calculations the wight for everi event in overrlopingEvent
            var lastEventInGroup = 0
            var arrayWIthEvents = arrayWityBegin
            
            func oneCount(i: Int = 0) -> (Int) {
                
                
                
                var maxHeight = 0 //height of tallest event in overloppingEvent
                var startIndex = i
                var indexOfMax = 0
                
                if startIndex + 1 == arrayWIthEvents.count && arrayForOverloppingevents.count != 0{
                    if arrayWIthEvents[i]["start"]! < arrayWIthEvents[i - 1]["end"]!{
                        arrayForOverloppingevents = addIndexInGroup(arrayForOverloppingevents: arrayForOverloppingevents, array: arrayWIthEvents, index: i)
                        
                        if (indexOfMax != 0 && arrayWIthEvents[arrayForOverloppingevents[indexOfMax]]["start"]! > arrayWIthEvents[arrayForOverloppingevents[indexOfMax - 1]]["end"]!) || (indexOfMax + 1 < arrayForOverloppingevents.count && arrayWIthEvents[arrayForOverloppingevents[indexOfMax]]["start"]! >  arrayWIthEvents[arrayForOverloppingevents[indexOfMax + 1]]["end"]!) {
                            widht -= 1
                            
                        }
                        
                        widht += 1
                        //addIndexInGroup(index: i)
                    }
                    //print(i,"getframeFirst")
                    arrayWIthEvents = getFrameOfEvents(arrayForOverloppingevents: arrayForOverloppingevents, arrayWIthBegin: arrayWIthEvents, widht: widht)
                    //getFrameOfEvents()
                    return startIndex
                }
                
                guard let endFirst = arrayWIthEvents[startIndex]["end"] else {
                    return startIndex
                }
                
                guard let beginSecond = arrayWIthEvents[startIndex + 1]["start"] else {
                    return startIndex
                }
                
                oldMaxHeightIndex = maxHeightIndex
                
                //пока условие наложение выполняется мы ...
                
                if endFirst > beginSecond{
                    
                    
                    
                    guard let end = arrayWIthEvents[i]["end"] else {
                        return startIndex
                    }
                    
                    
                    if end > maxHeight{
                        maxHeight = end
                        maxHeightIndex = startIndex
                    }
                    
                    if arrayForOverloppingevents.count != 0 && arrayWIthEvents[oldMaxHeightIndex]["end"]! > arrayWIthEvents[i]["start"]!{
                        
                        arrayForOverloppingevents = addIndexInGroup(arrayForOverloppingevents: arrayForOverloppingevents, array: arrayWIthEvents, index: i)
                        
                        if (indexOfMax != 0 && arrayWIthEvents[arrayForOverloppingevents[indexOfMax]]["start"]! > arrayWIthEvents[arrayForOverloppingevents[indexOfMax - 1]]["end"]!) || (indexOfMax + 1 < arrayForOverloppingevents.count && arrayWIthEvents[arrayForOverloppingevents[indexOfMax]]["start"]! >  arrayWIthEvents[arrayForOverloppingevents[indexOfMax + 1]]["end"]!) {
                            widht -= 1
                            
                        }
                        
                        widht += 1
                        
                        if i > lastEventInGroup{
                            lastEventInGroup = i
                        }
                        
                    } else {
                        
                        arrayWIthEvents = getFrameOfEvents(arrayForOverloppingevents: arrayForOverloppingevents, arrayWIthBegin: arrayWIthEvents, widht: widht)
                        print(i,"getframeSecond")
                        print(arrayForOverloppingevents)
                        widht = 1
                        
                        arrayForOverloppingevents.removeAll()
                        arrayForOverloppingevents.append(i)
                        
                    }
                    
                } else if arrayForOverloppingevents.isEmpty == false && arrayWIthEvents[arrayForOverloppingevents[0]]["end"]! > arrayWIthEvents[i]["start"]! {
                    //добавляются лишие элементы
                    
                    while
                        (arrayWIthEvents[arrayForOverloppingevents[indexOfMax]]["end"]! - arrayWIthEvents[arrayForOverloppingevents[indexOfMax]]["start"]! ) > arrayWIthEvents[i]["end"]! - arrayWIthEvents[i]["start"]!{
                            
                            indexOfMax += 1
                            
                            if indexOfMax == arrayForOverloppingevents.count{
                                break
                            }
                    }
                    
                    
                    arrayForOverloppingevents.insert(startIndex, at: indexOfMax)
                    
                    if (indexOfMax != 0 && arrayWIthEvents[arrayForOverloppingevents[indexOfMax]]["start"]! > arrayWIthEvents[arrayForOverloppingevents[indexOfMax - 1]]["end"]!) || (indexOfMax + 1 < arrayForOverloppingevents.count && arrayWIthEvents[arrayForOverloppingevents[indexOfMax]]["start"]! >  arrayWIthEvents[arrayForOverloppingevents[indexOfMax + 1]]["end"]!) {
                        widht -= 1
                        
                    }
                    
                    widht += 1
                    
                } else if lastEventInGroup + 1 == i && arrayForOverloppingevents.count != 0 {
                    print("error")
                    
                    arrayForOverloppingevents = addIndexInGroup(arrayForOverloppingevents: arrayForOverloppingevents, array: arrayWIthEvents, index: i)
                    
                    if (indexOfMax != 0 && arrayWIthEvents[arrayForOverloppingevents[indexOfMax]]["start"]! > arrayWIthEvents[arrayForOverloppingevents[indexOfMax - 1]]["end"]!) || (indexOfMax + 1 < arrayForOverloppingevents.count && arrayWIthEvents[arrayForOverloppingevents[indexOfMax]]["start"]! >  arrayWIthEvents[arrayForOverloppingevents[indexOfMax + 1]]["end"]!) {
                        widht -= 1
                        
                    }
                    
                    widht += 1
                    
                    print(arrayForOverloppingevents)
                    arrayWIthEvents = getFrameOfEvents(arrayForOverloppingevents: arrayForOverloppingevents, arrayWIthBegin: arrayWIthEvents, widht: widht)
                    print(i,"getframeThird")
                    arrayForOverloppingevents.removeAll()
                    
                } else {
                    return startIndex
                }
                
                print(arrayForOverloppingevents)
                return oneCount(i: startIndex + 1) //start again
            }
            var go: Int = 0
            while go <= arrayWIthEvents.count - 1{
                print(go,"before")
                go = oneCount(i: go) + 1
                print(go)
            }
            
            return arrayWIthEvents
        }
        
        let start = CFAbsoluteTimeGetCurrent()
        
        
        array = createFrameOfEvent(arrayWityBegin: array)
        
        
        let dif = CFAbsoluteTimeGetCurrent() - start
        
        kek.text = String(dif)
        
        
        
        print(array)
        
        print(dif)
    }

    
    @IBOutlet weak var kek: UILabel!
    //0.00214999
    //0.001956
    //0.001177
    // 19;0.0017
    // 18;0.00153
    // 17;0.00217
    // 16;0.00135
    // 15;0.00111
    // 14;0.00107
    // 13;0.001104
    // 11;0.001232
    // 9;0.00077
    // 6;0.0011260
    //180 0.004
    //180 v1 0.006121993064880371 0.010865926742553711 0.004848003387451172 0.010517001152038574 0.004477977752685547 0.0030059814453125 0.002969026565551758 0.0032520294189453125
    //180 v2 0.00501406192779541 0.00866091251373291 0.010090947151184082 0.010529041290283203 0.0031169652938842773 0.0029529333114624023 0.003175973892211914 0.002987980842590332
    
    //180 v3 0.002043008804321289  0.0013910531997680664 0.0011619329452514648 0.0014650821685791016 0.0013710260391235352 0.0012639760971069336
    //1097 = 0.013
    //28012 0.2120 //15 накалдывающихся
    //58012 0.5128580331802368
    //97644 0.7289819717407227
    
    //v4
    //15 событий из которых 7 и 3 накладывающиеся события 0.007673025131225586
    //180  0.006904006004333496 0.006711006164550781 0.010007977485656738 0.007675051689147949
    //316 0.01512598991394043
    
    //25 к 0.91530597 0.849297046661377 0.8720730543136597
    //0.8520830869674683
    
    //110 накадывающихся событий 0.02  0.019806981086730957
}

