package rakkar.pt

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._

import scala.concurrent.duration._
import scala.util.Random
import scala.io.Source

class FeederSimulation extends Simulation {

  val protocol = karateProtocol()

  protocol.nameResolver = (req, ctx) => req.getHeader("karate-name")

  val requester = csv("src/test/java/data/login.csv").circular

  val scn = scenario("FeedSimulation").exec {
              feed(requester)
              .exec(karateSet("requesterUserName", session => session("userName").as[String]))
              .exec(karateFeature("classpath:rakkar/pt/PT_FilterTransactions.feature"))
            }
            
  setUp(
    scn.inject(rampUsers(1) during (1 seconds))
  ).protocols(protocol)
}
