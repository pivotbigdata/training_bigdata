import org.apache.spark.mllib.recommendation.ALS
import org.apache.spark.mllib.recommendation.Rating
import org.apache.spark.SparkConf
import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.rdd._

object MovieLensALS {

  def main(args: Array[String]) {

    import org.apache.log4j._
    Logger.getLogger("org").setLevel(Level.ERROR)

    val conf = new SparkConf().setAppName("MovieLensALS").setMaster("local[*]")

    val sc = new SparkContext(conf)

    val rawData = sc.textFile("/Users/Training/u.data")

    //rawData.first()

    val rawRatings = rawData.map(_.split("\t").take(3))

    val ratings = rawRatings.map { case Array(user, movie, rating) => Rating(user.toInt, movie.toInt, rating.toDouble) }

    //ratings.first()

    //train the data:-


    val model = ALS.train(ratings, 50, 5, 0.01)

    model.userFeatures

    model.userFeatures.count

    model.productFeatures.count

    val predictedRating = model.predict(196, 242)

    println("Predicted Rating for the user 196 and Item 242:" +predictedRating)

    val userId = 308
    val K = 10
    val topKRecs = model.recommendProducts(userId, K)


    println("The TOP 10 Recommendation for the USERID 308")
    println(topKRecs.mkString("\n"))

    val movies = sc.textFile("/Users/sampy/Desktop/Sampy's_desk/Training/SparkScala@Technogeeks/ml-100k/u.item")
    val titles = movies.map(line => line.split("\\|").take(2)).map(array => (array(0).toInt, array(1))).collectAsMap()
    println("Title Name for the ID:123"+titles(123))

    val moviesForUser = ratings.keyBy(_.user).lookup(789)
    println("==========================================")
    println(moviesForUser)
    println("==========================================")

    println("Total number of movie data available"+moviesForUser.size)
    println("Watched Movies")
    // moviesForUser.sortBy(-_.rating).take(10).map(rating => (titles(rating.product), rating.rating)).foreach(println)
    moviesForUser.sortBy(-_.rating).map(rating => (titles(rating.product),rating.rating)).foreach(x => println("Watched Movie:->"+x))
    println()
    println("Recommended Movies")
    topKRecs.sortBy(-_.rating).map(rating => (titles(rating.product),rating.rating)).foreach(x => println("Recommended Movie:->"+x))


  }

}