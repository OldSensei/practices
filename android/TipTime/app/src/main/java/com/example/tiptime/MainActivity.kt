package com.example.tiptime

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Alignment.Companion.CenterVertically
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.RectangleShape
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.example.tiptime.ui.theme.TipTimeTheme
import java.text.NumberFormat


class MainActivity : ComponentActivity() {
    @OptIn(ExperimentalMaterial3Api::class)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            TipTimeTheme {
                // A surface container using the 'background' color from the theme
                Surface(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(all = 16.dp),
                    color = MaterialTheme.colorScheme.background
                ) {
                    Column( modifier = Modifier
                        .fillMaxSize()
                        .padding(top = 10.dp),
                        verticalArrangement = Arrangement.Top,
                        horizontalAlignment = Alignment.Start
                    ) {

                        var serviceCostText by remember { mutableStateOf("") }

                        OutlinedTextField(
                            value = serviceCostText,
                            onValueChange = { serviceCostText = it },
                            label = { Text( text = getString(R.string.cost_of_service) ) },
                            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
                        )

                        Text(text = getString(R.string.service_question))

                        val tipOptions = listOf<String>(
                            getString(R.string.amazing_opt),
                            getString(R.string.good_opt),
                            getString(R.string.okay_opt)
                        )
                        var selectedOption by remember { mutableStateOf(0) }

                        repeat(tipOptions.size) { idx ->
                            Row(modifier = Modifier.fillMaxWidth(),
                                verticalAlignment = CenterVertically,
                                horizontalArrangement = Arrangement.Start
                            ) {
                                RadioButton(selected = (idx == selectedOption),
                                    onClick = { selectedOption = idx }
                                )
                                Text(text = tipOptions[idx])
                            }
                        }
                        Spacer(modifier = Modifier.size(5.dp))

                        var isRoundUp by remember { mutableStateOf(true) }

                        Row(modifier = Modifier.fillMaxWidth(),
                            verticalAlignment = CenterVertically,
                            horizontalArrangement = Arrangement.SpaceBetween
                        ){
                            Text(text = getString(R.string.roundup_switch))


                            Switch(checked = isRoundUp,
                                onCheckedChange = { isRoundUp = it}
                            )
                        }
                        var tipAmount by remember{ mutableStateOf(getString(R.string.tip_amount, "")) }

                        Button(
                            modifier = Modifier.fillMaxWidth(),
                            shape = RectangleShape,
                            onClick = {
                                val costOpt: Double? = serviceCostText.toDoubleOrNull()
                                if (costOpt == null) {
                                    tipAmount = getString(R.string.tip_amount, "")
                                    return@Button
                                }

                                val cost: Double =  costOpt.toDouble()

                                val tipPercentage: Double = when(selectedOption) {
                                    0 -> 0.20
                                    1 -> 0.18
                                    else -> 0.15
                                }

                                val tip = calculateTip(cost, tipPercentage, isRoundUp)
                                val formattedTip = NumberFormat.getCurrencyInstance().format(tip)
                                tipAmount = getString(R.string.tip_amount, formattedTip)
                            }
                        ) {
                            Text(text = getString(R.string.calc_button))
                        }

                        Text(
                            modifier = Modifier.fillMaxWidth(),
                            textAlign = TextAlign.Right,
                            text = tipAmount)
                    }

                }
            }
        }
    }

    private fun calculateTip(cost: Double, tipPercentage: Double, toRoundUp: Boolean = true): Double {
        var tip = cost * tipPercentage
        if (toRoundUp) {
            tip = kotlin.math.ceil(tip)
        }

        return tip
    }
}