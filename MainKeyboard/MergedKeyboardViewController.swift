//
//  KeyboardViewController.swift
//  MainKeyboard
//
//  Created by Meng Huang on 11/13/16.
//  Copyright © 2016 Meng Huang. All rights reserved.
//

import UIKit

class MergedKeyboardViewController: UIInputViewController, UITableViewDelegate, UITableViewDataSource{

  /************************** Shared Variables **************************/
  var view_number : Int = 1
  var connector : DatabaseConnector = DatabaseConnector()
  var searchResult : [String] = []
  
  /************************** View 1 Variables **************************/
  let topRowView_view1 = UIView(frame: CGRect(x: 0, y: 0, width: 1376, height: 67))
    var inputBox_view1 : UITextField!
  
  var inputButtons_view1 : [UIButton] = []
  
  let firstRowView_view1 = UIView(frame: CGRect(x: 0, y: 69, width: 427.3, height: 67))
    var firstRowButtons_view1 : [UIButton] = []
  
  let secondRowView_view1 = UIView(frame: CGRect(x: 0, y: 138, width: 427.3, height: 67))
    var secondRowButtons_view1 : [UIButton] = []
  
  let thirdRowView_view1 = UIView(frame: CGRect(x: 0, y: 207, width: 427.3, height: 67))
    var thirdRowButtons_view1 : [UIButton] = []
  
  let forthRowView_view1 = UIView(frame: CGRect(x: 0, y: 276, width: 427.3, height: 67))
    var forthRowButtons_view1 : [UIButton] = []
  
  let fifthRowView_view1 = UIView(frame: CGRect(x: 0, y: 345, width: 427.3, height: 67))
    var fifthRowButtons_view1 : [UIButton] = []
      var confirmButton_view1 : UIButton!
      var nextKeyboardButton_view1: UIButton!
  
  var tableView1_view1 : UITableView = UITableView()
  var tableView2_view1 : UITableView = UITableView()
  var tableView3_view1 : UITableView = UITableView()
  
  var curCell_view1 : UITableViewCell!
  
  
  /************************** View 2 Variables **************************/
  let topRowView_view2 = UIView(frame: CGRect(x: 0, y: 0, width: 1376, height: 67))
    var inputBox_view2 : UITextField!
  
  let numberRowView_view2 = UIView(frame: CGRect(x: 0, y: 69, width: 940, height: 54))
    var numberRowButtons_view2 : [UIButton] = []
  
  let firstRowView_view2 = UIView(frame: CGRect(x: 0, y: 125, width: 940, height: 67))
    var firstRowButtons_view2 : [UIButton] = []
  
  let secondRowView_view2 = UIView(frame: CGRect(x: 0, y: 194, width: 940, height: 67))
    var secondRowButtons_view2 : [UIButton] = []
  
  let thirdRowView_view2 = UIView(frame: CGRect(x: 0, y: 263, width: 940, height: 67))
    var thirdRowButtons_view2 : [UIButton] = []
  
  let forthRowView_view2 = UIView(frame: CGRect(x: 0, y: 332, width: 940, height: 40))
    var forthRowButtons_view2 : [UIButton] = []
  
  var capsLockOn_view2 : Bool = false
  var inputButtons_view2 : [UIButton] = []
  var backSpaceButton_view2: UIButton!
  var shiftButton_view2: UIButton!
  var nextKeyboardButton_view2: UIButton!
  var languageButtons_view2 : [String : UIButton] = [:]
  var insertButton_view2 : UIButton!
  
  var insideKeyboard_view2 : String = "english"
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
    
