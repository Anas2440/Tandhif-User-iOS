//
//  CurrencyPopupView.swift
//  GoferHandy
//
//  Created by Trioangle on 29/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit

enum SwipeState {
  case full
  case middle
  case dismiss
}

enum TypeOfSwipe {
  case left
  case right
  case up
  case down
  case none
}

protocol currencyListDelegate {
    func onCurrencyChanged(currency:String)
}

class CurrencyPopupView: BaseView {
    var oldOrgin : CGPoint = .zero
    var oldSize : CGSize = .zero
    //MARK:- Outlets
    var viewControler : CurrencyPopupVC!
    @IBOutlet weak var currencyTable: CommonTableView!
    @IBOutlet weak var titleLbl: SecondaryHeaderLabel!
    @IBOutlet weak var hoverView: TopCurvedView!
    @IBOutlet weak var dismissView: UIView!
    @IBOutlet weak var hoverViewHeightCons: NSLayoutConstraint!
    
    var tabBar : UITabBar?
    var currentState : SwipeState = .middle
    var currentSwipe : TypeOfSwipe = .none
    var delegate: currencyListDelegate?
    var strCurrentCurrency = ""
    //MARK:- view life cycle
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.viewControler = baseVC as? CurrencyPopupVC
        let userCurrencySym = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG)
        let userCurrencyCode = Constants().GETVALUE(keyname: USER_CURRENCY_ORG)
        strCurrentCurrency = String(format: "%@ | %@",userCurrencyCode,userCurrencySym)
        self.viewControler.navigationController?.isNavigationBarHidden = true
        self.viewControler.callCurrencyAPI()
        self.initView()
        self.initLanguage()
        self.setupGesture()
        self.ThemeChange()
        self.currentState = .middle
        self.stateBasedAnimation(state: self.currentState)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.initLayer()
        }
    }
    override func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
        self.tabBar?.isHidden = true
        self.backgroundColor = .clear
        let userCurrencySym = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG)
        let userCurrencyCode = Constants().GETVALUE(keyname: USER_CURRENCY_ORG)
        strCurrentCurrency = String(format: "%@ | %@",userCurrencyCode,userCurrencySym)

    }
    override func didAppear(baseVC: BaseViewController) {
        super.didAppear(baseVC: baseVC)
//        self.backgroundColor = UIColor.gray.withAlphaComponent(0.25)
    }
    override func willDisappear(baseVC: BaseViewController) {
        super.willDisappear(baseVC: baseVC)
        self.tabBar?.isHidden = false
    }
        func ThemeChange() {
            self.darkModeChange()
            self.backgroundColor = UIColor.IndicatorColor.withAlphaComponent(0.5)
            self.hoverView.customColorsUpdate()
            self.currencyTable.customColorsUpdate()
            self.currencyTable.reloadData()
            self.titleLbl.customColorsUpdate()
        }
        //MARK:- initializers
        func initLanguage(){
            self.titleLbl.text = LangCommon.selectCurrency
        }
    func swipe(state: SwipeState,
               swipe: TypeOfSwipe) {
      switch state {
      case .full:
        switch swipe {
        case .down:
          self.currentState = .middle
        default:
          print("\(swipe) not Handled")
        }
      case .middle:
        switch swipe {
        case .down:
          self.currentState = .dismiss
        case .up:
          self.currentState = .full
        default:
          print("\(swipe) not Handled")
        }
      default:
        print("\(state) not Handled")
      }
      self.stateBasedAnimation(state: self.currentState)
    }
    
    func stateBasedAnimation(state: SwipeState) {
      UIView.animate(withDuration: 0.7) {
        switch state {
        case .full:
          self.hoverView.transform = .identity
          self.hoverView.frame.size.height = self.frame.height + 30
          self.hoverView.removeSpecificCorner()
        case .middle:
          self.hoverView.transform = CGAffineTransform(translationX: 0, y: self.frame.midY)
          self.hoverView.frame.size.height = (self.frame.height/2) + 30
          self.hoverView.customColorsUpdate()
        case .dismiss:
          self.hoverView.transform = CGAffineTransform(translationX: 0, y: self.frame.maxY)
          self.hoverView.frame.size.height = 30
          self.hoverView.customColorsUpdate()
        }
      } completion: { (isCompleted) in
        if isCompleted && state == .dismiss {
          self.viewControler.dismiss(animated: true) {
            print("Select Lanaguage is Completely Dismissed")
          }
        }
      }
    }
        func initView(){
            self.currencyTable.dataSource = self
            self.currencyTable.delegate = self
            self.currencyTable.separatorStyle = .none
            self.dismissView.addAction(for: .tap) { [weak self] in
                self?.viewControler.dismiss(animated: true, completion: nil)
            }
        }
        func initLayer(){
            self.hoverView.isClippedCorner = true
            self.hoverView.elevate(2)
        }
    func makeCurrencySymbols(encodedString : String) -> String
    {
        let encodedData = encodedString.stringByDecodingHTMLEntities
        return encodedData
    }
    func setupGesture() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
            swipeUp.direction = .up
            self.addGestureRecognizer(swipeUp)

            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
            swipeDown.direction = .down
            self.addGestureRecognizer(swipeDown)
    }
    @objc
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
      if let swipeGesture = gesture as? UISwipeGestureRecognizer {
        switch swipeGesture.direction {
        case .right:
          print("Swiped right")
          self.currentSwipe = .right
        case .down:
          print("Swiped down")
          self.currentSwipe = .down
        case .left:
          print("Swiped left")
          self.currentSwipe = .left
        case .up:
          print("Swiped up")
          self.currentSwipe = .up
        default:
          break
        }
        self.swipe(state: self.currentState,
                   swipe: self.currentSwipe)
      }
    }
    func makeScroll() {
        for i in 0...self.viewControler.arrCurrencyData.count-1
        {
            let currencyModel = self.viewControler.arrCurrencyData[i] as CurrencyModel?
            let str = strCurrentCurrency.components(separatedBy: "  |  ")
            if currencyModel?.currency_code as String? == str[0]
            {
                let indexPath = IndexPath(row: i, section: 0)
                currencyTable.scrollToRow(at: indexPath, at: .top, animated: true)
                break
            }
        }
        
    }
       
    }
    extension CurrencyPopupView : UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.viewControler.arrCurrencyData.count
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            return self.frame.height * 0.115
            return 50
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell : CellCurrency = tableView.dequeueReusableCell(for: indexPath)
            cell.ThemeChange()
            let currencyModel = self.viewControler.arrCurrencyData[indexPath.row] as CurrencyModel?
            let strSymbol = self.makeCurrencySymbols(encodedString: (currencyModel?.currency_symbol as String?)!)
            let checkdata = String(format: "%@ | %@",(currencyModel?.currency_code as NSString?)!,strSymbol)
            cell.lblCurrency?.text = String(format: "%@ | %@",(currencyModel?.currency_code as NSString?)!,strSymbol)
            cell.imgTickMark?.isHidden = (strCurrentCurrency == checkdata) ? false : true
            cell.imgTickMark?.image = UIImage(named: "tick")
            return cell
        }
        
    }
    extension CurrencyPopupView : UITableViewDelegate{
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let selectedCell = currencyTable.cellForRow(at: indexPath) as! CellCurrency
                   appDelegate.nSelectedIndex = indexPath.row
                   strCurrentCurrency = (selectedCell.lblCurrency?.text)!
                   let str = strCurrentCurrency.components(separatedBy: " | ")
                    Constants().STOREVALUE(value: str[1] as String? ?? "" , keyname: USER_CURRENCY_SYMBOL_ORG)
                    Constants().STOREVALUE(value: str[0] as String? ?? "" , keyname: USER_CURRENCY_ORG)
                    currencyTable.reloadData()
            self.viewControler.dismiss(animated: true) {
                self.viewControler.callback?(str[0])
                self.viewControler.clickedSym?(str[1])
                self.viewControler.saveCurrencyDetails()
            }

        }

    }
