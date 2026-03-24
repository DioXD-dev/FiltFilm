package com.filmfilter.app.filter

data class FilmFilter(
    val id: String,
    val name: String,
    val brand: String,
    val description: String,
    val matrix: FloatArray
) {
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (other !is FilmFilter) return false
        return id == other.id
    }
    override fun hashCode(): Int = id.hashCode()
}

object FilmFilters {

    // Identity – no change
    val IDENTITY = floatArrayOf(
        1f, 0f, 0f, 0f, 0f,
        0f, 1f, 0f, 0f, 0f,
        0f, 0f, 1f, 0f, 0f,
        0f, 0f, 0f, 1f, 0f
    )

    // ── Fujifilm Velvia ─────────────────────────────────────────────────
    // Karakteristik: saturasi tinggi, merah/hijau vivid, bayangan gelap
    private val VELVIA = floatArrayOf(
         1.50f, -0.25f, -0.10f, 0f,  15f,
        -0.10f,  1.40f, -0.10f, 0f,   8f,
        -0.20f, -0.15f,  1.00f, 0f, -10f,
         0f,     0f,     0f,    1f,   0f
    )

    // ── Fujifilm Provia ─────────────────────────────────────────────────
    // Karakteristik: natural, sedikit hangat, seimbang
    private val PROVIA = floatArrayOf(
        1.15f, -0.05f,  0.00f, 0f,  8f,
       -0.03f,  1.10f, -0.03f, 0f,  4f,
        0.00f, -0.05f,  1.08f, 0f,  2f,
        0f,     0f,     0f,    1f,  0f
    )

    // ── Fujifilm Classic Chrome ─────────────────────────────────────────
    // Karakteristik: desaturasi, faded, dokumenter, highlight lifted
    private val CLASSIC_CHROME = floatArrayOf(
        0.65f, 0.20f, 0.05f, 0f, 20f,
        0.05f, 0.75f, 0.10f, 0f, 15f,
        0.10f, 0.15f, 0.65f, 0f, 25f,
        0f,    0f,    0f,    1f,  0f
    )

    // ── Leica M ─────────────────────────────────────────────────────────
    // Karakteristik: kontras tinggi, desaturasi kuat, shadow gelap, dingin
    private val LEICA = floatArrayOf(
        0.45f, 0.35f, 0.20f, 0f, -20f,
        0.15f, 0.65f, 0.20f, 0f, -15f,
        0.10f, 0.20f, 0.55f, 0f, -20f,
        0f,    0f,    0f,    1f,   0f
    )

    val all = listOf(
        FilmFilter("velvia",         "Velvia",         "Fujifilm", "Vivid & punchy",       VELVIA),
        FilmFilter("provia",         "Provia",         "Fujifilm", "Natural & balanced",   PROVIA),
        FilmFilter("classic_chrome", "Classic Chrome", "Fujifilm", "Faded documentary",    CLASSIC_CHROME),
        FilmFilter("leica",          "Leica M",        "Leica",    "High contrast, muted", LEICA),
    )
}
