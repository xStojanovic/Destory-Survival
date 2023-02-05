// ( Check if a_samp it's included in the main script )
#if !defined a_samp

#include a_samp

#endif

// ( This is the function you can simply use on your script )
stock IsPlayerInWater(playerid)
{
	new Float[3];
	GetPlayerPos(playerid, Float[0], Float[1], Float[2]);
	if((IsPlayerInArea(playerid, 2032.1371, 1841.2656, 1703.1653, 1467.1099) && Float[ 2 ] <= 9.0484)
  	|| (IsPlayerInArea(playerid, 2109.0725, 2065.8232, 1962.5355, 10.8547) && Float[ 2 ] <= 10.0792)
  	|| (IsPlayerInArea(playerid, -492.5810, -1424.7122, 2836.8284, 2001.8235) && Float[ 2 ] <= 41.06) 
  	|| (IsPlayerInArea(playerid, -2675.1492, -2762.1792, -413.3973, -514.3894) && Float[ 2 ] <= 4.24) 
  	|| (IsPlayerInArea(playerid, -453.9256, -825.7167, -1869.9600, -2072.8215) && Float[ 2 ] <= 5.72) 
  	|| (IsPlayerInArea(playerid, 1281.0251, 1202.2368, -2346.7451, -2414.4492) && Float[ 2 ] <= 9.3145) 
  	|| (IsPlayerInArea(playerid, 2012.6154, 1928.9028, -1178.6207, -1221.4043) && Float[ 2 ] <= 18.45) 
  	|| (IsPlayerInArea(playerid, 2326.4858, 2295.7471, -1400.2797, -1431.1266) && Float[ 2 ] <= 22.615) 
  	|| (IsPlayerInArea(playerid, 2550.0454, 2513.7588, 1583.3751, 1553.0753) && Float[ 2 ] <= 9.4171) 
  	|| (IsPlayerInArea(playerid, 1102.3634, 1087.3705, -663.1653, -682.5446) && Float[ 2 ] <= 112.45) 
  	|| (IsPlayerInArea(playerid, 1287.7906, 1270.4369, -801.3882, -810.0527) && Float[ 2 ] <= 87.123)
  	|| (Float[ 2 ] < 1.5))
	{
		return (1);
	}
	return (0);
}