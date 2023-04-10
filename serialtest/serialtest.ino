#define mySerial Serial6 // RX, TX
unsigned char data[4]={};
float distance;

void setup()
{
 Serial.begin(115200);
 mySerial.begin(9600); 
}

void loop()
{
  Serial.println(mySerial.available());

  do{
     for(int i=0;i<4;i++)
     {
       data[i]=mySerial.read();
     }
  }while(mySerial.read()==0xff);


  Serial.println(data[0]);
  Serial.println(data[1]);
  Serial.println(data[2]);
  Serial.println(data[3]);
  Serial.println();
  

  mySerial.clear();

  if(data[0]==0xff)
    {
      int sum;
      sum=(data[0]+data[1]+data[2])&0x00FF;
      if(sum==data[3])
      {
        distance=(data[1]<<8)+data[2];
        if(distance>30)
          {
           Serial.print("distance=");
           Serial.print(distance/10);
           Serial.println("cm");
          }else 
             {
               Serial.println("Below the lower limit");
             }
      } else Serial.println("ERROR");
     }
     delay(100);
}