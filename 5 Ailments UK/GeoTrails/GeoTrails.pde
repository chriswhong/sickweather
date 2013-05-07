// GeoTrails.pde
// (c) 2012 David Troy (@davetroy)
//
// Simple sketch to allow visualization of simple geo-based trails through time.
// Currently ingests a csv file of tweets in the format of:
// screen_name,timestamp,lat,lon
// and displays them as geo trails on a basemap (specified in this file)
// Trails are displayed with a persistence-of-vision effect and gradually fade out.
// The sketch is rendered at a target frame rate of 30fps and each frame loads
// a certain number of seconds worth of tweets to display (currently 287 seconds).
// The sketch will stop running when it runs out of tweets.

PImage mapImage;
PImage logo;
MercatorMap mercatorMap;
PVector lastLoc;
TweetBase db;
Tweet current;
int currentTime;
TrailSystem trailSystem;
PFont legendFont, legendFont2, legendFont3, legendFont4, legendFont5;

 int cx, cy;
float secondsRadius;
float minutesRadius;
float hoursRadius;
float clockDiameter;

float heatmap[][][] = new float[2][1280][720];
int heatindex = 0; 
 
  int radius = 75;
  int tintamount = 50;
  String monthstring;
  
     int ccCount = 0;
  int fluCount = 0;
  int stCount = 0;
  int mfCount = 0;
  int cofCount = 0;

void setup() {
  size(1280, 720);
  //frameRate(1);
  smooth();

  mapImage = loadImage("uk.png");
    logo = loadImage("logo.png");
  mercatorMap = new MercatorMap(1280, 720, 
  59.15, 49.849, -17.85, 10.64);

  legendFont = createFont("HelveticaNeue-Bold", 24);
  legendFont2 = createFont("HelveticaNeue-Light", 24);
    legendFont3 = createFont("HelveticaNeue-Light", 75);
    legendFont4 = createFont("HelveticaNeue-Light", 55);
       legendFont5 = createFont("HelveticaNeue-Light", 180);
 //tint(100 , 100, 100);
  lastLoc = new PVector(0, 0);
  image(mapImage, 0, 0, width, height);

  db = new TweetBase();
  current = db.get(0);
  currentTime = current.timestamp;

  trailSystem = new TrailSystem();
  





}
void draw() 
{
  
  
  // draw the base map
  
  tint(tintamount);
  image(mapImage, 0, 0, width, height);
  tint(255);

  // grab tweets for this time interval
 currentTime += 7200;
 ArrayList<Tweet> newTweets = db.tweetsThrough(currentTime);

  trailSystem.addTweets(newTweets);

  trailSystem.draw();




  // generate formatted date
  int offsetTime = currentTime + 14400;
  Date time = new java.util.Date((long)offsetTime*1000);
  DateFormat df = new SimpleDateFormat("EEEE MM/dd/yyyy HH:mm");
  String reportDate = df.format(time);
  DateFormat minsFormat = new SimpleDateFormat("m");
  String mins = minsFormat.format(time);
  int minsint = Integer.parseInt(mins);
   DateFormat hoursFormat = new SimpleDateFormat("h");
  String hours = hoursFormat.format(time);
  int hoursint = Integer.parseInt(hours);
  DateFormat apFormat = new SimpleDateFormat("a");
  String ap = apFormat.format(time);
  
    DateFormat monthFormat = new SimpleDateFormat("M");
  String mmonth = monthFormat.format(time);
  DateFormat yearFormat = new SimpleDateFormat("y");
  String yyear = yearFormat.format(time);
  DateFormat dayFormat = new SimpleDateFormat("d");
  String dday = dayFormat.format(time);  
  
 
  

  // draw the legends
   // draw the legends
  image(logo,30,30, 269  ,153);
  fill(255, 255);
  //text(tweets.size(), 30, 25);
  textFont(legendFont);
  //text("SickWeather Common Cold", 30, 40);
  textFont(legendFont2);
  //text("Active Bikes: " + trailSystem.size(), 600, 40);
    //text(currentTime,30,70);
  //text(reportDate, 30, 70);
   textAlign(CENTER);
   text("UK Sickness Map",160,200);

   

  
   textFont(legendFont3);
  //text("Vizualization by @chris_whong", 30, 525);
 
   text("20" + yyear,160,650);
    
  textFont(legendFont5);
  text(dday,160,565);

  
  switch(Integer.parseInt(mmonth)){
  case 1:
    monthstring="January";
    break;
  case 2:
    monthstring="February";
    break;
    case 3:
    monthstring="March";
    break;
  case 4:
    monthstring="April";
    break;
    case 5:
    monthstring="May";
    break;
    case 6:
    monthstring="June";
    break;
    case 7:
    monthstring="July";
    break;
    case 8:
    monthstring="August";
    break;
    case 9:
    monthstring="September";
    break;
    case 10:
    monthstring="October";
    break;
    case 11:
    monthstring="November";
    break;
    case 12:
    monthstring="December";
    break;
  
  }
  
      textFont(legendFont4); 
  text(monthstring,160,400);

  textFont(legendFont5); 
  

  fill(255, 128);
  




  


 //save frames to make a movie later (warning! slow, large disk usage)
  //saveFrame("5ailments/frames####.tiff");


  }
  
  
 


