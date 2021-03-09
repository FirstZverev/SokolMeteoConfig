////
////  LineChartController.swift
////  SOKOL
////
////  Created by Володя Зверев on 13.01.2021.
////  Copyright © 2021 zverev. All rights reserved.
////
//
//import Foundation
//import Charts
//import UIKit
//import QuickLook
//
//class LineChartController: ChartViewDelegate {
//    
//    let chartView: LineChartView
//    
//    let colors = [UIColor.green, UIColor.blue, UIColor.red, UIColor.purple, UIColor.brown, UIColor.cyan]
//    
//    let building: Building
//    
//    init(rect: CGRect, building: Building){
//        
//        self.building = building
//        
//        chartView = LineChartView(frame: rect)
//        
//        //
//        chartView.delegate = self
//        
//        chartView.noDataText = "Loading chart data..."
//        
//        chartView.xAxis.valueFormatter = DateValueFormatter()
//        chartView.xAxis.labelPosition = .bottom
//        chartView.xAxis.axisMinLabels = 7
//        chartView.xAxis.axisMaxLabels = 7
//        chartView.xAxis.setLabelCount(7, force: true)
//        chartView.xAxis.granularity = 4 * 3600
//        
//        chartView.chartDescription?.enabled = false
//        chartView.dragEnabled = false
//        chartView.setScaleEnabled(false)
//        chartView.pinchZoomEnabled = false
//        
//        chartView.xAxis.gridLineDashLengths = [10, 10]
//        chartView.xAxis.gridLineDashPhase = 0
//        
//        let leftAxis = chartView.leftAxis
//        leftAxis.removeAllLimitLines()
//        leftAxis.axisMaximum = 100
//        leftAxis.axisMinimum = 0
//        leftAxis.gridLineDashLengths = [5, 5]
//        leftAxis.drawLimitLinesBehindDataEnabled = true
//        
//        chartView.rightAxis.enabled = false
//        
//        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
//                                   font: .systemFont(ofSize: 12),
//                                   textColor: .white,
//                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
//        marker.chartView = chartView
//        marker.minimumSize = CGSize(width: 80, height: 40)
//        chartView.marker = marker
//        
//        chartView.legend.form = .line
//        
//        self.updateChartData()
//        
//    }
//    func updateChartData() {
//        
//        // Create dummy data points
//        
//        self.getChartData(self.building)
//        
//    }
//    /// Plot each rooms data on a 24 hour x Axis
//    func getChartData(_ building: Building) {
//        
//        guard let rooms = building.rooms else {
//            return
//        }
//        
//        var i = 0
//        var minX = TimeInterval(99999999999999)
//        var maxX = TimeInterval(0)
//        
//        var dataSets = [LineChartDataSet]()
//        
//        for room in rooms {
//            i += 1
//            var yVals = [BarChartDataEntry]()
//            
//            if let capacity = room.capacity, let observations = room.observations {
//                if capacity > 0 {
//                    for obs in observations {
//                        if let x = obs.timestamp?.timeIntervalSince1970 {
//                            minX = min(minX, x)
//                            maxX = max(maxX, x)
//                            let y = Double(obs.numberOfPeople ?? 0) / Double(capacity)
//                            yVals.append(BarChartDataEntry(x: x, y: y*100.0))
//                        }
//                    }
//                }
//                
//                var setLabel = "Rm \(i)"
//                if let label = room.name {
//                    setLabel = label
//                }
//                
//                let set = LineChartDataSet(values: yVals, label: setLabel)
//                set.drawIconsEnabled = false
//                
//                set.setColor(self.getColor(i - 1))
//                set.setCircleColor(.red)
//                set.lineWidth = 1
//                set.circleRadius = 3
//                set.drawCircleHoleEnabled = false
//                set.valueFont = .systemFont(ofSize: 9)
//                set.drawCirclesEnabled = false
//                set.drawValuesEnabled = false
//                set.formLineWidth = 1
//                set.formSize = 15
//                
//                let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
//                                      ChartColorTemplates.colorFromString("#ffff0000").cgColor]
//                let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
//                
//                set.fillAlpha = 1
//                set.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
//                set.drawFilledEnabled = false
//                
//                dataSets.append(set)
//            }
//        }
//        let data = LineChartData(dataSets: dataSets)
//        
//        // Set the X Axis min and max values
//        
//        let minDate = Date(timeIntervalSince1970: minX)
//        let maxDate = Date(timeIntervalSince1970: maxX)
//        let startOfDate = NSCalendar.current.startOfDay(for: minDate)
//        let endOfDate = NSCalendar.current.startOfDay(for: maxDate).addingTimeInterval(24*3600)
//        
//        chartView.xAxis.axisMinimum = startOfDate.timeIntervalSince1970
//        chartView.xAxis.axisMaximum = endOfDate.timeIntervalSince1970
//        
//        chartView.data = data
//    }
//    
//    func getColor(_ index: Int)->UIColor{
//        // Find the color based on the index
//        let count = colors.count
//        
//        if index UIColor{
//            // Find the color based on the index
//            let count = colors.count
//            
//            if index Void){
//                
//                DispatchQueue.global().async {
//                    
//                    self.building.getRooms {
//                        
//                        DispatchQueue.main.async {
//                            
//                            self.generatePdfWithFilePath(thefilePath: self.path)
//                            
//                            completion()
//                        }
//                    }
//                }
//            }
//            func drawLineGraph(x: CGFloat, y: CGFloat)->CGRect{
//                
//                let width = (pageSize.width - 2*kBorderInset - 2*kMarginInset)/2.0 - 50.0
//                
//                let renderingRect = CGRect(x: x, y: y + 50.0, width: width, height: 150.0)
//                
//                // Create a view for the Graph
//                let graphController = LineChartController(rect: renderingRect, building: self.building)
//                
//                if let currentContext = UIGraphicsGetCurrentContext() {
//                    
//                    let frame = graphController.chartView.frame
//                    currentContext.saveGState()
//                    currentContext.translateBy(x:frame.origin.x, y:frame.origin.y)
//                    graphController.chartView.layer.render(in: currentContext)
//                    currentContext.restoreGState()
//                }
//                return renderingRect
//            }
//            func drawBarGraph(x: CGFloat, y: CGFloat)->CGRect{
//                
//                let width = (pageSize.width - 2*kBorderInset - 2*kMarginInset)/2.0 - 50.0
//                
//                let renderingRect = CGRect(x: x + width + 50, y: y + 50.0, width: width, height: 150.0)
//                
//                // Create a view for the Graph
//                let graphController = BarChartController(rect: renderingRect, building: self.building)
//                
//                if let currentContext = UIGraphicsGetCurrentContext() {
//                    
//                    let frame = graphController.chartView.frame
//                    currentContext.saveGState()
//                    currentContext.translateBy(x:frame.origin.x, y:frame.origin.y)
//                    //graphController.chartView.layer.render(in: currentContext)
//                    graphController.chartView.draw(frame)
//                    currentContext.restoreGState()
//                    
//                }
//                return renderingRect
//            }
//            func generatePdfWithFilePath(thefilePath: String)
//            {
//                
//                UIGraphicsBeginPDFContextToFile(thefilePath, CGRect.zero, nil);
//                
//                var currentPage = 0
//                var done = false
//                repeat
//                {
//                    //Start a new page.
//                    UIGraphicsBeginPDFPageWithInfo(CGRect(x: 0, y: 0, width: pageSize.width, height: pageSize.height), nil);
//                    
//                    //Draw a border for each page.
//                    self.drawBorder()
//                    
//                    //Draw a page number at the bottom of each page.
//                    currentPage += 1
//                    self.drawPageNumber(currentPage)
//                    
//                    //Draw text fo our header.
//                    self.drawHeader()
//                    
//                    //Draw a line below the header.
//                    self.drawLine()
//                    
//                    //Draw some text for the page.
//                    if let textRect = self.drawText() {
//                        
//                        let lineRect = self.drawLineGraph(x: textRect.minX, y:textRect.maxY)
//                        
//                        self.drawBarGraph(x: lineRect.minX, y:textRect.maxY)
//                    }
//                    //Draw an image
//                    self.drawImage()
//                    
//                    done = true
//                }
//                while (!done)
//                
//                // Close the PDF context and write the contents out.
//                UIGraphicsEndPDFContext();
//            }
//            
//            /// Draw a border around the page
//            func drawBorder()
//            {
//                
//                if let currentContext = UIGraphicsGetCurrentContext() {
//                    let borderColor = UIColor.brown
//                    
//                    let rectFrame = CGRect(x: kBorderInset, y: kBorderInset, width: pageSize.width-kBorderInset*2, height: pageSize.height-kBorderInset*2)
//                    
//                    currentContext.setStrokeColor(borderColor.cgColor)
//                    currentContext.setLineWidth(CGFloat(kBorderWidth))
//                    currentContext.stroke(rectFrame)
//                    
//                }
//            }
//            
//            // Draw the page number at bottom center
//            func drawPageNumber(_ page: Int){
//                
//                // if let currentContext = UIGraphicsGetCurrentContext() {
//                
//                let pageNumberString = String(format:"Page %d", pageNumber) as NSString
//                
//                let attributes = getParaAttributes(textAlignment: .center)
//                
//                let pageNumberStringSize = pageNumberString.boundingRect(with: pageSize, options: [.usesLineFragmentOrigin], attributes: attributes, context: nil)
//                
//                let stringRenderingRect = CGRect(x: kBorderInset,
//                                                 y: pageSize.height - 40.0,
//                                                 width: pageSize.width - 2*kBorderInset,
//                                                 height: pageNumberStringSize.height)
//                
//                pageNumberString.draw(in: stringRenderingRect, withAttributes: attributes)
//                
//            }
//            
//            // Draw the page header
//            func drawHeader(){
//                if let currentContext = UIGraphicsGetCurrentContext() {
//                    currentContext.setFillColor(red: 0.3, green: 0.7, blue: 0.2, alpha: 1.0)
//                    
//                    let textToDraw = "SpaceU Report"  as NSString
//                    
//                    let font = UIFont.systemFont(ofSize:24.0)
//                    
//                    let attributes = getParaAttributes(font: font, textAlignment: .center)
//                    let paraSize = CGSize(width: pageSize.width - 2*kBorderInset-2*kMarginInset, height: pageSize.height - 2*kBorderInset - 2*kMarginInset)
//                    
//                    let stringSize = textToDraw.boundingRect(with: paraSize, options: [.usesLineFragmentOrigin], attributes: attributes, context: nil)
//                    
//                    let renderingRect = CGRect(x: kBorderInset + kMarginInset, y: kBorderInset + kMarginInset, width: pageSize.width - 2*kBorderInset - 2*kMarginInset, height: stringSize.height)
//                    
//                    textToDraw.draw(in:renderingRect, withAttributes: attributes)
//                    
//                }
//            }
//            
//            // Draw a line
//            func drawLine(){
//                
//                if let currentContext = UIGraphicsGetCurrentContext() {
//                    
//                    currentContext.setLineWidth(kLineWidth)
//                    
//                    currentContext.setStrokeColor(UIColor.blue.cgColor)
//                    
//                    let startPoint = CGPoint(x:kMarginInset + kBorderInset, y:kMarginInset + kBorderInset + 40.0)
//                    let endPoint = CGPoint(x:pageSize.width - 2*kMarginInset - 2*kBorderInset, y:kMarginInset + kBorderInset + 40.0)
//                    
//                    currentContext.beginPath()
//                    currentContext.move(to: startPoint)
//                    currentContext.addLine(to: endPoint)
//                    
//                    currentContext.closePath()
//                    currentContext.drawPath(using: .fillStroke)
//                    
//                }
//            }
//            
//            // Draw text
//            func drawText()->CGRect?{
//                
//                if let currentContext = UIGraphicsGetCurrentContext() {
//                    currentContext.setFillColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
//                    
//                    let textToDraw = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Nam liber tempor cum soluta nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum. Typi non habent claritatem insitam; est usus legentis in iis qui facit eorum claritatem. Investigationes demonstraverunt lectores legere me lius quod ii legunt saepius. Claritas est etiam processus dynamicus, qui sequitur mutationem consuetudium lectorum. Mirum est notare quam littera gothica, quam nunc putamus parum claram, anteposuerit litterarum formas humanitatis per seacula quarta decima et quinta decima. Eodem modo typi, qui nunc nobis videntur parum clari, fiant sollemnes in futurum."
//                    
//                    let font = UIFont.systemFont(ofSize:14.0)
//                    
//                    let attributes = getParaAttributes(font: font, textAlignment: .left)
//                    let paraSize = CGSize(width: pageSize.width - 2*kBorderInset-2*kMarginInset, height: pageSize.height - 2*kBorderInset - 2*kMarginInset)
//                    
//                    let stringSize = textToDraw.boundingRect(with: paraSize, options: [.usesLineFragmentOrigin], attributes: attributes, context: nil)
//                    
//                    let renderingRect = CGRect(x: kBorderInset + kMarginInset, y: kBorderInset + kMarginInset + 50.0, width: pageSize.width - 2*kBorderInset - 2*kMarginInset, height: stringSize.height)
//                    
//                    textToDraw.draw(in:renderingRect, withAttributes: attributes)
//                    
//                    return renderingRect
//                }
//                
//                return nil
//            }
//            
//            // Draw an Image
//            func drawImage(){
//                /*
//                 UIImage * demoImage = [UIImage imageNamed:@"demo.png"];
//                 [demoImage drawInRect:CGRectMake( (pageSize.width - demoImage.size.width/2)/2, 350, demoImage.size.width/2, demoImage.size.height/2)];
//                 */
//            }
//            
//            func drawHeaderX(){
//                let headerTextX = leftMargin
//                let headerTextY = self.pdfHeight - CGFloat(35.0)
//                let headerTextWidth = self.pdfWidth - leftMargin - rightMargin
//                let headerTextHeight = CGFloat(20.0)
//                
//                let headerFont = UIFont(name: "Helvetica", size: 15.0)
//                
//                let headerParagraphStyle = NSMutableParagraphStyle()
//                headerParagraphStyle.alignment = NSTextAlignment.right
//                
//                let headerFontAttributes = [
//                    NSAttributedStringKey.font: headerFont ?? UIFont.systemFont(ofSize: 12),
//                    NSAttributedStringKey.paragraphStyle:headerParagraphStyle,
//                    NSAttributedStringKey.foregroundColor:UIColor.lightGray
//                ]
//                let headerRect = CGRect(x:headerTextX, y:headerTextY, width:headerTextWidth, height:headerTextHeight)
//                self.headerText.draw(in: headerRect, withAttributes: headerFontAttributes)
//            }
//            
//            func getParaAttributes(fontName: String = "Helvetica", fontSize: CGFloat = 12.0, textAlignment: NSTextAlignment = .left)->[NSAttributedStringKey: Any]{
//                if let font = UIFont(name: fontName, size: fontSize) {
//                    
//                    return getParaAttributes(font: font, textAlignment: textAlignment)
//                } else {
//                    return getParaAttributes(textAlignment: textAlignment)
//                }
//            }
//            
//            func getParaAttributes(font: UIFont = UIFont.systemFont(ofSize: 12), textAlignment: NSTextAlignment = .left)->[NSAttributedStringKey: Any]{
//                
//                let paragraphStyle = NSMutableParagraphStyle()
//                paragraphStyle.alignment = textAlignment
//                paragraphStyle.lineBreakMode = .byWordWrapping
//                
//                let fontAttributes = [
//                    NSAttributedStringKey.font:             font,
//                    NSAttributedStringKey.paragraphStyle:   paragraphStyle,
//                    NSAttributedStringKey.foregroundColor:  UIColor.lightGray
//                ]
//                
//                return fontAttributes
//            }
//        }
//    }
//}
//
//class PDFReportViewController: UIViewController, QLPreviewControllerDataSource {
//    
//    @IBOutlet var statusLabel: UILabel?
//    
//    let quickLookController = QLPreviewController()
//    var fileURLs = [URL]()
//    
//    var project:Project?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Do any additional setup after loading the view.
//        
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let documentsDirectory = paths[0]
//        
//        let filePath = documentsDirectory.appendingPathComponent("SpaceU_Report.pdf")
//        
//        fileURLs.append(filePath)
//        
//        quickLookController.dataSource = self
//        
//        self.createPDFReport(sender: nil)
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    /*
//     // MARK: - Navigation
//     
//     // In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//     // Get the new view controller using segue.destinationViewController.
//     // Pass the selected object to the new view controller.
//     }
//     */
//    
//    @IBAction func createPDFReport(sender: Any?) {
//        
//        guard let project = self.project else {
//            DebugLog(" Project is nil!")
//            self.progress("Project is nil!")
//            return
//        }
//        
//        self.progress("Fetching project data, please wait...")
//        // Get the project data
//        CloudKitController.sharedController.projectData(project, completion: { success in
//            
//            self.progress("Generating report, please wait...")
//            if success {
//                self.createReport()
//            } else {
//                return
//            }
//            
//        })
//    }
//    func progress(_ progress:String){
//        DispatchQueue.main.async {
//            self.statusLabel?.text = progress
//        }
//    }
//    func createReport() {
//        
//        guard let building = self.project!.buildings?[0] else {
//            DebugLog(" Building is nil!")
//            return
//        }
//        
//        let filePath = self.fileURLs[0].path
//        
//        let pdfReport = PDFReport(filePath, building: building)
//        
//        self.progress("Creating PDF Report, please wait...")
//        
//        pdfReport.createPDF({
//            
//            DispatchQueue.main.async {
//                self.statusLabel?.text = "PDF Report Created."
//                
//                // Show the report
//                self.showMyDocPreview(currIndex: 0)
//            }
//            
//        })
//        
//    }
//    @IBAction func showPDFReport(sender: Any?) {
//        print("showPDFReport")
//        self.showMyDocPreview(currIndex: 0)
//    }
//    
//    // MARK: QuickLook
//    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController) -> Int {
//        return fileURLs.count
//    }
//    
//    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
//        return fileURLs[index] as QLPreviewItem
//    }
//    
//    @available(iOS 4.0, *)
//    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
//        return fileURLs.count
//    }
//    
//    func showMyDocPreview(currIndex:Int) {
//        
//        if QLPreviewController.canPreview(fileURLs[currIndex] as QLPreviewItem) {
//            quickLookController.currentPreviewItemIndex = currIndex
//            navigationController?.pushViewController(quickLookController, animated: true)
//        }
//    }
//}
