import SwiftUI

struct ProgressRingView: View {
    let progress: Double
    
    var ringRadius: CGFloat = 27.5
    var thickness: CGFloat = 5.0
    var startColor = Color.investSky()
    var endColor = Color.investMidnight()
    
    var body: some View {
        let activityAngularGradient = AngularGradient ( gradient: Gradient (colors: [startColor, endColor]), center: .center, startAngle: .degrees (0), endAngle: .degrees (360.0 * progress))
        ZStack {
            Circle ().stroke (Color.investLightGray(), lineWidth: thickness).frame (width: ringRadius * 2)
            Circle().trim(from: 0, to: CGFloat (self.progress))
                .stroke(
                    activityAngularGradient, style: StrokeStyle(lineWidth: thickness, lineCap: .round))
                .rotationEffect(Angle (degrees: -90))
                .frame (width:ringRadius * 2)
            ProgressRingTip(progress: progress,
                            ringRadius: Double (ringRadius))
            .fill (progress > 0.95 ? endColor : .clear).frame (width:thickness, height:thickness)
        }
    }
}

struct ProgressRingTip: Shape {
    var progress: Double
    var ringRadius: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        if progress > 0.0 {
            let frame = CGRect(
                x: position.x, y: position.y, width: rect.size.width,
                height: rect.size.height)
            path.addEllipse (in: frame)
            return path
        }
        return path
    }
    
    private var position: CGPoint {
        let progressAngle = Angle (degrees: (360.0 * progress) - 90.0)
        return CGPoint(x: ringRadius * cos(progressAngle.radians),
                       y: ringRadius * sin(progressAngle.radians))
    }
    
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
}
