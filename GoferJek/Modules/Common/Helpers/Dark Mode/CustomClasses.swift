//
//  CustomClasses.swift
//  GoferHandy
//
//  Created by trioangle on 11/02/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit

//------------------------------------
// MARK: - Custom Views
//------------------------------------

/**
 - note:
 - Type                ->      View
 - Background    ->     White or Black (in Dark -> Black)
 - cornerRadius  ->     15
 */
class CurvedView: UIView {
    func customColorsUpdate() {
        let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
        self.backgroundColor = isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.cornerRadius = 15
        self.clipsToBounds = true
        self.elevate(2)
    }
    
    override
    func awakeFromNib() {
        super.awakeFromNib()
        self.customColorsUpdate()
    }
}


/**
 - note:
 - Type                ->      View
 - Background    ->     Light white or Light Gray (in Dark -> Black)
 */
class BoxFieldView: UIView {
    func customColorsUpdate() {
        let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
        self.backgroundColor = isDarkStyle ? .BoxColor : .SecondaryColor
    }
    
    override
    func awakeFromNib() {
        super.awakeFromNib()
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      View
 - Background    ->     Light white or Black (in Dark -> Black)
 - cornerRadius  ->     15
 */
class TeritaryView: UIView {
    func customColorsUpdate() {
        let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
        self.backgroundColor = isDarkStyle ?  .DarkModeBackground : .LightWhiteColor
    }
    
    override
    func awakeFromNib() {
        super.awakeFromNib()
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                            ->     View
 - Background                ->     White or Black (in Dark -> Black)
 - Specified Corner        ->     Top Left and Right
 - cornerRadius             ->      40
 */

class TopCurvedView: UIView {
    
    func customColorsUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.layer.cornerRadius = 40
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.elevate(4,shadowColor: self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor)
    }
    
    func removeSpecificCorner(){
        self.clipsToBounds = true
        self.layer.cornerRadius = 0
        self.layer.maskedCorners = [] //
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
    }
    
    override
    func awakeFromNib() {
        super.awakeFromNib()
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                            ->     View
 - Background                ->     White or Black (in Dark -> Black)
 - Specified Corner        ->     Bottom Left and Right
 - cornerRadius             ->      40
 */

class BottomCurvedView: UIView {
    func customColorsUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.layer.cornerRadius = 40
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        self.elevate(4)
    }
    
    override
    func awakeFromNib() {
        super.awakeFromNib()
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                            ->     View
 - Background                ->     White or Black  (in Dark -> Black)
 */

class HeaderView : UIView {
    func customColorsUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      View
 - Background    ->     Theme Color
 */

class PrimaryView : UIView {
    func customColorsUpdate() {
        self.backgroundColor = .PrimaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                            ->     View
 - Background                ->     White or Black  (in Dark -> Black)
 */

class CategoryView : UIView {
    func customColorsUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        //self.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.elevate(2)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->     View
 - Background    ->     Black or White (in Dark -> white)
 */

class SecondaryInvertedView : UIView {
    func customColorsUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      View
 - Background    ->      White or Black  (in Dark -> Black)
 */
class SecondaryView : UIView {
    func customColorsUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class ViewBasketView : UIView {
    func customColorsUpdate() {
        self.backgroundColor = self.isDarkStyle ? .PrimaryColor : .PrimaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class TeritaryBackgroundView : UIView {
    func customColorsUpdate() {
        self.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.1)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}


class cornerWithShadowView : UIView {
    func customColorsUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.layer.masksToBounds = true;
        self.elevate(1)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class cornerWIthShadowViewNew : UIView {
    func customColorsUpdate() {
//        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.layer.cornerRadius = 10.0;
        self.layer.masksToBounds = true;
        self.elevate(1)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                ->      View
 - Background    ->      White or Black  (in Dark -> Black)
 - Border             ->      Light gray
 - cornerRadius  ->      15
 */

class SecondaryBorderedView: UIView {
    func customColorsUpdate() {
        self.border(width: 1,
                    color: UIColor.TertiaryColor.withAlphaComponent(0.5))
        self.clipsToBounds = true
        self.cornerRadius = 15
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}


/**
 - note:
 - Type                            ->     View
 - Background                ->     White or Black  (in Dark -> Black)
 */

class cornerWithShadow : UIView {
    func customColorsUpdate() {
        self.cornerRadius = 20
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.layer.masksToBounds = true;
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 5.0
        self.layer.masksToBounds = false
        
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}


//------------------------------------
// MARK: - Custom Buttons
//------------------------------------

/**
 - note:
 - Type                            ->     Button
 - Background                ->     White or Black (in Dark -> Black)
 - tintColor                      ->     Black or White (in Dark -> white)
 - TitleColor                    ->     Black or White (in Dark -> White)
 */

class SecondaryBackButton : UIButton {
    func customColorsUpdate() {
        self.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.setTitleColor(self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor, for: .normal)
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                            ->     Button
 - Background                ->     White or Black (in Dark -> Black)
 - tintColor                      ->     Black or White (in Dark -> white)
 - TitleColor                    ->     Black or White (in Dark -> White)
 */

class SecondaryTintButtons : UIButton {
    func customColorsUpdate() {
        self.tintColor = self.isDarkStyle ? .SecondaryColor : .IndicatorColor
    }
    
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class primaryBgButton : UIButton {
    func customColorsUpdate() {
        self.imageView?.tintColor = .PrimaryTextColor
        self.backgroundColor = .PrimaryColor
    }
    
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}


class errorBgButton : UIButton {
    func customColorsUpdate() {
        self.imageView?.tintColor = .PrimaryTextColor
        self.backgroundColor = .ErrorColor
    }
    
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}


/**
 - note:
 - Type                            ->     Button
 - Background                ->     White or Black (in Dark -> Black)
 - tintColor                      ->     Black or White (in Dark -> white)
 - TitleColor                    ->     Black or White (in Dark -> White)
 */

class imgTintButtons : UIButton {
    func customColorsUpdate() {
        self.imageView?.tintColor = self.isDarkStyle ? .white : .DarkModeBackground
        self.imageView?.image = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
    }
    
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}


/**
 - note:
 - Type                            ->     Button
 - TitleColor                    ->     Black or White (in Dark -> White)
 -  Font                           ->     Font bold 15
 */

class SecondaryTransperentIndicatorButton: UIButton {
    func customColorsUpdate() {
        self.setTitleColor(self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor, for: .normal)
        self.titleLabel?.font = AppTheme.Fontbold(size: 15).font
        self.tintColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
    }
    override
    func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Button
 - Background    ->     Theme Color
 - TextColor        ->      White
 - Font                ->     Font bold 15
 - cornerRadius ->      15
 */

class PrimaryButton: UIButton {
    func customColorsUpdate() {
        self.backgroundColor = .PrimaryColor
        self.tintColor = .PrimaryTextColor
        self.setTitleColor(.PrimaryTextColor, for: .normal)
        self.titleLabel?.font = AppTheme.Fontbold(size: 15).font
        self.clipsToBounds = true
        self.cornerRadius = 15
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}


class CancelledColorBtn: UIButton {
    func customColorsUpdate() {
        self.backgroundColor = .CancelledStatusColor
        self.tintColor = .PrimaryTextColor
        self.setTitleColor(.PrimaryTextColor, for: .normal)
        self.titleLabel?.font = AppTheme.Fontbold(size: 15).font
        self.clipsToBounds = true
        self.cornerRadius = 15
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class PrimaryButtonWithoutCorner: UIButton {
    func customColorsUpdate() {
        self.backgroundColor = .PrimaryColor
        self.tintColor = .PrimaryTextColor
        self.setTitleColor(.PrimaryTextColor, for: .normal)
        self.titleLabel?.font = AppTheme.Fontbold(size: 15).font
        self.clipsToBounds = true
        self.cornerRadius = 2
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Button
 - Background    ->     inactive Color
 - TextColor        ->      black
 - Font                ->     Font bold 15
 - cornerRadius ->      15
 */

class InactiveButton: UIButton {
    func customColorsUpdate() {
        self.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.5)
        self.setTitleColor(self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor, for: .normal)
        self.titleLabel?.font = AppTheme.Fontbold(size: 15).font
        self.clipsToBounds = true
        self.cornerRadius = 15
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                ->      Button
 - Background    ->     Light Gray
 - TextColor        ->      Black or White (in Dark -> White)
 - Font                ->     Font light 15
 - cornerRadius ->      10
 */

class TeritaryButton: UIButton {
    func customColorsUpdate() {
        self.backgroundColor = .LightWhiteColor
        self.setTitleColor(self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor,
                           for: .normal)
        self.titleLabel?.font = AppTheme.Fontlight(size: 14).font
        self.clipsToBounds = true
        self.cornerRadius = 15
    }
    
    func customColorsUpdated() {
        self.backgroundColor = .TertiaryColor
        self.setTitleColor(self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor,
                           for: .normal)
        self.titleLabel?.font = AppTheme.Fontlight(size: 14).font
        self.clipsToBounds = true
        self.cornerRadius = 15
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Button
 - Background    ->     White or Black (in Dark -> Black)
 - TextColor        ->      Theme Color
 - Font                ->     Font bold 15
 */

class PrimaryTextButton: UIButton {
    func customColorsUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.setTitleColor(.ThemeTextColor, for: .normal)
        self.titleLabel?.font = AppTheme.Fontbold(size: 15).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Button
 - Background    ->      themeColor
 - TextColor        ->      white
 - Font                ->     Font bold 15
 */

class themeBtn: UIButton {
    func customColorsUpdate() {
        self.backgroundColor = .ThemeTextColor
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = AppTheme.Fontbold(size: 15).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Button
 - Background    ->     White or Black (in Dark -> Black)
 - TextColor        ->      Black or White (in Dark -> White)
 - Font                ->     Font bold 15
 */
class SecondaryButton : UIButton {
    func customColorsUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.setTitleColor(self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor ,
                           for: .normal)
        self.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.titleLabel?.font = AppTheme.Fontbold(size: 15).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class InvertedButton : UIButton {
    func customColorsUpdate() {
        self.backgroundColor = self.isDarkStyle ? .SecondaryColor : .DarkModeBackground
        self.tintColor = self.isDarkStyle ? .SecondaryTextColor : .DarkModeTextColor
        self.setTitleColor(self.isDarkStyle ? .SecondaryTextColor : .DarkModeTextColor ,
                           for: .normal)
        self.titleLabel?.font = AppTheme.Fontbold(size: 15).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                ->      Button
 - Background    ->     Theme Color
 - TextColor        ->      White
 */

class PrimaryFontButton : UIButton {
    func customColorsUpdate() {
        self.backgroundColor = .PrimaryColor
        self.setTitleColor(.PrimaryTextColor, for: .normal)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Button
 - Background    ->     White or Black (in Dark -> Black)
 - TextColor        ->      Theme Color
 - Border            ->      Theme Color
 - Font                ->     Font bold 15
 - cornerRadius  ->    15
            
 */
class PrimaryBorderedButton : UIButton {
    func customColorsUpdate() {
        self.border(width: 1,
                    color: .PrimaryColor)
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.setTitleColor(.ThemeTextColor,
                           for: .normal)
        self.clipsToBounds = true
        self.cornerRadius = 15
        self.titleLabel?.font = AppTheme.Fontbold(size: 15).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Button
 - TextColor        ->     Theme Color
 - Font                ->     Font bold 15
            
 */
class PrimaryTextTintButton: UIButton {
    func customColorsUpdate() {
        self.setTitleColor(.ThemeTextColor, for: .normal)
        self.titleLabel?.font = AppTheme.Fontbold(size: 15).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Button
 - TextColor        ->     Theme Color
 - Font                ->     Font bold 12
 */

class PrimarySmallTextButton: UIButton {
    func customColorsUpdate() {
        self.setTitleColor(.ThemeTextColor,
                           for: .normal)
        self.titleLabel?.font = AppTheme.Fontbold(size: 12).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Button
 - TintColor        ->     Theme Color
 */

class PrimaryTintButton : UIButton {
    func customColorsUpdate() {
        self.imageView?.tintColor = .PrimaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Button
 - TintColor        ->     White Color
 */

class SecondaryTintButton : UIButton {
    func customColorsUpdate() {
        self.imageView?.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Button
 - Background    ->     Default
 - TextColor        ->     Black Color
 - Border            ->      Default
 - Font                ->     Font bold 20
 */

class SecondaryBorderedButton : UIButton {
    func customColorsUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.setTitleColor(self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor, for: .normal)
        self.border(width: 1, color: .TertiaryColor)
        self.titleLabel?.font = AppTheme.Fontbold(size: 16).font
        self.clipsToBounds = true
        self.cornerRadius = 15

    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}


//------------------------------------
// MARK: - Custom ImageViews
//------------------------------------

/**
 - note:
 - Type                            ->     ImageView
 - tintColor                      ->     White or Black (in Dark -> White)
 */

class SecondaryTintImageView : UIImageView {
    func customColorsUpdate() {
        self.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
    }
    override
    func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      ImageView
 - Tint Color        ->     Theme Color
 */
class PrimaryImageView : UIImageView {
    func customColorsUpdate() {
        self.tintColor = .PrimaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      ImageView
 - Tint Color        ->     white
 */

class SecondaryImageView : UIImageView {
    func customColorsUpdate() {
        self.tintColor = .SecondaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      ImageView
 - Background    ->     White Color
 */
class PrimaryBackgroundImageView : UIImageView {
    func customColorsUpdate() {
        self.backgroundColor = .PrimaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      ImageView
 - Background    ->     White Color
 */
class SecondaryBackgroundImageView : UIImageView {
    func customColorsUpdate() {
        self.backgroundColor = .SecondaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      ImageView
 - Tint Color        ->     Theme Color
 - Border Color    ->    Theme Color
 */
class PrimaryBorderedImageView : UIImageView {
    func customColorsUpdate() {
        self.tintColor = .PrimaryColor
        self.border(width: 1, color: .PrimaryColor)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                ->      ImageView
 - Border Color    ->    TeritaryColor
 */
class TeriteryBorderedImageView : UIImageView {
    func customColorsUpdate() {
        self.border(width: 1, color: .TertiaryColor)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class TeriteryTintImageView : UIImageView {
    func customColorsUpdate() {
        self.tintColor = .TertiaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                         ->    ImageView
 - background Color   ->    PromoColor
 - tintColor                  ->    white
 */
class PromoImageView: UIImageView {
    func customColorsUpdate() {
        self.backgroundColor = .PromoColor
        self.tintColor = .SecondaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}


//------------------------------------
// MARK: - Custom Labels
//------------------------------------

/**
 - note:
 - Type                ->     Label
 - TextColor        ->     White or Black (in Dark -> White)
 - Font                ->     Font bold 18
 */

class SecondaryHeaderLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.font = AppTheme.Fontbold(size: 18).font
    }
    func customColorsUpdates() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.font = AppTheme.Fontlight(size: 15).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

//------------------------------------
// MARK: - Custom Labels
//------------------------------------

/**
 - note:
 - Type                ->     Label
 - TextColor        ->     White or Black (in Dark -> White)
 - Font                ->     Font bold 15
 */

class SecondaryTitleLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.font = AppTheme.Fontbold(size: 15).font
    }
    func customColorsUpdates() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.font = AppTheme.Fontbold(size: 14).font
    }
    func customFontUpdates() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.font = AppTheme.Fontbold(size: 13).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

//------------------------------------
// MARK: - Custom Labels
//------------------------------------

/**
 - note:
 - Type                ->     Label
 - TextColor        ->     White or Black (in Dark -> White)
 - Font                ->     Font medium 12
 */

class SecondaryDescLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.font = AppTheme.Fontmedium(size: 12).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

//------------------------------------
// MARK: - Custom Labels
//------------------------------------

/**
 - note:
 - Type                ->     Label
 - TextColor        ->     White or Black (in Dark -> White)
 - Font                ->     Font light 12
 */

class SecondaryDescLightLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.font = AppTheme.Fontlight(size: 12).font
    }
    func customColorsUpdates() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.font = AppTheme.Fontlight(size: 10).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Label
 - TextColor        ->     Red Color
 - Font                ->     Font Bold 13
 */
class ErrorLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .ErrorColor
        self.font = AppTheme.Fontbold(size: 13).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                             ->     Label
 - TextColor                     ->     white
 - background Color        ->     promo Color
 */
class PromoAppliedLabel: UILabel {
    func customColorsUpdate() {
        self.backgroundColor = .PromoColor
        self.textColor = .PrimaryTextColor
        self.font = AppTheme.Fontmedium(size: 15).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class SecondaryExtraSmallLabel : UILabel {
    func customColorsUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.font = AppTheme.Fontlight(size: 10).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Label
 - TextColor        ->     promo Color
 */
class PromoLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .PromoColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Label
 - TextColor        ->     White Color
 - Font                ->     Font bold 15
 */
class PrimaryButtonLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .PrimaryTextColor
        self.font = AppTheme.Fontbold(size: 15).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Label
 - TextColor        ->    white or  Black (in Dark -> White)
 - Font                ->     Font light 14
 */

class SecondaryRegularLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .LightModeTextColor
        self.font = AppTheme.Fontlight(size: 14).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Label
 - TextColor        ->    white or  Black (in Dark -> White)
 - Font                ->     Font bold 14
 */

class SecondaryRegularBoldLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .LightModeTextColor
        self.font = AppTheme.Fontbold(size: 14).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Label
 - TextColor        ->    white or  Black (in Dark -> White)
 - Font                ->     Font light 12
 */

class SecondarySmallLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .LightModeTextColor
        self.font = AppTheme.Fontlight(size: 12).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}



/**
 - note:
 - Type                ->      Label
 - TextColor        ->      gray or  inactive (in Dark -> White)
 - Font                ->     Font light 12
 */

class InactiveSmallLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeBorderColor : .TertiaryColor
        self.font = AppTheme.Fontlight(size: 12).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                ->      Label
 - TextColor        ->      gray or  inactive (in Dark -> White)
 - Font                ->     Font Medium 16
 */

class InactiveSubHeaderLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .InactiveTextColor
        self.font = AppTheme.Fontbold(size: 16).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Label
 - TextColor        ->      white or  inactive (in Dark -> White)
 - Font                ->     Font light 14
 */
class SecondarySmallBoldLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.font = AppTheme.Fontbold(size: 14).font//.BoldFont(size: 14)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                ->      Label
 - TextColor        ->      white or  inactive (in Dark -> White)
 - Font                ->     Font light 14
 */
class SecondarySmallMediumLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.font = AppTheme.Fontmedium(size: 14).font//.BoldFont(size: 14)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Label
 - TextColor        ->    white or  inactive (in Dark -> White)
 - Font                ->     Font light 17
 */

class SecondaryLargeLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.font = AppTheme.Fontlight(size: 17).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                ->      Label
 - TextColor        ->     white or  inactive (in Dark -> White)
 - Font                ->     Font medium 16
 */

class SecondarySubHeaderLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.font = AppTheme.Fontbold(size: 16).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Label
 - TextColor        ->     white or  inactive (in Dark -> White)
 - Font                ->     Font medium 16
 */

class PrimarySubHeaderLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .PrimaryTextColor
        self.font = AppTheme.Fontbold(size: 16).font
    }
    func customColorsUpdates() {
        self.textColor = .PrimaryTextColor
        self.font = AppTheme.Fontbold(size: 14).font
    }
    func tinyFontUpdate() {
        self.textColor = .PrimaryTextColor
        self.font = AppTheme.Fontbold(size: 10).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class InvertedSecondaryLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .SecondaryTextColor : .DarkModeTextColor
        self.font = AppTheme.Fontmedium(size: 16).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                ->      Label
 - TextColor        ->    Red Color
 - Font                ->     Font medium 14
 */
class PrimarySmallBoldLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .ThemeTextColor
        self.font = AppTheme.Fontmedium(size: 14).font
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                ->      Label
 - TextColor        ->     Theme Color
 - Font                ->     Font medium 25
 */

class PrimaryLargeLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .ThemeTextColor
        self.font = AppTheme.Fontbold(size: 25).font //.BoldFont(size: 35)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Label
 - TextColor        ->     white or black (in Dark -> white)
 - Font                ->     Font medium 25
 */

class SecondaryExtraLargeLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.font = AppTheme.Fontbold(size: 35).font //.BoldFont(size: 35)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                ->      Label
 - TextColor        ->     white  (in Dark -> white)
 - Font                ->     Font medium 50
 */

class SecondaryTooLargeLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.font = AppTheme.Fontbold(size: 50).font //.BoldFont(size: 35)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Label
 - Background    ->     Theme Color
 - TextColor        ->     White Color
 - Font                ->     Font light 16
 */

class CustomOtpLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .PrimaryTextColor
        self.backgroundColor = .PrimaryColor
        self.font = AppTheme.Fontlight(size: 16).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Label
 - TextColor        ->     white or black (in Dark -> white)
 - Font                ->     Font medium 16
 */

class SecondaryTextFieldLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.font = AppTheme.Fontbold(size: 15).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Label
 - TextColor        ->     light gray Color
 - Font                ->      Font light 14
 */

class InactiveRegularLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeBorderColor : .TertiaryColor
        self.font = AppTheme.Fontlight(size: 14).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Label
 - TextColor        ->     Theme Color
 - Font                ->      Font medium 16
 */

class PrimaryColoredHeaderLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .ThemeTextColor
        self.font = AppTheme.Fontbold(size: 16).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                ->      Label
 - Background    ->     Theme  Color
 - TextColor        ->     white
 - Font                ->      Font medium 16
 */

class PrimaryBackgroundNormalLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .PrimaryTextColor
        self.backgroundColor = .PrimaryColor
        self.font = AppTheme.Fontmedium(size: 16).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class PrimaryBackgroundNormalLabels: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.font = AppTheme.Fontmedium(size: 16).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

//------------------------------------
// MARK: - Custom Segment
//------------------------------------

/**
 - note:
 - Type                ->      Segment Control
 - Background    ->     Theme Color
 - TextColor        ->      White
 - Border            ->      Default
 -  Selected Color ->  White
            
 */
class CommonSegmentControl : UISegmentedControl {
    func customColorsUpdate() {
        self.border(width: 1, color: .PrimaryColor)
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.selectedSegmentTintColor = .PrimaryColor
        self.tintColor = .PrimaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}


//------------------------------------
// MARK: - Custom TextField
//------------------------------------

/**
 - note:
 - Type                ->      TextField
 - Tint Color        ->     Theme Color
 - Text Color       ->      Black Color
 - Font                ->       Font Medium 14
 */
class commonTextField : UITextField {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.tintColor = .PrimaryColor
        self.font = AppTheme.Fontmedium(size: 14).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class boxTextField : UITextField {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.tintColor = .PrimaryColor
        self.font = AppTheme.Fontmedium(size: 14).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

//------------------------------------
// MARK: - Custom TextView
//------------------------------------

/**
 - note:
 - Type                ->      TextView
 - Tint Color        ->     Theme Color
 - Text Color       ->      Black Color
 - Font                ->       Font Medium 15
 */
class commonTextView : UITextView {
    func customColorsUpdate() {
        self.tintColor = .PrimaryColor
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.font = AppTheme.Fontmedium(size: 15).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class boxTextView : UITextView {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.tintColor = .PrimaryColor
        self.font = AppTheme.Fontmedium(size: 15).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

//------------------------------------
// MARK: - Custom TableView
//------------------------------------

/**
 - note:
 - Type                ->     TableView
 - Background    ->     White or Black Color (in dark -> Black)
 - Tint Color        ->     Theme Color
 */
class CommonTableView : UITableView {
    func customColorsUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.tintColor = .PrimaryColor
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.clipsToBounds = true
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}


//------------------------------------
// MARK: - Custom PageControl
//------------------------------------

/**
 - note:
 - Type                ->     PageControl
 - Background    ->     White Color
 - Tint Color        ->     Theme Color
 */
class CommonPageControl : UIPageControl {
    func customColorsUpdate() {
        self.currentPageIndicatorTintColor = .PrimaryColor
        self.tintColor = .TertiaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

//------------------------------------
// MARK: - Custom SearchBar
//------------------------------------

/**
 - note:
 - Type                   ->     SearchBar
 - Background       ->     White or Black Color (in dark -> Black)
 - Tint Color           ->     Theme Color
 - searchBarStyle  ->      minimal
 */
class CommonSearchBar : UISearchBar {
    func customColorsUpdate() {
        self.barTintColor = .PrimaryColor
        self.backgroundColor = .PrimaryColor
        self.searchBarStyle = .minimal
        self.searchTextField.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.searchTextField.font = AppTheme.Fontmedium(size: 14).font
        self.searchTextField.tintColor = .PrimaryColor
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                ->      Label
 - Background    ->     Theme Color
 - TextColor        ->      White
 - Font                ->     Font bold 15
 - cornerRadius ->      15
 */

class PrimaryBackgroundLabel: UILabel {
    func customColorsUpdate() {
        self.backgroundColor = .PrimaryColor
        self.tintColor = .PrimaryTextColor
        self.textColor = .PrimaryTextColor
        self.font = AppTheme.Fontbold(size: 12).font
        self.clipsToBounds = true
        self.cornerRadius = 5
        self.border(width: 1, color: .SecondaryColor)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
