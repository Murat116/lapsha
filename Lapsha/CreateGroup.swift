//
//  CreateGroup.swift
//  Lapsha
//
//  Created by Мурат Камалов on 03/08/2019.
//  Copyright © 2019 Мурат Камалов. All rights reserved.
//

import UIKit

var lastIndex: [Int] = []
var time: Double = 0

//TODO: доработать влияние нижних уровней на верхнии

class CreateGroup: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let start = CFAbsoluteTimeGetCurrent()

        createGroup(arrayWithEvents: array)
        print(time, "время")
        print(CFAbsoluteTimeGetCurrent() - start)

        }

    var matrixGroup = [[Int]]()

    func addInMatrix(index: Int,length : Int, groupEvent: inout [[Int]], array: [[String:Int]], nextInGroup: Int, endLast: Int) {

        let startTime = CFAbsoluteTimeGetCurrent()

        guard let start = array[index]["start"] else { return }
        guard let end = array[index]["end"] else { return }

        let level = lastIndex[0]
        let position = lastIndex[1]
        let addArray = groupEvent[level]
        let addArrayCount = addArray.count - 1

        if nextInGroup == 1,
            position + 1 <= addArrayCount,
            let endNext =  array[addArray[position + 1]]["end"],
            endNext > start
            {
            var indexMin : Int
            var indexMax : Int

            var oldindexMid: Int = -1
            if let startLast = array[index - 1]["start"],
                endLast - startLast > end - start{
                indexMin = position
                indexMax = addArray.endIndex - 1
            } else {
                indexMin = addArray.startIndex
                indexMax = position + 1
            }
            while indexMin <= indexMax{

                let indexMid = indexMin + (indexMax - indexMin)/2

                if oldindexMid == indexMid{

                    groupEvent[level].insert(index, at: indexMid + 1)
                    lastIndex = [level,indexMid + 1]

                    break
                }

                guard let begin = array[groupEvent[level][indexMid]]["start"] else { return }

                guard let end = array[groupEvent[level][indexMid]]["end"] else { return }

                guard let beginOfnext = array[groupEvent[level][indexMid + 1]]["start"] else { return }

                guard let endOfNext = array[groupEvent[level][indexMid + 1]]["end"] else { return }
                let lengthOfNext = endOfNext -  beginOfnext

                let lengthMid = end - begin

                if lengthMid >= length && length >= lengthOfNext{
                    groupEvent[level].insert(index, at: indexMid + 1)
                    lastIndex = [level,indexMid + 1]
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

        } else
        if nextInGroup == 1,
           position == addArrayCount{

            if let startLastEvent = array[index - 1]["start"],
                endLast - startLastEvent > end - start {

                groupEvent[level].append(index)
                lastIndex = [level,position + 1]
            } else {

                var indexMin : Int
                var indexMax : Int

                var oldindexMid: Int = -1
                if let startLast = array[index - 1]["start"],
                    endLast - startLast > end - start{
                    indexMin = position
                    indexMax = addArray.endIndex - 1
                } else {
                    indexMin = addArray.startIndex
                    indexMax = position
                }
                while indexMin <= indexMax{

                    let indexMid = indexMin + (indexMax - indexMin)/2

                    if oldindexMid == indexMid{

                        groupEvent[level].insert(index, at: indexMid)
                        lastIndex = [level,indexMid]

                        break
                    }

                    guard let begin = array[groupEvent[level][indexMid]]["start"] else { return }

                    guard let end = array[groupEvent[level][indexMid]]["end"] else { return }

                    guard let beginOfnext = array[groupEvent[level][indexMid + 1]]["start"] else { return }

                    guard let endOfNext = array[groupEvent[level][indexMid + 1]]["end"] else { return }
                    let lengthOfNext = endOfNext -  beginOfnext

                    let lengthMid = end - begin

                    if lengthMid >= length && length >= lengthOfNext{
                        groupEvent[level].insert(index, at: indexMid + 1)
                        lastIndex = [level,indexMid + 1]
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

            }

        } else
        if nextInGroup == 1{

            let removeCount = addArrayCount - position
            var newLevelArray = addArray

            for _ in 1...removeCount{
                newLevelArray.removeLast()
            }

            newLevelArray.append(index)
            groupEvent.append(newLevelArray)
            let newLevel = groupEvent.count -  1
            lastIndex = [newLevel,position + 1]
        }else{

            var newLevelArray = [Int]()

            for i in 0...addArrayCount{
                if let endBefore = array[addArray[i]]["end"],
                    endBefore > start{
                    newLevelArray.append(addArray[i])
                }
            }

            newLevelArray.append(index)
            groupEvent.append(newLevelArray)
            let newLevel = groupEvent.count -  1
            lastIndex = [newLevel,newLevelArray.count - 1]

        }

        time = time + (CFAbsoluteTimeGetCurrent() - startTime)
    }
    
    func addInGroup(index: Int,length : Int, groupEvent: inout [Int], array: [[String:Int]]) {

        var indexMin = groupEvent.startIndex
        var indexMax = groupEvent.endIndex-1
        var oldindexMid = 0

        //binary search index
        while indexMin <= indexMax{

            let indexMid = indexMin + (indexMax - indexMin)/2

            if oldindexMid == indexMid{
                groupEvent.insert(index, at: indexMid + 1)
                break
            }

            guard let begin = array[groupEvent[indexMid]]["start"] else {
                return
            }

            guard let end = array[groupEvent[indexMid]]["end"] else {
                return
            }

            guard let beginOfnext = array[groupEvent[indexMid + 1]]["start"] else {
                return
            }

            guard let endOfNext = array[groupEvent[indexMid + 1]]["end"] else {
                return
            }
            let lengthOfNext = endOfNext -  beginOfnext

            let lengthMid = end - begin

            if lengthMid >= length && length >= lengthOfNext{
                groupEvent.insert(index, at: indexMid + 1)
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
    }

    var arrayEventsCount = array.count - 1
    var groupEventCount = 0
    var maxEnd = 0

    func createGroup(i: Int = 0, arrayWithEvents: [[String:Int]]) -> Int {

        let start = "start" //key start
        let end = "end" //key end

        //если следующего события не сушествует то выходим
        if i >= arrayEventsCount{

            print(matrixGroup)
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
                addInMatrix(index: i, length: lenght, groupEvent: &matrixGroup, array: arrayWithEvents, nextInGroup: 1, endLast: endLast)
            } else {
                addInMatrix(index: i, length: lenght, groupEvent: &matrixGroup, array: arrayWithEvents, nextInGroup: 0, endLast: endLast)
            }

            if let endIndex = arrayWithEvents[i][end],
                endIndex > maxEnd{
                maxEnd = endIndex
            }

            return createGroup(i: i + 1, arrayWithEvents: arrayWithEvents)
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

            return createGroup(i: i + 2, arrayWithEvents: arrayWithEvents)
        }

        //если мы ничего не добавили значит в группу дальнейшие события не входят значит рассчитывает событий и удаляем масив с группов событий
        //делаем рассчеты
        print(matrixGroup)
        matrixGroup.removeAll()
        print(i, "вне")

        return createGroup(i: i + 1, arrayWithEvents: arrayWithEvents)

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
