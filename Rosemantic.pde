import processing.pdf.*;
import controlP5.*;

ControlP5 cp5;

public color backgroundColor = color(0);

public PVector origin = new PVector(780, 350);

public boolean recordPDF = false;
public int fileNum = 0;
public String fileName = "rose";
public int num = 1;

public boolean shouldRandomize = false;

public int repetitions = 0;
public int actualSelectedRepetitions = 0;

public float minRay = 1;
public float maxRay = 150;

public float minAngle = 0;
public float maxAngle = 180;

public float minRed1 = 0;
public float maxRed1 = 255;
public float minGreen1 = 0;
public float maxGreen1 = 255;
public float minBlue1 = 0;
public float maxBlue1 = 255;

public float minRed2 = 0;
public float maxRed2 = 255;
public float minGreen2 = 0;
public float maxGreen2 = 255;
public float minBlue2 = 0;
public float maxBlue2 = 255;

public PVector[] vectors1 = new PVector[repetitions];
public PVector[] vectors2 = new PVector[repetitions];
public PVector[] vectors3 = new PVector[repetitions];

/*
public float red1 = 0;
 public float green1 = 0;
 public float blue1 = 0;
 
 public float red2 = 0;
 public float green2 = 0;
 public float blue2 = 0;
 */

public color[] colors1 = new color[repetitions];
public color[] colors2 = new color[repetitions];

public float alpha = 255;

public int blending = BLEND;

void setup() {
  size(1200, 700, OPENGL);
  background(backgroundColor);

  cp5 = new ControlP5(this);

  Button buttonLoad = cp5.addButton("load")
    .setPosition(10, 10)
      .setSize(140, 20)
        ;
  buttonLoad.getCaptionLabel().align( CENTER, CENTER);

  Button buttonSave = cp5.addButton("save")
    .setPosition(170, 10)
      .setSize(140, 20)
        ;
  buttonSave.getCaptionLabel().align( CENTER, CENTER);

  Slider sliderRepetitions = cp5.addSlider("repetitions")
    .setPosition(10, 50)
      .setSize(300, 15)
        .setRange(1, 100)
          .setValue(50)
            ;

  Range rangeRay = cp5.addRange("ray")
    // disable broadcasting since setRange and setRangeValues will trigger an event
    .setBroadcast(false) 
      .setPosition(10, 70)
        .setSize(300, 15)
          .setHandleSize(20)
            .setRange(minRay, maxRay)
              .setRangeValues(minRay, maxRay)
                // after the initialization we turn broadcast back on again
                .setBroadcast(true)
                  ;

  Range range = cp5.addRange("angle")
    // disable broadcasting since setRange and setRangeValues will trigger an event
    .setBroadcast(false) 
      .setPosition(10, 90)
        .setSize(300, 15)
          .setHandleSize(20)
            .setRange(minAngle, maxAngle)
              .setRangeValues(minAngle, maxAngle)
                // after the initialization we turn broadcast back on again
                .setBroadcast(true)
                  ;

  Range rangeRed1 = cp5.addRange("red1")
    // disable broadcasting since setRange and setRangeValues will trigger an event
    .setBroadcast(false) 
      .setPosition(10, 120)
        .setSize(300, 15)
          .setHandleSize(20)
            .setRange(0, 255)
              .setRangeValues(0, 255)
                // after the initialization we turn broadcast back on again
                .setBroadcast(true)
                  ;

  Range rangeGreen1 = cp5.addRange("green1")
    // disable broadcasting since setRange and setRangeValues will trigger an event
    .setBroadcast(false) 
      .setPosition(10, 140)
        .setSize(300, 15)
          .setHandleSize(20)
            .setRange(0, 255)
              .setRangeValues(0, 255)
                // after the initialization we turn broadcast back on again
                .setBroadcast(true)
                  ;

  Range rangeBlue1 = cp5.addRange("blue1")
    // disable broadcasting since setRange and setRangeValues will trigger an event
    .setBroadcast(false) 
      .setPosition(10, 160)
        .setSize(300, 15)
          .setHandleSize(20)
            .setRange(0, 255)
              .setRangeValues(0, 255)
                // after the initialization we turn broadcast back on again
                .setBroadcast(true)
                  ;

  Range rangeRed2 = cp5.addRange("red2")
    // disable broadcasting since setRange and setRangeValues will trigger an event
    .setBroadcast(false) 
      .setPosition(10, 190)
        .setSize(300, 15)
          .setHandleSize(20)
            .setRange(0, 255)
              .setRangeValues(0, 255)
                // after the initialization we turn broadcast back on again
                .setBroadcast(true)
                  ;

  Range rangeGreen2 = cp5.addRange("green2")
    // disable broadcasting since setRange and setRangeValues will trigger an event
    .setBroadcast(false) 
      .setPosition(10, 210)
        .setSize(300, 15)
          .setHandleSize(20)
            .setRange(0, 255)
              .setRangeValues(0, 255)
                // after the initialization we turn broadcast back on again
                .setBroadcast(true)
                  ;

  Range rangeBlue2 = cp5.addRange("blue2")
    // disable broadcasting since setRange and setRangeValues will trigger an event
    .setBroadcast(false) 
      .setPosition(10, 230)
        .setSize(300, 15)
          .setHandleSize(20)
            .setRange(0, 255)
              .setRangeValues(0, 255)
                // after the initialization we turn broadcast back on again
                .setBroadcast(true)
                  ;

  Slider sliderAlpha = cp5.addSlider("alpha")
    .setPosition(10, 260)
      .setSize(300, 15)
        .setRange(0, 1)
          .setValue(1)
            ;

  DropdownList dropdownBlending = cp5.addDropdownList("blending")
    .setPosition(10, 300)
      .setSize(300, 165)
        .setItemHeight(15)
          .setBarHeight(15)
            .actAsPulldownMenu(true)
              ;

  dropdownBlending.setIndex(0);

  dropdownBlending.addItem("BLEND", BLEND);
  dropdownBlending.addItem("ADD", ADD);
  dropdownBlending.addItem("SUBTRACT", SUBTRACT);
  dropdownBlending.addItem("DARKEST", DARKEST);
  dropdownBlending.addItem("LIGHTEST", LIGHTEST);
  //dropdownBlending.addItem("DIFFERENCE", DIFFERENCE);
  dropdownBlending.addItem("EXCLUSION", EXCLUSION);
  dropdownBlending.addItem("MULTIPLY", MULTIPLY);
  dropdownBlending.addItem("SCREEN", SCREEN);
  dropdownBlending.addItem("REPLACE", REPLACE);

  Button buttonRandomize = cp5.addButton("randomize")
    .setPosition(10, 465)
      .setSize(140, 70)
        ;
  buttonRandomize.getCaptionLabel().align(CENTER, CENTER);

  Slider sliderNum = cp5.addSlider("num")
    .setPosition(170, 465)
      .setSize(140, 20)
        .setRange(1, 100)
          .setValue(1)
            ;

  Button buttonPdf = cp5.addButton("export_pdf")
    .setPosition(170, 490)
      .setSize(140, 20)
        ;
  buttonPdf.getCaptionLabel().align( CENTER, CENTER);

  Button buttonSvg = cp5.addButton("export_svg")
    .setPosition(170, 515)
      .setSize(140, 20)
        ;
  buttonSvg.getCaptionLabel().align( CENTER, CENTER);

  Textlabel labelBackground = cp5.addTextlabel("label")
    .setText("BACKGROUND COLOR")
      .setPosition(10, 615)
        ;

  ColorPicker cpBackground = cp5.addColorPicker("background")
    .setPosition(10, 630)
      .setSize(300, 15)
        .setColorValue(backgroundColor)
          ;
}


