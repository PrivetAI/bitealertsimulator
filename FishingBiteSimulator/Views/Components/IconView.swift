import SwiftUI

struct IconView: View {
    let name: String
    var size: CGFloat = 24
    var color: Color = AppTheme.primary
    
    var body: some View {
        iconContent
            .frame(width: size, height: size)
    }
    
    @ViewBuilder
    private var iconContent: some View {
        switch name {
        case "fish_small":
            FishIcon(size: size, color: color)
        case "fish_medium":
            FishIcon(size: size, color: color)
        case "fish_large":
            FishIcon(size: size, color: color)
        case "fish_trophy":
            TrophyFishIcon(size: size, color: color)
        case "hook":
            HookIcon(size: size, color: color)
        case "rod":
            RodIcon(size: size, color: color)
        case "timer":
            TimerIcon(size: size, color: color)
        case "chart":
            ChartIcon(size: size, color: color)
        case "trophy":
            TrophyIcon(size: size, color: color)
        case "settings":
            SettingsIcon(size: size, color: color)
        case "history":
            HistoryIcon(size: size, color: color)
        case "home":
            HomeIcon(size: size, color: color)
        case "play":
            PlayIcon(size: size, color: color)
        case "check":
            CheckIcon(size: size, color: color)
        case "cross":
            CrossIcon(size: size, color: color)
        case "flame":
            FlameIcon(size: size, color: color)
        case "lightning":
            LightningIcon(size: size, color: color)
        case "star":
            StarIcon(size: size, color: color)
        case "medal":
            MedalIcon(size: size, color: color)
        case "calendar":
            CalendarIcon(size: size, color: color)
        case "target":
            TargetIcon(size: size, color: color)
        case "vibration":
            VibrationIcon(size: size, color: color)
        case "sound":
            SoundIcon(size: size, color: color)
        case "arrow_left":
            ArrowLeftIcon(size: size, color: color)
        case "refresh":
            RefreshIcon(size: size, color: color)
        case "share":
            ShareIcon(size: size, color: color)
        default:
            Circle()
                .fill(color.opacity(0.3))
        }
    }
}

// MARK: - Custom Icon Shapes

struct FishIcon: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Canvas { context, canvasSize in
            let scale = size / 24
            
            // Fish body
            var bodyPath = Path()
            bodyPath.move(to: CGPoint(x: 4 * scale, y: 12 * scale))
            bodyPath.addQuadCurve(
                to: CGPoint(x: 18 * scale, y: 12 * scale),
                control: CGPoint(x: 11 * scale, y: 4 * scale)
            )
            bodyPath.addQuadCurve(
                to: CGPoint(x: 4 * scale, y: 12 * scale),
                control: CGPoint(x: 11 * scale, y: 20 * scale)
            )
            
            // Tail
            var tailPath = Path()
            tailPath.move(to: CGPoint(x: 4 * scale, y: 12 * scale))
            tailPath.addLine(to: CGPoint(x: 1 * scale, y: 7 * scale))
            tailPath.addLine(to: CGPoint(x: 1 * scale, y: 17 * scale))
            tailPath.closeSubpath()
            
            context.fill(bodyPath, with: .color(color))
            context.fill(tailPath, with: .color(color))
            
            // Eye
            let eyeRect = CGRect(x: 14 * scale, y: 10 * scale, width: 2 * scale, height: 2 * scale)
            context.fill(Path(ellipseIn: eyeRect), with: .color(.white))
        }
    }
}

struct TrophyFishIcon: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        ZStack {
            FishIcon(size: size * 0.7, color: color)
                .offset(y: -size * 0.1)
            
            // Crown
            Canvas { context, _ in
                let scale = size / 24
                var path = Path()
                path.move(to: CGPoint(x: 8 * scale, y: 8 * scale))
                path.addLine(to: CGPoint(x: 10 * scale, y: 4 * scale))
                path.addLine(to: CGPoint(x: 12 * scale, y: 6 * scale))
                path.addLine(to: CGPoint(x: 14 * scale, y: 4 * scale))
                path.addLine(to: CGPoint(x: 16 * scale, y: 8 * scale))
                path.closeSubpath()
                
                context.fill(path, with: .color(Color(hex: "FFD700")))
            }
        }
    }
}

