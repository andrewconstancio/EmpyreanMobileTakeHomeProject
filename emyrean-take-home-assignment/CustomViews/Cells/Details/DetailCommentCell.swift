//
//  DetailCommentCell.swift
//  empyrean-take-home-assignment
//
//  Created by Andrew Constancio on 6/1/25.
//
import UIKit

class DetailCommentCell: UICollectionViewCell {
    
    static let identifier = "DetailCommentCell"
    
    private var commentAuthorLabel = EMTitleLabel(textAlignment: .left, fontSize: 14)
    
    private var commentDateLabel = EMTitleLabel(textAlignment: .left, fontSize: 10)
    
    private var commentMessage = UILabel()
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Set time zone if needed
        return formatter
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCommentMessage()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        let padding: CGFloat = 8
        
        addSubviews(commentAuthorLabel, commentDateLabel, commentMessage)
        
        layer.cornerRadius = 8
        backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            commentAuthorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            commentAuthorLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            
            commentDateLabel.leadingAnchor.constraint(equalTo: commentAuthorLabel.trailingAnchor, constant: padding),
            commentDateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            
            commentMessage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            commentMessage.topAnchor.constraint(equalTo: commentAuthorLabel.bottomAnchor, constant: padding),
            commentMessage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            commentMessage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
    }
    
    func set(comment: ItemComment) {
        commentAuthorLabel.text = comment.author
        commentMessage.text = comment.message
        if let date = formatter.date(from: comment.timestamp) {
            formatter.dateFormat = "MMM d, yyyy h:mm a"
            let formattedString = formatter.string(from: date)
            commentDateLabel.text = "\(formattedString)"
        }
    }
    
    func setupCommentMessage() {
        commentMessage.translatesAutoresizingMaskIntoConstraints = false
        commentMessage.font = UIFont.preferredFont(forTextStyle: .body)
        commentMessage.adjustsFontSizeToFitWidth = true
        commentMessage.minimumScaleFactor = 0.75
        commentMessage.numberOfLines = 0
        commentMessage.font = UIFont.systemFont(ofSize: 12)
    }
}

