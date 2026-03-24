package com.filmfilter.app

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import com.filmfilter.app.ui.MainScreen
import com.filmfilter.app.ui.theme.FilmFilterTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            FilmFilterTheme {
                MainScreen()
            }
        }
    }
}
