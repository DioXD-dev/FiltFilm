package com.filmfilter.app.filter

import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.ColorMatrix
import android.graphics.ColorMatrixColorFilter
import android.graphics.Paint

object FilterEngine {

    /**
     * Terapkan filter ke [source] bitmap dengan [intensity] (0..1).
     * intensity=0 → foto asli, intensity=1 → efek penuh.
     */
    fun applyFilter(source: Bitmap, filter: FilmFilter, intensity: Float): Bitmap {
        val output = source.copy(Bitmap.Config.ARGB_8888, true)
        val canvas = Canvas(output)
        val paint  = Paint(Paint.ANTI_ALIAS_FLAG)

        val blended = interpolateMatrix(FilmFilters.IDENTITY, filter.matrix, intensity)
        paint.colorFilter = ColorMatrixColorFilter(ColorMatrix(blended))
        canvas.drawBitmap(source, 0f, 0f, paint)

        return output
    }

    /** Interpolasi linear antara dua ColorMatrix */
    private fun interpolateMatrix(from: FloatArray, to: FloatArray, t: Float): FloatArray =
        FloatArray(20) { i -> from[i] + (to[i] - from[i]) * t }
}
