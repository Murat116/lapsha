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

    @IBOutlet weak var scroolView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //begin OF Timer
        let start = CFAbsoluteTimeGetCurrent()
        
        //get frame of events from group
        array = createFrameOfEvent(arrayWityBegin: array)
        
        
        //create view with event
        for i in 0..<array.count{
           
            //height of event
            let height = array[i]["end"]! - array[i]["start"]!
            
            //width of screen
            let defualtWidth = Int(UIScreen.main.bounds.width)
            
            //create view
            let myNewView = UIView(frame: CGRect(x: array[i]["x"] ?? 0, y: array[i]["start"]!, width: array[i]["wight"] ?? defualtWidth , height: height))
            
            //grete rundom background color
            let color = UIColor(red: CGFloat(Float.random(in: 0...1.0)), green: CGFloat(Float.random(in: 0...1.0)), blue: CGFloat(Float.random(in: 0...1.0)), alpha: 0.7)
            myNewView.backgroundColor = color
            
            let label = UILabel(frame: CGRect(x: myNewView.frame.size.width / 2, y: myNewView.frame.size.height / 2 , width: 20, height: 20))
                
            label.text = String(i)
            
            myNewView.addSubview(label)
            //add view in scrool
            self.scroolView.addSubview(myNewView)
        }
        
        //get and of timer
        let dif = CFAbsoluteTimeGetCurrent() - start
        
        //display text in the label
        kek.text = String(dif)
        
        
        self.scroolView.frame = self.view.frame
        
        //create height of scrool
        self.scroolView.contentSize.height = 5000
        self.scroolView.contentSize.width = 1000
        
        
        print(array)
        
        print(dif)
    }

    
    @IBOutlet weak var kek: UILabel!
    
    //func which create Frame For All overlooping Event
    func getFrameOfEvents(OverlopEnentArr : [Int], arrayWIthBegin: [[String : Int]], widht: Int) -> [[String:Int]]{
        var arrayWIthEvents = arrayWIthBegin
        var countOfEvent = 0 // на сколько нужно увеличить ширину некоторых событий
        print(OverlopEnentArr)
        //if array with overlopping events dosen't empty we can crete coordinatis for it
        if OverlopEnentArr.count != 0{
            let weightForAllElements = Int(UIScreen.main.bounds.width) / widht //по-моему вот тут!
            
            //create coordinates for first event in froup bcs we know x and width
            arrayWIthEvents[OverlopEnentArr[0]]["x"] = 0
            arrayWIthEvents[OverlopEnentArr[0]]["wight"] = weightForAllElements
            
            //create coordinates for others event
            for i in 1..<OverlopEnentArr.count{
            
                guard let xOfLastEvent = arrayWIthEvents[OverlopEnentArr[i - 1]]["x"] else{
                    return arrayWIthEvents
                }
                
                //если конец нынешнего события больше начала прошлого значит они идут друг за другом, обратное утврждение означает что они идут друг под другом(в одном столбце) в соотвествии с этим задаем коорлинаты
                if let end = arrayWIthEvents[OverlopEnentArr[i]]["end"], let startLast = arrayWIthEvents[OverlopEnentArr[i - 1]]["start"], end > startLast{
             
                   print(OverlopEnentArr[i],"end > start")
                    
                   
                   var remomeAt = i - 1
                    while let start = arrayWIthEvents[OverlopEnentArr[i]]["start"],let endLast = arrayWIthEvents[OverlopEnentArr[remomeAt]]["end"], startLast >= endLast{
                        remomeAt -= 1
                    }
                    print(OverlopEnentArr[remomeAt],OverlopEnentArr[i],"index")
                    
                    guard let xOfDesiredEvent = arrayWIthEvents[OverlopEnentArr[remomeAt]]["x"] else{
                        return arrayWIthEvents
                    }
                    
                    arrayWIthEvents[OverlopEnentArr[i]]["x"] = xOfDesiredEvent + weightForAllElements
                    print(OverlopEnentArr[i],arrayWIthEvents[OverlopEnentArr[i]]["x"] )
                    arrayWIthEvents[OverlopEnentArr[i]]["wight"] = weightForAllElements
                    //
                } else {
                    print(OverlopEnentArr[i],"end < start")
                
                    var index = i - 1
                    
                    while let end = arrayWIthEvents[OverlopEnentArr[i]]["end"], let startLast = arrayWIthEvents[OverlopEnentArr[index]]["start"], end <= startLast{
                        index -= 1
                    }
                     print(OverlopEnentArr[index],OverlopEnentArr[i],"index")
                    
                    guard let xOfDesiredEvent = arrayWIthEvents[OverlopEnentArr[index]]["x"] else{
                        return arrayWIthEvents
                    }
                    
                    arrayWIthEvents[OverlopEnentArr[i]]["x"] = xOfDesiredEvent + weightForAllElements
                    
                    arrayWIthEvents[OverlopEnentArr[i]]["wight"] = weightForAllElements
                }
                
                //решение проблемы с увеличение ширины некоторые вьюх
                //проблмеа решенна в лоб, TODO: переделать или доработать
                //TODO: добавить проверку по енду и бегин некст
                
                
                
                if arrayWIthEvents[OverlopEnentArr[i]]["overlop"] != nil , let xlast = arrayWIthEvents[OverlopEnentArr[i] - 1]["x"], let x = arrayWIthEvents[OverlopEnentArr[i]]["x"], xlast + weightForAllElements != x{
                    
                   //arrayWIthEvents[OverlopEnentArr[i]]["x"] = arrayWIthEvents[OverlopEnentArr[i] + 1]["x"]
                    
                    print(OverlopEnentArr[i],"растягивай")
                }
                
            }
            
        }
        return arrayWIthEvents
    }
    
    //func which add index of overlopping event from array with all events to array with index from group
    func addIndexInGroup (OverlopEnentArr: [Int], array: [[String : Int]], index: Int) -> [Int]{
        
        var list = OverlopEnentArr
        var indexMin = list.startIndex
        var indexMax = list.endIndex-1
        var oldindexMid = 0
        
        guard let end = array[index]["end"] else{
            return list
        }
        
        guard let start = array[index]["start"] else{
            return list
        }
        
        let value = end - start
        
        //binary search index
        while indexMin <= indexMax{
            
            let indexMid = indexMin + (indexMax - indexMin)/2
            
            //line serch
            if indexMid == 0 || indexMid == oldindexMid{
                var indexOfMax = indexMid
                
                while let end = array[list[indexOfMax]]["end"], let begin = array[list[indexOfMax]]["start"], end - begin > value {
                        
                        indexOfMax += 1
                        
                        if indexOfMax == list.count{
                            
                            break
                        }
                }
                
                list.insert(index, at: indexOfMax)
                return list
            }
            
            
            
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
        
     
        return list
    }
    
    func createFrameOfEvent(arrayWityBegin: [[String: Int]] ) -> [[String: Int]]{
        
        
        
        var OverlopEnentArr = [Int]()
        var oldMaxHeightIndex = 0
        var maxHeightIndex = 0 //index for the most height event
        var widht: Int = 0 //variable for counting overlloping ; this varuable is used for calculations the wight for everi event in overrlopingEvent
        var lastEventInGroup = 0
        var arrayWIthEvents = arrayWityBegin
        
        func oneCount(i: Int = 0) -> (Int) {
            
            var maxHeight = 0 //height of tallest event in overloppingEvent
            
            var indexOfMax = 0
            
            //если это последний элемент и массив с группами еше не пустой значит последнее событий ввходит в группу =>
            if i + 1 == arrayWIthEvents.count && OverlopEnentArr.count != 0{
                if let start = arrayWIthEvents[i]["start"], let endOFLast =  arrayWIthEvents[i - 1]["end"], start < endOFLast{
                    
                    
                    
                    OverlopEnentArr = addIndexInGroup(OverlopEnentArr: OverlopEnentArr, array: arrayWIthEvents, index: i)
                    
                    indexOfMax = OverlopEnentArr.firstIndex(of: i) ?? 0
                    
                    if indexOfMax != 0, let start =           arrayWIthEvents[OverlopEnentArr[indexOfMax]]["start"], let endOfLast = arrayWIthEvents[OverlopEnentArr[indexOfMax - 1]]["end"],
                        start > endOfLast ||
                            indexOfMax + 1 < OverlopEnentArr.count, let endOfNext = arrayWIthEvents[OverlopEnentArr[indexOfMax + 1]]["end"],
                        start >  endOfNext {
                        
                        widht -= 1
                        
                    }
                    
                    widht += 1
                    
                }
                
                

                arrayWIthEvents = getFrameOfEvents(OverlopEnentArr: OverlopEnentArr, arrayWIthBegin: arrayWIthEvents, widht: widht)
                
                return i
            }
            
            guard let endFirst = arrayWIthEvents[i]["end"] else {
                return i
            }
            
            guard let beginSecond = arrayWIthEvents[i + 1]["start"] else {
                return i
            }
            
            oldMaxHeightIndex = maxHeightIndex
            
            //пока условие наложение выполняется мы ...
            
            //если следом идущее событий совпалае
            if endFirst > beginSecond{
                
                
                
                guard let end = arrayWIthEvents[i]["end"] else {
                    return i
                }
                
                //обновляем индекс максимально длинного события
                if end > maxHeight{
                    maxHeight = end
                    maxHeightIndex = i
                }
                
                
                
                if OverlopEnentArr.count != 0, let oldMaxHeightEnd = arrayWIthEvents[maxHeightIndex]["end"], let start = arrayWIthEvents[i]["start"], oldMaxHeightEnd > start{
                    
                    
                    OverlopEnentArr = addIndexInGroup(OverlopEnentArr: OverlopEnentArr, array: arrayWIthEvents, index: i)
                    
                    indexOfMax = OverlopEnentArr.firstIndex(of: i) ?? 0
                    
                    if indexOfMax != 0, let start = arrayWIthEvents[OverlopEnentArr[indexOfMax]]["start"], let endOfLast = arrayWIthEvents[OverlopEnentArr[indexOfMax - 1]]["end"], start > endOfLast || indexOfMax + 1 < OverlopEnentArr.count, let endOfNext = arrayWIthEvents[OverlopEnentArr[indexOfMax + 1]]["end"], start >  endOfNext {
                        
                        widht -= 1
                        
                    }
                    
                    widht += 1
                    
                    if i > lastEventInGroup{
                        lastEventInGroup = i
                    }
                    
                } else {
                    
                   
                    arrayWIthEvents = getFrameOfEvents(OverlopEnentArr: OverlopEnentArr, arrayWIthBegin: arrayWIthEvents, widht: widht)
                    
                    widht = 1
                    
                    OverlopEnentArr.removeAll()
                    OverlopEnentArr.append(i)
                    
                }
                
            } else if let start = arrayWIthEvents[i]["start"], OverlopEnentArr.isEmpty == false, let maxHeightEnd = arrayWIthEvents[OverlopEnentArr[0]]["end"], maxHeightEnd > start {
                
                arrayWIthEvents[i]["overlop"] = 1
                
                

                
                OverlopEnentArr = addIndexInGroup(OverlopEnentArr: OverlopEnentArr, array: arrayWIthEvents, index: i)
                
                indexOfMax = OverlopEnentArr.firstIndex(of: i) ?? 0
                
                if indexOfMax != 0, let start = arrayWIthEvents[OverlopEnentArr[indexOfMax]]["start"], let endOfLast = arrayWIthEvents[OverlopEnentArr[indexOfMax - 1]]["end"], start > endOfLast || indexOfMax + 1 < OverlopEnentArr.count, let endOfNext = arrayWIthEvents[OverlopEnentArr[indexOfMax + 1]]["end"], start >  endOfNext {
                    
                    widht -= 1
                    
                }
                
                widht += 1
                
            } else if lastEventInGroup + 1 == i && OverlopEnentArr.count != 0 {
                
                OverlopEnentArr = addIndexInGroup(OverlopEnentArr: OverlopEnentArr, array: arrayWIthEvents, index: i)
                
                indexOfMax = OverlopEnentArr.firstIndex(of: i) ?? 0
                
                if indexOfMax != 0, let start = arrayWIthEvents[OverlopEnentArr[indexOfMax]]["start"], let endOfLast = arrayWIthEvents[OverlopEnentArr[indexOfMax - 1]]["end"], start > endOfLast || indexOfMax + 1 < OverlopEnentArr.count, let endOfNext = arrayWIthEvents[OverlopEnentArr[indexOfMax + 1]]["end"], start >  endOfNext {
                    
                    widht -= 1
                    
                }
                
                widht += 1
                
                
                arrayWIthEvents = getFrameOfEvents(OverlopEnentArr: OverlopEnentArr, arrayWIthBegin: arrayWIthEvents, widht: widht)
               
                OverlopEnentArr.removeAll()
                
            } else {
                return i
            }
            
            
            return oneCount(i: i + 1) //start again
        }
        var go: Int = 0
        while go <= arrayWIthEvents.count - 1{
            
            go = oneCount(i: go) + 1
            
        }
        
        return arrayWIthEvents
    }

    //time of run
    
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
    
    
    //v5 с постройков вьюх 11 накладывающихся событий 0.011510968208312988,0.043148040771484375,0.007544040679931641, 0.011369943618774414, 0.013023972511291504, 0.006308913230895996, 0.011523008346557617,0.006826996803283691,0.0023859739303588867
    
}

