package mock

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._

import scala.concurrent.duration._
import scala.util.Random
import scala.io.Source

class FeederSimulation extends Simulation {

  val protocol = karateProtocol(
    "/cats/{id}" -> Nil
  )

  private val requester = {
    val fileContents = Source.fromFile("src/test/java/data/login.csv").getLines().mkString
    Iterator.continually(Map("userName" -> fileContents))
  }
  private val approver = {
    val fileContents = Source.fromFile("src/test/java/data/login_approve.csv").getLines().mkString
    Iterator.continually(Map("userName" -> fileContents))
  }

  val feederToKarate = scenario("feederToKarate")
    .exec(karateSet("userName", session => session("userName").as[String]))

  val filterTransaction = scenario("filterTransaction").exec(karateFeature("classpath:rakkar/pt/PT_FilterTransactions.feature"))

  // val read = scenario("read").exec(karateFeature("classpath:mock/cats-chained.feature@name=read")).exec(session => {
  //   println("*** id in gatling: " + session("id").as[String])
  //   println("*** session status in gatling: " + session.status)
  //   session
  // })

  val createAndRead = scenario("createAndRead").group("createAndRead") {
    feed(requester)
      .exec(feederToKarate)
      .exec(filterTransaction)
      // for demo: injecting a new variable name expected by the 'read' feature
      .exec(karateSet("expectedName", session => session("userName").as[String]))
      // .exec(read)
  }

  setUp(
    createAndRead.inject(rampUsers(10) during (5 seconds)).protocols(protocol)
  ).assertions(details("createAndRead").failedRequests.percent.is(0))

}
