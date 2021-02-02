# SKPickerViewSwift
This library provides a picker view that fast to create

# Requirements
* iOS 9.0 or later
* Swift 4.0 or later
# Installation with CocoaPods
Podfile

    pod 'SKPickerViewSwift', '~> 0.0.1'
    
# How To Use

### SKDatePickerView.swift
		// Optional
		SKDatePickerView.theme 		= .Dark
		SKDatePickerView.sytel 		= .inline		// available by iOS 13.4
		SKDatePickerView.maxDate 	= Date.init()
		...
		// Optional Over
		SKDatePickerView.ShowPicker(nil, .date) { (SKPickerEvent, Date) in
		
		}
		
### SKSinglePickerView.swift
		// Optional
		SKSinglePickerView.theme 																												= .Dark
		SKSinglePickerView.sytel 																												= .inline		// available by iOS 13.4
		SKSinglePickerView.backgroundColor[SKPickerViewTheme.Dark.rawValue]							= UIColor.red
		SKSinglePickerView.pickerColor[SKPickerViewTheme.Dark.rawValue]									= UIColor.black
		...
		// Optional Over
		SKSinglePickerView.ShowPicker(["1","2","3"], 1) { (SKPickerEvent, Int) in
		
		}
		
### SKMutilePickerView.swift
		import UIKit
		class SomeObject: UIPickerViewDelegate, UIPickerViewDataSource {
		...
		// Optional
		...
		// Optional Over
		
		SKMutilePickerView.ShowPicker(self, self) { (SKPickerEvent, Int) in
		
		}
