//
//  CreateGroup.swift
//  Lapsha
//
//  Created by Мурат Камалов on 03/08/2019.
//  Copyright © 2019 Мурат Камалов. All rights reserved.
//

import UIKit


class CreateGroup: UIViewController {

     @IBOutlet weak var scroolView: UIScrollView!
    @IBOutlet weak var lavel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let start = CFAbsoluteTimeGetCurrent()

        createGroup(arrayWithEvents: &array)
        let dif = CFAbsoluteTimeGetCurrent() - start

        print(dif)

        lavel.text = String(dif)

        for i in 0..<array.count{

            //height of event
            let height = array[i]["end"]! - array[i]["start"]!

            //width of screen
            let defualtWidth = Int(UIScreen.main.bounds.width)

            //create view
            let myNewView = UIView(frame: CGRect(x: array[i]["x"] ?? 0, y: array[i]["start"]!, width: array[i]["widht"] ?? defualtWidth , height: height))

            //grete rundom background color
            let color = UIColor(red: CGFloat(Float.random(in: 0...1.0)), green: CGFloat(Float.random(in: 0...1.0)), blue: CGFloat(Float.random(in: 0...1.0)), alpha: 0.7)
            myNewView.backgroundColor = color

            let label = UILabel(frame: CGRect(x: myNewView.frame.size.width / 2, y: myNewView.frame.size.height / 2 , width: 20, height: 20))

            label.text = String(i)
            label.sizeToFit()

            myNewView.addSubview(label)
            //add view in scrool
            self.scroolView.addSubview(myNewView)
        }

        self.scroolView.frame = self.view.frame