struct HookIcon: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Canvas { context, _ in
            let scale = size / 24
            var path = Path()
            path.move(to: CGPoint(x: 12 * scale, y: 2 * scale))
            path.addLine(to: CGPoint(x: 12 * scale, y: 10 * scale))
            path.addQuadCurve(
                to: CGPoint(x: 8 * scale, y: 18 * scale),
                control: CGPoint(x: 12 * scale, y: 16 * scale)
            )
            path.addQuadCurve(
                to: CGPoint(x: 16 * scale, y: 14 * scale),
                control: CGPoint(x: 4 * scale, y: 22 * scale)
            )
            
            context.stroke(path, with: .color(color), lineWidth: 2.5 * scale)
            
            // Hook point
            var pointPath = Path()
            pointPath.move(to: CGPoint(x: 16 * scale, y: 14 * scale))
            pointPath.addLine(to: CGPoint(x: 14 * scale, y: 11 * scale))
            context.stroke(pointPath, with: .color(color), lineWidth: 2 * scale)
        }
    }
}

struct RodIcon: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Canvas { context, _ in
            let scale = size / 24
            
            // Rod
            var rodPath = Path()
            rodPath.move(to: CGPoint(x: 4 * scale, y: 20 * scale))
            rodPath.addLine(to: CGPoint(x: 20 * scale, y: 4 * scale))
            context.stroke(rodPath, with: .color(color), lineWidth: 2 * scale)
            
            // Reel
            let reelRect = CGRect(x: 6 * scale, y: 16 * scale, width: 4 * scale, height: 4 * scale)
            context.fill(Path(ellipseIn: reelRect), with: .color(color))
            
            // Line
            var linePath = Path()
            linePath.move(to: CGPoint(x: 20 * scale, y: 4 * scale))
            linePath.addLine(to: CGPoint(x: 20 * scale, y: 12 * scale))
            context.stroke(linePath, with: .color(color.opacity(0.5)), lineWidth: 1 * scale)
        }
    }
}

struct TimerIcon: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Canvas { context, _ in
            let scale = size / 24
            let center = CGPoint(x: 12 * scale, y: 13 * scale)
            let radius = 9 * scale
            
            // Circle
            let circlePath = Path(ellipseIn: CGRect(
                x: center.x - radius,
                y: center.y - radius,
                width: radius * 2,
                height: radius * 2
            ))
            context.stroke(circlePath, with: .color(color), lineWidth: 2 * scale)
            
            // Top button
            var topPath = Path()
            topPath.move(to: CGPoint(x: 12 * scale, y: 2 * scale))
            topPath.addLine(to: CGPoint(x: 12 * scale, y: 4 * scale))
            context.stroke(topPath, with: .color(color), lineWidth: 2 * scale)
            
            // Hands
            var handPath = Path()
            handPath.move(to: center)
            handPath.addLine(to: CGPoint(x: 12 * scale, y: 8 * scale))
            handPath.move(to: center)
            handPath.addLine(to: CGPoint(x: 16 * scale, y: 13 * scale))
            context.stroke(handPath, with: .color(color), lineWidth: 1.5 * scale)
        }
    }
}

struct ChartIcon: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Canvas { context, _ in
            let scale = size / 24
            
            // Bars
            let bar1 = CGRect(x: 4 * scale, y: 14 * scale, width: 4 * scale, height: 6 * scale)
            let bar2 = CGRect(x: 10 * scale, y: 8 * scale, width: 4 * scale, height: 12 * scale)
            let bar3 = CGRect(x: 16 * scale, y: 4 * scale, width: 4 * scale, height: 16 * scale)
            
            context.fill(Path(roundedRect: bar1, cornerRadius: 1 * scale), with: .color(color.opacity(0.5)))
            context.fill(Path(roundedRect: bar2, cornerRadius: 1 * scale), with: .color(color.opacity(0.75)))
            context.fill(Path(roundedRect: bar3, cornerRadius: 1 * scale), with: .color(color))
        }
    }
}

