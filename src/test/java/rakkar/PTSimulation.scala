package rakkar;

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._

import scala.concurrent.duration._
import scala.util.Random

class PTSimulation extends Simulation {
    val protocol = karateProtocol()

    protocol.nameResolver = (req, ctx) => req.getHeader("karate-name")
    protocol.runner.karateEnv("perf")

    val openAPI = scenario("openAPI").exec(karateFeature("classpath:rakkar/feature/pt/PT_OpenAPI.feature"))
    // val helpCenter = scenario("helpCenter").exec(karateFeature("classpath:rakkar/feature/HelpCenter.feature"))

    setUp(
        openAPI.inject(rampUsers(1) during (10 seconds), nothingFor(2 seconds)).protocols(protocol),

        // helpCenter.inject(rampUsers(1) during (10 seconds), nothingFor(2 seconds)).protocols(protocol)

    )
}