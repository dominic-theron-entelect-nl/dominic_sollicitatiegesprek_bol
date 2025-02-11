import SwiftUI

struct SubmitApprovalSectionView: View {
    @Binding var approvalOptions: [GenericTransactionDetailsApprovalOptions]
    @Binding var referenceNumber: String
    
    var body: some View {
        GenericTransactionDetailsSectionView(
            header: {
                GenericTransactionDetailsSectionHeaderView(headerText: "Submit approval", shouldHideBadge: false)
            },
            content: {
                ForEach($approvalOptions, id:\.optionText) { $option in
                    RadioButtonRow(text:$option.optionText, isSelected: $option.isSelected)
                }
            },
            footer: {
                GenericTransactionDetailsSectionFooterView(footerText: "Reference number:", referenceNumber: referenceNumber)
            }
        )
    }
}

struct RadioButtonRow: View {
    private let IMAGE_SIZE:CGFloat = 30
    
    @Binding var text: String
    @Binding var isSelected: Bool
    var body: some View {
        HStack {
            getFinalText(inputText: text)
                .font(.subheadline)
                .onTapGesture {
                    if let urlText = extractURL(from: text), let urlToOpen = URL(string: urlText), UIApplication.shared.canOpenURL(urlToOpen) {
                        UIApplication.shared.open(urlToOpen)
                    } else {
                        isSelected = !isSelected
                    }
                }
            Spacer()
            Button {
                isSelected.toggle()
            } label: {
                Image(isSelected ? "check-selected" : "check-unselected", bundle: .investResources())
                    .resizable()
                    .frame(width: IMAGE_SIZE, height: IMAGE_SIZE)
                    .foregroundColor(Color.investDiscoveryBlue())
            }
        }
    }
    
    private func getFinalText(inputText: String) -> Text {
        if let linkText = extractText(from: text) {
            let textBefore = replaceAnchorTag(with: "$", originalText: text)?.components(separatedBy: "$")[0] ?? ""
            let textAfter = replaceAnchorTag(with: "$", originalText: text)?.components(separatedBy: "$")[1] ?? ""
            
            return Text(textBefore).foregroundColor(.investDarkGray()) +
            Text(linkText).foregroundColor(.investDiscoveryBlue()) +
            Text(textAfter).foregroundColor(.investDarkGray())
        } else {
            return Text(inputText).foregroundColor(.investDarkGray())
        }
    }
    
    private func extractURL(from text: String) -> String? {
        let pattern = "<a\\s+href=(\"[^\"]*\"|'[^']*'|[^\\s>]+)"
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(location: 0, length: text.utf16.count)
            if let match = regex.firstMatch(in: text, options: [], range: range) {
                let urlRange = Range(match.range(at: 1), in: text)!
                return String(text[urlRange])
            }
        } catch {
            print("Error creating regular expression: \(error.localizedDescription)")
        }
        return nil
    }
    
    private func extractText(from text: String) -> String? {
        let pattern = #"<a[^>]*>(.*?)</a>"#
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators)
            let range = NSRange(location: 0, length: text.utf16.count)
            if let match = regex.firstMatch(in: text, options: [], range: range) {
                let textRange = Range(match.range(at: 1), in: text)!
                return String(text[textRange])
            }
        } catch {
            print("Error creating regular expression: \(error.localizedDescription)")
        }
        return nil
    }
    
    private func replaceAnchorTag(with replacement: String?, originalText: String) -> String? {
        guard let replacement = replacement else { return nil }
        let pattern = #"<a[^>]*>.*?</a>"#
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators)
            let range = NSRange(location: 0, length: originalText.utf16.count)
            return regex.stringByReplacingMatches(in: originalText, options: [], range: range, withTemplate: replacement)
        } catch {
            print("Error creating regular expression: \(error.localizedDescription)")
        }
        return nil
    }
}
