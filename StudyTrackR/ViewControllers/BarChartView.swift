import UIKit

// MARK: - Custom bar chart drawn with Core Graphics (no third-party libraries)
class BarChartView: UIView {

    struct Bar {
        let label: String
        let value: Int          // seconds
        let color: UIColor
    }

    var bars: [Bar] = [] {
        didSet { setNeedsDisplay() }
    }

    private let barSpacing: CGFloat = 12
    private let labelHeight: CGFloat = 18

    override func draw(_ rect: CGRect) {
        guard !bars.isEmpty, let ctx = UIGraphicsGetCurrentContext() else { return }

        let chartHeight = rect.height - labelHeight - 4
        let maxValue    = bars.map { $0.value }.max() ?? 1
        let totalWidth  = rect.width
        let barWidth    = (totalWidth - barSpacing * CGFloat(bars.count + 1)) / CGFloat(bars.count)

        for (i, bar) in bars.enumerated() {
            let x        = barSpacing + CGFloat(i) * (barWidth + barSpacing)
            let fraction = maxValue > 0 ? CGFloat(bar.value) / CGFloat(maxValue) : 0
            let barH     = max(fraction * chartHeight, 4)
            let y        = chartHeight - barH

            // Draw bar
            let barRect = CGRect(x: x, y: y, width: barWidth, height: barH)
            let path    = UIBezierPath(roundedRect: barRect, cornerRadius: 6)
            bar.color.setFill()
            path.fill()

            // Draw label below bar
            let labelRect = CGRect(x: x, y: chartHeight + 4, width: barWidth, height: labelHeight)
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 11),
                .foregroundColor: UIColor.secondaryLabel
            ]
            (bar.label as NSString).draw(in: labelRect, withAttributes: attrs)

            // Draw value above bar
            let hours     = bar.value / 3600
            let minutes   = (bar.value % 3600) / 60
            let valueStr  = hours > 0 ? "\(hours)h\(minutes)m" : "\(minutes)m"
            let valueRect = CGRect(x: x, y: max(y - 18, 0), width: barWidth, height: 16)
            let valueAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 10, weight: .semibold),
                .foregroundColor: UIColor.label
            ]
            (valueStr as NSString).draw(in: valueRect, withAttributes: valueAttrs)
        }

        // Baseline
        ctx.setStrokeColor(UIColor.separator.cgColor)
        ctx.setLineWidth(1)
        ctx.move(to: CGPoint(x: 0, y: chartHeight))
        ctx.addLine(to: CGPoint(x: rect.width, y: chartHeight))
        ctx.strokePath()
    }
}
