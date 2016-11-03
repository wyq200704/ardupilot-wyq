/// -*- tab-width: 4; Mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-

#ifdef USERHOOK_INIT
void userhook_init()
{
    // put your initialisation code here
    // this will be called once at start-up
}
#endif

#ifdef USERHOOK_FASTLOOP
void userhook_FastLoop()
{
    // put your 100Hz code here
}
#endif

#ifdef USERHOOK_50HZLOOP

unsigned char UWB_rectemp[25];
unsigned char count = 0;
unsigned char first_Time;
unsigned char xorCheck=0;
unsigned char rec_state;
unsigned int loopcnt;
void userhook_50Hz()
{
    // put your 50Hz code here
	// put your 100Hz code here
    uint16_t nbytes = hal.uartD->available();
    uint32_t now =  hal.scheduler->millis();
    uint8_t cRev;
    loopcnt++;
    static uint32_t last_time_stamp;

    while(hal.uartD->available()>0)
    {
		cRev = (unsigned char) hal.uartD->read();
		if(count == 0 && cRev==235)
		{
			count = 1;
		}
		else if(count==1&&cRev==144)
		{
			count =2;
		}
		else if(count>=2)
		{
			xorCheck ^=cRev;
			UWB_rectemp[count-2]=cRev;
			count ++;
			if(count==25)
			{
				if(xorCheck==0)
				{
					O2       = (unsigned char)UWB_rectemp[0];
					CO2      = (unsigned char)UWB_rectemp[1];
					CO.B[0]  = (unsigned char)UWB_rectemp[3];
					CO.B[1]  = (unsigned char)UWB_rectemp[2];
					NO.B[0]  = (unsigned char)UWB_rectemp[5];
					NO.B[1]  = (unsigned char)UWB_rectemp[4];
					NO2.B[0] = (unsigned char)UWB_rectemp[7];
					NO2.B[1] = (unsigned char)UWB_rectemp[6];
					SO2.B[0] = (unsigned char)UWB_rectemp[9];
					SO2.B[1] = (unsigned char)UWB_rectemp[8];
					H2S.B[0] = (unsigned char)UWB_rectemp[11];
					H2S.B[1] = (unsigned char)UWB_rectemp[10];

					COC.B[0]  = (unsigned char)UWB_rectemp[13];
					COC.B[1]  = (unsigned char)UWB_rectemp[12];
					NOC.B[0]  = (unsigned char)UWB_rectemp[15];
					NOC.B[1]  = (unsigned char)UWB_rectemp[14];
					NO2C.B[0] = (unsigned char)UWB_rectemp[17];
					NO2C.B[1] = (unsigned char)UWB_rectemp[16];
					SO2C.B[0] = (unsigned char)UWB_rectemp[19];
					SO2C.B[1] = (unsigned char)UWB_rectemp[18];
					H2SC.B[0] = (unsigned char)UWB_rectemp[21];
					H2SC.B[1] = (unsigned char)UWB_rectemp[20];
					loopcnt=0;	
					if(rec_state==0)
					{
						rec_state = 1;
						gcs_send_text_P(SEVERITY_HIGH ,PSTR("recev sensor data!"));
					}			
				}else
				{
					gcs_send_text_P(SEVERITY_HIGH ,PSTR("sensor data crc error!"));					
				}
				count=0;
				xorCheck = 0;		
			}		
		}
		else
		{
			count = 0;
			xorCheck =0;
		}
    }
    if((loopcnt)>250)
    {
		gcs_send_text_P(SEVERITY_HIGH ,PSTR("no sensor data!"));
		rec_state = 0;
		loopcnt=0;
    }  	
}
#endif

#ifdef USERHOOK_MEDIUMLOOP
void userhook_MediumLoop()
{
    // put your 10Hz code here
}
#endif

#ifdef USERHOOK_SLOWLOOP
void userhook_SlowLoop()
{
    // put your 3.3Hz code here
}
#endif

#ifdef USERHOOK_SUPERSLOWLOOP
void userhook_SuperSlowLoop()
{
    // put your 1Hz code here
}
#endif