//
//  CustomClasses.swift
//  GoferHandy
//
//  Created by trioangle on 11/02/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit

/**
 - note:
 - Type                ->      View
 - Background    ->     Theme Color
 - Border            ->      Default
            
 */
class NavigationView : UIView {
    func customColorsUpdate() {
        self.backgroundColor = .PrimaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                ->      View
 - Background    ->     White Color
 - Border            ->      Default
            
 */
class MainView : UIView {
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
 - Border            ->      Default
            
 */
class ButtonBackgroundView: UIView {
    func customColorsUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .PrimaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                ->      View
 - Background    ->     White Color
 - Border            ->      Default
            
 */
class BorderLessTextFieldView : UIView {
    func customColorsUpdate() {
        self.backgroundColor = .SecondaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                ->      View
 - Background    ->     White Color
 - Border            ->      Light gray
            
 */
class BorderedTextFieldView: UIView {
    func customColorsUpdate() {
        self.border(width: 1,
                    color: self.isDarkStyle ? .DarkModeBorderColor : UIColor.TertiaryColor.withAlphaComponent(0.5))
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
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
 - Border            ->      Default
 - Font                ->     Font bold 15
            
 */

class CommonButton: UIButton {
    func customColorsUpdate() {
        self.backgroundColor = .PrimaryColor
        self.setTitleColor(.PrimaryTextColor,
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
 - Border            ->      Default
 - Font                ->     Font bold 15
            
 */

class InvertedCommonButton: UIButton {
    func customColorsUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.setTitleColor(.PrimaryTextColor,
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
 - Border            ->      Default
            
 */
class RegularInvertedThemeButton : UIButton {
    func customColorsUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.setTitleColor(self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor, for: .normal)
        self.titleLabel?.font = AppTheme.Fontlight(size: 17).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Segment Control
 - Background    ->     Theme Color
 - TextColor        ->      White
 - Border            ->      Default
 -  Selected Color ->  White
            
 */


/**
 - note:
 - Type                ->      Button
 - Background    ->     Theme Color
 - TextColor        ->      White
 - Border            ->      Default
            
 */
class FontBasedThemeButton : UIButton {
    func customColorsUpdate() {
        self.backgroundColor = .PrimaryColor
        self.setTitleColor(.PrimaryTextColor,
                           for: .normal)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Button
 - Background    ->     Default
 - TextColor        ->      Theme Color
 - Border            ->      Theme Color
 - Font                ->     Font bold 15
            
 */
class BorderedButton : UIButton {
    func customColorsUpdate() {
        self.border(width: 1,
                    color: .PrimaryColor)
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
 - Background    ->     Default
 - TextColor        ->     Theme Color
 - Border            ->      Default
 - Font                ->     Font bold 15
            
 */
class TransperentButton: UIButton {
    func customColorsUpdate() {
        self.setTitleColor(.ThemeTextColor,
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
 - Background    ->     Default
 - TextColor        ->     Theme Color
 - Border            ->      Default
 - Font                ->     Font Normal 17
            
 */
class TransperentRegularButton: UIButton {
    func customColorsUpdate() {
        self.setTitleColor(self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor,
                           for: .normal)
        self.titleLabel?.font = AppTheme.Fontlight(size: 17).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class TransperentSmallButton: UIButton {
    func customColorsUpdate() {
        self.setTitleColor(.ThemeTextColor,
                           for: .normal)
        self.titleLabel?.font = AppTheme.Fontbold(size: 14).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                ->      Button
 - Background    ->     Default
 - TextColor        ->     Default
 - Border            ->      Default
 - TintColor        ->     Theme Color
            
 */
class ThemeTintButton : UIButton {
    func customColorsUpdate() {
        self.imageView?.tintColor = .PrimaryColor
        self.titleLabel?.textColor = .PrimaryColor
        self.titleLabel?.font = AppTheme.Fontmedium(size: 12).font
        //self.backgroundColor = self.isDarkStyle ? .darkBackgroundColor : .SecondaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Button
 - Background    ->     Default
 - TextColor        ->     Default
 - Border            ->      Default
 - TintColor        ->     White Color
            
 */
class InvertedTintButton : UIButton {
    func customColorsUpdate() {
        self.imageView?.tintColor = .SecondaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                ->      Label
 - Background    ->     Default
 - TextColor        ->     Red Color
 - Border            ->      Default
 - Font                ->     Font Light 12
            
 */
/**
 - note:
 - Type                ->      Label
 - Background    ->     Default
 - TextColor        ->     White Color
 - Border            ->      Default
 - Font                ->     Font bold 15
            
 */
class InvertedHeaderButtonLabel: UILabel {
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
 - Background    ->     Default
 - TextColor        ->     White Color
 - Border            ->      Default
 - Font                ->     Font bold 20
            
 */

class InvertedHeaderLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .PrimaryTextColor
        self.font = AppTheme.Fontbold(size: 18).font
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

class ServiceAddButton : UIButton {
    func customColorsUpdate() {

        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.setTitleColor(.ThemeTextColor,
                           for: .normal)
        self.border(width: 1, color: .PrimaryColor)
        self.titleLabel?.font = AppTheme.Fontbold(size: 16).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                ->      Label
 - Background    ->     Default
 - TextColor        ->     Black Color
 - Border            ->      Default
 - Font                ->     Font bold 20
 */

class HeaderLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.font = AppTheme.Fontbold(size: 18).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Label
 - Background    ->     Default
 - TextColor        ->     Black Color
 - Border            ->      Default
 - Font                ->     Font light 14
            
 */

class RegularLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.font = AppTheme.Fontlight(size: 14).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Label
 - Background    ->     Default
 - TextColor        ->     Black Color
 - Border            ->      Default
 - Font                ->     Font bold 14
            
 */

class RegularHeaderLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.font = AppTheme.Fontbold(size: 14).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Label
 - Background    ->     Default
 - TextColor        ->     Black Color
 - Border            ->      Default
 - Font                ->     Font bold 14
            
 */

class RegularThemeHeaderLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = UIColor(hex: "#F54748")
        self.font = AppTheme.Fontbold(size: 14).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}


/**
 - note:
 - Type                ->      Label
 - Background    ->     Default
 - TextColor        ->     Black Color
 - Border            ->      Default
 - Font                ->     Font light 12
            
 */

class SmallRegularLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.font = AppTheme.Fontlight(size: 12).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}


/**
 - note:
 - Type                ->      Label
 - Background    ->     Default
 - TextColor        ->     Black Color
 - Border            ->      Default
 - Font                ->     Font light 12
            
 */

class InactiveSmallRegularLabel: UILabel {
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
 - Background    ->     Default
 - TextColor        ->     Black Color
 - Border            ->      Default
 - Font                ->     Font light 12
            
 */

class SmallMediumFontLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.font = AppTheme.Fontmedium(size: 12).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class SecondarySmallHeaderLabel: UILabel {
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
 - Background    ->     Default
 - TextColor        ->     Black Color
 - Border            ->      Default
 - Font                ->     Font light 12
            
 */

class SmallInactiveMediumFontLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .InactiveTextColor
        self.font = AppTheme.Fontmedium(size: 12).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class SmallInactiveFontLabel: UILabel {
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
 - Background    ->     Default
 - TextColor        ->     Black Color
 - Border            ->      Default
 - Font                ->     Font light 14
            
 */

class RegularLabelLargeText: UILabel {
    
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
 - Background    ->     Default
 - TextColor        ->     Black Color
 - Border            ->      Default
 - Font                ->     Font light 14
            
 */

class InvertedRegularLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .PrimaryTextColor
        self.font = AppTheme.Fontlight(size: 16).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                ->      Label
 - Background    ->     Default
 - TextColor        ->     Black Color
 - Border            ->      Default
 - Font                ->     Font medium 16
 */

class SubHeaderLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.font = AppTheme.Fontmedium(size: 16).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                ->      Label
 - Background    ->     Default
 - TextColor        ->     Black Color
 - Border            ->      Default
 - Font                ->     Font medium 16
 */

class SmallHeaderLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.font = AppTheme.Fontmedium(size: 14).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                ->      Label
 - Background    ->     Default
 - TextColor        ->     White Color
 - Border            ->      Default
 - Font                ->     Font medium 14
 */
class InvertedSmallHeaderLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .PrimaryTextColor
        self.font = AppTheme.Fontmedium(size: 14).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                ->      Label
 - Background    ->     Default
 - TextColor        ->     White Color
 - Border            ->      Default
 - Font                ->     Font medium 16
 */

class InvertedSubHeaderLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .PrimaryTextColor
        self.font = AppTheme.Fontmedium(size: 16).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class ThemeLargeLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .ThemeTextColor
        self.font = AppTheme.Fontbold(size: 35).font //.BoldFont(size: 35)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                ->      Label
 - Background    ->     Default
 - TextColor        ->     Black Color
 - Border            ->      Default
 - Font                ->     Font medium 16
 */

class CommonTextFieldLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.font = AppTheme.Fontmedium(size: 15).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}


/**
 - note:
 - Type                ->      Label
 - Background    ->     Default
 - TextColor        ->     Theme Color
 - Border            ->      Default
 - Font                ->      Font medium 12
 */

class ThemeColoredHintLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .ThemeTextColor
        self.font = AppTheme.Fontmedium(size: 12).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      Label
 - Background    ->     Default
 - TextColor        ->     Theme Color
 - Border            ->      Default
 - Font                ->      Font medium 12
 */

class ThemeColoredHeaderLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .ThemeTextColor
        self.font = AppTheme.Fontmedium(size: 16).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                ->      Label
 - Background    ->     Default
 - TextColor        ->     Theme Color
 - Border            ->      Default
 - Font                ->      Font medium 12
 */

class ThemeColorBgNormalLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .PrimaryTextColor
        self.backgroundColor = .PrimaryColor
        self.font = AppTheme.Fontmedium(size: 16).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                ->      Label
 - Background    ->     Default
 - TextColor        ->     Theme Color
 - Border            ->      Default
 - Font                ->      Font medium 16
 */

class ThemeColoredNormalLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .ThemeTextColor
        self.font = AppTheme.Fontmedium(size: 16).font
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      ImageView
 - Background    ->     Default
 - Tint Color        ->     Theme Color
 */
class ThemeColorTintImageView : UIImageView {
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
 - Background    ->     Default
 - Tint Color        ->     White Color
 */
class InvertedColorTintImageView : UIImageView {
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
 - Tint Color        ->     Default
 */
class ThemeColoredImageView : UIImageView {
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
 - Tint Color        ->     Default
 */
class InvertedColorImageView : UIImageView {
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
 - Background    ->     Black Color
 - Tint Color        ->     Default
 */
class IndicatorImageView : UIImageView {
    func customColorsUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = isdarkStyle ? .DarkModeTextColor : .IndicatorColor
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                ->      ImageView
 - Background    ->     Default
 - Tint Color        ->     Theme Color
 - Border Color    ->    Theme Color
 */
class ThemeBorderedImageView : UIImageView {
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
 - Background    ->     Default
 - Tint Color        ->     Theme Color
 - Border Color    ->    Theme Color
 */
class InvertedBorderedImageView : UIImageView {
    func customColorsUpdate() {
        self.border(width: 1,
                    color: .TertiaryColor)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class PromoLineLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .PromoColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}



//MARK:- ***** CollectionView *****
class CommonCollectionView: UICollectionView {
    func customColorsUpdate() {
        self.tintColor = .PrimaryColor
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = isdarkStyle ? .DarkModeBackground : .SecondaryColor

        } else {
            // Fallback on earlier versions
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customColorsUpdate()
    }
}