struct TrophyIcon: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Canvas { context, _ in
            let scale = size / 24
            
            // Cup
            var cupPath = Path()
            cupPath.move(to: CGPoint(x: 6 * scale, y: 4 * scale))
            cupPath.addLine(to: CGPoint(x: 18 * scale, y: 4 * scale))
            cupPath.addQuadCurve(
                to: CGPoint(x: 12 * scale, y: 14 * scale),
                control: CGPoint(x: 18 * scale, y: 10 * scale)
            )
            cupPath.addQuadCurve(
                to: CGPoint(x: 6 * scale, y: 4 * scale),
                control: CGPoint(x: 6 * scale, y: 10 * scale)
            )
            context.fill(cupPath, with: .color(color))
            
            // Base
            let baseRect = CGRect(x: 8 * scale, y: 16 * scale, width: 8 * scale, height: 4 * scale)
            context.fill(Path(roundedRect: baseRect, cornerRadius: 1 * scale), with: .color(color))
            
            // Stem
            let stemRect = CGRect(x: 10 * scale, y: 14 * scale, width: 4 * scale, height: 2 * scale)
            context.fill(Path(CGRect(x: 10 * scale, y: 14 * scale, width: 4 * scale, height: 2 * scale)), with: .color(color))
        }
    }
}

struct SettingsIcon: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Canvas { context, _ in
            let scale = size / 24
            let center = CGPoint(x: 12 * scale, y: 12 * scale)
            
            // Outer gear
            for i in 0..<8 {
                let angle = Double(i) * .pi / 4
                let x1 = center.x + cos(angle) * 6 * scale
                let y1 = center.y + sin(angle) * 6 * scale
                let x2 = center.x + cos(angle) * 9 * scale
                let y2 = center.y + sin(angle) * 9 * scale
                
                var path = Path()
                path.move(to: CGPoint(x: x1, y: y1))
                path.addLine(to: CGPoint(x: x2, y: y2))
                context.stroke(path, with: .color(color), lineWidth: 3 * scale)
            }
            
            // Center circle
            let innerCircle = Path(ellipseIn: CGRect(
                x: center.x - 4 * scale,
                y: center.y - 4 * scale,
                width: 8 * scale,
                height: 8 * scale
            ))
            context.fill(innerCircle, with: .color(color))
            
            let holeCircle = Path(ellipseIn: CGRect(
                x: center.x - 2 * scale,
                y: center.y - 2 * scale,
                width: 4 * scale,
                height: 4 * scale
            ))
            context.blendMode = .destinationOut
            context.fill(holeCircle, with: .color(.white))
        }
    }
}

struct HistoryIcon: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Canvas { context, _ in
            let scale = size / 24
            let center = CGPoint(x: 12 * scale, y: 12 * scale)
            
            // Circle
            let circlePath = Path(ellipseIn: CGRect(
                x: 4 * scale, y: 4 * scale,
                width: 16 * scale, height: 16 * scale
            ))
            context.stroke(circlePath, with: .color(color), lineWidth: 2 * scale)
            
            // Arrow
            var arrowPath = Path()
            arrowPath.move(to: CGPoint(x: 4 * scale, y: 12 * scale))
            arrowPath.addLine(to: CGPoint(x: 4 * scale, y: 6 * scale))
            arrowPath.addLine(to: CGPoint(x: 8 * scale, y: 9 * scale))
            context.fill(arrowPath, with: .color(color))
            
            // Hands
            var handPath = Path()
            handPath.move(to: center)
            handPath.addLine(to: CGPoint(x: 12 * scale, y: 7 * scale))
            handPath.move(to: center)
            handPath.addLine(to: CGPoint(x: 16 * scale, y: 12 * scale))
            context.stroke(handPath, with: .color(color), lineWidth: 1.5 * scale)
        }
    }
}

struct HomeIcon: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Canvas { context, _ in
            let scale = size / 24
            
