enum CanvasTool {
  pen,
  pencil,
  brush,
  marker,
  highlighter,
  eraser,
  laser,
  select,
  pan,
  line,
  arrow,
  rectangle,
  circle,
  triangle,
  polygon,
  star,
  text,
  image,
  sticker;

  bool get isDrawingStroke =>
      this == CanvasTool.pen ||
      this == CanvasTool.pencil ||
      this == CanvasTool.brush ||
      this == CanvasTool.marker ||
      this == CanvasTool.highlighter ||
      this == CanvasTool.laser;

  bool get isShape =>
      this == CanvasTool.line ||
      this == CanvasTool.arrow ||
      this == CanvasTool.rectangle ||
      this == CanvasTool.circle ||
      this == CanvasTool.triangle ||
      this == CanvasTool.polygon ||
      this == CanvasTool.star;
}
