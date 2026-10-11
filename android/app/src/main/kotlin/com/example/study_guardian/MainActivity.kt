package com.example.study_guardian

import android.app.AlarmManager
import android.content.Context
import android.os.Build
import android.provider.Settings
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "study_guardian/full_screen"

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine
    ) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "checkExactAlarmPermission" -> {

                    result.success(
                        canScheduleExactAlarms()
                    )
                }

                "requestExactAlarmPermission" -> {

                    requestExactAlarmPermission()

                    result.success(true)
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    // ============================================================
    // CHECK EXACT ALARM PERMISSION
    // ============================================================

    private fun canScheduleExactAlarms(): Boolean {

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
            return true
        }

        val alarmManager =
            getSystemService(
                Context.ALARM_SERVICE
            ) as AlarmManager

        return alarmManager.canScheduleExactAlarms()
    }

    // ============================================================
    // REQUEST EXACT ALARM PERMISSION
    // ============================================================

    private fun requestExactAlarmPermission() {

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
            return
        }

        if (canScheduleExactAlarms()) {

            println("========================================")
            println("EXACT ALARM PERMISSION ALREADY GRANTED")
            println("========================================")

            return
        }

        try {

            val intent = Intent(
                Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM
            )

            intent.data =
                android.net.Uri.parse(
                    "package:$packageName"
                )

            startActivity(intent)

            println("========================================")
            println("OPENED EXACT ALARM PERMISSION SETTINGS")
            println("========================================")

        } catch (e: Exception) {

            println("========================================")
            println("FAILED TO OPEN EXACT ALARM SETTINGS")
            println(e.message)
            println("========================================")
        }
    }
}