import AppKit

// Run after CaptureControls.swift. Only the surrounding artwork is illustrated.
let input = URL(fileURLWithPath: CommandLine.arguments[1])
let output = URL(fileURLWithPath: CommandLine.arguments[2])
try FileManager.default.createDirectory(at: output, withIntermediateDirectories: true)
let ink = NSColor(srgbRed: 0.13, green: 0.12, blue: 0.13, alpha: 1)
let cream = NSColor(srgbRed: 0.97, green: 0.95, blue: 0.91, alpha: 1)
let muted = NSColor(srgbRed: 0.42, green: 0.36, blue: 0.34, alpha: 1)
let rust = NSColor(srgbRed: 0.67, green: 0.18, blue: 0.12, alpha: 1)
func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> NSColor {
    NSColor(srgbRed: r, green: g, blue: b, alpha: 1)
}
func fill(_ rect: NSRect, _ color: NSColor, radius: CGFloat = 0) {
    color.setFill()
    NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius).fill()
}
func text(_ value: String, _ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ size: CGFloat,
          _ color: NSColor = ink, weight: NSFont.Weight = .regular, spacing: CGFloat = 1.12) {
    let p = NSMutableParagraphStyle()
    p.minimumLineHeight = size * spacing
    p.maximumLineHeight = size * spacing
    let attrs: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: size, weight: weight), .foregroundColor: color,
        .paragraphStyle: p, .kern: size >= 90 ? -size * 0.035 : -size * 0.008
    ]
    let s = NSAttributedString(string: value, attributes: attrs)
    let height = s.boundingRect(with: NSSize(width: width, height: 3000), options: [.usesLineFragmentOrigin, .usesFontLeading]).height
    precondition(y + height < 1800, "Text exceeds screenshot: \(value)")
    s.draw(in: NSRect(x: x, y: y, width: width, height: ceil(height) + 8))
}
func image(_ image: NSImage, _ rect: NSRect) {
    image.draw(in: rect, from: .zero, operation: .sourceOver, fraction: 1, respectFlipped: true, hints: [.interpolation: NSImageInterpolation.high])
}
func panel(_ name: String, x: CGFloat, y: CGFloat, width: CGFloat) {
    let img = NSImage(contentsOf: input.appendingPathComponent(name + ".png"))!
    let rect = NSRect(x: x, y: y, width: width, height: width * 416 / 320)
    NSGraphicsContext.saveGraphicsState()
    let shadow = NSShadow(); shadow.shadowColor = NSColor.black.withAlphaComponent(0.22)
    shadow.shadowBlurRadius = 48; shadow.shadowOffset = NSSize(width: 0, height: 18); shadow.set()
    fill(rect, name.contains("dark") ? rgb(0.15,0.15,0.15) : .white, radius: 30)
    NSGraphicsContext.restoreGraphicsState()
    NSGraphicsContext.saveGraphicsState()
    NSBezierPath(roundedRect: rect, xRadius: 30, yRadius: 30).addClip()
    image(img, rect)
    NSGraphicsContext.restoreGraphicsState()
}
func glasses(_ x: CGFloat, _ y: CGFloat, _ scale: CGFloat, _ color: NSColor?, frame: NSColor = ink) {
    NSGraphicsContext.saveGraphicsState()
    let c = NSGraphicsContext.current!.cgContext
    c.translateBy(x: x, y: y); c.scaleBy(x: scale, y: scale)
    for x in [CGFloat(2), 15] {
        let lens = NSBezierPath(roundedRect: NSRect(x: x, y: 3, width: 9, height: 9), xRadius: 2.5, yRadius: 2.5)
        if let color { color.setFill(); lens.fill() }
        frame.setStroke(); lens.lineWidth = 1.6; lens.stroke()
    }
    let bridge = NSBezierPath(); bridge.move(to: NSPoint(x: 11,y: 8))
    bridge.curve(to: NSPoint(x: 15,y: 8), controlPoint1: NSPoint(x: 12,y: 6), controlPoint2: NSPoint(x: 14,y: 6))
    bridge.lineWidth = 1.6; frame.setStroke(); bridge.stroke()
    NSGraphicsContext.restoreGraphicsState()
}
func header(_ page: Int, dark: Bool = false) {
    glasses(150, 87, 3, rust, frame: dark ? cream : ink)
    text("Marcos", 254, 77, 600, 43, dark ? cream : ink, weight: .semibold)
    text("SCREEN TINT FOR MAC", 2090, 87, 650, 30, dark ? cream.withAlphaComponent(0.65) : muted, weight: .medium)
    text(String(format: "%02d", page), page == 4 ? 150 : 2670, page == 4 ? 1740 : 1685, 100, 28, dark ? cream.withAlphaComponent(0.55) : muted)
}
// The preview uses the same color and opacity formula as FilterController.
// It is an original illustrated desktop, not an invented Marcos interface.
func desktop(_ r: NSRect, strength: CGFloat, color: NSColor = rgb(0.65,0,0)) {
    NSGraphicsContext.saveGraphicsState()
    NSBezierPath(roundedRect: r, xRadius: 18, yRadius: 18).addClip()
    fill(r, rgb(0.86,0.89,0.87))
    fill(NSRect(x:r.minX + r.width*0.58,y:r.minY-r.height*0.4,width:r.width*0.85,height:r.height*1.9),rgb(0.72,0.78,0.73),radius:r.width*0.4)
    fill(NSRect(x:r.minX,y:r.minY,width:r.width,height:r.height*0.075),rgb(0.96,0.97,0.95))
    let page = NSRect(x:r.minX+r.width*0.10,y:r.minY+r.height*0.15,width:r.width*0.80,height:r.height*0.77)
    fill(page,.white,radius:10)
    let s = min(r.width/700, r.height/450)
    for (i,col) in [rgb(0.94,0.38,0.33),rgb(0.96,0.75,0.27),rgb(0.39,0.75,0.42)].enumerated() {
        fill(NSRect(x:page.minX+18*s+CGFloat(i)*20*s,y:page.minY+18*s,width:11*s,height:11*s),col,radius:6*s)
    }
    text("Evening notes",page.minX+32*s,page.minY+66*s,page.width-64*s,26*s,ink,weight:.semibold)
    text("A little room to think.",page.minX+32*s,page.minY+117*s,page.width-64*s,36*s,ink,weight:.semibold)
    text("Read a chapter. Save an idea.\nCall it a day.",page.minX+32*s,page.minY+181*s,page.width-64*s,24*s,muted,spacing:1.35)
    for i in 0..<3 {
        fill(NSRect(x:page.minX+32*s,y:page.maxY-74*s+CGFloat(i)*18*s,width:page.width*(i==2 ? 0.42 : 0.75),height:6*s),rgb(0.88,0.88,0.87),radius:3*s)
    }
    fill(r,color.withAlphaComponent(strength/100*0.68))
    NSGraphicsContext.restoreGraphicsState()
}
func strengthStrip(_ name: String, x: CGFloat, y: CGFloat, width: CGFloat) {
    let img = NSImage(contentsOf: input.appendingPathComponent(name+".png"))!
    let cg = img.cgImage(forProposedRect: nil, context: nil, hints: nil)!
    let crop = cg.cropping(to: CGRect(x:40,y:160,width:560,height:236))!
    image(NSImage(cgImage:crop,size:NSSize(width:560,height:236)),NSRect(x:x,y:y,width:width,height:width*236/560))
}
func render(_ name: String, _ background: NSColor, _ body: () -> Void) {
    let rep = NSBitmapImageRep(bitmapDataPlanes:nil,pixelsWide:2880,pixelsHigh:1800,bitsPerSample:8,samplesPerPixel:4,hasAlpha:true,isPlanar:false,colorSpaceName:.deviceRGB,bytesPerRow:0,bitsPerPixel:0)!
    let cg = NSGraphicsContext(bitmapImageRep:rep)!.cgContext
    cg.translateBy(x:0,y:1800); cg.scaleBy(x:1,y:-1)
    NSGraphicsContext.saveGraphicsState(); NSGraphicsContext.current = NSGraphicsContext(cgContext:cg,flipped:true)
    fill(NSRect(x:0,y:0,width:2880,height:1800),background); body()
    NSGraphicsContext.restoreGraphicsState()
    try! rep.converting(to: .sRGB, renderingIntent: .default)!.representation(using:.jpeg,properties:[.compressionFactor:0.95])!.write(to:output.appendingPathComponent(name+".jpg"))
    print("Rendered",name,"2880 × 1800, RGB, no alpha")
}

