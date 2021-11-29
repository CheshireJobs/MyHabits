import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
     var habit: Habit? {
        didSet {
            nameLabel.text = habit?.name
            nameLabel.textColor = habit?.color
            dateStringLabel.text = habit?.dateString
            trackDatesLabel.text = "Счетчик: \(habit?.trackDates.count ?? 0)"
            trackTodayImageView.tintColor = habit?.color
            if ((habit?.isAlreadyTakenToday) == true) {
                trackTodayImageView.image = UIImage.init(systemName: "checkmark.circle.fill")
            } else {
             trackTodayImageView.image = UIImage.init(systemName: "circle")
            }
        }
    }
    var delegate: HabitCollectionViewCellDelegate?
    
    private var nameLabel: UILabel = {
        var nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 2
        return nameLabel
    }()
    private var dateStringLabel: UILabel = {
        var dateStringLabel = UILabel()
        dateStringLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        dateStringLabel.translatesAutoresizingMaskIntoConstraints = false
        dateStringLabel.textColor = .systemGray
        return dateStringLabel
    }()
    private var trackDatesLabel: UILabel = {
        var trackDatesLabel = UILabel()
        trackDatesLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        trackDatesLabel.translatesAutoresizingMaskIntoConstraints = false
        trackDatesLabel.textColor = .systemGray
        return trackDatesLabel
    }()
    var trackTodayImageView: UIImageView = {
        var trackTodayImageView = UIImageView()
        trackTodayImageView.translatesAutoresizingMaskIntoConstraints = false
        trackTodayImageView.layer.cornerRadius = 38/2
        trackTodayImageView.isUserInteractionEnabled = true
        return trackTodayImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        backgroundColor = .white
        self.layer.cornerRadius = 8
        
        let tapTrackHabitGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTapTrackHabitGesture)
        )
        trackTodayImageView.addGestureRecognizer(tapTrackHabitGesture)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
    }
}

protocol HabitCollectionViewCellDelegate {
    func updateData()
}

private extension HabitCollectionViewCell {
    
    @objc func handleTapTrackHabitGesture(gesture: UITapGestureRecognizer) {
        if(habit?.isAlreadyTakenToday == false) {
            HabitsStore.shared.track(habit!)
            delegate?.updateData()
        }
    }
    
    func setupConstraints() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateStringLabel)
        contentView.addSubview(trackDatesLabel)
        contentView.addSubview(trackTodayImageView)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: trackTodayImageView.leadingAnchor, constant: -40),
            
            dateStringLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            dateStringLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            trackDatesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            trackDatesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            trackTodayImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            trackTodayImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            trackTodayImageView.heightAnchor.constraint(equalToConstant: 38),
            trackTodayImageView.widthAnchor.constraint(equalTo: trackTodayImageView.heightAnchor)
        ])
    }
}
