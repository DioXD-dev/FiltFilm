#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════
#  FilmFilter – Android Photo Editor with Film Simulation Filters
#  Setup script: jalankan dari folder kosong di Termux
# ═══════════════════════════════════════════════════════════════════════
set -e

PKG="com.filmfilter.app"
PKG_PATH="com/filmfilter/app"

echo "🎞️  Creating FilmFilter project..."

mkdir -p app/src/main/java/$PKG_PATH/ui/theme
mkdir -p app/src/main/java/$PKG_PATH/filter
mkdir -p app/src/main/java/$PKG_PATH/viewmodel
mkdir -p app/src/main/res/values
mkdir -p app/src/main/res/mipmap-anydpi-v26
mkdir -p app/src/main/res/drawable
mkdir -p .github/workflows
mkdir -p gradle/wrapper

echo "📝 Writing build configs..."

# ── settings.gradle.kts ─────────────────────────────────────────────────
cat > settings.gradle.kts << 'ENDOFFILE'
pluginManagement {
    repositories {
        google {
            content {
                includeGroupByRegex("com\\.android.*")
                includeGroupByRegex("com\\.google.*")
                includeGroupByRegex("androidx.*")
            }
        }
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}
rootProject.name = "FilmFilter"
include(":app")
ENDOFFILE

# ── build.gradle.kts (root) ─────────────────────────────────────────────
cat > build.gradle.kts << 'ENDOFFILE'
plugins {
    id("com.android.application") version "8.2.2" apply false
    id("org.jetbrains.kotlin.android") version "1.9.22" apply false
}
ENDOFFILE

# ── gradle.properties ───────────────────────────────────────────────────
cat > gradle.properties << 'ENDOFFILE'
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.useAndroidX=true
kotlin.code.style=official
android.nonTransitiveRClass=true
ENDOFFILE

# ── gradle-wrapper.properties ───────────────────────────────────────────
cat > gradle/wrapper/gradle-wrapper.properties << 'ENDOFFILE'
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.6-bin.zip
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
ENDOFFILE

# ── app/build.gradle.kts ────────────────────────────────────────────────
cat > app/build.gradle.kts << 'ENDOFFILE'
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.filmfilter.app"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.filmfilter.app"
        minSdk = 29
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    buildFeatures {
        compose = true
    }

    composeOptions {
        kotlinCompilerExtensionVersion = "1.5.8"
    }
}

dependencies {
    val composeBom = platform("androidx.compose:compose-bom:2024.02.00")
    implementation(composeBom)

    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.7.0")
    implementation("androidx.activity:activity-compose:1.8.2")
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.ui:ui-graphics")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.lifecycle:lifecycle-viewmodel-compose:2.7.0")
}
ENDOFFILE

touch app/proguard-rules.pro

# ── AndroidManifest.xml ─────────────────────────────────────────────────
cat > app/src/main/AndroidManifest.xml << 'ENDOFFILE'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.FilmFilter">
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:windowSoftInputMode="adjustResize">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
ENDOFFILE

# ── Resources ────────────────────────────────────────────────────────────
cat > app/src/main/res/values/strings.xml << 'ENDOFFILE'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">FilmFilter</string>
</resources>
ENDOFFILE

cat > app/src/main/res/values/themes.xml << 'ENDOFFILE'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="Theme.FilmFilter" parent="android:Theme.Material.Light.NoActionBar">
        <item name="android:windowBackground">#0A0A0A</item>
        <item name="android:statusBarColor">#0A0A0A</item>
        <item name="android:navigationBarColor">#0A0A0A</item>
    </style>
</resources>
ENDOFFILE

cat > app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml << 'ENDOFFILE'
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@drawable/ic_launcher_background"/>
    <foreground android:drawable="@drawable/ic_launcher_foreground"/>
</adaptive-icon>
ENDOFFILE

cat > app/src/main/res/mipmap-anydpi-v26/ic_launcher_round.xml << 'ENDOFFILE'
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@drawable/ic_launcher_background"/>
    <foreground android:drawable="@drawable/ic_launcher_foreground"/>
</adaptive-icon>
ENDOFFILE

cat > app/src/main/res/drawable/ic_launcher_background.xml << 'ENDOFFILE'
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android">
    <solid android:color="#0A0A0A"/>
</shape>
ENDOFFILE