        //create height of scrool
        self.scroolView.contentSize.height = 3200

    }

    var lastIndex: [Int] = []
    var arrayEventsCount = array.count - 1
    var maxEnd = 0
    var matrixGroup = [[Int]]()
    var groupElementsCount = [Int]()


    func addInMatrix(index: Int,length : Int, array: [[String:Int]], nextInGroup: Int, endLast: Int) {

        guard let start = array[index]["start"] else { return }
        guard let end = array[index]["end"] else { return }

        let level = lastIndex[0]
        let position = lastIndex[1]
        let addArray = matrixGroup[level]
        let addArrayCount = addArray.count - 1

        func binarySearchj(){
            var indexMin : Int
            var indexMax : Int
            let addedLevel = matrixGroup[level]

            var oldindexMid: Int = -1
            if let startLast = array[index - 1]["start"],
                endLast - startLast >= end - start{
                indexMin = position
                indexMax = addArray.endIndex - 1
            } else {
                indexMin = addArray.startIndex
                indexMax = position
            }
            while indexMin <= indexMax{

                let indexMid = indexMin + (indexMax - indexMin)/2

                if indexMid == addArrayCount{
                    lastIndex = [level,addArrayCount]
                    break
                }

                guard let begin = array[addedLevel[indexMid]]["start"] else { return }

                guard let end = array[addedLevel[indexMid]]["end"] else { return }

                guard let beginOfnext = array[addedLevel[indexMid + 1]]["start"] else { return }

                guard let endOfNext = array[addedLevel[indexMid + 1]]["end"] else { return }

                if oldindexMid == indexMid {
                    if end - start <= length{

                        lastIndex = [level,indexMid]
                    } else if end - start >= length{

                        lastIndex = [level,indexMid + 1]
                    }

                    break
                }

                let lengthOfNext = endOfNext -  beginOfnext

                let lengthMid = end - begin

                if lengthMid >= length && length >= lengthOfNext{

                    lastIndex = [level,indexMid + 1]

                    break
                }

                if length <= lengthMid{

                    indexMin = indexMid

                }
                else{

                    indexMax = indexMid

                }

                oldindexMid = indexMid

            }
        }

        //если нынешнее события должно идти в ветке после прошлого события
        if nextInGroup == 1,
            position + 1 <= addArrayCount,
            let endNext =  array[addArray[position + 1]]["end"],
            endNext >= start
            {

            var indexMin : Int
            var indexMax : Int

            var oldindexMid: Int = -1
            if let startLast = array[index - 1]["start"],
                endLast - startLast >= end - start{
                indexMin = position
                indexMax = addArray.endIndex - 1
            } else {
                indexMin = addArray.startIndex
                indexMax = position + 1
            }
            while indexMin <= indexMax{

                let indexMid = indexMin + (indexMax - indexMin)/2

                guard let begin = array[matrixGroup[level][indexMid]]["start"] else { return }

                guard let end = array[matrixGroup[level][indexMid]]["end"] else { return }

                guard let beginOfnext = array[matrixGroup[level][indexMid + 1]]["start"] else { return }

                guard let endOfNext = array[matrixGroup[level][indexMid + 1]]["end"] else { return }

                if oldindexMid == indexMid {

                    if end - start <= length{

                        matrixGroup[level].insert(index, at: indexMid)
                        lastIndex = [level,indexMid]

                    } else if end - start >= length{

                        matrixGroup[level].insert(index, at: indexMid + 1)
                        lastIndex = [level,indexMid + 1]

                    }

                    groupElementsCount[level] = groupElementsCount[level] + 1

                    break
                }

                let lengthOfNext = endOfNext -  beginOfnext

                let lengthMid = end - begin

                if lengthMid >= length && length >= lengthOfNext{
                    matrixGroup[level].insert(index, at: indexMid + 1)
                    lastIndex = [level,indexMid + 1]
                    groupElementsCount[level] = groupElementsCount[level] + 1

                    return
                }

                if length <= lengthMid{

                    indexMin = indexMid

                }
                else{

                    indexMax = indexMid

                }

                oldindexMid = indexMid

            }

            if level > 0 && lastIndex[1] < (addArrayCount + 1 - groupElementsCount.count){

                let addedIndex = lastIndex[1]

                for i in 0...level - 1{
                    matrixGroup[i].insert(index, at: addedIndex)
                    if i != level || level == 0{
                        groupElementsCount[i] = groupElementsCount[i] + 1

                    }
                }
            }

        }  else if nextInGroup == 1, //если нынешний индекс идет прошлым и прошлое последнее в ветке
           position == addArrayCount{

            //если высота нынешнего меньше предыдущего
            if let startLastEvent = array[index - 1]["start"],
                endLast - startLastEvent >= end - start {

                matrixGroup[level].append(index)
                lastIndex = [level,position + 1]
                groupElementsCount[level] = groupElementsCount[level] + 1
            } else {
                //в обратном случае ищем бин поиском куда его вставить

            binarySearchj()

                //если мы его вставили до общих событий на несколько групп, тогда мы добавляем это событий и в прошлые группы
                if level >= 0{

                    let addedIndex = lastIndex[1]

                    for i in 0...level{

                        if let startDrop = array[index]["start"],
                            let endDrop = array[matrixGroup[i][addedIndex]]["end"],
                            startDrop < endDrop{
                            matrixGroup[i].insert(index, at: addedIndex)

                                groupElementsCount[i] = groupElementsCount[i] + 1

                        }
                    }
                }



            }

        } else
        if nextInGroup == 1{ //во всех остальных случаях подряд накалдывающихся событий мы создаем новую ветку, т.к они начинаються с новой ветки

            let removeCount = addArrayCount - position
            var newLevelArray = addArray

            for _ in 1...removeCount{
                newLevelArray.removeLast()
            }

            newLevelArray.append(index)
            matrixGroup.append(newLevelArray)
            let newLevel = matrixGroup.count -  1
            lastIndex = [newLevel,position + 1]

            groupElementsCount.append(1)

        }else{

            var newLevelArray = [Int]()
            //ищем куда вставить
            //если вставили до общих групп
            //вставляем все индекс в верхние уровни после этого индекса
            //если вставили после общих то все ок  алго уже есть
            let lastlastIndex = lastIndex
            binarySearchj()

            if lastIndex[1] == 0{
                newLevelArray = [index]
                matrixGroup.append(newLevelArray)
                lastIndex[0] = lastlastIndex[0] + 1

                if level >= 0{

                    let addedIndex = lastIndex[1]

                    for i in 0...level{
                        matrixGroup[i].insert(index, at: addedIndex)
                        if i != level || level == 0{
                            groupElementsCount[i] = groupElementsCount[i] + 1

                        }
                    }
                }
            } else {

                for i in 0...addArrayCount{

                    if let endBefore = array[addArray[i]]["end"],
                        endBefore > start{
                        newLevelArray.append(addArray[i])
                    }
                }

                newLevelArray.append(index)
                matrixGroup.append(newLevelArray)
                let newLevel = matrixGroup.count -  1
                lastIndex = [newLevel,newLevelArray.count - 1]
            }

            groupElementsCount.append(1)

        }



    }

    func createFrame(arrayWithEvents: inout [[String:Int]], groupElementCount: [Int], level: Int = 0){


        let screenWidht = Int(UIScreen.main.bounds.width)

        var elementCount = groupElementCount[level]
        var levelCount =  matrixGroup[level].count - 1
        var stepsCount = 0
        var startI = levelCount - elementCount
        let widht: Int

        if arrayWithEvents[matrixGroup[level][startI + 1]]["x"] != nil{

            elementCount -= 1
        }

        startI = levelCount - elementCount

        if level != 0{

            let startIndex = matrixGroup[level][startI]
            guard let x = arrayWithEvents[startIndex]["x"] else { return }
            guard let widhtIndex = arrayWithEvents[startIndex]["widht"] else { return }

            widht = (screenWidht - x - widhtIndex) / elementCount

        }else {

            widht = screenWidht / elementCount
        }

        let index = matrixGroup[level][levelCount]

        arrayWithEvents[index]["x"] = screenWidht - widht
        arrayWithEvents[index]["widht"] = widht

        levelCount -= 1
        stepsCount += 1

        while stepsCount != elementCount && levelCount >= 0 {

            let array = matrixGroup[level]
            let nextIndex = array[levelCount + 1]

            let index = array[levelCount]

            arrayWithEvents[index]["x"] = arrayWithEvents[nextIndex]["x"]! - widht
            arrayWithEvents[index]["widht"] = widht
            stepsCount += 1
            levelCount -= 1
        }

        if matrixGroup.count - 1 > level{
            createFrame(arrayWithEvents: &arrayWithEvents, groupElementCount: groupElementCount, level: (level + 1))
        }
    }

    func createGroup(i: Int = 0, arrayWithEvents: inout [[String:Int]]) -> Int {

        let start = "start" //key start
        let end = "end" //key end

        //если следующего события не сушествует то выходим
        if i >= arrayEventsCount{
            if matrixGroup.isEmpty == false {
                createFrame(arrayWithEvents: &arrayWithEvents, groupElementCount: groupElementsCount)
            }

            return i
        }

        guard let endFirst = arrayWithEvents[i][end] else { return i }

        //если начала проверяемого события меньше конца самого большого из группы событий тогда добавляем его

        if  matrixGroup.isEmpty == false ,
            let startFirst = arrayWithEvents[i][start],
            startFirst < maxEnd{

            let lenght = endFirst - startFirst

            guard let endLast =  arrayWithEvents[i - 1]["end"] else { return i}

            //проверка на данном этапе уменьшает количество дейтвий в addIndex
            if endLast > startFirst{
                addInMatrix(index: i, length: lenght,  array: arrayWithEvents, nextInGroup: 1, endLast: endLast)
            } else {
                addInMatrix(index: i, length: lenght, array: arrayWithEvents, nextInGroup: 0, endLast: endLast)
            }

            if let endIndex = arrayWithEvents[i][end],
                endIndex > maxEnd{
                maxEnd = endIndex
            }


            return createGroup(i: i + 1, arrayWithEvents: &arrayWithEvents)
        }

        guard let startNext =  arrayWithEvents[i+1][start] else { return i }

        //если конец проверяемого значения меньше начала прошлого тогда мы добавляем его и след значение в группу
        if matrixGroup.isEmpty && endFirst > startNext{

            matrixGroup = [[i]]

            guard let endIndex = arrayWithEvents[i][end] else { return i}

            maxEnd = endIndex

            if let endNext = arrayWithEvents[i+1][end],
                let startFirst = arrayWithEvents[i][start],
                endNext - startNext > endFirst - startFirst{

                matrixGroup[0].insert(i + 1, at: 0)
                lastIndex = [0,0]
            } else {

                matrixGroup[0].append(i + 1)
                lastIndex = [0,1]
            }

            if let endIndex = arrayWithEvents[i + 1][end],
                endIndex > maxEnd{
                maxEnd = endIndex
            }


            groupElementsCount.append(2)
            return createGroup(i: i + 2, arrayWithEvents: &arrayWithEvents)
        }

        //если мы ничего не добавили значит в группу дальнейшие события не входят значит рассчитывает событий и удаляем масив с группов событий
        if matrixGroup.isEmpty == false{
            createFrame(arrayWithEvents: &arrayWithEvents, groupElementCount: groupElementsCount)

            groupElementsCount.removeAll()
            matrixGroup.removeAll()

            return createGroup(i: i - 1, arrayWithEvents: &arrayWithEvents)
        }

        return createGroup(i: i + 1, arrayWithEvents: &arrayWithEvents)

    }
}

