import SwiftUI

enum MxFont {
    static let display = "BowlbyOne-Regular"
    static let head    = "ArchivoBlack-Regular"
    static let body    = "Space Grotesk"
    static let accent  = "Bungee-Regular"

    static func display(_ size: CGFloat) -> Font {
        .custom(display, size: size)
    }
    static func head(_ size: CGFloat) -> Font {
        .custom(head, size: size)
    }
    static func body(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .custom(body, size: size).weight(weight)
    }
    static func accent(_ size: CGFloat) -> Font {
        .custom(accent, size: size)
    }
}

extension View {
    /// Italic-skewed display headline (like CSS .mx-head with skewX(-6deg)).
    func mxHeadStyle(skew: CGFloat = -6) -> some View {
        let rad = skew * .pi / 180
        return self
            .italic()
            .transformEffect(CGAffineTransform(a: 1, b: 0, c: CGFloat(tan(rad)), d: 1, tx: 0, ty: 0))
    }

    /// Eyebrow — tiny uppercase orange label.
    func mxEyebrow(color: Color = Mx.orange) -> some View {
        self
            .font(MxFont.head(10))
            .tracking(1.6)
            .textCase(.uppercase)
            .foregroundColor(color)
    }
}
