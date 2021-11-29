import UIKit

class HabitDetailsTableViewCell: UITableViewCell {
    
    var dateLabel: UILabel = {
        var dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstarints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstarints()
    }
}

private extension HabitDetailsTableViewCell {
    
    func setupConstarints() {
        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 11),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -11)
        ])
    }
}