cat > app/src/main/res/drawable/ic_launcher_foreground.xml << 'ENDOFFILE'
<?xml version="1.0" encoding="utf-8"?>
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <path
        android:fillColor="#E8D5B0"
        android:pathData="M54,18 C54,18 80,42 80,58 C80,72 68,86 54,86 C40,86 28,72 28,58 C28,42 54,18 54,18 Z"/>
    <circle android:fillColor="#0A0A0A" cx="54" cy="58" r="10"/>
</vector>
ENDOFFILE

echo "🎨 Writing theme files..."

# ── Color.kt ─────────────────────────────────────────────────────────────
cat > app/src/main/java/$PKG_PATH/ui/theme/Color.kt << 'ENDOFFILE'
package com.filmfilter.app.ui.theme

import androidx.compose.ui.graphics.Color

val FilmBlack   = Color(0xFF0A0A0A)
val FilmDark    = Color(0xFF141414)
val FilmSurface = Color(0xFF1E1E1E)
val FilmGold    = Color(0xFFE8D5B0)
val FilmGray    = Color(0xFF888888)
ENDOFFILE

# ── Type.kt ──────────────────────────────────────────────────────────────
cat > app/src/main/java/$PKG_PATH/ui/theme/Type.kt << 'ENDOFFILE'
package com.filmfilter.app.ui.theme

import androidx.compose.material3.Typography
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.sp

val Typography = Typography(
    bodyLarge = TextStyle(
        fontFamily    = FontFamily.Default,
        fontWeight    = FontWeight.Normal,
        fontSize      = 16.sp,
        lineHeight    = 24.sp,
        letterSpacing = 0.5.sp
    )
)
ENDOFFILE

# ── Theme.kt ─────────────────────────────────────────────────────────────
cat > app/src/main/java/$PKG_PATH/ui/theme/Theme.kt << 'ENDOFFILE'
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
ENDOFFILE

echo "🎞️  Writing filter engine..."

# ── FilmFilter.kt ─────────────────────────────────────────────────────────
cat > app/src/main/java/$PKG_PATH/filter/FilmFilter.kt << 'ENDOFFILE'
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
ENDOFFILE

# ── FilterEngine.kt ───────────────────────────────────────────────────────
cat > app/src/main/java/$PKG_PATH/filter/FilterEngine.kt << 'ENDOFFILE'
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
ENDOFFILE

echo "🧠 Writing ViewModel..."

# ── MainViewModel.kt ──────────────────────────────────────────────────────
cat > app/src/main/java/$PKG_PATH/viewmodel/MainViewModel.kt << 'ENDOFFILE'
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
ENDOFFILE

echo "🖼️  Writing UI (MainScreen)..."

# ── MainScreen.kt ─────────────────────────────────────────────────────────
cat > app/src/main/java/$PKG_PATH/ui/MainScreen.kt << 'ENDOFFILE'
package com.filmfilter.app.ui

import android.net.Uri
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.detectHorizontalDragGestures
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Slider
import androidx.compose.material3.SliderDefaults
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.drawWithContent
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.filmfilter.app.filter.FilmFilter
import com.filmfilter.app.filter.FilmFilters
import com.filmfilter.app.ui.theme.FilmBlack
import com.filmfilter.app.ui.theme.FilmDark
import com.filmfilter.app.ui.theme.FilmGold
import com.filmfilter.app.ui.theme.FilmGray
import com.filmfilter.app.ui.theme.FilmSurface
import com.filmfilter.app.viewmodel.MainViewModel
import kotlinx.coroutines.launch
import kotlin.math.roundToInt

// ═══════════════════════════════════════════════════════════════════════
//  MainScreen
// ═══════════════════════════════════════════════════════════════════════