void draw() {
  background(backgroundColor);
  fill(color(30, 30, 30));
  rect(0, 0, 360, 700);
  if (shouldRandomize) {
    randomizeVectors();
    shouldRandomize = false;
  }
  drawVectors();
}

void controlEvent(ControlEvent event) {
  // min and max values are stored in an array.
  // access this array with controller().arrayValue().
  // min is at index 0, max is at index 1.
  if (event.isFrom("ray")) {
    minRay = int(event.getController().getArrayValue(0));
    maxRay = int(event.getController().getArrayValue(1));
  } else if (event.isFrom("angle")) {
    minAngle = int(event.getController().getArrayValue(0));
    maxAngle = int(event.getController().getArrayValue(1));
  } else if (event.isFrom("red1")) {
    minRed1 = int(event.getController().getArrayValue(0));
    maxRed1 = int(event.getController().getArrayValue(1));
  } else if (event.isFrom("green1")) {
    minGreen1 = int(event.getController().getArrayValue(0));
    maxGreen1 = int(event.getController().getArrayValue(1));
  } else if (event.isFrom("blue1")) {
    minBlue1 = int(event.getController().getArrayValue(0));
    maxBlue1 = int(event.getController().getArrayValue(1));
  } else if (event.isFrom("red2")) {
    minRed2 = int(event.getController().getArrayValue(0));
    maxRed2 = int(event.getController().getArrayValue(1));
  } else if (event.isFrom("green2")) {
    minGreen2 = int(event.getController().getArrayValue(0));
    maxGreen2 = int(event.getController().getArrayValue(1));
  } else if (event.isFrom("blue2")) {
    minBlue2 = int(event.getController().getArrayValue(0));
    maxBlue2 = int(event.getController().getArrayValue(1));
  } else if (event.isFrom("background")) {
    int r = int(event.getArrayValue(0));
    int g = int(event.getArrayValue(1));
    int b = int(event.getArrayValue(2));
    int a = int(event.getArrayValue(3));
    backgroundColor = color(r, g, b, a);
  } else if (event.isGroup() && event.name().equals("blending")) {
    blending = (int) event.group().value();
  }
}

void load() {
  cp5.loadProperties(("parameters.properties"));
}

void save() {
  cp5.saveProperties(("parameters.properties"));
}

