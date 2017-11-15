//
//  ViewController.swift
//  lab3
//
//  Created by Labuser on 2/13/17.
//  Copyright © 2017 wustl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var currLineStart = CGPoint.zero
    var currLine: LineView?
    var array:[CGPoint] = []
    var size : CGFloat = 5
    var color: UIColor = UIColor.black

    @IBOutlet weak var pen: UIButton!
    @IBOutlet weak var eraser: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func clear(_ sender: Any) {
        for v in paintView.subviews{
            v.removeFromSuperview()
        }
    }
    
    @IBOutlet weak var paintView: UIView!
    
    @IBAction func changeLineColorBlue(_ sender: UIButton) {
        color = UIColor.blue
    }
    
    @IBAction func usingPen(_ sender: UIButton) {
        color = UIColor.black
        pen.setImage(#imageLiteral(resourceName: "pencil-pressed.png"), for: UIControlState.normal)
        eraser.setImage(#imageLiteral(resourceName: "eraser.png"), for: UIControlState.normal)
        
    }
    
    @IBAction func changeLineColorRed(_ sender: UIButton) {
        color = UIColor.red
    }
    
    @IBAction func usingEraser(_ sender: UIButton) {
        color = UIColor.white
        pen.setImage(#imageLiteral(resourceName: "pencil.png"), for: UIControlState.normal)
        eraser.setImage(#imageLiteral(resourceName: "eraser-pressed.png"), for: UIControlState.normal)
    }
    
    @IBAction func changeLineColorYellow(_ sender: UIButton) {
        color = UIColor.yellow
    }
    
    @IBAction func changeLineColorOrange(_ sender: UIButton) {
        color = UIColor.orange
    }
    
    @IBAction func setBackgroundGrey(_ sender: UIButton) {
        paintView.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func setBackgroundWhite(_ sender: UIButton) {
        paintView.backgroundColor = UIColor.white
    }
    
    @IBAction func changeLineColorGreen(_ sender: UIButton) {
        color = UIColor.green
    }
    
    @IBAction func changeLineSize(_ sender: UISlider) {
        size = CGFloat(sender.value)
    }
    
    @IBAction func undoLastDraw(_ sender: Any) {
        if paintView.subviews.endIndex > 0{
            let v = paintView.subviews[paintView.subviews.endIndex-1]
            v.removeFromSuperview()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: view) else { return }
        array.append(touchPoint)
        currLineStart  = touchPoint
        let frame = CGRect(x:0, y:0, width: view.frame.width - 45, height: view.frame.height)
        currLine = LineView(frame: frame, size: size, color: color)
        currLine?.array = array
        paintView.addSubview(currLine!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: view) else { return }
        array.append(touchPoint)
        currLine?.array = array
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        array.removeAll()
    }
}