@Composable
fun MainScreen(viewModel: MainViewModel = viewModel()) {
    val context       = LocalContext.current
    val snackbarState = remember { SnackbarHostState() }
    val scope         = rememberCoroutineScope()

    val launcher = rememberLauncherForActivityResult(
        ActivityResultContracts.GetContent()
    ) { uri: Uri? -> uri?.let { viewModel.loadImage(context, it) } }

    LaunchedEffect(viewModel.saveSuccess) {
        viewModel.saveSuccess?.let { ok ->
            scope.launch {
                snackbarState.showSnackbar(
                    if (ok) "✓ Foto tersimpan di Galeri/FilmFilter" else "✗ Gagal menyimpan foto"
                )
            }
            viewModel.resetSaveStatus()
        }
    }

    Box(Modifier.fillMaxSize().background(FilmBlack)) {

        Column(Modifier.fillMaxSize()) {

            // ── Top Bar ───────────────────────────────────────────────
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 20.dp, vertical = 14.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment     = Alignment.CenterVertically
            ) {
                Column {
                    Text(
                        "FilmFilter",
                        color        = FilmGold,
                        fontSize     = 22.sp,
                        fontWeight   = FontWeight.Bold,
                        letterSpacing = 2.sp
                    )
                    Text(
                        "Film Simulation",
                        color        = FilmGray,
                        fontSize     = 10.sp,
                        letterSpacing = 1.5.sp
                    )
                }
                Button(
                    onClick = { launcher.launch("image/*") },
                    colors  = ButtonDefaults.buttonColors(containerColor = FilmSurface),
                    shape   = RoundedCornerShape(10.dp),
                    contentPadding = PaddingValues(horizontal = 16.dp, vertical = 10.dp)
                ) {
                    Text("Buka Foto", color = FilmGold, fontSize = 13.sp)
                }
            }

            // ── Image Preview ─────────────────────────────────────────
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .weight(1f)
                    .background(Color(0xFF050505)),
                contentAlignment = Alignment.Center
            ) {
                val orig = viewModel.originalBitmap
                val proc = viewModel.processedBitmap
                if (orig != null && proc != null) {
                    BeforeAfterPreview(
                        original       = orig,
                        filtered       = proc,
                        showComparison = viewModel.selectedFilter != null
                    )
                } else {
                    EmptyState { launcher.launch("image/*") }
                }
                if (viewModel.isProcessing) {
                    CircularProgressIndicator(
                        color    = FilmGold,
                        modifier = Modifier.size(40.dp)
                    )
                }
            }

            // ── Filter Name Banner (ketika ada filter terpilih) ───────
            if (viewModel.selectedFilter != null) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .background(Color(0xFF0F0F0F))
                        .padding(horizontal = 20.dp, vertical = 6.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Text(
                        viewModel.selectedFilter!!.name,
                        color      = FilmGold,
                        fontSize   = 13.sp,
                        fontWeight = FontWeight.SemiBold,
                        letterSpacing = 1.sp
                    )
                    Text(
                        viewModel.selectedFilter!!.description,
                        color    = FilmGray,
                        fontSize = 11.sp
                    )
                }
            }

            // ── Filter Carousel ───────────────────────────────────────
            LazyRow(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(FilmDark)
                    .padding(vertical = 14.dp),
                contentPadding        = PaddingValues(horizontal = 16.dp),
                horizontalArrangement = Arrangement.spacedBy(14.dp)
            ) {
                items(FilmFilters.all) { filter ->
                    FilterChip(
                        filter   = filter,
                        selected = viewModel.selectedFilter?.id == filter.id,
                        onClick  = { viewModel.applyFilter(filter) }
                    )
                }
            }

            // ── Intensity Slider ──────────────────────────────────────
            if (viewModel.selectedFilter != null) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .background(FilmDark)
                        .padding(horizontal = 20.dp, vertical = 4.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        "Intensitas",
                        color    = FilmGray,
                        fontSize = 12.sp,
                        modifier = Modifier.width(72.dp)
                    )
                    Slider(
                        value    = viewModel.intensity,
                        onValueChange         = { viewModel.setIntensity(it) },
                        onValueChangeFinished = { viewModel.applyWithCurrentIntensity() },
                        valueRange = 0f..1f,
                        colors     = SliderDefaults.colors(
                            thumbColor         = FilmGold,
                            activeTrackColor   = FilmGold,
                            inactiveTrackColor = FilmSurface
                        ),
                        modifier = Modifier.weight(1f)
                    )
                    Text(
                        "${(viewModel.intensity * 100).roundToInt()}%",
                        color     = FilmGold,
                        fontSize  = 12.sp,
                        textAlign = TextAlign.End,
                        modifier  = Modifier.width(40.dp)
                    )
                }
            }

            // ── Save Button ───────────────────────────────────────────
            if (viewModel.processedBitmap != null && viewModel.selectedFilter != null) {
                Button(
                    onClick  = { viewModel.saveToGallery(context) },
                    colors   = ButtonDefaults.buttonColors(containerColor = FilmGold),
                    shape    = RoundedCornerShape(0.dp),
                    modifier = Modifier.fillMaxWidth().height(56.dp)
                ) {
                    Text(
                        "Simpan ke Galeri",
                        color         = FilmBlack,
                        fontSize      = 15.sp,
                        fontWeight    = FontWeight.Bold,
                        letterSpacing = 0.5.sp
                    )
                }
            }
        }

        // Snackbar
        SnackbarHost(
            hostState = snackbarState,
            modifier  = Modifier.align(Alignment.BottomCenter)
        )
    }
}

