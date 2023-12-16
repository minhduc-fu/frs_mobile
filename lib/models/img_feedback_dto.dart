class ImgFeedbackDTO {
  int feedBackImgID;
  String imgUrl;

  ImgFeedbackDTO({
    required this.feedBackImgID,
    required this.imgUrl,
  });

  factory ImgFeedbackDTO.fromJson(Map<String, dynamic> json) {
    return ImgFeedbackDTO(
      feedBackImgID: json['feedBackImgID'],
      imgUrl: json['imgUrl'],
    );
  }
}
