//
//  ContentView.swift
//  PeterPan100#2
//
//  Created by 林伯翰 on 2019/10/22.
//  Copyright © 2019 林伯翰. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var inputTextField: String = ""
    @State var inputSlider: Double = 0.0
    @State var inputToggle: Bool = false
    @State var inputStepper: Double = 0.0
    @State var favoriteGender = 1 //理想性別 ["男","女"]
    @State var youGender = 0      //目前性別 0 male 1 female
    @State var imageIsHidden = true
    @State var imageViewNum = [ImageViewNum(imageNum: Int.random(in: 0 ... 21)),ImageViewNum(imageNum: Int.random(in: 0 ... 21)),ImageViewNum(imageNum: Int.random(in: 0 ... 21))]
    
    let sex = ["男","女"]
    let horoscope = ["水瓶","雙魚","牡羊","金牛","雙子","巨蟹","獅子","處女","天秤","天蠍","射手","摩羯"]
    let horoscopeArcana = [17,18,4,5,6,7,8,9,11,13,14,15]
    struct LargeLabelStyle: ViewModifier{
        func body(content: Content) -> some View{
            return content
                .foregroundColor(Color.white)
                .font(.title)
        }
    }
    struct LabelStyle: ViewModifier{
        func body(content: Content) -> some View{
            return content
                .foregroundColor(Color.white)
                .font(.headline)
        }
    }
    struct BtnStyle: ViewModifier{
        func body(content: Content) -> some View{
            return content
                .foregroundColor(Color.white)
                .font(.headline)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 45).stroke(lineWidth: 4))
                .background(Color.orange)
                .padding(2)
                .cornerRadius(40)
        }
    }
    struct ImageViewNum: Identifiable{
        var id = UUID()
        var imageNum: Int
        // 圖片陣列名稱
        func imageNameArray(_ imageNum: Int) ->String{
            var imageNameAry = [String]()
            let strName = "Tarot"
            for item in 0...21{
                if item <= 9 {
                    imageNameAry.append("\(strName)0\(item)")
                }else{
                    imageNameAry.append("\(strName)\(item)")
                }
            }
            if !imageNameAry.isEmpty{
                return "\(imageNameAry[imageNum])"
            }else{
                return "Tarot00"
            }
            
        }
    }
    
    
    var body: some View {
        
        VStack{
            HStack{
                Text("輸入星座：").modifier(LargeLabelStyle())
                TextField("來個星座吧！", text: $inputTextField )
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(lineWidth: 3))
                    .foregroundColor(Color.white)
                    .textFieldStyle(DefaultTextFieldStyle())
                    
                
            }
            HStack{
                Text("想按就按：").modifier(LargeLabelStyle())
                Toggle(isOn: $inputToggle) {
                    Text("")
                }
                Spacer()
            }
            HStack{
                Text("您的：")
                Picker(selection: $youGender, label: Text("")) {
                    ForEach(0 ..< sex.count) { index in
                        Text(self.sex[index]).tag(index)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                    .frame(width: 100, height: .none)
                
                Text("理想的:")
                Picker(selection: $favoriteGender, label: Text("")) {
                    ForEach(0 ..< sex.count) { index in
                        Text(self.sex[index]).tag(index)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                    .frame(width: 100, height: .none)
            }
            HStack{
                Text("今天心情：").modifier(LargeLabelStyle())
                Slider(value: $inputSlider, in: 1 ... 100)
            }
            
            HStack{
                Text("理想約會的時間：").modifier(LargeLabelStyle()).fixedSize()
                Stepper(value: $inputStepper){
                    Text("\(inputStepperStr())").modifier(LabelStyle())
                }
            }
            Divider()
            HStack{
            Button(action: {
                self.randomNum()
                self.processData()
                self.hiddenBtn(isHidden: self.imageIsHidden)
            }) {
                Text("結果是！？").fontWeight(.bold)
            }.modifier(BtnStyle())
                
            }
            Spacer()
            VStack{
                if !imageIsHidden{
                    HStack{
                        ForEach(imageViewNum){ randomNum in
                            Image("\(self.imageNameArray(randomNum.imageNum))")
                                .resizable()
                                .frame(width: 100, height: 200)
                            
                        }
                    }
                }
            }
            Spacer()
            
        
        }.background(Image("tarotBG")
            .resizable()
            .scaledToFill())//Vstack End, Photo from vecteezy
        
    }// body End
    func inputToggleStr() -> String{
        return "\(inputToggle)"
    }
    func inputSliderStr() -> String{
        return "\(Int(inputSlider))"
    }
    func inputStepperStr() -> String{
        return "\(Int(inputStepper))"
    }
    
    func randomNum(){  //隨機數值 get
        self.imageViewNum.removeAll()
        for _ in 0 ... 2{
            self.imageViewNum.append(ImageViewNum(imageNum: Int.random(in: 0 ... 21)))
        }
    }
    func hiddenBtn(isHidden: Bool){  // is hidden yes or no
        if isHidden{
            imageIsHidden = false
        }else{
            imageIsHidden = true
        }
    }

    func imageNameArray(_ ImageNum: Int) ->String{
        var imageNameAry = [String]()
        let strName = "Tarot"
        for item in 0...21{
            if item <= 9 {
                imageNameAry.append("\(strName)0\(item)")
            }else{
                imageNameAry.append("\(strName)\(item)")
            }
        }
        if !imageNameAry.isEmpty{
            return "\(imageNameAry[ImageNum])"
        }else{
            return "Tarot00"
        }
        
    }
 
    func processData(){
        var score = 0
        ///抓取字串是否含有星座
        for item in 0...horoscope.count-1{
            if inputTextField.hasPrefix(horoscope[item]){
                imageViewNum.remove(at: 1)
                imageViewNum.insert(ImageViewNum(imageNum: horoscopeArcana[item]), at: 1)
            }
        }
        if inputToggle{
            score += 21
            score += (Int(inputStepper) * 7)
        }else{
            score += 38
            score += (Int(inputStepper) * 27)
        }
        score += Int(inputSlider)
        //["男","女"]
        switch youGender{
            case 0 where favoriteGender == 1:
                score += 20
            case 0 where favoriteGender == 0:
                score += 40
            case 1 where favoriteGender == 0:
                score += 30
            case 1 where favoriteGender == 1:
                score += 60
            default:
                score += 0
        }
        let resultScore = score % 21
        if resultScore >= 0 && resultScore <= 21{
            imageViewNum.removeLast()
            imageViewNum.append(ImageViewNum(imageNum: resultScore))
        }
    }
    
}//ContentView End

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
