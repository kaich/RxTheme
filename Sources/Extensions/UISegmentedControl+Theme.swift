//
//  Created by duan on 2018/3/7.
//  2018 Copyright (c) RxSwiftCommunity. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit
import RxSwift
import RxCocoa


public extension ThemeProxy where Base: UISegmentedControl {

    /// (set only) bind a stream to style
    @available(iOS 13, tvOS 13, *)
    var selectedSegmentTintColor: ThemeAttribute<UIColor> {
        get { return .empty() }
        set {
            if let value = newValue.value {
                base.selectedSegmentTintColor = value
            }
            let disposable = newValue.stream
                .take(until: base.rx.deallocating)
                .observe(on: MainScheduler.instance)
                .bind(to: base.rx.selectedSegmentTintColor)
            hold(disposable, for: "selectedSegmentTintColor")
        }
    }

}
#endif
