package com.example.happybirthday

import Message
import SampleData
import android.content.res.Configuration
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.animateContentSize
import androidx.compose.foundation.Image
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.setValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.example.happybirthday.ui.theme.HappyBirthdayTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            Column{
                Text("The author is ${getString(R.string.author_name)}") // load resource string
                Spacer(modifier = Modifier.width(8.dp))
                HappyBirthdayTheme {
                    Surface(modifier = Modifier.fillMaxSize()) {
                        Conversation(SampleData.conversationSample)
                    }
                }
            }
        }
    }
}

@Composable
fun Conversation(messages: List<Message>) {
    LazyColumn{
        items(messages) { message ->
            MessageCard(message)
        }
    }
}

@Composable
fun MessageCard(msg: Message)
{
    Row(modifier = Modifier.padding(all = 8.dp))
    {
        Image(painter = painterResource(id = R.drawable.sword),
            contentDescription = "the picture of sword",
            modifier = Modifier
                .size(40.dp)
                .clip(CircleShape)
                .border(1.0.dp, MaterialTheme.colorScheme.primary)
        )
        Spacer(modifier = Modifier.width(8.dp))

        var isExpanded by remember { mutableStateOf(false) }

        val surfaceColor by animateColorAsState(
            if (isExpanded) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.surface,
        )

        Column(modifier = Modifier.clickable { isExpanded = !isExpanded })
        {
            Text(
                text = msg.author,
                color = MaterialTheme.colorScheme.secondary,
                style = MaterialTheme.typography.titleSmall
            )
            Spacer(Modifier.height(4.dp))
            Surface(
                shape = MaterialTheme.shapes.medium,
                shadowElevation = 1.dp,
                color = surfaceColor,
                modifier = Modifier.animateContentSize().padding(1.dp)
            ) {
                Text(
                    text = msg.body,
                    modifier = Modifier.padding(all = 4.dp),
                    maxLines = if (isExpanded) Int.MAX_VALUE else 1,
                    style = MaterialTheme.typography.bodyMedium
                )
            }
        }
    }
}

@Preview
@Composable
fun PreviewConversation() {
    HappyBirthdayTheme {
        Conversation(SampleData.conversationSample)
    }
}
@Preview(name = "Light Mode")
@Preview(
    uiMode = Configuration.UI_MODE_NIGHT_YES,
    showBackground = true,
    name = "Dark Mode"
)
@Composable
fun PreviewMessageCard()
{
    HappyBirthdayTheme {
        Surface(modifier = Modifier.fillMaxSize()) {
            MessageCard(
                msg = Message("Lexi", "Hey, take a look at Jetpack Compose")
            )
        }
    }
}
