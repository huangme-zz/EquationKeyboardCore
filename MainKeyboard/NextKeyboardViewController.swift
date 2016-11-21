//
//  NextKeyboardViewController.swift
//  MainKeyboard
//
//  Created by Meng Huang on 11/13/16.
//  Copyright © 2016 Meng Huang. All rights reserved.
//

import UIKit

extension String {
  func insert(string: String, ind: Int) -> String {
    return  String(self.characters.prefix(ind)) + string + String(self.characters.suffix(self.characters.count-ind))
  }
  
  func remove(ind: Int) -> String {
    return String(self.characters.prefix(ind-1)) + String(self.characters.suffix(self.characters.count-ind))
  }
}

class NextKeyboardViewController: UIInputViewController, UITableViewDelegate, UITableViewDataSource{
  
  @IBOutlet var nextKeyboardButton: UIButton!
  
  var template : String = ""
  
  var inputBox : UITextField?
  
  var capsLockOn : Bool = false
  var inputButtons : [UIButton] = []
  var backSpaceButton: UIButton?
  var shiftButton: UIButton?
  var languageButtons : [String : UIButton] = [:]
  var insertButton : UIButton?
  
  var insideKeyboard : String = "english"
  
  var tableView : UITableView = UITableView()
  
  var connector : DatabaseConnector = DatabaseConnector()
  var search_result : [String] = []
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
    
    // Add custom view sizing constraints here
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // creating input box (textfield)
    self.inputBox = UITextField(frame: CGRect(x: 0, y: 0, width: 1024, height: 50))
    self.inputBox?.text = template
    self.inputBox?.backgroundColor = UIColor.white
    
    // creating titles of input buttons
    var firstRowButtonTitles = ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"]
    var secondRowButtonTitles = ["a", "s", "d", "f", "g", "h", "j", "k", "l"]
    var thirdRowButtonTitles = ["z", "x", "c", "v", "b", "n", "m"]
    let numberRowButtonTitles = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    
    // detecting and setting capital lock and related input buttons
    if capsLockOn == true {
      firstRowButtonTitles = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
      secondRowButtonTitles = ["A", "S", "D", "F", "G", "H", "J", "K", "L"]
      thirdRowButtonTitles = ["Z", "X", "C", "V", "B", "N", "M"]
    }
    
    // creating input buttons
    let firstRowButtons = createButtons(titles: firstRowButtonTitles)
    for button in firstRowButtons {
      self.inputButtons.append(button)
    }
    let secondRowButtons = createButtons(titles: secondRowButtonTitles)
    for button in secondRowButtons {
      self.inputButtons.append(button)
    }
    var thirdRowButtons = createButtons(titles: thirdRowButtonTitles)
    for button in thirdRowButtons {
      self.inputButtons.append(button)
    }
    let numberRowButtons = createButtons(titles: numberRowButtonTitles)
    var forthRowButtons: [UIButton] = []
    