    // Add custom view sizing constraints here
  }
  
  func customLoadView() {
    for subview in self.view.subviews {
      subview.removeFromSuperview()
    }
    if view_number == 1 {
      // adding each component into main view
      self.view.addSubview(self.topRowView_view1)
      self.view.addSubview(self.firstRowView_view1)
      self.view.addSubview(self.secondRowView_view1)
      self.view.addSubview(self.thirdRowView_view1)
      self.view.addSubview(self.forthRowView_view1)
      self.view.addSubview(self.fifthRowView_view1)
      
      self.view.addSubview(self.tableView1_view1)
      self.view.addSubview(self.tableView2_view1)
      self.view.addSubview(self.tableView3_view1)
      
    } else if view_number == 2{
      // adding each component into main view
      self.view.addSubview(self.topRowView_view2)
      self.view.addSubview(self.numberRowView_view2)
      self.view.addSubview(self.firstRowView_view2)
      self.view.addSubview(self.secondRowView_view2)
      self.view.addSubview(self.thirdRowView_view2)
      self.view.addSubview(self.forthRowView_view2)
    }
    
    self.view.setNeedsDisplay()
  }
  
  func customPrepareForLoad() {
    /**************************** View 1 ****************************/
    // creating input box (textfield)
    self.inputBox_view1 = UITextField(frame: CGRect(x: 0, y: 0, width: 1376, height: 67))
    self.inputBox_view1.text = ""
    self.inputBox_view1.backgroundColor = UIColor.white
    
    // creating titles of input buttons
    var firstRowButtonTitles = ["Polynomial", "Rational"]
    var secondRowButtonTitles = ["N-th Root", "Log and Exp"]
    var thirdRowButtonTitles = ["Trigonometric", "Calculus"]
    var forthRowButtonTitles = ["Advanced", "Favorite"]
    
    // creating input buttons
    self.firstRowButtons_view1 = createButtons_view1(titles: firstRowButtonTitles)
    for button in self.firstRowButtons_view1 {
      self.inputButtons_view1.append(button)
    }
    self.secondRowButtons_view1 = createButtons_view1(titles: secondRowButtonTitles)
    for button in self.secondRowButtons_view1 {
      self.inputButtons_view1.append(button)
    }
    self.thirdRowButtons_view1 = createButtons_view1(titles: thirdRowButtonTitles)
    for button in self.thirdRowButtons_view1 {
      self.inputButtons_view1.append(button)
    }
    self.forthRowButtons_view1 = createButtons_view1(titles: forthRowButtonTitles)
    for button in self.forthRowButtons_view1 {
      self.inputButtons_view1.append(button)
    }
    self.fifthRowButtons_view1 = []
    
    // creating next keyboard button
    self.nextKeyboardButton_view1 = UIButton(type: .system)
    self.nextKeyboardButton_view1.setTitle("Next Keyboard", for: .normal)
    self.nextKeyboardButton_view1.titleLabel!.font = UIFont(name: "Helvetica-Bold", size: 15)
    self.nextKeyboardButton_view1.translatesAutoresizingMaskIntoConstraints = false
    self.nextKeyboardButton_view1.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
    self.nextKeyboardButton_view1.setTitleColor(UIColor.darkGray, for: .normal)
    self.nextKeyboardButton_view1.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
    self.fifthRowButtons_view1.append(self.nextKeyboardButton_view1)
    
    // creating confirm button
    self.confirmButton_view1 = UIButton(type: .system)
    self.confirmButton_view1?.setTitle("Confirm", for: .normal)
    self.confirmButton_view1?.titleLabel!.font = UIFont(name: "Helvetica-Bold", size: 18)
    self.confirmButton_view1?.translatesAutoresizingMaskIntoConstraints = false
    self.confirmButton_view1?.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
    self.confirmButton_view1?.setTitleColor(UIColor.darkGray, for: .normal)
    self.confirmButton_view1?.addTarget(self, action: #selector(self.nextPressed_view1), for: .touchUpInside)
    self.confirmButton_view1?.isEnabled = false
    self.confirmButton_view1?.alpha = 0.5
    self.fifthRowButtons_view1.append(self.confirmButton_view1!)
    
    // initializing table view component on the right of the main view
    self.tableView1_view1 = UITableView(frame: CGRect(x: 435, y: 69, width: 310.4, height: 356))
    self.tableView1_view1.delegate = self
    self.tableView1_view1.dataSource = self
    self.tableView1_view1.separatorStyle = .none
    self.tableView1_view1.register(UITableViewCell.self, forCellReuseIdentifier: "cell1")
    
    self.tableView2_view1 = UITableView(frame: CGRect(x: 745.4, y: 69, width: 310.4, height: 356))
    self.tableView2_view1.delegate = self
    self.tableView2_view1.dataSource = self
    self.tableView2_view1.separatorStyle = .none
    self.tableView2_view1.register(UITableViewCell.self, forCellReuseIdentifier: "cell2")
    
    self.tableView3_view1 = UITableView(frame: CGRect(x: 1055.8, y: 69, width: 310.4, height: 356))
    self.tableView3_view1.delegate = self
    self.tableView3_view1.dataSource = self
    self.tableView3_view1.separatorStyle = .none
    self.tableView3_view1.register(UITableViewCell.self, forCellReuseIdentifier: "cell3")
    
    updateResult()
    
    // adding each button into components on the left of the main view
    self.topRowView_view1.addSubview(self.inputBox_view1)
    
    for button in self.firstRowButtons_view1 {
      self.firstRowView_view1.addSubview(button)
    }
    
    for button in self.secondRowButtons_view1 {
      self.secondRowView_view1.addSubview(button)
    }
    
    for button in self.thirdRowButtons_view1 {
      self.thirdRowView_view1.addSubview(button)
    }
    
    for button in self.forthRowButtons_view1 {
      self.forthRowView_view1.addSubview(button)
    }
    
    for button in self.fifthRowButtons_view1 {
      self.fifthRowView_view1.addSubview(button)
    }
    
    // adding constraints
    addFirstRowConstraints_view1(buttons: self.firstRowButtons_view1, containingView: self.firstRowView_view1)
    addSecondRowConstraints_view1(buttons: self.secondRowButtons_view1, containingView: self.secondRowView_view1)
    addThirdRowConstraints_view1(buttons: self.thirdRowButtons_view1, containingView: self.thirdRowView_view1)
    addForthRowConstraints_view1(buttons: self.forthRowButtons_view1, containingView: self.forthRowView_view1)
    addFifthRowConstraints_view1(buttons: self.fifthRowButtons_view1, containingView: self.fifthRowView_view1)
    
//    self.inputBox_view1.translatesAutoresizingMaskIntoConstraints = false
//    addStandardConstraint(item: self.inputBox_view1, attribute: .top, toItem: self.topRowView_view1, containingView: self.topRowView_view1, mul: 1.0, offset: 1.0)
//    addStandardConstraint(item: self.inputBox_view1, attribute: .bottom, toItem: self.topRowView_view1, containingView: self.topRowView_view1, mul: 1.0, offset: -1.0)
//    addStandardConstraint(item: self.inputBox_view1, attribute: .left, toItem: self.topRowView_view1, containingView: self.topRowView_view1, mul: 1.0, offset: 1.0)
//    addStandardConstraint(item: self.inputBox_view1, attribute: .right, toItem: self.topRowView_view1, containingView: self.topRowView_view1, mul: 1.0, offset: -1.0)
//    
//    self.topRowView_view1.translatesAutoresizingMaskIntoConstraints = false
//    addStandardConstraint(item: self.topRowView_view1, attribute: .top, toItem: self.view, containingView: self.view, mul: 1.0, offset: 1.0)
//    addStandardConstraint(item: self.topRowView_view1, attribute: .bottom, toItem: self.firstRowView_view1, containingView: self.view, mul: 1.0, offset: -2.0)
//    addStandardConstraint(item: self.topRowView_view1, attribute: .left, toItem: self.view, containingView: self.view, mul: 1.0, offset: 1.0)
//    addStandardConstraint(item: self.topRowView_view1, attribute: .right, toItem: self.tableView1_view1, containingView: self.view, mul: 1.0, offset: -1.0)
//    addStandardConstraint(item: self.topRowView_view1, attribute: .height, toItem: self.view, containingView: self.view, mul: 1.0/26.0, offset: -2.0)
    
    
    /**************************** View 2 ****************************/
    // creating input box (textfield)
    self.inputBox_view2 = UITextField(frame: CGRect(x: 0, y: 0, width: 1376, height: 67))
    self.inputBox_view2.text = ""
    self.inputBox_view2.backgroundColor = UIColor.white
    
    // creating titles of input buttons
    firstRowButtonTitles = ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"]
    secondRowButtonTitles = ["a", "s", "d", "f", "g", "h", "j", "k", "l"]
    thirdRowButtonTitles = ["z", "x", "c", "v", "b", "n", "m"]
    let numberRowButtonTitles = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    
    // detecting and setting capital lock and related input buttons
    if self.capsLockOn_view2 == true {
      firstRowButtonTitles = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
      secondRowButtonTitles = ["A", "S", "D", "F", "G", "H", "J", "K", "L"]
      thirdRowButtonTitles = ["Z", "X", "C", "V", "B", "N", "M"]
    }
    
    // creating input buttons
    self.firstRowButtons_view2 = createButtons_view2(titles: firstRowButtonTitles)
    for button in self.firstRowButtons_view2 {
      self.inputButtons_view2.append(button)
    }
    self.secondRowButtons_view2 = createButtons_view2(titles: secondRowButtonTitles)
    for button in self.secondRowButtons_view2 {
      self.inputButtons_view2.append(button)
    }
    self.thirdRowButtons_view2 = createButtons_view2(titles: thirdRowButtonTitles)
    for button in self.thirdRowButtons_view2 {
      self.inputButtons_view2.append(button)
    }
    self.numberRowButtons_view2 = createButtons_view2(titles: numberRowButtonTitles)
    
    // creating BackSpace Button
    self.backSpaceButton_view2 = UIButton(type: .system) as UIButton
    self.backSpaceButton_view2.setTitle("Delete", for: .normal)
    self.backSpaceButton_view2.titleLabel!.font = UIFont(name: "Helvetica-Bold", size: 18)
    self.backSpaceButton_view2.translatesAutoresizingMaskIntoConstraints = false
    self.backSpaceButton_view2.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
    self.backSpaceButton_view2.setTitleColor(UIColor.darkGray, for: .normal)
    self.backSpaceButton_view2.addTarget(self, action: #selector(self.backSpaceKeyPressed_view2), for: .touchUpInside)
    self.thirdRowButtons_view2.append(self.backSpaceButton_view2)
    
    // creating Shift Button
    self.shiftButton_view2 = UIButton(type: .system) as UIButton
    if self.capsLockOn_view2 == false {
      self.shiftButton_view2.setTitle("lower", for: .normal)
      self.shiftButton_view2.backgroundColor = UIColor.white
    } else {
      self.shiftButton_view2.setTitle("UPPER", for: .normal)
      self.shiftButton_view2.backgroundColor = UIColor.yellow
    }
    self.shiftButton_view2.titleLabel!.font = UIFont(name: "Helvetica-Bold", size: 18)
    self.shiftButton_view2.translatesAutoresizingMaskIntoConstraints = false
    self.shiftButton_view2.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
    self.shiftButton_view2.setTitleColor(UIColor.darkGray, for: .normal)
    self.shiftButton_view2.addTarget(self, action: #selector(self.shiftKeyPressed_view2), for: .touchUpInside)
    self.thirdRowButtons_view2.insert(self.shiftButton_view2, at: 0)
    
    // creating next keyboard button
    self.nextKeyboardButton_view2 = UIButton(type: .system)
    self.nextKeyboardButton_view2.setTitle("Next Keyboard", for: .normal)
    self.nextKeyboardButton_view2.titleLabel!.font = UIFont(name: "Helvetica-Bold", size: 15)
    self.nextKeyboardButton_view2.translatesAutoresizingMaskIntoConstraints = false
    self.nextKeyboardButton_view2.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
    self.nextKeyboardButton_view2.setTitleColor(UIColor.darkGray, for: .normal)
    self.nextKeyboardButton_view2.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
    self.forthRowButtons_view2.append(self.nextKeyboardButton_view2)
    
    // initializing inside keyboard switch buttons
    let englishButton = UIButton(type: .system) as UIButton
    englishButton.setTitle("English", for: .normal)
    englishButton.titleLabel!.font = UIFont(name: "Helvetica-Bold", size: 18)
    englishButton.translatesAutoresizingMaskIntoConstraints = false
    englishButton.backgroundColor = UIColor.yellow
    englishButton.setTitleColor(UIColor.darkGray, for: .normal)
    englishButton.addTarget(self, action: #selector(self.englishKeyPressed_view2), for: .touchUpInside)
    self.languageButtons_view2["english"] = englishButton
    self.forthRowButtons_view2.append(englishButton)
    
    let greekButton = UIButton(type: .system) as UIButton
    greekButton.setTitle("Greek", for: .normal)
    greekButton.titleLabel!.font = UIFont(name: "Helvetica-Bold", size: 18)
    greekButton.translatesAutoresizingMaskIntoConstraints = false
    greekButton.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
    greekButton.setTitleColor(UIColor.darkGray, for: .normal)
    greekButton.addTarget(self, action: #selector(self.greekKeyPressed_view2), for: .touchUpInside)
    self.languageButtons_view2["greek"] = greekButton
    self.forthRowButtons_view2.append(greekButton)
    
    // creating Insert Button
    self.insertButton_view2 = UIButton(type: .system) as UIButton
    self.insertButton_view2.setTitle("Insert", for: .normal)
    self.insertButton_view2.titleLabel!.font = UIFont(name: "Helvetica-Bold", size: 18)
    self.insertButton_view2.translatesAutoresizingMaskIntoConstraints = false
    self.insertButton_view2.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
    self.insertButton_view2.setTitleColor(UIColor.darkGray, for: .normal)
    self.insertButton_view2.addTarget(self, action: #selector(self.insertPressed_view2), for: .touchUpInside)
    self.forthRowButtons_view2.append(self.insertButton_view2)
    
    // adding each button into components on the left of the main view
    self.topRowView_view2.addSubview(self.inputBox_view2)
    
    for button in self.numberRowButtons_view2 {
      self.numberRowView_view2.addSubview(button)
    }
    
    for button in self.firstRowButtons_view2 {
      self.firstRowView_view2.addSubview(button)
    }
    
    for button in self.secondRowButtons_view2 {
      self.secondRowView_view2.addSubview(button)
    }
    
    for button in self.thirdRowButtons_view2 {
      self.thirdRowView_view2.addSubview(button)
    }
    
    for button in self.forthRowButtons_view2 {
      self.forthRowView_view2.addSubview(button)
    }
    
    // adding constraints
    addFirstRowConstraints_view2(buttons: self.numberRowButtons_view2, containingView: self.numberRowView_view2)
    addFirstRowConstraints_view2(buttons: self.firstRowButtons_view2, containingView: self.firstRowView_view2)
    addSecondRowConstraints_view2(buttons: self.secondRowButtons_view2, containingView: self.secondRowView_view2)
    addThirdRowConstraints_view2(buttons: self.thirdRowButtons_view2, containingView: self.thirdRowView_view2)
    addForthRowConstraints_view2(buttons: self.forthRowButtons_view2, containingView: self.forthRowView_view2)
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    customPrepareForLoad()
    customLoadView()
    NotificationCenter.default.addObserver(self, selector: #selector(self.customLoadView), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    
    //    // Perform custom UI setup here
    //    self.nextKeyboardButton = UIButton(type: .system)
    //
    //    self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
    //    self.nextKeyboardButton.sizeToFit()
    //    self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
    //
    //    self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
    //
    //    self.view.addSubview(self.nextKeyboardButton)
    //
    //    self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
    //    self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated
  }
  
  override func textWillChange(_ textInput: UITextInput?) {
    // The app is about to change the document's contents. Perform any preparation here.
  }
  
  override func textDidChange(_ textInput: UITextInput?) {
    // The app has just changed the document's contents, the document context has been updated.
//    
//    var textColor: UIColor
//    let proxy = self.textDocumentProxy
//    if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
//      textColor = UIColor.white
//    } else {
//      textColor = UIColor.black
//    }
//    self.nextKeyboardButton.setTitleColor(textColor, for: [])
  }
  
  // override function of table view
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == self.tableView1_view1 {
      return min(self.searchResult.count, 6)
    }
    
    if tableView == self.tableView2_view1 {
      if self.searchResult.count < 7 {
        return 0
      } else {
        return min(self.searchResult.count-6, 6)
      }
    }
    
    if tableView == self.tableView3_view1 {
      if self.searchResult.count < 13 {
        return 0
      } else {
        return min(self.searchResult.count-12, 6)
      }
    }
    
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell : UITableViewCell = UITableViewCell()
    if tableView == self.tableView1_view1 {
      cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell1")
      cell.textLabel!.text = self.searchResult[indexPath.row]
    }
    
    if tableView == self.tableView2_view1 {
      cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell2")
      cell.textLabel!.text = self.searchResult[indexPath.row+6]
    }
    
    if tableView == self.tableView3_view1 {
      cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell3")
      cell.textLabel!.text = self.searchResult[indexPath.row+12]
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if self.curCell_view1 != nil {
      self.curCell_view1!.backgroundColor = UIColor.white
      self.curCell_view1 = nil
    }
    
    self.curCell_view1 = tableView.cellForRow(at: indexPath)
    self.curCell_view1?.selectionStyle = .none
    self.curCell_view1!.backgroundColor = UIColor.yellow
    self.confirmButton_view1.isEnabled = true
    self.confirmButton_view1.alpha = 1
  }
  
  // shared functions
  func updateResult() {
    var keyword : String = ""
    for button in self.inputButtons_view1 {
      if button.backgroundColor == UIColor.yellow {
        let title = button.titleLabel?.text!
        keyword += title! + " "
      }
    }
    
    self.searchResult = self.connector.perform_search(keyword: keyword.lowercased())
    self.tableView1_view1.reloadData()
    self.tableView2_view1.reloadData()
    self.tableView3_view1.reloadData()
    self.curCell_view1 = nil
    self.confirmButton_view1.isEnabled = false
    self.confirmButton_view1.alpha = 0.5
  }
  
  func getCursorPosition(textField: UITextField) -> Int{
    
    if let selectedRange = textField.selectedTextRange {
      
      let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
      
      return max(0, cursorPosition)
    }
    
    return textField.text!.characters.count
  }
  
  func setCursorPosition(textField: UITextField, ind: Int) {
    if let newPosition = textField.position(from: textField.beginningOfDocument, offset: ind) {
      
      textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
    }
  }
  
  func addAnimation(button: UIButton) {
    UIView.animate(withDuration: 0.2, animations: {
      button.transform = CGAffineTransform.identity.scaledBy(x: 2.0, y: 2.0)
    }, completion: {(_) -> Void in
      button.transform =
        CGAffineTransform.identity.scaledBy(x: 1, y: 1)
    })
  }
  
  func addStandardTopConstraint(index: Int, item: Any, containingView: UIView, val: Int){
    let topConstraint = NSLayoutConstraint(item: item, attribute: .top, relatedBy: .equal, toItem: containingView, attribute: .top, multiplier: 1.0, constant: CGFloat(val))
    containingView.addConstraint(topConstraint)
  }
  
  func addStandardBottomConstraint(index: Int, item: Any, containingView: UIView, val: Int){
    let bottomConstraint = NSLayoutConstraint(item: item, attribute: .bottom, relatedBy: .equal, toItem: containingView, attribute: .bottom, multiplier: 1.0, constant: CGFloat(val))
    containingView.addConstraint(bottomConstraint)
  }
  
  func addStandardConstraint(item: Any, attribute: NSLayoutAttribute, toItem: Any, containingView: UIView, mul: CGFloat, offset: CGFloat){
    let constraint = NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .equal, toItem: containingView, attribute: attribute, multiplier: mul, constant: offset)
    containingView.addConstraint(constraint)
  }
  
  func addButtonLeftConstraint(index: Int, buttons: [UIButton], containingView: UIView, val: Int){
    var leftConstraint : NSLayoutConstraint!
    let button = buttons[index]
    
    if index == 0 {
      
      leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: containingView, attribute: .left, multiplier: 1.0, constant: CGFloat(val))
      
    }else{
      leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: buttons[index-1], attribute: .right, multiplier: 1.0, constant: CGFloat(val))
      
      let widthConstraint = NSLayoutConstraint(item: buttons[0], attribute: .width, relatedBy: .equal, toItem: button, attribute: .width, multiplier: 1.0, constant: 0)
      
      containingView.addConstraint(widthConstraint)
    }
    
    containingView.addConstraint(leftConstraint)
  }
  
  func addButtonRightConstraint(index: Int, buttons: [UIButton], containingView: UIView, val: Int){
    var rightConstraint : NSLayoutConstraint!
    let button = buttons[index]
    
    if index == buttons.count - 1 {
      
      rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: containingView, attribute: .right, multiplier: 1.0, constant: CGFloat(val))
      
    }else{
      
      rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: buttons[index+1], attribute: .left, multiplier: 1.0, constant: CGFloat(val))
    }
    
    containingView.addConstraint(rightConstraint)
  }
  
  // Custom Functions for View 1
  func createButtons_view1(titles: [String]) -> [UIButton] {
    
    var buttons = [UIButton]()
    
    for title in titles {
      let button = UIButton(type: .system) as UIButton
      button.setTitle(title, for: .normal)
      button.titleLabel!.font = UIFont(name: "Helvetica-Bold", size: 18)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
      button.setTitleColor(UIColor.darkGray, for: .normal)
      button.addTarget(self, action: #selector(self.keyPressed_view1), for: .touchUpInside)
      buttons.append(button)
    }
    
    return buttons
  }
  
  func nextPressed_view1(sender: UIButton?) {
    self.view_number = 2
    self.inputBox_view2.text = self.curCell_view1.textLabel!.text
    customLoadView()
  }
  
  func keyPressed_view1(sender: AnyObject?) {
    let button = sender as! UIButton
    if button.backgroundColor == UIColor.white {
      button.backgroundColor = UIColor.yellow
    } else {
      button.backgroundColor = UIColor.white
    }
    updateResult()
    
    addAnimation(button: button)
  }
  
  func addFirstRowConstraints_view1(buttons: [UIButton], containingView: UIView){
    
    for (index, button) in buttons.enumerated() {
      self.addStandardTopConstraint(index: index, item: button, containingView: containingView, val: 1)
      
      self.addStandardBottomConstraint(index: index, item: button, containingView: containingView, val: -1)
      
      self.addButtonLeftConstraint(index: index, buttons: buttons, containingView: containingView, val: 3)
      
      self.addButtonRightConstraint(index:index, buttons: buttons, containingView: containingView, val: -3)
    }
  }
  
  func addSecondRowConstraints_view1(buttons: [UIButton], containingView: UIView){
    
    for (index, button) in buttons.enumerated() {
      self.addStandardTopConstraint(index: index, item: button, containingView: containingView, val: 1)
      
      self.addStandardBottomConstraint(index: index, item: button, containingView: containingView, val: -1)
      
      self.addButtonLeftConstraint(index: index, buttons: buttons, containingView: containingView, val: 3)
      
      self.addButtonRightConstraint(index:index, buttons: buttons, containingView: containingView, val: -3)
    }
  }
  
  func addThirdRowConstraints_view1(buttons: [UIButton], containingView: UIView){
    
    for (index, button) in buttons.enumerated() {
      self.addStandardTopConstraint(index: index, item: button, containingView: containingView, val: 1)
      
      self.addStandardBottomConstraint(index: index, item: button, containingView: containingView, val: -1)
      
      self.addButtonLeftConstraint(index: index, buttons: buttons, containingView: containingView, val: 3)
      
      self.addButtonRightConstraint(index:index, buttons: buttons, containingView: containingView, val: -3)
    }
  }
  
  func addForthRowConstraints_view1(buttons: [UIButton], containingView: UIView){
    
    for (index, button) in buttons.enumerated() {
      self.addStandardTopConstraint(index: index, item: button, containingView: containingView, val: 1)
      
      self.addStandardBottomConstraint(index: index, item: button, containingView: containingView, val: -1)
      
      self.addButtonLeftConstraint(index: index, buttons: buttons, containingView: containingView, val: 3)
      
      self.addButtonRightConstraint(index:index, buttons: buttons, containingView: containingView, val: -3)
    }
  }
  
  func addFifthRowConstraints_view1(buttons: [UIButton], containingView: UIView){
    
    for (index, button) in buttons.enumerated() {
      self.addStandardTopConstraint(index: index, item: button, containingView: containingView, val: 1)
      
      self.addStandardBottomConstraint(index: index, item: button, containingView: containingView, val: -1)
      
      self.addButtonLeftConstraint(index: index, buttons: buttons, containingView: containingView, val: 23)
      
      self.addButtonRightConstraint(index:index, buttons: buttons, containingView: containingView, val: -23)
    }
  }
  
  // custom functions for View 2
  func createButtons_view2(titles: [String]) -> [UIButton] {
    
    var buttons = [UIButton]()
    
    for title in titles {
      let button = UIButton(type: .system) as UIButton
      button.setTitle(title, for: .normal)
      button.titleLabel!.font = UIFont(name: "Helvetica-Bold", size: 18)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
      button.setTitleColor(UIColor.darkGray, for: .normal)
      button.addTarget(self, action: #selector(self.keyPressed_view2), for: .touchUpInside)
      buttons.append(button)
    }
    
    return buttons
  }
  
  func keyPressed_view2(sender: AnyObject?) {
    let button = sender as! UIButton
    let title = button.title(for: .normal)
    let pos: Int = getCursorPosition(textField: self.inputBox_view2)
    self.inputBox_view2.text = self.inputBox_view2.text?.insert(string: title!, ind: pos)
    setCursorPosition(textField: self.inputBox_view2, ind: pos + title!.characters.count)
    updateResult()
    //self.inputBox?.text?.append(String(pos))
    //(textDocumentProxy as UIKeyInput).insertText(title!)
    
    addAnimation(button: button)
  }
  
  func insertPressed_view2(sender: UIButton?) {
    (self.textDocumentProxy as UIKeyInput).insertText(self.inputBox_view2.text!)
    self.view_number = 1
    self.inputBox_view2.text = ""
    customLoadView()
  }
  
  func backSpaceKeyPressed_view2(sender: UIButton?) {
    let button = sender!
    let pos = getCursorPosition(textField: self.inputBox_view2)
    if pos > 0 {
      self.inputBox_view2.text = self.inputBox_view2.text!.remove(ind: pos)
      setCursorPosition(textField: self.inputBox_view2, ind: pos-1)
      updateResult()
    }
    //    if (self.inputBox?.text?.characters.count)! > 0 {
    //      self.inputBox?.text?.characters.removeLast()
    //    }
    addAnimation(button: button)
  }
  
  func shiftKeyPressed_view2(sender: UIButton?) {
    let button = sender!
    self.capsLockOn_view2 = !self.capsLockOn_view2
    if self.capsLockOn_view2 == false {
      button.setTitle("lower", for: .normal)
      button.backgroundColor = UIColor.white
      for temp_button in self.inputButtons_view2 {
        let buttonTitle = temp_button.titleLabel!.text
        let text = buttonTitle!.lowercased()
        temp_button.setTitle("\(text)", for: .normal)
      }
    } else {
      button.setTitle("UPPER", for: .normal)
      button.backgroundColor = UIColor.yellow
      for temp_button in self.inputButtons_view2 {
        let buttonTitle = temp_button.titleLabel!.text
        let text = buttonTitle!.uppercased()
        temp_button.setTitle("\(text)", for: .normal)
      }
    }
    
    addAnimation(button: button)
  }
  
  func englishKeyPressed_view2(sender: UIButton?) {
    let button = sender!
    
    if self.insideKeyboard_view2 == "english" {
      return
    }
    
    let buttonTitles = ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "a", "s", "d", "f", "g", "h", "j", "k", "l", "z", "x", "c", "v", "b", "n", "m"]
    
    for i in 0 ..< buttonTitles.count {
      self.inputButtons_view2[i].setTitle(buttonTitles[i], for: .normal)
    }
    self.capsLockOn_view2 = false
    self.shiftButton_view2.setTitle("lower", for: .normal)
    self.shiftButton_view2.backgroundColor = UIColor.white
    self.insideKeyboard_view2 = "english"
    for (_, temp_button) in self.languageButtons_view2 {
      temp_button.backgroundColor = UIColor.white
    }
    self.languageButtons_view2["english"]?.backgroundColor = UIColor.yellow
    
    addAnimation(button: button)
  }
  
  func greekKeyPressed_view2(sender: UIButton?) {
    let button = sender!
    
    if self.insideKeyboard_view2 == "greek" {
      return
    }
    
    let buttonTitles = ["θ", "ω", "ε", "ρ", "τ", "ψ", "υ", "ι", "ο", "π", "α", "σ", "δ", "φ", "γ", "η", "ϑ", "κ", "λ", "ζ", "ξ", "χ", "v", "β", "ν", "μ"]
    
    for i in 0 ..< buttonTitles.count {
      self.inputButtons_view2[i].setTitle(buttonTitles[i], for: .normal)
    }
    self.capsLockOn_view2 = false
    self.shiftButton_view2.setTitle("lower", for: .normal)
    self.shiftButton_view2.backgroundColor = UIColor.white
    self.insideKeyboard_view2 = "greek"
    for (_, temp_button) in self.languageButtons_view2 {
      temp_button.backgroundColor = UIColor.white
    }
    self.languageButtons_view2["greek"]?.backgroundColor = UIColor.yellow
    
    addAnimation(button: button)
  }
  
  func addFirstRowConstraints_view2(buttons: [UIButton], containingView: UIView){
    
    for (index, button) in buttons.enumerated() {
      self.addStandardTopConstraint(index: index, item: button, containingView: containingView, val: 1)
      
      self.addStandardBottomConstraint(index: index, item: button, containingView: containingView, val: -1)
      
      self.addButtonLeftConstraint(index: index, buttons: buttons, containingView: containingView, val: 3)
      
      self.addButtonRightConstraint(index:index, buttons: buttons, containingView: containingView, val: -3)
    }
  }
  
  func addSecondRowConstraints_view2(buttons: [UIButton], containingView: UIView){
    
    for (index, button) in buttons.enumerated() {
      self.addStandardTopConstraint(index: index, item: button, containingView: containingView, val: 1)
      
      self.addStandardBottomConstraint(index: index, item: button, containingView: containingView, val: -1)
      
      self.addButtonLeftConstraint(index: index, buttons: buttons, containingView: containingView, val: 3)
      
      self.addButtonRightConstraint(index:index, buttons: buttons, containingView: containingView, val: -3)
    }
  }
  
  func addThirdRowConstraints_view2(buttons: [UIButton], containingView: UIView){
    
    for (index, button) in buttons.enumerated() {
      self.addStandardTopConstraint(index: index, item: button, containingView: containingView, val: 1)
      
      self.addStandardBottomConstraint(index: index, item: button, containingView: containingView, val: -1)
      
      if index == 0 {
        self.addButtonLeftConstraint(index: index, buttons: buttons, containingView: containingView, val: 3)
        
        self.addButtonRightConstraint(index:index, buttons: buttons, containingView: containingView, val: -23)
      }
      else if index == buttons.count - 2 {
        self.addButtonLeftConstraint(index: index, buttons: buttons, containingView: containingView, val: 3)
        
        self.addButtonRightConstraint(index: index, buttons: buttons, containingView: containingView, val: -23)
      }
      else {
        self.addButtonLeftConstraint(index: index, buttons: buttons, containingView: containingView, val: 3)
        
        self.addButtonRightConstraint(index: index, buttons: buttons, containingView: containingView, val: -3)
      }
    }
  }
  
  func addForthRowConstraints_view2(buttons: [UIButton], containingView: UIView){
    
    for (index, button) in buttons.enumerated() {
      self.addStandardTopConstraint(index: index, item: button, containingView: containingView, val: 1)
      
      self.addStandardBottomConstraint(index: index, item: button, containingView: containingView, val: -1)
      
      self.addButtonLeftConstraint(index: index, buttons: buttons, containingView: containingView, val: 30)
      
      self.addButtonRightConstraint(index:index, buttons: buttons, containingView: containingView, val: -30)
    }
  }
}
