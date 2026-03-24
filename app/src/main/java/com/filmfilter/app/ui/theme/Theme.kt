package com.filmfilter.app.ui.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

private val DarkColors = darkColorScheme(
    primary      = FilmGold,
    background   = FilmBlack,
    surface      = FilmDark,
    onPrimary    = FilmBlack,
    onBackground = Color.White,
    onSurface    = Color.White,
)

@Composable
fun FilmFilterTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = DarkColors,
        typography  = Typography,
        content     = content
    )
}