// ═══════════════════════════════════════════════════════════════════════
//  Before / After Preview – geser handle kiri-kanan untuk perbandingan
// ═══════════════════════════════════════════════════════════════════════

@Composable
fun BeforeAfterPreview(
    original: android.graphics.Bitmap,
    filtered: android.graphics.Bitmap,
    showComparison: Boolean
) {
    if (!showComparison) {
        // Tampilkan foto asli saja (belum ada filter)
        Image(
            bitmap             = original.asImageBitmap(),
            contentDescription = null,
            contentScale       = ContentScale.Fit,
            modifier           = Modifier.fillMaxSize()
        )
        return
    }

    var divider by remember { mutableFloatStateOf(0.5f) }

    BoxWithConstraints(
        modifier = Modifier
            .fillMaxSize()
            .pointerInput(Unit) {
                detectHorizontalDragGestures { change, delta ->
                    change.consume()
                    divider = (divider + delta / size.width).coerceIn(0.04f, 0.96f)
                }
            }
    ) {
        val w = maxWidth

        // Original (kanan / background)
        Image(
            bitmap             = original.asImageBitmap(),
            contentDescription = "Original",
            contentScale       = ContentScale.Fit,
            modifier           = Modifier.fillMaxSize()
        )

        // Filtered (kiri, di-clip sampai posisi divider)
        Image(
            bitmap             = filtered.asImageBitmap(),
            contentDescription = "Filtered",
            contentScale       = ContentScale.Fit,
            modifier           = Modifier
                .fillMaxSize()
                .drawWithContent {
                    clipRect(right = size.width * divider) {
                        this@drawWithContent.drawContent()
                    }
                }
        )

        // Garis pembatas vertikal
        Box(
            modifier = Modifier
                .width(2.dp)
                .fillMaxHeight()
                .offset(x = w * divider - 1.dp)
                .background(Color.White.copy(alpha = 0.85f))
        )

        // Handle geser (lingkaran putih di tengah garis)
        Box(
            modifier = Modifier
                .size(36.dp)
                .align(Alignment.CenterStart)
                .offset(x = w * divider - 18.dp)
                .background(Color.White, CircleShape),
            contentAlignment = Alignment.Center
        ) {
            Text("⇔", fontSize = 14.sp, color = Color.Black, fontWeight = FontWeight.Bold)
        }

        // Label AFTER (kiri = filtered)
        Text(
            "AFTER",
            color         = FilmGold,
            fontSize      = 10.sp,
            letterSpacing = 1.sp,
            fontWeight    = FontWeight.SemiBold,
            modifier      = Modifier.align(Alignment.TopStart).padding(10.dp)
        )
        // Label BEFORE (kanan = original)
        Text(
            "BEFORE",
            color         = Color.White.copy(alpha = 0.65f),
            fontSize      = 10.sp,
            letterSpacing = 1.sp,
            modifier      = Modifier.align(Alignment.TopEnd).padding(10.dp)
        )
    }
}

// ═══════════════════════════════════════════════════════════════════════
//  Filter Chip
// ═══════════════════════════════════════════════════════════════════════

@Composable
fun FilterChip(filter: FilmFilter, selected: Boolean, onClick: () -> Unit) {
    // Warna gradien sesuai karakter tiap filter
    val gradientColors = when (filter.id) {
        "velvia"         -> listOf(Color(0xFFE84B3A), Color(0xFF4CAF50))
        "provia"         -> listOf(Color(0xFFD4A96A), Color(0xFF5BA0B5))
        "classic_chrome" -> listOf(Color(0xFF7A8B9A), Color(0xFF9A8A70))
        "leica"          -> listOf(Color(0xFF101010), Color(0xFFD5D5D5))
        else             -> listOf(Color(0xFF444444), Color(0xFF888888))
    }

    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        modifier            = Modifier.clickable(onClick = onClick)
    ) {
        Box(
            modifier = Modifier
                .size(64.dp)
                .clip(RoundedCornerShape(10.dp))
                .background(Brush.linearGradient(gradientColors))
                .then(
                    if (selected)
                        Modifier.border(2.dp, FilmGold, RoundedCornerShape(10.dp))
                    else
                        Modifier
                )
        ) {
            if (selected) {
                Box(
                    modifier = Modifier
                        .align(Alignment.BottomCenter)
                        .fillMaxWidth()
                        .background(Color.Black.copy(alpha = 0.55f))
                        .padding(vertical = 3.dp),
                    contentAlignment = Alignment.Center
                ) {
                    Text("✓", color = FilmGold, fontSize = 12.sp, fontWeight = FontWeight.Bold)
                }
            }
        }
        Spacer(Modifier.height(6.dp))
        Text(
            filter.name,
            color      = if (selected) FilmGold else Color.White,
            fontSize   = 11.sp,
            fontWeight = if (selected) FontWeight.Bold else FontWeight.Normal,
            textAlign  = TextAlign.Center
        )
        Text(
            filter.brand,
            color     = FilmGray,
            fontSize  = 9.sp,
            textAlign = TextAlign.Center
        )
    }
}