    // creating BackSpace Button
    self.backSpaceButton = UIButton(type: .system) as UIButton
    self.backSpaceButton?.setTitle("Delete", for: .normal)
    self.backSpaceButton?.titleLabel!.font = UIFont(name: "Helvetica-Bold", size: 18)
    self.backSpaceButton?.translatesAutoresizingMaskIntoConstraints = false
    self.backSpaceButton?.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
    self.backSpaceButton?.setTitleColor(UIColor.darkGray, for: .normal)
    self.backSpaceButton?.addTarget(self, action: #selector(self.backSpaceKeyPressed), for: .touchUpInside)
    thirdRowButtons.append(self.backSpaceButton!)
    
    // creating Shift Button
    self.shiftButton = UIButton(type: .system) as UIButton
    if self.capsLockOn == false {
      self.shiftButton?.setTitle("lower", for: .normal)
      self.shiftButton?.backgroundColor = UIColor.white
    } else {
      self.shiftButton?.setTitle("UPPER", for: .normal)
      self.shiftButton?.backgroundColor = UIColor.yellow
    }
    self.shiftButton?.titleLabel!.font = UIFont(name: "Helvetica-Bold", size: 18)
    self.shiftButton?.translatesAutoresizingMaskIntoConstraints = false
    self.shiftButton?.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
    self.shiftButton?.setTitleColor(UIColor.darkGray, for: .normal)
    self.shiftButton?.addTarget(self, action: #selector(self.shiftKeyPressed), for: .touchUpInside)
    thirdRowButtons.insert(self.shiftButton!, at: 0)
    
    // creating Next Keyboard Button
//    self.nextKeyboardButton = UIButton(type: .system) as UIButton
//    self.nextKeyboardButton.setTitle("Next Keyboard", for: .normal)
//    self.nextKeyboardButton.titleLabel!.font = UIFont(name: "Helvetica-Bold", size: 18)
//    self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
//    self.nextKeyboardButton.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
//    self.nextKeyboardButton.setTitleColor(UIColor.darkGray, for: .normal)
//    self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
    forthRowButtons.append(self.nextKeyboardButton)
    
    // initializing inside keyboard switch buttons
    let englishButton = UIButton(type: .system) as UIButton
    englishButton.setTitle("English", for: .normal)
    englishButton.titleLabel!.font = UIFont(name: "Helvetica-Bold", size: 18)
    englishButton.translatesAutoresizingMaskIntoConstraints = false
    englishButton.backgroundColor = UIColor.yellow
    englishButton.setTitleColor(UIColor.darkGray, for: .normal)
    englishButton.addTarget(self, action: #selector(self.englishKeyPressed), for: .touchUpInside)
    self.languageButtons["english"] = englishButton
    forthRowButtons.append(englishButton)
    
    let greekButton = UIButton(type: .system) as UIButton
    greekButton.setTitle("Greek", for: .normal)
    greekButton.titleLabel!.font = UIFont(name: "Helvetica-Bold", size: 18)
    greekButton.translatesAutoresizingMaskIntoConstraints = false
    greekButton.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
    greekButton.setTitleColor(UIColor.darkGray, for: .normal)
    greekButton.addTarget(self, action: #selector(self.greekKeyPressed), for: .touchUpInside)
    self.languageButtons["greek"] = greekButton
    forthRowButtons.append(greekButton)
    
    // creating Insert Button
    self.insertButton = UIButton(type: .system) as UIButton
    self.insertButton?.setTitle("Insert", for: .normal)
    self.insertButton?.titleLabel!.font = UIFont(name: "Helvetica-Bold", size: 18)
    self.insertButton?.translatesAutoresizingMaskIntoConstraints = false
    self.insertButton?.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
    self.insertButton?.setTitleColor(UIColor.darkGray, for: .normal)
    self.insertButton?.addTarget(self, action: #selector(self.insertPressed), for: .touchUpInside)
    forthRowButtons.append(self.insertButton!)
    
    // initializing table view component on the right of the main view
    self.tableView = UITableView(frame: CGRect(x: 704, y: 52, width: 316, height: 300))
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
    // creating components
    let topRow = UIView(frame: CGRect(x: 0, y: 0, width: 700, height: 50))
    let numberRow = UIView(frame: CGRect(x: 0, y: 52, width: 700, height: 40))
    let firstRow = UIView(frame: CGRect(x: 0, y: 100, width: 700, height: 50))
    let secondRow = UIView(frame: CGRect(x: 0, y: 152, width: 700, height: 50))
    let thirdRow = UIView(frame: CGRect(x: 0, y: 204, width: 700, height: 50))
    let forthRow = UIView(frame: CGRect(x: 0, y: 256, width: 700, height: 30))
    
    // adding each button into components on the left of the main view
    topRow.addSubview(self.inputBox!)
    
    for button in numberRowButtons {
      numberRow.addSubview(button)
    }
    
    for button in firstRowButtons {
      firstRow.addSubview(button)
    }
    
    for button in secondRowButtons {
      secondRow.addSubview(button)
    }
    
    for button in thirdRowButtons {
      thirdRow.addSubview(button)
    }
    
    for button in forthRowButtons {
      forthRow.addSubview(button)
    }
    
    // adding each component into main view
    self.view.addSubview(topRow)
    self.view.addSubview(numberRow)
    self.view.addSubview(firstRow)
    self.view.addSubview(secondRow)
    self.view.addSubview(thirdRow)
    self.view.addSubview(forthRow)
    
    self.view.addSubview(self.tableView)
    
    // adding constraints
    addFirstRowConstraints(buttons: numberRowButtons, containingView: numberRow)
    addFirstRowConstraints(buttons: firstRowButtons, containingView: firstRow)
    addSecondRowConstraints(buttons: secondRowButtons, containingView: secondRow)
    addThirdRowConstraints(buttons: thirdRowButtons, containingView: thirdRow)
    addForthRowConstraints(buttons: forthRowButtons, containingView: forthRow)
    
    
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
    
    var textColor: UIColor
    let proxy = self.textDocumentProxy
    if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
      textColor = UIColor.white
    } else {
      textColor = UIColor.black
    }
    self.nextKeyboardButton.setTitleColor(textColor, for: [])
  }
  
  // override function of table view
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.search_result.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
    cell.textLabel!.text = self.search_result[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    return
  }
  
  // Custom Functions
  func getResult() {
    self.search_result = self.connector.perform_search(keyword: (self.inputBox?.text)!)
    self.inputBox!.backgroundColor = UIColor.blue
    self.tableView.reloadData()
  }
  
  func addAnimation(button: UIButton) {
    UIView.animate(withDuration: 0.2, animations: {
      button.transform = CGAffineTransform.identity.scaledBy(x: 2.0, y: 2.0)
    }, completion: {(_) -> Void in
      button.transform =
        CGAffineTransform.identity.scaledBy(x: 1, y: 1)
    })
  }
  
  func getCursorPosition() -> Int{
    
    if let selectedRange = self.inputBox?.selectedTextRange {
      
      let cursorPosition = self.inputBox?.offset(from: (self.inputBox?.beginningOfDocument)!, to: selectedRange.start)
      
      return max(0, cursorPosition!)
    }
    
    return (self.inputBox?.text!.characters.count)!
  }
  
  func setCursorPosition(ind: Int) {
    if let newPosition = self.inputBox?.position(from: (self.inputBox?.beginningOfDocument)!, offset: ind) {
      
      self.inputBox?.selectedTextRange = self.inputBox?.textRange(from: newPosition, to: newPosition)
    }
  }
  
  func createButtons(titles: [String]) -> [UIButton] {
    
    var buttons = [UIButton]()
    
    for title in titles {
      let button = UIButton(type: .system) as UIButton
      button.setTitle(title, for: .normal)
      button.titleLabel!.font = UIFont(name: "Helvetica-Bold", size: 18)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
      button.setTitleColor(UIColor.darkGray, for: .normal)
      button.addTarget(self, action: #selector(self.keyPressed), for: .touchUpInside)
      buttons.append(button)
    }
    
    return buttons
  }
  
  func keyPressed(sender: AnyObject?) {
    let button = sender as! UIButton
    let title = button.title(for: .normal)
    let pos: Int = getCursorPosition()
    self.inputBox?.text = self.inputBox?.text?.insert(string: title!, ind: pos)
    setCursorPosition(ind: pos + title!.characters.count)
    getResult()
    //self.inputBox?.text?.append(String(pos))
    //(textDocumentProxy as UIKeyInput).insertText(title!)
    
    addAnimation(button: button)
  }
  
  func insertPressed(sender: UIButton?) {
    (self.textDocumentProxy as UIKeyInput).insertText(self.inputBox!.text!)
    performSegue(withIdentifier: "second_to_first", sender: self)
  }
  
  func backSpaceKeyPressed(sender: UIButton?) {
    let button = sender!
    let pos = getCursorPosition()
    if pos > 0 {
      self.inputBox?.text = self.inputBox?.text?.remove(ind: pos)
      setCursorPosition(ind: pos-1)
      getResult()
    }
    //    if (self.inputBox?.text?.characters.count)! > 0 {
    //      self.inputBox?.text?.characters.removeLast()
    //    }
    addAnimation(button: button)
  }
  
  func shiftKeyPressed(sender: UIButton?) {
    let button = sender!
    self.capsLockOn = !self.capsLockOn
    if self.capsLockOn == false {
      button.setTitle("lower", for: .normal)
      button.backgroundColor = UIColor.white
      for temp_button in self.inputButtons {
        let buttonTitle = temp_button.titleLabel!.text
        let text = buttonTitle!.lowercased()
        temp_button.setTitle("\(text)", for: .normal)
      }
    } else {
      button.setTitle("UPPER", for: .normal)
      button.backgroundColor = UIColor.yellow
      for temp_button in self.inputButtons {
        let buttonTitle = temp_button.titleLabel!.text
        let text = buttonTitle!.uppercased()
        temp_button.setTitle("\(text)", for: .normal)
      }
    }
    
    addAnimation(button: button)
  }
  
  func englishKeyPressed(sender: UIButton?) {
    let button = sender!
    
    if self.insideKeyboard == "english" {
      return
    }
    
    let buttonTitles = ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "a", "s", "d", "f", "g", "h", "j", "k", "l", "z", "x", "c", "v", "b", "n", "m"]
    
    for i in 0 ..< buttonTitles.count {
      self.inputButtons[i].setTitle(buttonTitles[i], for: .normal)
    }
    self.capsLockOn = false
    self.shiftButton?.setTitle("lower", for: .normal)
    self.shiftButton?.backgroundColor = UIColor.white
    self.insideKeyboard = "english"
    for (_, temp_button) in self.languageButtons {
      temp_button.backgroundColor = UIColor.white
    }
    self.languageButtons["english"]?.backgroundColor = UIColor.yellow
    
    addAnimation(button: button)
  }
  
  func greekKeyPressed(sender: UIButton?) {
    let button = sender!
    
    if self.insideKeyboard == "greek" {
      return
    }
    
    let buttonTitles = ["θ", "ω", "ε", "ρ", "τ", "ψ", "υ", "ι", "ο", "π", "α", "σ", "δ", "φ", "γ", "η", "ϑ", "κ", "λ", "ζ", "ξ", "χ", "v", "β", "ν", "μ"]
    
    for i in 0 ..< buttonTitles.count {
      self.inputButtons[i].setTitle(buttonTitles[i], for: .normal)
    }
    self.capsLockOn = false
    self.shiftButton?.setTitle("lower", for: .normal)
    self.shiftButton?.backgroundColor = UIColor.white
    self.insideKeyboard = "greek"
    for (_, temp_button) in self.languageButtons {
      temp_button.backgroundColor = UIColor.white
    }
    self.languageButtons["greek"]?.backgroundColor = UIColor.yellow
    
    addAnimation(button: button)
  }
  
  func addStandardTopConstraint(index: Int, button: UIButton, containingView: UIView, val: Int){
    let topConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: containingView, attribute: .top, multiplier: 1.0, constant: CGFloat(val))
    containingView.addConstraint(topConstraint)
  }
  
  func addStandardBottomConstraint(index: Int, button: UIButton, containingView: UIView, val: Int){
    let bottomConstraint = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: containingView, attribute: .bottom, multiplier: 1.0, constant: CGFloat(val))
    containingView.addConstraint(bottomConstraint)
  }
  
  func addStandardLeftConstraint(index: Int, buttons: [UIButton], containingView: UIView, val: Int){
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
  
  func addStandardRightConstraint(index: Int, buttons: [UIButton], containingView: UIView, val: Int){
    var rightConstraint : NSLayoutConstraint!
    let button = buttons[index]
    
    if index == buttons.count - 1 {
      
      rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: containingView, attribute: .right, multiplier: 1.0, constant: CGFloat(val))
      
    }else{
      
      rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: buttons[index+1], attribute: .left, multiplier: 1.0, constant: CGFloat(val))
    }
    
    containingView.addConstraint(rightConstraint)
  }
  
