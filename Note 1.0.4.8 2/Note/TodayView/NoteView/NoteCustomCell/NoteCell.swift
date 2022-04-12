//
//  NoteCell.swift
//  Note
//
//  Created by Евгений on 04.01.2021.
//

import UIKit


extension NoteTableCell: NoteCellDelegate {
    func resignKeyboard() {
        textBody.resignFirstResponder()
        print("22222222")
    }
}

var becomeFirstResponceForCell = Bool()
var indexCellFromNoteCell = Int()


protocol NoteDelegate {
    func rewriteEditedCell()
    
    func reloadNoteTable()
    func reloadCell()
    func printSmth()
    
    func createNoteCell()
    func createCheckListCell()
    func deleteCell(index:Int)
    
    func checkPatternNote()
    
    func checkCheckMarkButton()
    
    func adaptiveScrollForKeyboard()
}


enum LastCellAction {
    static var wasCreatedCheckList = "wasCreatedCheckList"
    static var wasCreatedNote = "wasCreatedNote"
    static var wasDeleted = "wasDeleted"
    static var wasOpenCreateNote = "wasOpenCreateNote"
    
}

var statusCell = String()

class NoteTableCell: UITableViewCell, UITextViewDelegate {
    var updateNoteDelegate: NoteDelegate?
    var placeHolderTextView = "Введите текст"
    var currentCell = ""
    
    
    // MARK: - Outlets
    @IBOutlet weak var textBody: UITextView!
    @IBOutlet weak var bodyLeftConst: NSLayoutConstraint!
    @IBOutlet weak var checkMarkOutlet: UIButton!

    
    // MARK: - Tapped Checkmark button
    @IBAction func checkMarkAction(_ sender: Any) {
        
        
        ///* - TurnON checkmark
        if noteCellItems[checkMarkOutlet.tag].isCheckList == true
            && noteCellItems[checkMarkOutlet.tag].isDone == false {
            
            stickthought(text: textBody, isOn: true)
            
            checkMarkOutlet.setImage(UIImage(systemName: "checkmark.square", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22)), for: .normal)
            noteCellItems[checkMarkOutlet.tag].isDone = true
            textBody.alpha = 0.35
          
            
        ///* - TurnOFF checkmark
        } else if noteCellItems[checkMarkOutlet.tag].isCheckList == true
                    && noteCellItems[checkMarkOutlet.tag].isDone == true {
            
            stickthought(text: textBody, isOn: false)
            updateNoteDelegate?.reloadNoteTable()

            checkMarkOutlet.setImage(UIImage(systemName: "square", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22)), for: .normal)
            noteCellItems[checkMarkOutlet.tag].isDone = false
            textBody.alpha = 0.8
        }
        
        
        ///* - Save checkmark change
        todayNoteItems[usedIndexCell].noteCell = noteCellItems
    }
    
    
    
    
    
    
    // MARK: - SETUP NOTE CELL
    func setupNoteCell(isCheckList:Bool,
                       isDone: Bool,
                       markColor: String,
                       body: String,
                       statusEditNote: String,
                       indexPath:IndexPath) {
        
        checkMarkOutlet.tag = Int(indexPath.row)
        textBody.delegate = self
        textBody.tag = Int(indexPath.row)
        textBody.text = body
        
        checkPlaceHolder(IsOn: true)
        

        
        //MARK: - Set type of cell (Checklist or note)
        
        ///* - Checklsit:
        if isCheckList == true {
            
            bodyLeftConst.constant = 60
            checkMarkOutlet.isHidden = false
            
        ///* - Note:
        } else {
            bodyLeftConst.constant = 14
            checkMarkOutlet.isHidden = true
        }
        
        
        //MARK: - Set color of CheckMark
        switch markColor {
        
        case ColorMark.red:
            checkMarkOutlet.tintColor = .systemRed
            
        case ColorMark.orange:
            checkMarkOutlet.tintColor = .systemOrange
            
        case ColorMark.gray:
            checkMarkOutlet.tintColor = .systemGray
        default:
            break
        }
        
        
        //MARK: - Set isDone
        
        ///* - If isDone = false
        if noteCellItems[checkMarkOutlet.tag].isCheckList == true
            && noteCellItems[checkMarkOutlet.tag].isDone == false {
            
            checkMarkOutlet.setImage(UIImage(systemName: "square", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22)), for: .normal)
            textBody.alpha = 0.8
            
            
        ///* - If isDone = true
        } else if noteCellItems[checkMarkOutlet.tag].isCheckList == true
                    && noteCellItems[checkMarkOutlet.tag].isDone == true {
            
            checkMarkOutlet.setImage(UIImage(systemName: "checkmark.square", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22)), for: .normal)
            textBody.alpha = 0.35
            
            stickthought(text: textBody, isOn: true)
            
            
        ///* - last check for note
        } else if noteCellItems[checkMarkOutlet.tag].isCheckList == false && noteCellItems[checkMarkOutlet.tag].isDone == false {
            textBody.alpha = 0.8
        }
        
    }
    
    
    
    func stickthought(text: UITextView, isOn: Bool = true, sizeText: CGFloat = 17.0) {
        if isOn {
            let attributeString =  NSMutableAttributedString(string: text.text)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                         value: NSUnderlineStyle.single.rawValue,
                                         range: NSMakeRange(0, attributeString.length))

            text.attributedText = attributeString
            text.font = UIFont(descriptor: text.font!.fontDescriptor, size: sizeText)

        } else {
            let attributeString =  NSMutableAttributedString(string: text.text)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                         value: NSUnderlineStyle.single.rawValue,
                                         range: NSMakeRange(0, attributeString.length))


            text.font = UIFont(descriptor: text.font!.fontDescriptor, size: sizeText)
        }
        
        checkColorTextBody()

    }
    
}

