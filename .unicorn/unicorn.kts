import com.jonaswanke.unicorn.action.*
import com.jonaswanke.unicorn.api.*
import com.jonaswanke.unicorn.api.github.*
import com.jonaswanke.unicorn.core.*
import com.jonaswanke.unicorn.core.ProjectConfig.*
import com.jonaswanke.unicorn.script.*
import com.jonaswanke.unicorn.script.parameters.*
import com.jonaswanke.unicorn.template.*

unicorn {
    gitHubAction {
        when (val event = this.event) {
            is Action.Event.PullRequest -> {
                event.pullRequest.addAuthorAsAssignee()
                event.pullRequest.inferLabels(this)

                runChecks {
                    checkLabels()
                    checkClosedIssues()
                }
            }
        }
    }
}
