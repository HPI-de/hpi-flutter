package de.hpi.android

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

class MainActivity : FlutterActivity() {
    companion object {
        private const val FEEDBACK_LOG_LINES_MAX = 2000
        private const val FEEDBACK_LOG_READ_CMD = "logcat -b main,system,crash,events -t $FEEDBACK_LOG_LINES_MAX -v threadtime printable"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        MethodChannel(flutterView, "feedback").setMethodCallHandler { call, result ->
            when (call.method) {
                "getLog" -> {
                    GlobalScope.launch(Dispatchers.Main) {
                        Runtime.getRuntime().exec(FEEDBACK_LOG_READ_CMD)
                                .inputStream
                                .bufferedReader()
                                .use {
                                    result.success(it.readText())
                                }
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