  func addFirstRowConstraints(buttons: [UIButton], containingView: UIView){
    
    for (index, button) in buttons.enumerated() {
      self.addStandardTopConstraint(index: index, button: button, containingView: containingView, val: 1)
      
      self.addStandardBottomConstraint(index: index, button: button, containingView: containingView, val: -1)
      
      self.addStandardLeftConstraint(index: index, buttons: buttons, containingView: containingView, val: 3)
      
      self.addStandardRightConstraint(index:index, buttons: buttons, containingView: containingView, val: -3)
    }
  }
  
  func addSecondRowConstraints(buttons: [UIButton], containingView: UIView){
    
    for (index, button) in buttons.enumerated() {
      self.addStandardTopConstraint(index: index, button: button, containingView: containingView, val: 1)
      
      self.addStandardBottomConstraint(index: index, button: button, containingView: containingView, val: -1)
      
      self.addStandardLeftConstraint(index: index, buttons: buttons, containingView: containingView, val: 3)
      
      self.addStandardRightConstraint(index:index, buttons: buttons, containingView: containingView, val: -3)
    }
  }
  
  func addThirdRowConstraints(buttons: [UIButton], containingView: UIView){
    
    for (index, button) in buttons.enumerated() {
      self.addStandardTopConstraint(index: index, button: button, containingView: containingView, val: 1)
      
      self.addStandardBottomConstraint(index: index, button: button, containingView: containingView, val: -1)
      
      if index == 0 {
        self.addStandardLeftConstraint(index: index, buttons: buttons, containingView: containingView, val: 3)
        
        self.addStandardRightConstraint(index:index, buttons: buttons, containingView: containingView, val: -23)
      }
      else if index == buttons.count - 2 {
        self.addStandardLeftConstraint(index: index, buttons: buttons, containingView: containingView, val: 3)
        
        self.addStandardRightConstraint(index: index, buttons: buttons, containingView: containingView, val: -23)
      }
      else {
        self.addStandardLeftConstraint(index: index, buttons: buttons, containingView: containingView, val: 3)
        
        self.addStandardRightConstraint(index: index, buttons: buttons, containingView: containingView, val: -3)
      }
    }
  }
  
  func addForthRowConstraints(buttons: [UIButton], containingView: UIView){
    
    for (index, button) in buttons.enumerated() {
      self.addStandardTopConstraint(index: index, button: button, containingView: containingView, val: 1)
      
      self.addStandardBottomConstraint(index: index, button: button, containingView: containingView, val: -1)
      
      self.addStandardLeftConstraint(index: index, buttons: buttons, containingView: containingView, val: 30)
      
      self.addStandardRightConstraint(index:index, buttons: buttons, containingView: containingView, val: -30)
    }
  }
  
}
