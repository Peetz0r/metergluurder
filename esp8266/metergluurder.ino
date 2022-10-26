#include <SoftwareSerial.h>
#include <WiFiClient.h>
#include <WiFiSettings.h>
#include <LittleFS.h>
#include <MQTT.h>

#define SOFTSERIAL_RX D1 // arduino 10
#define SOFTSERIAL_TX D2 // arduino A7

SoftwareSerial arduino = SoftwareSerial(SOFTSERIAL_RX, SOFTSERIAL_TX, false);

WiFiClient wificlient;
MQTTClient mqtt;

String mqtt_host;
int mqtt_port;
String mqtt_topic;

void setup () {
  Serial.begin(74880);
  arduino.begin(9600);

  pinMode(SOFTSERIAL_RX, INPUT);
  pinMode(SOFTSERIAL_TX, OUTPUT);


  WiFiSettings.hostname = "metergluurder-";

  LittleFS.begin();
  WiFiSettings.begin();
  mqtt_host   = WiFiSettings.string("mqtt_server", "mqtt.peetz0r.nl", "MQTT server ip/host");
  mqtt_port   = WiFiSettings.integer("mqtt_port", 0, 65535, 1883, "MQTT server port");
  mqtt_topic  = WiFiSettings.string("mqtt_topic", WiFiSettings.hostname, "MQTT topic");

  //~ WiFiSettings.portal();

  Serial.println("Connecting to Wifi");
  if(WiFiSettings.connect()) {
    Serial.println("Connected to Wifi");
  } else {
    Serial.println("Failed, restarting");
    ESP.restart();
  }

  mqtt.begin(mqtt_host.c_str(), mqtt_port, wificlient);
}

void loop() {
  unsigned long start = millis();

  if (!mqtt.connected()) {
    Serial.println("Connecting to MQTT");
    static int failures = 0;
    if (mqtt.connect("")) {
      Serial.println("Connected to MQTT");
      failures = 0;
    } else {
      failures++;
      if (failures >= 5) {
        Serial.println("Failed, restarting");
        ESP.restart();
      }
    }
  }

  mqtt.loop();
  delay(10); // https://github.com/256dpi/arduino-mqtt#notes

  char data[4];
  if(arduino.available() >= 5) {
    while(char a = arduino.read() != 0) {
      Serial.print("Ignore: ");
      Serial.println(a, DEC);
    }
    for(int i = 0; i < 4; i++) {
      data[i] = arduino.read();
    }

    double W = *(float *) data;
    Serial.print("Power: ");
    Serial.print(W);
    Serial.println(" W");
    mqtt.publish(String(mqtt_topic), String(W), true, 0);
  }
}