void repetitions(int number) {
  actualSelectedRepetitions = number;
}

void alpha(float number) {
  alpha = map(number, 0.0, 1.0, 0, 255);
}

void randomize() {
  vectors1 = new PVector[actualSelectedRepetitions];
  vectors2 = new PVector[actualSelectedRepetitions];
  vectors3 = new PVector[actualSelectedRepetitions];
  colors1 = new color[actualSelectedRepetitions];
  colors2 = new color[actualSelectedRepetitions];
  shouldRandomize = true;
  repetitions = actualSelectedRepetitions;
}

void num(int number) {
  num =  number;
}

void export_pdf() {
  for (int i = 0; i < num; i++) {
    PGraphics pdf = createGraphics(600, 600, PDF, fileName + "-" + (fileNum + 1) + ".pdf");
    pdf.beginDraw();

    pdf.noStroke();
    pdf.blendMode(blending);
    for (int k = 0; k < repetitions; k++) {
      pdf.fill(colors1[k], alpha);
      pdf.triangle(300, 300, 300 + vectors1[k].x, 300 + vectors1[k].y, 300 + vectors3[k].x, 300 + vectors3[k].y);
      pdf.fill(colors2[k], alpha);
      pdf.triangle(300, 300, 300 + vectors2[k].x, 300 + vectors2[k].y, 300 + vectors3[k].x, 300 + vectors3[k].y);
    }

    pdf.dispose();
    pdf.endDraw();

    fileNum++;
    if (num > 1) {
      randomizeVectors();
    }
  }
}

void export_svg() {
  for (int i = 0; i < num; i++) {

    StringBuffer sb = new StringBuffer();
    sb.append("<?xml version=\"1.0\" standalone=\"no\"?>\n");
    sb.append("<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">\n");
    sb.append("<svg viewBox=\"0 0 600 600\" xmlns=\"http://www.w3.org/2000/svg\" version =\"1.1\">\n");
    for (int k = 0; k < repetitions; k++) {
      sb.append(
      "  <polygon points=\"300,300 " + (300 + vectors1[k].x) + "," + (300 + vectors1[k].y) + " " + (300 + vectors3[k].x) + "," + (300 + vectors3[k].y)
        + "\" fill=\"#" + hex(colors1[k], 6) + "\" "
        + "style=\"opacity:" + map(alpha, 0, 255, 0, 1) + "\""
        + "/>" + "\n"
        );
      sb.append(
      "  <polygon points=\"300,300 " + (300 + vectors2[k].x) + "," + (300 + vectors2[k].y) + " " + (300 + vectors3[k].x) + "," + (300 + vectors3[k].y)
        + "\" fill=\"#" + hex(colors2[k], 6) + "\" "
        + "style=\"opacity:" + map(alpha, 0, 255, 0, 1) + "\""
        + "/>" + "\n"
        );
    }
    sb.append("</svg>\n");

    String[] lines = new String[1];
    lines[0] = sb.toString();
    saveStrings(fileName + "-" + (fileNum + 1) + ".svg", lines);

    fileNum++;
    if (num > 1) {
      randomizeVectors();
    }
  }
}

void randomizeVectors() {
  for (int k = 0; k < repetitions; k++) {

    // set vecto1 (x1, y1)
    float angle1 = random(0, 360);
    PVector vector1 = PVector.fromAngle(radians(angle1));
    vector1.setMag(random(minRay, maxRay));

    float angle2 = angle1 + random(minAngle, maxAngle);
    PVector vector2 = PVector.fromAngle(radians(angle2));
    vector2.setMag(random(minRay, maxRay));

    vectors1[k] = vector1;
    vectors2[k] = vector2;
    vectors3[k] = PVector.add(vector1, vector2);

    //red1 = random(minRed1, maxRed1);
    //green1 = random(minGreen1, maxGreen1);
    //blue1 = random(minBlue1, maxBlue1);
    colors1[k] = color(random(minRed1, maxRed1), random(minGreen1, maxGreen1), random(minBlue1, maxBlue1));

    //red2 = random(minRed2, maxRed2);
    //green2 = random(minGreen2, maxGreen2);
    //blue2 = random(minBlue2, maxBlue2);
    colors2[k] = color(random(minRed2, maxRed2), random(minGreen2, maxGreen2), random(minBlue2, maxBlue2));
  }
}

void drawVectors() {
  noStroke();
  blendMode(blending);
  for (int k = 0; k < repetitions; k++) {
    //fill(red1, green1, blue1, alpha);
    fill(colors1[k], alpha);
    triangle(origin.x, origin.y, origin.x + vectors1[k].x, origin.y + vectors1[k].y, origin.x + vectors3[k].x, origin.y + vectors3[k].y);
    //fill(red2, green2, blue2, alpha);
    fill(colors2[k], alpha);
    triangle(origin.x, origin.y, origin.x + vectors2[k].x, origin.y + vectors2[k].y, origin.x + vectors3[k].x, origin.y + vectors3[k].y);
  }
  blendMode(BLEND);
}

