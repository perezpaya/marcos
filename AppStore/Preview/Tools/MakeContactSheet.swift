import AppKit

let directory = URL(fileURLWithPath: CommandLine.arguments[1])
let rep = NSBitmapImageRep(bitmapDataPlanes:nil,pixelsWide:1440,pixelsHigh:1640,bitsPerSample:8,samplesPerPixel:4,hasAlpha:true,isPlanar:false,colorSpaceName:.deviceRGB,bytesPerRow:0,bitsPerPixel:0)!
let cg = NSGraphicsContext(bitmapImageRep:rep)!.cgContext
cg.translateBy(x:0,y:1640); cg.scaleBy(x:1,y:-1)
NSGraphicsContext.current = NSGraphicsContext(cgContext:cg,flipped:true)
NSColor(srgbRed:0.94,green:0.91,blue:0.86,alpha:1).setFill()
NSBezierPath(rect:NSRect(x:0,y:0,width:1440,height:1640)).fill()
func label(_ s:String,_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ size:CGFloat,_ bold:Bool=false) {
    (s as NSString).draw(in:NSRect(x:x,y:y,width:width,height:180),withAttributes:[.font:NSFont.systemFont(ofSize:size,weight:bold ? .semibold : .regular),.foregroundColor:NSColor(srgbRed:0.16,green:0.12,blue:0.11,alpha:1)])
}
label("Marcos · App Store screenshots",40,30,1360,40,true)
for (i,name) in ["01-one-click","02-warm-colors","03-your-strength","04-all-displays","05-quietly-ready"].enumerated() {
    let x = CGFloat(40+(i%2)*700), y = CGFloat(120+(i/2)*505)
    NSImage(contentsOf:directory.appendingPathComponent("Screenshots/"+name+".jpg"))!.draw(in:NSRect(x:x,y:y,width:660,height:412.5),from:.zero,operation:.sourceOver,fraction:1,respectFlipped:true,hints:[.interpolation:NSImageInterpolation.high])
    label(["01 · A red filter for Mac","02 · Three warm colors","03 · Your preferred strength","04 · Connected displays","05 · Login and privacy"][i],x,y+428,660,24,true)
}
label("Submitted listing",770,1180,620,26,true)
label("Marcos: Screen Tint",770,1230,620,36,true)
label("Warm colors. One click away.",770,1290,620,25)
label("Utilities · Free\nWorldwide · General audience",770,1360,620,28)
label("Submitted. Waiting for Review.",770,1490,620,24,true)
try rep.converting(to:.sRGB,renderingIntent:.default)!.representation(using:.jpeg,properties:[.compressionFactor:0.93])!.write(to:directory.appendingPathComponent("ContactSheet.jpg"))
print("Created screenshot contact sheet.")