            // Roof
            var roofPath = Path()
            roofPath.move(to: CGPoint(x: 12 * scale, y: 3 * scale))
            roofPath.addLine(to: CGPoint(x: 21 * scale, y: 10 * scale))
            roofPath.addLine(to: CGPoint(x: 3 * scale, y: 10 * scale))
            roofPath.closeSubpath()
            context.fill(roofPath, with: .color(color))
            
            // House body
            let houseRect = CGRect(x: 5 * scale, y: 10 * scale, width: 14 * scale, height: 10 * scale)
            context.fill(Path(houseRect), with: .color(color))
            
            // Door
            let doorRect = CGRect(x: 10 * scale, y: 14 * scale, width: 4 * scale, height: 6 * scale)
            context.blendMode = .destinationOut
            context.fill(Path(doorRect), with: .color(.white))
        }
    }
}

struct PlayIcon: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Canvas { context, _ in
            let scale = size / 24
            
            var path = Path()
            path.move(to: CGPoint(x: 6 * scale, y: 4 * scale))
            path.addLine(to: CGPoint(x: 20 * scale, y: 12 * scale))
            path.addLine(to: CGPoint(x: 6 * scale, y: 20 * scale))
            path.closeSubpath()
            
            context.fill(path, with: .color(color))
        }
    }
}

struct CheckIcon: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Canvas { context, _ in
            let scale = size / 24
            
            var path = Path()
            path.move(to: CGPoint(x: 5 * scale, y: 12 * scale))
            path.addLine(to: CGPoint(x: 10 * scale, y: 17 * scale))
            path.addLine(to: CGPoint(x: 19 * scale, y: 7 * scale))
            
            context.stroke(path, with: .color(color), style: StrokeStyle(lineWidth: 2.5 * scale, lineCap: .round, lineJoin: .round))
        }
    }
}

struct CrossIcon: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Canvas { context, _ in
            let scale = size / 24
            
            var path = Path()
            path.move(to: CGPoint(x: 6 * scale, y: 6 * scale))
            path.addLine(to: CGPoint(x: 18 * scale, y: 18 * scale))
            path.move(to: CGPoint(x: 18 * scale, y: 6 * scale))
            path.addLine(to: CGPoint(x: 6 * scale, y: 18 * scale))
            
            context.stroke(path, with: .color(color), style: StrokeStyle(lineWidth: 2.5 * scale, lineCap: .round))
        }
    }
}

struct FlameIcon: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Canvas { context, _ in
            let scale = size / 24
            
            var path = Path()
            path.move(to: CGPoint(x: 12 * scale, y: 2 * scale))
            path.addQuadCurve(
                to: CGPoint(x: 18 * scale, y: 14 * scale),
                control: CGPoint(x: 18 * scale, y: 6 * scale)
            )
            path.addQuadCurve(
                to: CGPoint(x: 12 * scale, y: 22 * scale),
                control: CGPoint(x: 18 * scale, y: 20 * scale)
            )
            path.addQuadCurve(
                to: CGPoint(x: 6 * scale, y: 14 * scale),
                control: CGPoint(x: 6 * scale, y: 20 * scale)
            )
            path.addQuadCurve(
                to: CGPoint(x: 12 * scale, y: 2 * scale),
                control: CGPoint(x: 6 * scale, y: 6 * scale)
            )
            
            context.fill(path, with: .color(color))
        }
    }
}

struct LightningIcon: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Canvas { context, _ in
            let scale = size / 24
            
            var path = Path()
            path.move(to: CGPoint(x: 13 * scale, y: 2 * scale))
            path.addLine(to: CGPoint(x: 6 * scale, y: 14 * scale))
            path.addLine(to: CGPoint(x: 12 * scale, y: 14 * scale))
            path.addLine(to: CGPoint(x: 11 * scale, y: 22 * scale))
            path.addLine(to: CGPoint(x: 18 * scale, y: 10 * scale))
            path.addLine(to: CGPoint(x: 12 * scale, y: 10 * scale))
            path.closeSubpath()
            
            context.fill(path, with: .color(color))
        }
    }
}

struct StarIcon: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Canvas { context, _ in
            let scale = size / 24
            let center = CGPoint(x: 12 * scale, y: 12 * scale)
            
