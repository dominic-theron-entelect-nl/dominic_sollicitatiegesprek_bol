import SwiftUI

struct AdHocSwitchFundBreakdownView: View {
    let data: [AdHocSwitchFundBreakdownModel]
    let progress: Double
    let fundName: String
    let fundCount: Int
    
    var body: some View {
        VStack {
            FundBreakdownProgressRingView(progress: progress, fundName: fundName, fundCount: fundCount).padding(5.0)
            Divider().frame(height: 40).overlay(Color.investLightGray())
            VStack(spacing: 12.0) {
                HStack {
                    Text("Breakdown").font(.system(size: 20.0)).fontWeight(.bold)
                    Spacer()
                }
                HStack {
                    Text("\(Int(progress*100))% has been allocated to the following funds:").font(.system(size: 15)).foregroundColor(Color.investDarkGray())
                    Spacer()
                }
                CombinedLineBarFundPercentage(data: data)
                CombinedTableFundPercentage(data: data)
            }.padding().compatibilityVersionClearBackground()
        }
    }
}

struct CombinedTableFundPercentage: View {
    let data: [AdHocSwitchFundBreakdownModel]
    var body: some View {
        List(data) { item in
            BreakdownLineItemRow(progress: item.percentage, color: item.color, contentText: item.textDescription)
        }.compatibilityListPadding()
    }
}

struct CombinedLineBarFundPercentage: View {
    var data: [AdHocSwitchFundBreakdownModel]
    let lineBarHeight = 12.0
    let barSpacing = 2.0
    private let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        let dataCount = data.count
        let availableWidth = screenWidth - barSpacing * Double(dataCount) - 30.0
        HStack(spacing: 2) {
            ForEach(data) { item in
                Rectangle().frame(width: item.percentage * availableWidth, height: lineBarHeight).foregroundColor(item.color)
            }
        }.cornerRadius(lineBarHeight/2)
    }
}

struct BreakdownLineItemRow: View {
    var progress: Double
    var color: Color
    var contentText: String
    
    var body: some View {
        HStack(spacing: 8.0) {
            VStack {
                Circle().frame(width: 10.0, height: 10.0).foregroundColor(color)
                Spacer()
            }.padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
            Text(contentText).font(.system(size: 15.0))
            Spacer()
            Text("\(Int(progress*100))%").font(.system(size: 15.0).weight(.semibold))
        }
        .padding(2.0)
        .listRowBackground(Color.investLightGray())
    }
}
