//
//  ContentView.swift
//  RegionQuiz
//
//  Created by 山田晃路 on 2023/04/03.
//

import SwiftUI

struct ContentView: View {
    @State var mainBtnText = "スタート"
    @State var viewStatus = "start"
    @State var img: String? = "dummy_img"
    @State var correct: String? = "" // 正解の都道府県
    @State var correctIndex: Int? = nil //正解の都道府県のindex
    @State var selectIndex: Int? = nil // プレイヤが選んだindex
    @State var isShowResult = false // 結果画面を表示するかのフラグ
    @State var choiceList: [Int] = [] // 選択肢
    @State var numCorrect:Int = 0 // 正解数
    @State var numQuiz:Int = 0 // 現在の出題数
    @State var numMaxQuiz:Int = 5 // 最大出題数
    @State private var rotationDegrees = 0.0
    @State private var isScaled = false
    
    
    // 回答の選択肢をグリッドデザインにする
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let soundController = SoundController()
    
    
    init() {
        soundController.soundPlay()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.0, green: 1.0, blue: 1.0, opacity: 1.0).edgesIgnoringSafeArea(.all)
                
                // 最終結果画面
                if viewStatus == "result" {
                    VStack {
                        Text("正解数 \(numCorrect)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding()
                        Button {
                            numCorrect = 0
                            numQuiz = 0
                            viewStatus = "start"
                            mainBtnText = "スタート"
                            rotationDegrees = 0.0
                            soundController.soundStopGame();
                            soundController.soundPlay()
                        }label: {
                            Text("もう一度")
                                .font(.title2)
                                .padding(10)
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .padding()
                    }
                }
                
                // スタート画面
                if(viewStatus == "start") {
                    Image("bg_todofuken")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .rotationEffect(.degrees(rotationDegrees), anchor: .center)
                        .animation(Animation.linear(duration: 100).repeatForever(autoreverses: false), value: rotationDegrees)
                        .onAppear() {
                            UIView.animate(withDuration: 10.0, delay: 0, options: [.curveLinear, .repeat], animations: {
                                self.rotationDegrees = 360
                            })
                        }
                        .onChange(of: rotationDegrees) { _ in
                            UIView.animate(withDuration: 10.0, delay: 0, options: [.curveLinear, .repeat], animations: {
                                self.rotationDegrees = 360
                            })
                        }
                }
                
                VStack {
                    // 回答画面
                    if(viewStatus == "answer") {
                        VStack {
                            if (viewStatus != "start") {
                                HStack {
                                    Spacer()
                                    Text("問題数 \(numQuiz) / \(numMaxQuiz)")
                                        .font(.title2)
                                        .padding()
                                }
                                
                            }
                        }
                        
                        Image(img ?? "")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Spacer()
                        
                        LazyVGrid(columns: columns, spacing: 4) {
                            ForEach(0..<4) { index1 in
                                let randomIndex = choiceList[index1]
                                Button {
                                    selectIndex = randomIndex
                                    isShowResult = true
                                    result()
                                    soundController.soundPlayBtn()
                                }label: {
                                    Text(prefectures[randomIndex]["ja"] ?? "")
                                        .font(.title2)
                                        .padding(10)
                                }
                                .frame(maxWidth: .infinity)
                                .foregroundColor(Color.white)
                                .background(Color.blue)
                                .padding()
                                
                                
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // スタート画面のボタン
                    if(viewStatus == "start") {
                        Button{
                            soundController.soundStop()
                            soundController.soundPlayGame()
                            mainBtnText = "次へ"
                            viewStatus = "answer"
                            answerQuiz()
                            
                        } label: {
                            Text(mainBtnText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 130)
                                .font(.title)
                                .background(Color.pink)
                                .foregroundColor(Color.white)
                                .clipShape(Circle())
                        }
                    }
                    Spacer()
                }
                
                // 結果画面
                if(isShowResult) {
                    
                    if(correctIndex == selectIndex) {
                        Color.blue.edgesIgnoringSafeArea(.all)
                    }else{
                        Color.red.edgesIgnoringSafeArea(.all)
                    }
                    VStack {
                        Spacer()
                        if(correctIndex == selectIndex) {
                            Text("正解")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                        }else{
                            Text("不正解")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(Color.black)
                                .padding(.bottom, 20)
                                
                            
                            let text =  (prefectures[correctIndex ?? 99]["ja"])
                            if let text = text {
                                Text("答えは ")   .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                                + Text("\(text)")
                                    .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                            } else {
                                Text("正解は不明")
                            }

                        }
                        Spacer()
                        Button {
                            isShowResult = false
                            answerQuiz()
                        }label: {
                            Text("次へ")
                                .frame(maxWidth: .infinity)
                                .frame(height: 140)
                                .font(.title)
                                .background(Color.green)
                                .foregroundColor(Color.white)
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .padding()
                }
                
            }
        }
    }
    
    // クイズ生成
    func answerQuiz() {
        let randomIndex = Int.random(in: 0..<47)
        img =  prefectures[randomIndex]["romaji"]
        correctIndex = randomIndex
        correct = prefectures[randomIndex]["ja"]
        choiceList = []
        var randomChoiceIndex: Int
        
        // 正解の選択肢
        if let correctIndex = correctIndex {
            choiceList.append(correctIndex)
        }
        
        // はずれの選択肢
        for _ in 0..<3 {
            randomChoiceIndex = Int.random(in: 0..<47)
            
            while(choiceList.contains(randomChoiceIndex)){
                randomChoiceIndex = Int.random(in: 0..<47)
            }
            choiceList.append(randomChoiceIndex)
        }
        
        // 選択肢生成
        choiceList = fisherYatesShuffle(choiceList)
    }
    
    // 結果
    func result(){
        if(correctIndex == selectIndex) {
            numCorrect += 1
        }
        numQuiz += 1
        if numMaxQuiz <= numQuiz {
            viewStatus = "result"
        }
    }
    
    // 選択肢をシャッフル
    func fisherYatesShuffle<T>(_ array: [T]) -> [T] {
        var shuffledArray = array
        for i in stride(from: array.count - 1, through: 1, by: -1) {
            let j = Int.random(in: 0...i)
            if i != j {
                shuffledArray.swapAt(i, j)
            }
        }
        return shuffledArray
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