            var path = Path()
            for i in 0..<5 {
                let angle = Double(i) * 4 * .pi / 5 - .pi / 2
                let x = center.x + cos(angle) * 10 * scale
                let y = center.y + sin(angle) * 10 * scale
                
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.closeSubpath()
            
            context.fill(path, with: .color(color))
        }
    }
}

struct MedalIcon: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Canvas { context, _ in
            let scale = size / 24
            
            // Ribbon
            var ribbonPath = Path()
            ribbonPath.move(to: CGPoint(x: 8 * scale, y: 2 * scale))
            ribbonPath.addLine(to: CGPoint(x: 12 * scale, y: 10 * scale))
            ribbonPath.addLine(to: CGPoint(x: 16 * scale, y: 2 * scale))
            ribbonPath.addLine(to: CGPoint(x: 14 * scale, y: 2 * scale))
            ribbonPath.addLine(to: CGPoint(x: 12 * scale, y: 7 * scale))
            ribbonPath.addLine(to: CGPoint(x: 10 * scale, y: 2 * scale))
            ribbonPath.closeSubpath()
            context.fill(ribbonPath, with: .color(color.opacity(0.7)))
            
            // Medal
            let medalCircle = Path(ellipseIn: CGRect(
                x: 6 * scale, y: 10 * scale,
                width: 12 * scale, height: 12 * scale
            ))
            context.fill(medalCircle, with: .color(color))
        }
    }
}

struct CalendarIcon: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Canvas { context, _ in
            let scale = size / 24
            
            // Calendar body
            let bodyRect = CGRect(x: 3 * scale, y: 6 * scale, width: 18 * scale, height: 14 * scale)
            context.fill(Path(roundedRect: bodyRect, cornerRadius: 2 * scale), with: .color(color))
            
            // Header line
            var headerPath = Path()
            headerPath.move(to: CGPoint(x: 3 * scale, y: 10 * scale))
            headerPath.addLine(to: CGPoint(x: 21 * scale, y: 10 * scale))
            context.stroke(headerPath, with: .color(color.opacity(0.7)), lineWidth: 2 * scale)
            
            // Hooks
            for x in [8, 16] as [CGFloat] {
                let hookRect = CGRect(x: x * scale - 1 * scale, y: 3 * scale, width: 2 * scale, height: 5 * scale)
                context.fill(Path(roundedRect: hookRect, cornerRadius: 1 * scale), with: .color(color))
            }
        }
    }
}

struct TargetIcon: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Canvas { context, _ in
            let scale = size / 24
            let center = CGPoint(x: 12 * scale, y: 12 * scale)
            
            for radius in [10, 6, 2] as [CGFloat] {
                let circle = Path(ellipseIn: CGRect(
                    x: center.x - radius * scale,
                    y: center.y - radius * scale,
                    width: radius * 2 * scale,
                    height: radius * 2 * scale
                ))
                
                if radius == 2 {
                    context.fill(circle, with: .color(color))
                } else {
                    context.stroke(circle, with: .color(color), lineWidth: 2 * scale)
                }
            }
        }
    }
}

struct VibrationIcon: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Canvas { context, _ in
            let scale = size / 24
            
            // Phone body
            let phoneRect = CGRect(x: 8 * scale, y: 4 * scale, width: 8 * scale, height: 16 * scale)
            context.stroke(Path(roundedRect: phoneRect, cornerRadius: 2 * scale), with: .color(color), lineWidth: 2 * scale)
            
            // Vibration waves
            for offset in [-4, 20] as [CGFloat] {
                for i in 0..<3 {
                    let x = offset * scale + (offset < 0 ? -CGFloat(i) * 2 * scale : CGFloat(i) * 2 * scale)
                    var wavePath = Path()
                    wavePath.move(to: CGPoint(x: x, y: 8 * scale))
                    wavePath.addLine(to: CGPoint(x: x, y: 16 * scale))
                    context.stroke(wavePath, with: .color(color.opacity(1 - Double(i) * 0.3)), lineWidth: 1.5 * scale)
                }
            }
        }
    }
}

struct SoundIcon: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Canvas { context, _ in
            let scale = size / 24
            
