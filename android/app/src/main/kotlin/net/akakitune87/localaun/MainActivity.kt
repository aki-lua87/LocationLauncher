package net.akakitune87.localaun

import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Canvas
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class MainActivity : FlutterActivity() {
    private val CHANNEL = "net.akakitune87.localaun/apps"
    private var pendingSharedUrl: String? = null
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel = channel
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getInstalledApps" -> result.success(getInstalledApps())
                "getAppIcon" -> {
                    val packageName = call.argument<String>("packageName") ?: ""
                    result.success(getAppIcon(packageName))
                }
                "launchApp" -> {
                    val packageName = call.argument<String>("packageName") ?: ""
                    result.success(launchApp(packageName))
                }
                "getSharedUrl" -> {
                    result.success(pendingSharedUrl)
                    pendingSharedUrl = null
                }
                else -> result.notImplemented()
            }
        }

        // Flutter起動後に共有URLがあれば送信
        pendingSharedUrl?.let { url ->
            channel.invokeMethod("onSharedUrl", url)
            pendingSharedUrl = null
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleShareIntent(intent)
    }

    override fun onResume() {
        super.onResume()
        handleShareIntent(intent)
    }

    private fun handleShareIntent(intent: Intent?) {
        if (intent?.action == Intent.ACTION_SEND && intent.type == "text/plain") {
            val url = intent.getStringExtra(Intent.EXTRA_TEXT) ?: return
            val channel = methodChannel
            if (channel != null) {
                channel.invokeMethod("onSharedUrl", url)
            } else {
                pendingSharedUrl = url
            }
            // 同じintentを二度処理しない
            intent.action = null
        }
    }

    private fun getInstalledApps(): List<Map<String, String>> {
        val pm = packageManager
        val intent = Intent(Intent.ACTION_MAIN, null).apply {
            addCategory(Intent.CATEGORY_LAUNCHER)
        }
        val resolveInfos = pm.queryIntentActivities(intent, 0)
        return resolveInfos
            .filter { it.activityInfo.packageName != packageName }
            .map { info ->
                mapOf(
                    "packageName" to info.activityInfo.packageName,
                    "appName" to info.loadLabel(pm).toString()
                )
            }
            .sortedBy { it["appName"] }
    }

    private fun getAppIcon(packageName: String): ByteArray? {
        return try {
            val pm = packageManager
            val drawable = pm.getApplicationIcon(packageName)
            val width = drawable.intrinsicWidth.coerceIn(1, 192)
            val height = drawable.intrinsicHeight.coerceIn(1, 192)
            val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
            val canvas = Canvas(bitmap)
            drawable.setBounds(0, 0, width, height)
            drawable.draw(canvas)
            val stream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.PNG, 90, stream)
            stream.toByteArray()
        } catch (e: Exception) {
            null
        }
    }

    private fun launchApp(packageName: String): Boolean {
        return try {
            val intent = packageManager.getLaunchIntentForPackage(packageName)
                ?: return false
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
            true
        } catch (e: Exception) {
            false
        }
    }
}
