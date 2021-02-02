//
//  SKPickerView.swift
//  SKPickerView
//
//  Created by 施　坤 on 2021/01/28.
//
import UIKit

private let SCREEN_WIDTH                    = UIScreen.main.bounds.width
private let SCREEN_HEIGHT                   = UIScreen.main.bounds.height


class SKSinglePickerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate{
    
    
    
    static var theme:SKPickerViewTheme                              = .defalut
    static var backgroundColor: [UIColor]                           = [UIColor.white, UIColor.black]
    static var pickerColor: [UIColor]                               = [UIColor.init(red: 0.996, green: 0.957, blue: 0.906, alpha: 1), UIColor.init(red: 0.251, green: 0.251, blue: 0.251, alpha: 1)]
    static var toolbarColor: [UIColor]                              = [UIColor.init(red: 0.918, green: 0.918, blue: 0.886, alpha: 1), UIColor.init(red: 0.173, green: 0.173, blue: 0.173, alpha: 1)]
    static var toolbarTint: [UIColor]                               = [UIColor.init(red: 0.0, green: 0.627, blue: 0.776, alpha: 1), UIColor.white]
    static var showToolbar: Bool                                    = false         // false, when pickerView disappeared that will auto send confirmPick event,
                                                                                    // true, only press Done button that will send confirmPick event
    
    private var data: [String] = []
    private var callback:(_ event: SKPickerEvent, _ indexPath: Int) -> Void = {_,_ in }
    private let backgroundView: UIView = UIView.init()
    private let toolBar: UIView = UIView.init()
    private let picker: UIPickerView = UIPickerView.init()
    private let doneButton: UIButton = UIButton.init(type: .system)
    
   
    static func ShowPicker(_ data:[String], _ initIndex:Int, _ callback:@escaping (_ event: SKPickerEvent, _ selectedIndex: Int) -> Void) {
        let pickView =  SKSinglePickerView(data, initIndex, callback);
        if pickView != nil {
            pickView!.show()
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init?(_ data:[String], _ initIndex:Int, _ callback:@escaping (_ event: SKPickerEvent, _ selectedIndex: Int) -> Void) {
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        self.backgroundColor = UIColor.clear
        self.callback = callback
        self.data = data
        
        self.backgroundView.frame = self.frame
        self.backgroundView.alpha = 0
        self.backgroundView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.backgroundViewPressed(gestureRecognizer:))))
        self.addSubview(self.backgroundView)
        
        if SKSinglePickerView.showToolbar {
            self.toolBar.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 30)
            self.addSubview(self.toolBar)
            self.doneButton.setTitle("Done", for: .normal)
            self.doneButton.sizeToFit()
            self.doneButton.frame = CGRect.init(x: self.toolBar.frame.width - 15 - self.doneButton.frame.width, y: (self.toolBar.frame.height - self.doneButton.frame.height) / 2.0, width: self.doneButton.frame.width, height: self.doneButton.frame.height)
            self.doneButton.addTarget(self, action: #selector(toolDonePressed(sender:)), for: .touchUpInside)
            self.toolBar.addSubview(self.doneButton)
        } else {
            self.toolBar.frame = CGRect.init()
        }
        
        self.picker.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT + self.toolBar.frame.size.height, width: SCREEN_WIDTH, height: self.picker.frame.height)
        self.picker.delegate = self
        self.picker.dataSource = self
        self.picker.reloadAllComponents()
        self.picker.selectRow(initIndex, inComponent: 0, animated: true)
        self.addSubview(self.picker)
        
        let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).last
        window?.rootViewController?.view.addSubview(self)
        
        if #available(iOS 12.0, *) {
            let currentMode = UITraitCollection.current.userInterfaceStyle
            if SKSinglePickerView.theme == .defalut {
                if currentMode == .dark {
                    self.setTheme(.Dark)
                } else {
                    self.setTheme(.Light)
                }
            } else {
                self.setTheme(SKSinglePickerView.theme)
            }
        } else {
            self.setTheme(.Light)
        }
    }
    
    private func show() {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
        self.callback(.willAppare, self.picker.selectedRow(inComponent: 0))
        UIView .animate(withDuration: 0.5) {
            self.backgroundView.alpha = 0.5
            self.toolBar.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT - self.picker.frame.height - self.toolBar.frame.height, width: SCREEN_WIDTH, height: self.toolBar.frame.height)
            self.picker.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT - self.picker.frame.height, width: SCREEN_WIDTH, height: self.picker.frame.height)
        } completion: { (Bool) in
            self.callback(.didAppare, self.picker.selectedRow(inComponent: 0))
        }

    }
  
    private func setTheme(_ theme: SKPickerViewTheme) {
        self.backgroundView.backgroundColor = SKSinglePickerView.backgroundColor[theme.rawValue]
        self.picker.backgroundColor = SKSinglePickerView.pickerColor[theme.rawValue]
        self.toolBar.backgroundColor = SKSinglePickerView.toolbarColor[theme.rawValue]
        self.doneButton.setTitleColor(SKSinglePickerView.toolbarTint[theme.rawValue], for: .normal)
    }
    
    @objc private func backgroundViewPressed(gestureRecognizer: UIFeedbackGenerator) {
        if SKSinglePickerView.showToolbar {
            self.callback(.cancelPick, self.picker.selectedRow(inComponent: 0))
        } else {
            self.callback(.confirmPick, self.picker.selectedRow(inComponent: 0))
        }
        self.hide()
    }
    
    private func hide() {
        self.callback(.willDisappare, self.picker.selectedRow(inComponent: 0))
        UIView.animate(withDuration: 0.5) {
            self.backgroundView.alpha = 0
            self.picker.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT + self.toolBar.frame.height, width: SCREEN_WIDTH, height: self.picker.frame.height)
            self.toolBar.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: self.toolBar.frame.height)
        } completion: { (Bool) in
            self.callback(.didDisappare, self.picker.selectedRow(inComponent: 0))
            self.removeFromSuperview()
        }
    }

    
    @objc private func toolDonePressed(sender: UIButton) {
        self.callback(.confirmPick, self.picker.selectedRow(inComponent: 0))
        self.hide()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.callback(.valueChanged, row)
    }
}