            // Speaker
            var speakerPath = Path()
            speakerPath.move(to: CGPoint(x: 4 * scale, y: 9 * scale))
            speakerPath.addLine(to: CGPoint(x: 8 * scale, y: 9 * scale))
            speakerPath.addLine(to: CGPoint(x: 12 * scale, y: 5 * scale))
            speakerPath.addLine(to: CGPoint(x: 12 * scale, y: 19 * scale))
            speakerPath.addLine(to: CGPoint(x: 8 * scale, y: 15 * scale))
            speakerPath.addLine(to: CGPoint(x: 4 * scale, y: 15 * scale))
            speakerPath.closeSubpath()
            context.fill(speakerPath, with: .color(color))
            
            // Sound waves
            for i in 0..<3 {
                let radius = (4 + CGFloat(i) * 3) * scale
                var arcPath = Path()
                arcPath.addArc(
                    center: CGPoint(x: 12 * scale, y: 12 * scale),
                    radius: radius,
                    startAngle: .degrees(-60),
                    endAngle: .degrees(60),
                    clockwise: false
                )
                context.stroke(arcPath, with: .color(color.opacity(1 - Double(i) * 0.25)), lineWidth: 1.5 * scale)
            }
        }
    }
}

struct ArrowLeftIcon: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Canvas { context, _ in
            let scale = size / 24
            
            var path = Path()
            path.move(to: CGPoint(x: 15 * scale, y: 6 * scale))
            path.addLine(to: CGPoint(x: 9 * scale, y: 12 * scale))
            path.addLine(to: CGPoint(x: 15 * scale, y: 18 * scale))
            
            context.stroke(path, with: .color(color), style: StrokeStyle(lineWidth: 2.5 * scale, lineCap: .round, lineJoin: .round))
        }
    }
}

struct RefreshIcon: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Canvas { context, _ in
            let scale = size / 24
            let center = CGPoint(x: 12 * scale, y: 12 * scale)
            
            var arcPath = Path()
            arcPath.addArc(
                center: center,
                radius: 8 * scale,
                startAngle: .degrees(0),
                endAngle: .degrees(270),
                clockwise: false
            )
            context.stroke(arcPath, with: .color(color), lineWidth: 2.5 * scale)
            
            // Arrow
            var arrowPath = Path()
            arrowPath.move(to: CGPoint(x: 12 * scale, y: 4 * scale))
            arrowPath.addLine(to: CGPoint(x: 16 * scale, y: 4 * scale))
            arrowPath.addLine(to: CGPoint(x: 12 * scale, y: 8 * scale))
            context.fill(arrowPath, with: .color(color))
        }
    }
}

struct ShareIcon: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Canvas { context, _ in
            let scale = size / 24
            
            // Arrow
            var arrowPath = Path()
            arrowPath.move(to: CGPoint(x: 12 * scale, y: 3 * scale))
            arrowPath.addLine(to: CGPoint(x: 12 * scale, y: 15 * scale))
            context.stroke(arrowPath, with: .color(color), lineWidth: 2 * scale)
            
            var pointPath = Path()
            pointPath.move(to: CGPoint(x: 12 * scale, y: 3 * scale))
            pointPath.addLine(to: CGPoint(x: 8 * scale, y: 7 * scale))
            pointPath.move(to: CGPoint(x: 12 * scale, y: 3 * scale))
            pointPath.addLine(to: CGPoint(x: 16 * scale, y: 7 * scale))
            context.stroke(pointPath, with: .color(color), style: StrokeStyle(lineWidth: 2 * scale, lineCap: .round))
            
            // Box
            var boxPath = Path()
            boxPath.move(to: CGPoint(x: 4 * scale, y: 12 * scale))
            boxPath.addLine(to: CGPoint(x: 4 * scale, y: 20 * scale))
            boxPath.addLine(to: CGPoint(x: 20 * scale, y: 20 * scale))
            boxPath.addLine(to: CGPoint(x: 20 * scale, y: 12 * scale))
            context.stroke(boxPath, with: .color(color), lineWidth: 2 * scale)
        }
    }
}