// ═══════════════════════════════════════════════════════════════════════
//  Empty State
// ═══════════════════════════════════════════════════════════════════════

@Composable
fun EmptyState(onOpen: () -> Unit) {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center,
        modifier            = Modifier.fillMaxSize().clickable(onClick = onOpen)
    ) {
        Text("📷", fontSize = 52.sp)
        Spacer(Modifier.height(16.dp))
        Text("Tap untuk membuka foto", color = FilmGray, fontSize = 16.sp)
        Spacer(Modifier.height(6.dp))
        Text(
            "Terapkan filter film klasik",
            color    = Color(0xFF505050),
            fontSize = 12.sp
        )
        Spacer(Modifier.height(24.dp))
        Box(
            modifier = Modifier
                .background(FilmSurface, RoundedCornerShape(8.dp))
                .padding(horizontal = 20.dp, vertical = 10.dp)
        ) {
            Text("Buka Galeri", color = FilmGold, fontSize = 13.sp)
        }
    }
}
ENDOFFILE

echo "📱 Writing MainActivity..."

# ── MainActivity.kt ───────────────────────────────────────────────────────
cat > app/src/main/java/$PKG_PATH/MainActivity.kt << 'ENDOFFILE'
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
ENDOFFILE

echo "⚙️  Writing GitHub Actions workflow..."

# ── .github/workflows/build.yml ───────────────────────────────────────────
cat > .github/workflows/build.yml << 'ENDOFFILE'
name: Build APK

on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up JDK 17
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'

      - name: Setup Gradle 8.6
        uses: gradle/actions/setup-gradle@v3
        with:
          gradle-version: '8.6'

      - name: Build Debug APK
        run: gradle assembleDebug

      - name: Upload APK artifact
        uses: actions/upload-artifact@v4
        with:
          name: filmfilter-debug-apk
          path: app/build/outputs/apk/debug/*.apk
          retention-days: 14
ENDOFFILE

# ── Final summary ─────────────────────────────────────────────────────────
echo ""
echo "╔═══════════════════════════════════════════════════╗"
echo "║  ✅  FilmFilter project created!                  ║"
echo "╠═══════════════════════════════════════════════════╣"
echo "║                                                   ║"
echo "║  📁 Struktur file:                                ║"
echo "║     app/src/main/java/com/filmfilter/app/         ║"
echo "║     ├── MainActivity.kt                           ║"
echo "║     ├── filter/                                   ║"
echo "║     │   ├── FilmFilter.kt  (4 filter)             ║"
echo "║     │   └── FilterEngine.kt (ColorMatrix)         ║"
echo "║     ├── viewmodel/                                ║"
echo "║     │   └── MainViewModel.kt                      ║"
echo "║     └── ui/                                       ║"
echo "║         ├── MainScreen.kt                         ║"
echo "║         └── theme/ (Color, Type, Theme)           ║"
echo "║                                                   ║"
echo "║  🎞️  Filter tersedia:                             ║"
echo "║     • Velvia      (Fujifilm) – vivid & punchy     ║"
echo "║     • Provia      (Fujifilm) – natural            ║"
echo "║     • Classic Chrome (Fujifilm) – faded           ║"
echo "║     • Leica M     (Leica)    – high contrast      ║"
echo "║                                                   ║"
echo "║  🚀 Langkah selanjutnya:                          ║"
echo "║     git init                                      ║"
echo "║     git add .                                     ║"
echo "║     git commit -m 'Initial: FilmFilter app'       ║"
echo "║     git remote add origin <URL_REPO_KAMU>         ║"
echo "║     git push -u origin main                       ║"
echo "║                                                   ║"
echo "║  → GitHub Actions otomatis build APK-nya!         ║"
echo "╚═══════════════════════════════════════════════════╝"
