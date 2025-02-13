import SwiftUI

//TODO: IMD-2132 - Integrate ad hoc switch transaction details
struct AdHocSwitchTransactionDetailsRowView: View {
    let progress: Double
    let fundName: String
    let fundCount: Int
    
    var startColor = Color.investSky()
    var endColor = Color.investMidnight()
    
    var body: some View {
        HStack(spacing: 15.0) {
            ZStack {
                ProgressRingView(progress: progress)
                Text("\(Int(progress * 100))%")
                    .font(.system(size:15.0))
                    .fontWeight(.semibold)
                    .selfSizeMask(
                        LinearGradient(
                            gradient: Gradient(colors: [endColor, startColor]),
                            startPoint: .top,
                            endPoint: .bottom))
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("\(Int(progress * 100))% of")
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 15.0))
                    .foregroundColor(Color.investDarkGray())
                Text(fundName)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 13.0))
                    .foregroundColor(Color.investMidnight())
                Text(allocatedText)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 15.0))
                    .foregroundColor(Color.investDarkGray())
                fundCount > 1
                ? Text("\(fundCount) \(fundsText)")
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 15.0))
                    .foregroundColor(Color.investMidnight())
                : Text("\(fundCount) \(fundText)")
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 15.0))
                    .foregroundColor(Color.investMidnight())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: "chevron.right")
                .foregroundColor(.gray.opacity(0.5))
        }.padding(15)
    }
}

extension AdHocSwitchTransactionDetailsRowView {
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
