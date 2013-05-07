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
PFont legendFont, legendFont2, legendFont3;




  
  int radius = 75;
  int tintamount = 50;

void setup() {
  size(1280, 720);
  //frameRate(1);
  smooth();

  mapImage = loadImage("uk.png");
  mercatorMap = new MercatorMap(1280, 720, 
  59.15, 49.849, -18.495, 10.64);

  legendFont = createFont("HelveticaNeue-Bold", 24);
  legendFont2 = createFont("HelveticaNeue-Light", 18);
    legendFont3 = createFont("HelveticaNeue-Light", 10);
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
  //image(logo,40,375, 125,126);


  // grab tweets for this time interval
 currentTime += 10800;
 
 println(currentTime);
text(currentTime, 30, 200);

 ArrayList<Tweet> newTweets = db.tweetsThrough(currentTime);




  fill(255, 255);
  //text(tweets.size(), 30, 25);
  textFont(legendFont);
  //text("newTweets Size:", 30, 100);
  //text(newTweets.size(), 210,100);

  // stop if there are no more tweets to display

  // add new tweets and draw the trails
  

 
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
  

  // draw the legends
  fill(255, 255);
  //text(tweets.size(), 30, 25);
  textFont(legendFont);
  text("Boston Hubway Data Visualization", 30, 40);
  textFont(legendFont2);
  text("Active Bikes: " + trailSystem.size(), 600, 40);
    //text(currentTime,30,70);
  text(reportDate, 30, 70);
   textFont(legendFont3);
  text("Vizualization by @chris_whong", 30, 525);
  
  

  

  fill(255, 128);
  




  


 //save frames to make a movie later (warning! slow, large disk usage)
  //saveFrame("output/frames####.tiff");


  }

