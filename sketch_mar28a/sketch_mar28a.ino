float sintable[100];
void setup() {
}

void loop() {
  float time = millis()/1000.0f; // seconds

  float voltage = sin(400*PI*time)+1;

  analogWrite(0, voltage*256);
}
