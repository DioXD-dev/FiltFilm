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
