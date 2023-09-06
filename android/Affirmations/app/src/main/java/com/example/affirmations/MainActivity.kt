package com.example.affirmations

import android.content.Context
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.Image
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Alignment.Companion.CenterHorizontally
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.RectangleShape
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.example.affirmations.data.Datasource
import com.example.affirmations.model.Affirmation
import com.example.affirmations.ui.theme.AffirmationsTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            AffirmationsTheme {
                // A surface container using the 'background' color from the theme
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    val affirmations = Datasource().loadAffirmations()
                    LazyColumn(Modifier.fillMaxSize()){
                        items(affirmations) {
                            AffirmationView(it,
                                this@MainActivity,
                                        Modifier.padding(all = 5.dp)
                                                .fillMaxWidth()
                                                .border(width = 2.dp,
                                                        color = MaterialTheme.colorScheme.secondary,
                                                        shape = RectangleShape)
                            )
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun AffirmationView(data: Affirmation, context: Context, modifier: Modifier = Modifier) {
    Column(modifier = modifier) {
        Image(painter = painterResource(id = data.imageResourceId),
            contentDescription = "picture",
            contentScale = ContentScale.Crop,
            modifier = Modifier.align(CenterHorizontally)
                .fillMaxWidth()
                .height(194.dp)
        )

        Spacer(modifier = Modifier.size(5.dp))
        Text(
            text = context.getString(data.stringResourceId),
            modifier = Modifier.padding(start = 10.dp, bottom = 3.dp)
        )
    }
}

@Composable
fun Greeting(name: String, modifier: Modifier = Modifier) {
    Text(
        text = "Hello $name!",
        modifier = modifier
    )
}

@Preview(showBackground = true)
@Composable
fun GreetingPreview() {
    AffirmationsTheme {
        Greeting("Android")
    }
}