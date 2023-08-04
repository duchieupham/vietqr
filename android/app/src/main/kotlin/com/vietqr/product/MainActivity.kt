package com.vietqr.product

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Build
import android.os.Bundle
import androidx.annotation.RequiresApi
import com.google.zxing.BinaryBitmap
import com.google.zxing.MultiFormatReader
import com.google.zxing.RGBLuminanceSource
import com.google.zxing.ReaderException
import com.google.zxing.common.HybridBinarizer
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.io.IOException
import java.util.*


class MainActivity : FlutterActivity() {
    private val CHANNEL = "scan_qr_code"

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        flutterEngine?.dartExecutor?.binaryMessenger?.let {
            MethodChannel(it, CHANNEL).setMethodCallHandler { call, result ->
                if (call.method == "processQRImage") {
                    val args = call.arguments as Map<*, *>
                    val base64Image = args?.get("imageData") as? String
                    if (base64Image != null) {
                        val imageBytes = Base64.getDecoder().decode(base64Image)
                        val bitmap = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)

                        if (bitmap != null) {
                            val qrCode = decodeQRCode(bitmap)
                            result.success(qrCode) // (Optional) Trả về kết quả nếu cần
                        } else {
                            result.success("-1")
                        }
                    }

                } else {
                    result.notImplemented()
                }
            }
        }
    }

    private fun convertXFileToBitmap(xFilePath: String): Bitmap? {
        return try {
            val file = File(xFilePath)
            val fileInputStream = FileInputStream(file)
            val bitmap = BitmapFactory.decodeStream(fileInputStream)
            fileInputStream.close()
            bitmap
        } catch (e: IOException) {
            e.printStackTrace()
            null
        }
    }

    private fun decodeQRCode(bitmap: Bitmap): String? {
        val pixels = IntArray(bitmap.width * bitmap.height)
        bitmap.getPixels(pixels, 0, bitmap.width, 0, 0, bitmap.width, bitmap.height)
        val source = RGBLuminanceSource(bitmap.width, bitmap.height, pixels)
        val binaryBitmap = BinaryBitmap(HybridBinarizer(source))
        val reader = MultiFormatReader()
        return try {
            val result = reader.decode(binaryBitmap)
            result.text
        } catch (e: ReaderException) {
            e.printStackTrace()
            null
        }
    }
}


