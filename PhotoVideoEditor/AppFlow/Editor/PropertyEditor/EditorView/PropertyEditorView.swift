//
//  PropertyEditorView.swift
//  PhotoVideoEditor
//
//  Created by Dmitriy Levkutnyk on 26.04.2022.
//

import UIKit

class PropertyEditorView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var propertyTableView: UITableView!
    
    private let heightOfSinglePropertyEditor: CGFloat = 95.0
    var propertyEditor: PropertyEditor!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let nib = UINib(nibName: "PropertyEditorView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        setup()
    }
    
    private func setup() {
        let propertyTableViewCellNib = UINib(nibName: "PropertySetupTableViewCell", bundle: nil)
        propertyTableView.register(propertyTableViewCellNib, forCellReuseIdentifier: "PropertySetupCell")
        propertyTableView.delegate = self
        propertyTableView.dataSource = self
    }
    
    func reload() {
        propertyTableView.reloadData()
    }
    
}

extension PropertyEditorView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return propertyEditor.properties.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertySetupCell") as! PropertySetupTableViewCell
        cell.setup(withProperty: propertyEditor.properties[indexPath.row])
        cell.valueChangeCompletion = { [weak self] property in
            guard let self = self else { return }
            self.propertyEditor.currentlyChangedProperty = property
        }
        return cell
    }

}

extension PropertyEditorView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfSinglePropertyEditor
    }
}
