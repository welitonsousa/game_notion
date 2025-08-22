extension StringExt on String {
  String get imageURL {
    return 'https://images.igdb.com/igdb/image/upload/t_original/$this.jpg';
  }

  String get imageThumbURL {
    return 'https://images.igdb.com/igdb/image/upload/t_thumb/$this.jpg';
  }

  String get imageCoverURL {
    return 'https://images.igdb.com/igdb/image/upload/t_cover_big/$this.jpg';
  }

  String get imageLogoURL {
    return 'https://images.igdb.com/igdb/image/upload/t_logo_med/$this.png';
  }

  String get ytURL {
    return 'https://www.youtube.com/watch?v=$this';
  }

  String get ytThumbURL {
    return 'https://img.youtube.com/vi/$this/hqdefault.jpg';
  }
}
