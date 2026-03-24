package com.filmfilter.app.viewmodel

import android.content.ContentValues
import android.content.Context
import android.graphics.Bitmap
import android.graphics.ImageDecoder
import android.net.Uri
import android.os.Environment
import android.provider.MediaStore
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.filmfilter.app.filter.FilmFilter
import com.filmfilter.app.filter.FilterEngine
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class MainViewModel : ViewModel() {

    var originalBitmap: Bitmap?  by mutableStateOf(null); private set
    var processedBitmap: Bitmap? by mutableStateOf(null); private set
    var selectedFilter: FilmFilter? by mutableStateOf(null)
    var intensity: Float           by mutableFloatStateOf(1f)
    var isProcessing: Boolean      by mutableStateOf(false)
    var saveSuccess: Boolean?      by mutableStateOf(null)

    fun loadImage(context: Context, uri: Uri) {
        viewModelScope.launch(Dispatchers.IO) {
            val bmp = decodeBitmap(context, uri)
            withContext(Dispatchers.Main) {
                originalBitmap  = bmp
                processedBitmap = bmp
                selectedFilter  = null
                intensity       = 1f
            }
        }
    }

    fun applyFilter(filter: FilmFilter) {
        val orig = originalBitmap ?: return
        selectedFilter = filter
        viewModelScope.launch(Dispatchers.IO) {
            withContext(Dispatchers.Main) { isProcessing = true }
            val result = FilterEngine.applyFilter(orig, filter, intensity)
            withContext(Dispatchers.Main) {
                processedBitmap = result
                isProcessing    = false
            }
        }
    }

    /** Update nilai slider (realtime, tanpa re-process) */
    fun setIntensity(value: Float) { intensity = value }

    /** Terapkan filter dengan intensitas terkini (dipanggil saat slider dilepas) */
    fun applyWithCurrentIntensity() { selectedFilter?.let { applyFilter(it) } }

    fun saveToGallery(context: Context) {
        val bmp = processedBitmap ?: return
        viewModelScope.launch(Dispatchers.IO) {
            val filename = "FilmFilter_${System.currentTimeMillis()}.jpg"
            val values = ContentValues().apply {
                put(MediaStore.Images.Media.DISPLAY_NAME, filename)
                put(MediaStore.Images.Media.MIME_TYPE, "image/jpeg")
                put(MediaStore.Images.Media.RELATIVE_PATH,
                    "${Environment.DIRECTORY_PICTURES}/FilmFilter")
            }
            val uri = context.contentResolver.insert(
                MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values
            )
            val ok = uri?.let {
                context.contentResolver.openOutputStream(it)?.use { stream ->
                    bmp.compress(Bitmap.CompressFormat.JPEG, 95, stream)
                }
                true
            } ?: false
            withContext(Dispatchers.Main) { saveSuccess = ok }
        }
    }

    fun resetSaveStatus() { saveSuccess = null }

    private fun decodeBitmap(context: Context, uri: Uri): Bitmap {
        val source = ImageDecoder.createSource(context.contentResolver, uri)
        return ImageDecoder.decodeBitmap(source) { decoder, _, _ ->
            decoder.allocator = ImageDecoder.ALLOCATOR_SOFTWARE
        }
    }
}