//v1
//0.009122967720031738 0.003702998161315918 0.0032650232315063477 0.007753968238830566 0.00427699089050293 0.0029720067977905273 0.0066950321197509766 0.0026209354400634766
//0.00577284608568464

//v1.1
//0.002333998680114746 , 0.0019729137420654297 , 0.006231069564819336 , 0.0018149614334106445, 0.0021790266036987305, 0.004879951477050781 , 0.002180933952331543
//0.003598809242248535

//v2 использую матрицу  0.001186966896057129, 0.0014560222625732422, 0.002389073371887207, 0.002418994903564453, 0.0012890100479125977, 0.001909017562866211, 0.0012720823287963867, 0.0010900497436523438, 0.002328038215637207, 0.0015659332275390625, 0.0013710260391235352, 0.0015000104904174805
//0.001797838644547896

//v2 с заданием параметров 0.0008449554443359375, 0.0008090734481811523, 0.0008510351181030273, 0.000782012939453125, 0.0008399486541748047, 0.0008139610290527344, 0.000904083251953125, 0.0009250640869140625
//0.0009671619960239955

//v3 с дебагом всех известных кейсов
//0.004423022270202637,0.0033670663833618164,0.0036429166793823242,0.003787994384765625,0.0032110214233398438,0.0036469697952270508,0.0033330917358398438,0.0032470226287841797,0.0038149356842041016,0.0038149356842041016,0.003134012222290039,0.006775975227355957,0.0031909942626953125,0.014513015747070312,0.003204941749572754,0.0049190521240234375,0.0032149553298950195,0.003471970558166504,0.004595041275024414,0.0030961036682128906
//0.004547633622822009
//0.003830355756423053 без аномально больших

//0.0023010969161987305,0.006704092025756836,0.008327007293701172,0.0021790266036987305,0.0030269622802734375,0.002604961395263672
//0.005028629302978515

//12 групп 41 накладывающиеся событие 0.07779598236083984б0,0.12298297882080078,0.09410107135772705,0.0629349946975708,0.0466160774230957,0.015125036239624023,0.012606978416442871,0.01573193073272705,0.048364996910095215,0.05236101150512695,0.11309397220611572
//0.06617150306701661

//почистил код 0.0034199953079223633,0.0009150505065917969,0.0010139942169189453,0.0010269880294799805, 0.0010190010070800781, 0.0010889768600463867,0.0010589361190795898, 0.0010170936584472656,0.0010139942169189453,0.0010559558868408203,0.0009980201721191406,0.0010030269622802734,0.0010019540786743164
//0.0013027489185333252
