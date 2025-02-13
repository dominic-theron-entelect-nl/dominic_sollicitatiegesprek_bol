import SwiftUI

struct FundBreakdownProgressRingView: View {
    let progress: Double
    let fundName: String
    let fundCount: Int
    
    var startColor = Color.investSky()
    var endColor = Color.investMidnight()
    
    var body: some View {
        HStack {
            ZStack {
                ProgressRingView(progress: progress, ringRadius: 75, thickness: 12).padding()
                VStack(spacing: 0) {
                    Image("arrows-two-way", bundle: .investResources()).resizable().frame(width: 30, height: 30)
                    Text("\(Int(progress * 100))%")
                        .font(.system(size:28.0))
                        .fontWeight(.bold)
                        .selfSizeMask(
                            LinearGradient(
                                gradient: Gradient(colors: [endColor, startColor]),
                                startPoint: .top,
                                endPoint: .bottom))
                    Text("Switch Out").font(.system(size: 13)).foregroundColor(Color.investDarkGray())
                }
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("\(Int(progress * 100))% of")
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 13.0))
                    .foregroundColor(Color.investDarkGray())
                Text(fundName)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 17.0))
                    .foregroundColor(endColor)
                Text(allocatedText)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 13.0))
                    .foregroundColor(Color.investDarkGray())
                fundCount > 1
                ? Text("\(fundCount) \(fundsText)")
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 17.0))
                    .foregroundColor(endColor)
                : Text("\(fundCount) \(fundText)")
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 17.0))
                    .foregroundColor(endColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

extension FundBreakdownProgressRingView {
    public var fundText: String {
        InvestLocalizedString(key: "ACTION_ITEM_SWITCH_FUND")
    }
    public var fundsText: String {
        InvestLocalizedString(key: "ACTION_ITEM_SWITCH_FUNDS")
    }
    public var allocatedText: String {
        InvestLocalizedString(key: "ACTION_ITEM_SWITCH_ALLOCATED_TO")
    }
}