extension NoteViewController {
    
//    //MARK: - Adaptive area size Text View when keyboard is show or hide
//    func createAdaptive() {
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
//        
////        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//    
//    @objc func keyboardWillHide(){
//        //        textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        //        textView.scrollIndicatorInsets = textView.contentInset
//        //
//        //        textView.scrollRangeToVisible(textView.selectedRange)
//    }
//
//
//    @objc func keyboardWillShow(param: Notification) {
//        let userInfo = param.userInfo
//        let getKeyboardRect = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        let keyboardFrame = self.view.convert(getKeyboardRect, to: view.window)
//
//
//        if param.name == UIResponder.keyboardWillHideNotification {
//            noteTableView.contentInset = UIEdgeInsets.zero
//        } else {
//            noteTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
//            noteTableView.scrollIndicatorInsets = noteTableView.contentInset
//        }
////        textView.scrollRangeToVisible(textView.selectedRange)
////        noteTableView.scrollRangeToVisibl
//    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        NotificationCenter.default.addObserver(self, selector: #selector(NoteViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(NoteViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//
//    }

//    @objc func keyboardWillShow(_ notification:Notification) {
//
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            noteTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
//        }
//    }
//
//
//    @objc func keyboardWillHide(_ notification:Notification) {
//
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            noteTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        }
//    }
}



//extension UITextView {
//
//func strikeThrough(_ isStrikeThrough:Bool) {
//    if isStrikeThrough {
//        if let lblText = self.text {
//            let attributeString =  NSMutableAttributedString(string: lblText)
//            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
//            self.attributedText = attributeString
//            self.textColor = .none
//            self.font = UIFont(descriptor: self.font!.fontDescriptor, size: 17.0)
//        }
//    } else {
//
//            let txt = self.text
//            self.attributedText = nil
//            self.textColor = .none
//            self.font = UIFont(descriptor: self.font!.fontDescriptor, size: 17.0)
//            self.text = txt
//            return
//
//    }
//}
//}