render("01-one-click",cream) {
    let hero = NSImage(contentsOf: output.deletingLastPathComponent().appendingPathComponent("Assets/01-macbook-red-render.png"))!
    image(hero, NSRect(x: 0, y: 0, width: 2880, height: 1800))
}
render("02-warm-colors",rgb(0.15,0.075,0.08)) {
    header(2,dark:true)
    text("Find your kind of warm.",150,225,2580,127,cream,weight:.semibold)
    text("Three warm tints. One simple choice.",157,407,2500,49,cream.withAlphaComponent(0.74))
    for (i,name) in ["red-dark","orange-dark","amber-dark"].enumerated() {
        let x = CGFloat(150+i*885)
        let col = [rgb(0.49,0.15,0.14),rgb(0.63,0.27,0.13),rgb(0.68,0.42,0.13)][i]
        fill(NSRect(x:x,y:600,width:810,height:1020),col,radius:44)
        text(["Red","Orange","Amber"][i],x+75,645,660,50,cream,weight:.semibold)
        panel(name,x:x+80,y:745,width:650)
    }
}
render("03-your-strength",cream) {
    header(3)
    text("Just a little.\nOr a lot.",150,240,1450,134,ink,weight:.semibold)
    text("Set your tint from 0 to 100%.\nSlide to zero to go clear.",1670,345,1050,47,muted,spacing:1.3)
    for (i,strength) in [20,45,80].enumerated() {
        let x = CGFloat(150+i*885)
        text("\(strength)%",x,661,810,78,rust,weight:.semibold)
        desktop(NSRect(x:x,y:785,width:810,height:440),strength:CGFloat(strength))
        strengthStrip(["subtle","red","strong"][i],x:x+40,y:1285,width:730)
    }
    text("Your next click brings back your last tint strength.",150,1640,2550,39,ink,weight:.medium)
    text("Illustrative desktop previews",150,1710,2400,25,muted)
}
render("04-all-displays",rgb(0.13,0.15,0.145)) {
    header(4,dark:true)
    text("Every display.\nOne warm setting.",150,230,2600,130,cream,weight:.semibold)
    text("Keep the same tint across connected screens.",157,565,2500,49,cream.withAlphaComponent(0.73))
    fill(NSRect(x:150,y:795,width:1460,height:850),rgb(0.34,0.36,0.35),radius:37)
    desktop(NSRect(x:175,y:820,width:1410,height:800),strength:45,color:rgb(0.8,0.35,0.04))
    fill(NSRect(x:775,y:1645,width:210,height:65),rgb(0.34,0.36,0.35),radius:12)
    fill(NSRect(x:655,y:1700,width:450,height:16),rgb(0.45,0.46,0.44),radius:8)
    fill(NSRect(x:1680,y:1020,width:1050,height:652),rgb(0.34,0.36,0.35),radius:30)
    desktop(NSRect(x:1705,y:1045,width:1000,height:602),strength:45,color:rgb(0.8,0.35,0.04))
    fill(NSRect(x:1640,y:1670,width:1130,height:24),rgb(0.52,0.54,0.52),radius:10)
    panel("amber",x:1060,y:959,width:410)
    text("Illustrative desktop previews · Native Marcos controls",1680,1733,1100,24,cream.withAlphaComponent(0.55))
}
render("05-quietly-ready",cream) {
    header(5)
    text("Quietly ready.\nRight in your menu bar.",150,250,1550,112,ink,weight:.semibold)
    let rows = [("Start at login.","Choose Launch at login to keep Marcos ready."),
                ("Keep your settings.","Your chosen color and strength are saved."),
                ("Keep your privacy.","Your settings stay on your Mac.")]
    for (i,row) in rows.enumerated() {
        let y = CGFloat(750+i*250)
        text("0\(i+1)",153,y+4,150,31,rust,weight:.semibold)
        text(row.0,290,y-5,1320,54,ink,weight:.semibold)
        text(row.1,290,y+80,1320,39,muted)
    }
    fill(NSRect(x:1785,y:270,width:945,height:1320),rgb(0.86,0.79,0.68),radius:58)
    glasses(2110,350,8,nil)
    panel("off-dark",x:1905,y:555,width:700)
    text("Clear glasses. Filter off.",1935,1515,750,33,muted)
    text("No account. No ads. No tracking.",150,1635,2350,43,ink,weight:.semibold)
}
