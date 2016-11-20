//
//  KeyboardViewController.swift
//  MainKeyboard
//
//  Created by Meng Huang on 11/13/16.
//  Copyright © 2016 Meng Huang. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController, UITableViewDelegate, UITableViewDataSource{
  
  @IBOutlet var nextKeyboardButton: UIButton!
  
  var inputBox : UITextField?
  
  var inputButtons : [UIButton] = []
  
  var tableView1 : UITableView = UITableView()
  var tableView2 : UITableView = UITableView()
  var tableView3 : UITableView = UITableView()
  
  var cur_cell : UITableViewCell? = nil
  
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
    self.inputBox?.text = ""
    self.inputBox?.backgroundColor = UIColor.white
    
    // creating titles of input buttons
    let firstRowButtonTitles = ["Polynomial", "Rational"]
    let secondRowButtonTitles = ["N-th Root", "Log and Exp"]
    let thirdRowButtonTitles = ["Trigonometric", "Calculus"]
    let forthRowButtonTitles = ["Advanced", "Favorite"]
    
    // creating input buttons
    let firstRowButtons = createButtons(titles: firstRowButtonTitles)
    for button in firstRowButtons {
      self.inputButtons.append(button)
    }
    let secondRowButtons = createButtons(titles: secondRowButtonTitles)
    for button in secondRowButtons {
      self.inputButtons.append(button)
    }
    let thirdRowButtons = createButtons(titles: thirdRowButtonTitles)
    for button in thirdRowButtons {
      self.inputButtons.append(button)
    }
    let forthRowButtons = createButtons(titles: forthRowButtonTitles)
    for button in forthRowButtons {
      self.inputButtons.append(button)
    }
    
    // initializing table view component on the right of the main view
    self.tableView1 = UITableView(frame: CGRect(x: 325, y: 52, width: 231, height: 265))
    self.tableView1.delegate = self
    self.tableView1.dataSource = self
    self.tableView1.separatorStyle = .none
    self.tableView1.register(UITableViewCell.self, forCellReuseIdentifier: "cell1")
    
    self.tableView2 = UITableView(frame: CGRect(x: 556, y: 52, width: 231, height: 265))
    self.tableView2.delegate = self
    self.tableView2.dataSource = self
    self.tableView2.separatorStyle = .none
    self.tableView2.register(UITableViewCell.self, forCellReuseIdentifier: "cell2")
    
    self.tableView3 = UITableView(frame: CGRect(x: 787, y: 52, width: 231, height: 265))
    self.tableView3.delegate = self
    self.tableView3.dataSource = self
    self.tableView3.separatorStyle = .none
    self.tableView3.register(UITableViewCell.self, forCellReuseIdentifier: "cell3")
    
    getResult()
    
    // creating components
    let topRow = UIView(frame: CGRect(x: 0, y: 0, width: 700, height: 50))
    let firstRow = UIView(frame: CGRect(x: 0, y: 52, width: 320, height: 60))
    let secondRow = UIView(frame: CGRect(x: 0, y: 114, width: 320, height: 60))
    let thirdRow = UIView(frame: CGRect(x: 0, y: 176, width: 320, height: 60))
    let forthRow = UIView(frame: CGRect(x: 0, y: 238, width: 320, height: 60))
    
    // adding each button into components on the left of the main view
    topRow.addSubview(self.inputBox!)
    
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
    self.view.addSubview(firstRow)
    self.view.addSubview(secondRow)
    self.view.addSubview(thirdRow)
    self.view.addSubview(forthRow)
    
    self.view.addSubview(self.tableView1)
    self.view.addSubview(self.tableView2)
    self.view.addSubview(self.tableView3)
    
    // adding constraints
    addFirstRowConstraints(buttons: firstRowButtons, containingView: firstRow)
    addSecondRowConstraints(buttons: secondRowButtons, containingView: secondRow)
    addThirdRowConstraints(buttons: thirdRowButtons, containingView: thirdRow)
    addForthRowConstraints(buttons: forthRowButtons, containingView: forthRow)
    
    // Perform custom UI setup here
    self.nextKeyboardButton = UIButton(type: .system)
    
    self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
    self.nextKeyboardButton.sizeToFit()
    self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
    
    self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
    
    self.view.addSubview(self.nextKeyboardButton)
    
    self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
    self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
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
    if tableView == self.tableView1 {
      return min(self.search_result.count, 6)
    }
    
    if tableView == self.tableView2 {
      if self.search_result.count < 7 {
        return 0
      } else {
        return min(self.search_result.count-6, 6)
      }
    }
    
    if tableView == self.tableView3 {
      if self.search_result.count < 13 {
        return 0
      } else {
        return min(self.search_result.count-12, 6)
      }
    }
    
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell : UITableViewCell = UITableViewCell()
    if tableView == self.tableView1 {
      cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell1")
      cell.textLabel!.text = self.search_result[indexPath.row]
    }
    
    if tableView == self.tableView2 {
      cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell2")
      cell.textLabel!.text = self.search_result[indexPath.row+6]
    }
    
    if tableView == self.tableView3 {
      cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell3")
      cell.textLabel!.text = self.search_result[indexPath.row+12]
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if self.cur_cell != nil {
      self.cur_cell!.backgroundColor = UIColor.white
      self.cur_cell = nil
    }
    
    self.cur_cell = tableView.cellForRow(at: indexPath)
    self.cur_cell?.selectionStyle = .none
    self.cur_cell!.backgroundColor = UIColor.yellow
  }
  
  // Custom Functions
  func getResult() {
    var keyword : String = ""
    for button in self.inputButtons {
      if button.backgroundColor == UIColor.yellow {
        let title = button.titleLabel?.text!
        keyword += title! + " "
      }
    }
    
    self.search_result = self.connector.perform_search(keyword: keyword.lowercased())
    self.tableView1.reloadData()
    self.tableView2.reloadData()
    self.tableView3.reloadData()
  }
  
  func addAnimation(button: UIButton) {
    UIView.animate(withDuration: 0.2, animations: {
      button.transform = CGAffineTransform.identity.scaledBy(x: 2.0, y: 2.0)
    }, completion: {(_) -> Void in
      button.transform =
        CGAffineTransform.identity.scaledBy(x: 1, y: 1)
    })
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
    if button.backgroundColor == UIColor.white {
      button.backgroundColor = UIColor.yellow
    } else {
      button.backgroundColor = UIColor.white
    }
    getResult()
    
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
      
      self.addStandardLeftConstraint(index: index, buttons: buttons, containingView: containingView, val: 3)
      
      self.addStandardRightConstraint(index:index, buttons: buttons, containingView: containingView, val: -3)
    }
  }
  
  func addForthRowConstraints(buttons: [UIButton], containingView: UIView){
    
    for (index, button) in buttons.enumerated() {
      self.addStandardTopConstraint(index: index, button: button, containingView: containingView, val: 1)
      
      self.addStandardBottomConstraint(index: index, button: button, containingView: containingView, val: -1)
      
      self.addStandardLeftConstraint(index: index, buttons: buttons, containingView: containingView, val: 3)
      
      self.addStandardRightConstraint(index:index, buttons: buttons, containingView: containingView, val: -3)
    }
  }
}
