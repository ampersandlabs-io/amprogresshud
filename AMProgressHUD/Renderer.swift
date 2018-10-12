//
//  CircularSpinner.swift
//  Shack15
//
//  Created by Drew Barnes on 07/10/2018.
//  Copyright © 2018 Ampersand Technologies Ltd. All rights reserved.
//

import UIKit

internal class Renderer: UIView {

    @IBOutlet weak var spinner: Spinner!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    
    func animate() {
        spinner.animate()
    }

    class func fromNib() -> Renderer {
        let bundle = Bundle(for: Renderer.self)
        return bundle.loadNibNamed(
            String(describing: Renderer.self), owner: nil, options: nil
        )!.first! as! Renderer // swiftlint:disable:this force_cast

    }

}
