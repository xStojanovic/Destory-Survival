//----------------------------------------------------------------------------//
#include 							<	a_samp			>
#include 							<	progress		>
#include 							<	streamer		>
#include 							<	sscanf2			>
#include 							<	zcmd			>
#include                            <   foreach     	>
#include 							< 	time 			>
#include 							< 	YSI\y_ini 		>
//----------------------------------------------------------------------------//
#pragma tabsize 0
//----------------------------------------------------------------------------//
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define HOLDING(%0)  ((newkeys & (%0)) == (%0))
#define RELEASED(%0) (((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
//----------------------------------------------------------------------------//
#define PURPLE1             		0xF9BDFFAA
#define PURPLE2             		0xE6A9EFAA
#define PURPLE3             		0xC38ECAAA
#define PURPLE4             		0xCEB8CFAA
#define PURPLE5             		0xBDB1BDAA
//----------------------------------------------------------------------------//
#define BELA                        "{FFFFFF}"
#define PLAVA                       "{0000FF}"
#define CRVENA                      "{FF0000}"
#define ZELENA                      "{00FF00}"
#define SIVA                        "{C3C3C3}"
#define ZLATNA          			"{FFEB00}"
//----------------------------------------------------------------------------//
#define SCM                         SendClientMessage
#define SCMTA                       SendClientMessageToAll
#define SPD    						ShowPlayerDialog
#define DSL    						DIALOG_STYLE_LIST
#define DSB    						DIALOG_STYLE_MSGBOX
#define DSI    						DIALOG_STYLE_INPUT
#define DSP                         DIALOG_STYLE_PASSWORD
#define TDSFP                       TextDrawShowForPlayer
#define TDHFP                       TextDrawHideForPlayer
//----------------------------------------------------------------------------//
#define DIALOG_REGISTER 			1
#define DIALOG_LOGIN 				2
#define DIALOG_SUCCESS_1 			3
#define DIALOG_SUCCESS_2 			4
#define DIALOG_STATS 				5
#define TEZGA_RIBE                  6
#define TEZGA_VOCE                  7
#define TEZGA_VODA                  8
#define TEZGA_RIBEOS                9
#define TEZGA_VOCEOS                10
#define DIALOG_CRAFT                11
#define DIALOG_COOK                 12
//----------------------------------------------------------------------------//
new tezga1;
new tezga2;
new tezga3;
//
new HiddenMap; // Map Gangzone
new island1;
new island2;
new island3;
new island4;
new island5;
new island6;
new island7;
new island8;
new island9;
new island10;
new island11;
new island12;
new island13;
new island14;
new island15;
new island16;
new island17;
new island18;
new island19;
new island20;
new island21;
new island22;
new island23;
new island24;
new island25;
new island26;
new island27;
new island28;
new island29;
new island30;
new island31;
new island32;
new island33;
new island34;
new island35;
new island36;
new island37;
new island38;
new island39;
new island40;
new island41;
new island42;
new island43;
new island44;
new island45;
new island46;
new island47;
new island48;
new island49;
new island50;
new island51;
new island52;
new island53;
new island54;
new island55;
new island56;
new island57;
new island58;
new island59;
new island60;
new island61;
new island62;
new island63;
new island64;
new island65;
new island66;
new island67;
new island68;
new island69;
new island70;
new island71;
new island72;
new island73;
new island74;
new island75;
new island76;
new island77;
new island78;
new island79;
new island80;
new island81;
new island82;
new island83;
new island84;
new island85;
new island86;
new island87;
new island88;
new island89;
new island90;
new island91;
new island92;
new island93;
new island94;
new island95;
new island96;
new island97;
new island98;
new island99;
new island100;
new island101;
new island102;
new island103;
new island104;
new island105;
new island106;
new island107;
new island108;
new island109;
new IslandSpawned;
new IslandCantBeSpawned;
//
new Text:Logo;
new Text:Vrijeme[2];
new Text:Zedj[2][MAX_PLAYERS];
new Text:Srce[2][MAX_PLAYERS];
new Text:Glad[2][MAX_PLAYERS];
new Text:Dodaci[2];
new Text:Informacije[3];
new Text:SaveIcon[8];
//
new LoggedOn[MAX_PLAYERS];
new LoggingTimer[MAX_PLAYERS];
new EatMin[MAX_PLAYERS];
new Thirst[MAX_PLAYERS];
new Bleeding[MAX_PLAYERS];
new BleedingTimer[MAX_PLAYERS];
new IgracEdituje[MAX_PLAYERS];
//----------------------------------------------------------------------------//
new stationNames[13][] =
{
	{ "Radio Off" },
	{ "Playback FM" },
	{ "K-Rose" },
	{ "K-DST" },
	{ "Bounce FM" },
	{ "SF-UR" },
	{ "Radio Los Santos" },
	{ "Radio X" },
	{ "CSR 103.9" },
	{ "K-Jah West" },
	{ "Master Sounds 98.3" },
	{ "WCTR" },
	{ "User Track Player" }
};
//----------------------------------------------------------------------------//
new Float:pl_RandSpawn[][] =
{
    {1206.6125,-3612.6697,2.2549,258.1891},
    {1238.0902,-3625.8101,2.3304,65.4873},
    {1206.6125,-3612.6697,2.2549,258.1891},
    {1237.0964,-3635.5393,2.4277,5.0134}
};
//----------------------------------------------------------------------------//
#define KORISNICI 						"Users/%s.ini"
enum pInfo
{
    pPass,
	pMoney,
	pBan,
	pIP[16],
    pAdmin,
    pSkin,
    pGlad,
    pZedj,
    pRStap,
    pRibe,
    pJRibe,
    pDrvo,
    pKamen,
	pSatiIgre,
	pVoce,
	pFlasaVode,
	pFlasaPuna,
	pSibice,
	pPovez,
	pNote1[128],
	pNote1s,
	pNote2[128],
	pNote2s,
	pNote3[128],
	pNote3s,
	pNote4[128],
	pNote4s,
	pNote5[128],
	pNote5s,
	pSator
};
new PlayerInfo[MAX_PLAYERS][pInfo];
//----------------------------------------------------------------------------//
#define MAX_TREES   100
enum TreeInfo
{
    ID,
    Obj, // store object in this
    Type,
    Model,
    Float: Health,
    Float: xPos,
    Float: yPos,
    Float: zPos,
    Float: rxPos,
    Float: ryPos,
    Float: rzPos,
}
new tInfo[MAX_TREES][TreeInfo];
new tCount;
//----------------------------------------------------------------------------//
#define MAX_CAMPFIRES 30
enum CampfireInfo
{
    LogObj,
    FireObj,
    Float: xPos,
    Float: yPos,
    Float: zPos,
}
new cfInfo[MAX_CAMPFIRES][CampfireInfo];
new cfCount;
//----------------------------------------------------------------------------//
#define SATOR_OBJEKAT                    3243
#define SATOR_FILE   "Satori/Sator_%d.ini"
#define MAX_SATOR 50
enum Sator
{
	sVlasnik[MAX_PLAYER_NAME],
	sProveraVlasnika,
	sPostavljen,
	Float:sPozX,
	Float:sPozY,
	Float:sPozZ,
	Float:sPozX2,
	Float:sPozY2,
	Float:sPozZ2,
	sZakljucan,
	sInt,
	sVW,
	sObjekat,
	Float:sAngle,
	Text3D:SatorLabel
};
new SatorInfo[MAX_SATOR][Sator];
new esData[MAX_PLAYERS];
//----------------------------------------------------------------------------//
new pChoppingTree[MAX_PLAYERS];
new ChoppingProgress[MAX_PLAYERS];
new PlayerBar:ChoppingBar[MAX_PLAYERS];
new TreeHealthUpdater[MAX_PLAYERS];
//----------------------------------------------------------------------------//
new pFishing[MAX_PLAYERS];
new FishingProgress[MAX_PLAYERS];
new PlayerBar:FishingBar[MAX_PLAYERS];
new FishingUpdate[MAX_PLAYERS];
new bool:HoldForFish[MAX_PLAYERS];
//----------------------------------------------------------------------------//
main()
{
	print("GameMode loaded");
}
//----------------------------------------------------------------------------//
public OnGameModeInit()
{
	//------------------------------------------------------------------------//
	for(new s = 0; s < sizeof(SatorInfo); s++)
    {
        new saFile[50];
        format(saFile, sizeof(saFile), SATOR_FILE, s);
        if(fexist(saFile))
        {
 			INI_ParseFile(saFile, "UcitajSator", .bExtra = true, .extra = s);
			KreirajSator(s);
			printf("Y_INI | Sator %d ucitan",s);
		}
	}
	//------------------------------------------------------------------------//
	HiddenMap = GangZoneCreate(-3000, -3128.90625, 3128.90625, 3000);
	//------------------------------------------------------------------------//
	SetGameModeText("DS v0.2 (Alpha)");
 	//------------------------------------------------------------------------//
 	CreateDynamic3DTextLabel(""CRVENA"(("SIVA" Logorska Vatra "CRVENA"))\n"SIVA"- Ovde mozete da skuhate/ispecete ribu koju ste uhvatili -\n/ispeci",0x9EC73DAA,1241.9747,-3640.5361,3.0347, 30, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 20.0);
    CreateDynamic3DTextLabel(""ZELENA"(("SIVA" Tezga "ZELENA"))\n"SIVA"- Prikupljanje riba za prezivjele koji su gladni -\n"ZELENA"SPACE",0x9EC73DAA,1248.3463,-3641.6392,3.7160, 30, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 20.0);
    CreateDynamic3DTextLabel(""ZELENA"(("SIVA" Tezga "ZELENA"))\n"SIVA"- Prikupljanje voca za prezivjele koji su gladni -\n"ZELENA"SPACE",0x9EC73DAA,1249.7458,-3634.2498,3.7087, 30, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 20.0);
    CreateDynamic3DTextLabel(""ZELENA"(("SIVA" Tezga "ZELENA"))\n"SIVA"- Prikupljanje vode za prezivjele koji su zedni -\n"ZELENA"SPACE",0x9EC73DAA,1245.5681,-3630.7461,3.2048, 30, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 20.0);
    //------------------------------------------------------------------------//
    SaveIcon[0] = TextDrawCreate(574.000000, 369.000000, "...");
	TextDrawBackgroundColor(SaveIcon[0], 255);
	TextDrawFont(SaveIcon[0], 3);
	TextDrawLetterSize(SaveIcon[0], 0.940000, 2.899998);
	TextDrawColor(SaveIcon[0], -1);
	TextDrawSetOutline(SaveIcon[0], 1);
	TextDrawSetProportional(SaveIcon[0], 0);
	TextDrawSetSelectable(SaveIcon[0], 0);

	SaveIcon[1] = TextDrawCreate(622.000000, 406.000000, "_");
	TextDrawBackgroundColor(SaveIcon[1], 255);
	TextDrawFont(SaveIcon[1], 1);
	TextDrawLetterSize(SaveIcon[1], 0.500000, 3.099999);
	TextDrawColor(SaveIcon[1], -1);
	TextDrawSetOutline(SaveIcon[1], 0);
	TextDrawSetProportional(SaveIcon[1], 1);
	TextDrawSetShadow(SaveIcon[1], 1);
	TextDrawUseBox(SaveIcon[1], 1);
	TextDrawBoxColor(SaveIcon[1], 255);
	TextDrawTextSize(SaveIcon[1], 572.000000, 0.000000);
	TextDrawSetSelectable(SaveIcon[1], 0);

	SaveIcon[2] = TextDrawCreate(614.000000, 406.000000, "_");
	TextDrawBackgroundColor(SaveIcon[2], 255);
	TextDrawFont(SaveIcon[2], 1);
	TextDrawLetterSize(SaveIcon[2], 0.500000, -0.300000);
	TextDrawColor(SaveIcon[2], 65535);
	TextDrawSetOutline(SaveIcon[2], 0);
	TextDrawSetProportional(SaveIcon[2], 1);
	TextDrawSetShadow(SaveIcon[2], 1);
	TextDrawUseBox(SaveIcon[2], 1);
	TextDrawBoxColor(SaveIcon[2], 6605055);
	TextDrawTextSize(SaveIcon[2], 580.000000, -4.000000);
	TextDrawSetSelectable(SaveIcon[2], 0);

	SaveIcon[3] = TextDrawCreate(614.000000, 413.000000, "_");
	TextDrawBackgroundColor(SaveIcon[3], 255);
	TextDrawFont(SaveIcon[3], 1);
	TextDrawLetterSize(SaveIcon[3], 0.500000, 2.299999);
	TextDrawColor(SaveIcon[3], 65535);
	TextDrawSetOutline(SaveIcon[3], 0);
	TextDrawSetProportional(SaveIcon[3], 1);
	TextDrawSetShadow(SaveIcon[3], 1);
	TextDrawUseBox(SaveIcon[3], 1);
	TextDrawBoxColor(SaveIcon[3], -993737473);
	TextDrawTextSize(SaveIcon[3], 580.000000, -4.000000);
	TextDrawSetSelectable(SaveIcon[3], 0);

	SaveIcon[4] = TextDrawCreate(599.000000, 431.000000, "_");
	TextDrawBackgroundColor(SaveIcon[4], 255);
	TextDrawFont(SaveIcon[4], 1);
	TextDrawLetterSize(SaveIcon[4], 0.500000, 0.099999);
	TextDrawColor(SaveIcon[4], 65535);
	TextDrawSetOutline(SaveIcon[4], 0);
	TextDrawSetProportional(SaveIcon[4], 1);
	TextDrawSetShadow(SaveIcon[4], 1);
	TextDrawUseBox(SaveIcon[4], 1);
	TextDrawBoxColor(SaveIcon[4], 255);
	TextDrawTextSize(SaveIcon[4], 583.000000, -4.000000);
	TextDrawSetSelectable(SaveIcon[4], 0);

	SaveIcon[5] = TextDrawCreate(614.000000, 415.000000, "_");
	TextDrawBackgroundColor(SaveIcon[5], 255);
	TextDrawFont(SaveIcon[5], 1);
	TextDrawLetterSize(SaveIcon[5], 0.500000, -0.600000);
	TextDrawColor(SaveIcon[5], 16843263);
	TextDrawSetOutline(SaveIcon[5], 0);
	TextDrawSetProportional(SaveIcon[5], 1);
	TextDrawSetShadow(SaveIcon[5], 1);
	TextDrawUseBox(SaveIcon[5], 1);
	TextDrawBoxColor(SaveIcon[5], 842150655);
	TextDrawTextSize(SaveIcon[5], 580.000000, -4.000000);
	TextDrawSetSelectable(SaveIcon[5], 0);

	SaveIcon[6] = TextDrawCreate(614.000000, 411.000000, "_");
	TextDrawBackgroundColor(SaveIcon[6], 255);
	TextDrawFont(SaveIcon[6], 1);
	TextDrawLetterSize(SaveIcon[6], 0.500000, -0.600000);
	TextDrawColor(SaveIcon[6], 16843263);
	TextDrawSetOutline(SaveIcon[6], 0);
	TextDrawSetProportional(SaveIcon[6], 1);
	TextDrawSetShadow(SaveIcon[6], 1);
	TextDrawUseBox(SaveIcon[6], 1);
	TextDrawBoxColor(SaveIcon[6], 842150655);
	TextDrawTextSize(SaveIcon[6], 580.000000, -4.000000);
	TextDrawSetSelectable(SaveIcon[6], 0);

	SaveIcon[7] = TextDrawCreate(614.000000, 421.000000, "_");
	TextDrawBackgroundColor(SaveIcon[7], 255);
	TextDrawFont(SaveIcon[7], 1);
	TextDrawLetterSize(SaveIcon[7], 0.500000, -0.200000);
	TextDrawColor(SaveIcon[7], 65535);
	TextDrawSetOutline(SaveIcon[7], 0);
	TextDrawSetProportional(SaveIcon[7], 1);
	TextDrawSetShadow(SaveIcon[7], 1);
	TextDrawUseBox(SaveIcon[7], 1);
	TextDrawBoxColor(SaveIcon[7], 255);
	TextDrawTextSize(SaveIcon[7], 580.000000, -4.000000);
	TextDrawSetSelectable(SaveIcon[7], 0);

	Informacije[0] = TextDrawCreate(265.000000, 281.000000, "_");
	TextDrawBackgroundColor(Informacije[0], 255);
	TextDrawFont(Informacije[0], 1);
	TextDrawLetterSize(Informacije[0], 0.500000, 1.000000);
	TextDrawColor(Informacije[0], -1);
	TextDrawSetOutline(Informacije[0], 0);
	TextDrawSetProportional(Informacije[0], 1);
	TextDrawSetShadow(Informacije[0], 1);
	TextDrawUseBox(Informacije[0], 1);
	TextDrawBoxColor(Informacije[0], 100);
	TextDrawTextSize(Informacije[0], 0.000000, 0.000000);
	TextDrawSetSelectable(Informacije[0], 0);

	Informacije[1] = TextDrawCreate(12.000000, 280.000000, "~b~medo grizzli~w~ se ulogovao.");
	TextDrawBackgroundColor(Informacije[1], 255);
	TextDrawFont(Informacije[1], 2);
	TextDrawLetterSize(Informacije[1], 0.240000, 1.000000);
	TextDrawColor(Informacije[1], -1);
	TextDrawSetOutline(Informacije[1], 0);
	TextDrawSetProportional(Informacije[1], 1);
	TextDrawSetShadow(Informacije[1], 0);
	TextDrawSetSelectable(Informacije[1], 0);

	Informacije[2] = TextDrawCreate(245.000000, 265.000000, "LD_CHAT:badchat");
	TextDrawBackgroundColor(Informacije[2], 255);
	TextDrawFont(Informacije[2], 4);
	TextDrawLetterSize(Informacije[2], 0.500000, 1.000000);
	TextDrawColor(Informacije[2], -1);
	TextDrawSetOutline(Informacije[2], 0);
	TextDrawSetProportional(Informacije[2], 1);
	TextDrawSetShadow(Informacije[2], 1);
	TextDrawUseBox(Informacije[2], 1);
	TextDrawBoxColor(Informacije[2], 255);
	TextDrawTextSize(Informacije[2], 24.000000, 19.000000);
	TextDrawSetSelectable(Informacije[2], 0);

	Logo = TextDrawCreate(497.000000, 1.000000, "Destory Survival");
	TextDrawBackgroundColor(Logo, 25);
	TextDrawFont(Logo, 0);
	TextDrawLetterSize(Logo, 0.579999, 2.100000);
	TextDrawColor(Logo, -1);
	TextDrawSetOutline(Logo, 1);
	TextDrawSetProportional(Logo, 1);
	TextDrawSetSelectable(Logo, 0);
	
	Vrijeme[0] = TextDrawCreate(41.000000, 339.000000, "hud:radar_datedisco");
	TextDrawBackgroundColor(Vrijeme[0], 255);
	TextDrawFont(Vrijeme[0], 4);
	TextDrawLetterSize(Vrijeme[0], 1.200000, 1.000000);
	TextDrawColor(Vrijeme[0], -16776961);
	TextDrawSetOutline(Vrijeme[0], 0);
	TextDrawSetProportional(Vrijeme[0], 1);
	TextDrawSetShadow(Vrijeme[0], 1);
	TextDrawUseBox(Vrijeme[0], 1);
	TextDrawBoxColor(Vrijeme[0], 255);
	TextDrawTextSize(Vrijeme[0], 93.000000, 86.000000);
	TextDrawSetSelectable(Vrijeme[0], 0);

	Vrijeme[1] = TextDrawCreate(89.000000, 373.000000, "12:40");
	TextDrawAlignment(Vrijeme[1], 2);
	TextDrawBackgroundColor(Vrijeme[1], 255);
	TextDrawFont(Vrijeme[1], 2);
	TextDrawLetterSize(Vrijeme[1], 0.420000, 1.700000);
	TextDrawColor(Vrijeme[1], -1);
	TextDrawSetOutline(Vrijeme[1], 0);
	TextDrawSetProportional(Vrijeme[1], 1);
	TextDrawSetShadow(Vrijeme[1], 0);
	TextDrawSetSelectable(Vrijeme[1], 0);

	Dodaci[0] = TextDrawCreate(222.000000, 373.000000, "-");
	TextDrawBackgroundColor(Dodaci[0], 255);
	TextDrawFont(Dodaci[0], 1);
	TextDrawLetterSize(Dodaci[0], 12.710012, 1.000000);
	TextDrawColor(Dodaci[0], -16776961);
	TextDrawSetOutline(Dodaci[0], 0);
	TextDrawSetProportional(Dodaci[0], 1);
	TextDrawSetShadow(Dodaci[0], 1);
	TextDrawSetSelectable(Dodaci[0], 0);

	Dodaci[1] = TextDrawCreate(222.000000, 419.000000, "-");
	TextDrawBackgroundColor(Dodaci[1], 255);
	TextDrawFont(Dodaci[1], 1);
	TextDrawLetterSize(Dodaci[1], 12.710012, 1.000000);
	TextDrawColor(Dodaci[1], -16776961);
	TextDrawSetOutline(Dodaci[1], 0);
	TextDrawSetProportional(Dodaci[1], 1);
	TextDrawSetShadow(Dodaci[1], 1);
	TextDrawSetSelectable(Dodaci[1], 0);
	//------//
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
        Srce[0][i] = TextDrawCreate(260.000000, 388.000000, "HUD:radar_girlfriend");
		TextDrawBackgroundColor(Srce[0][i], 255);
		TextDrawFont(Srce[0][i], 4);
		TextDrawLetterSize(Srce[0][i], 0.500000, 1.000000);
		TextDrawColor(Srce[0][i], -1);
		TextDrawSetOutline(Srce[0][i], 0);
		TextDrawSetProportional(Srce[0][i], 1);
		TextDrawSetShadow(Srce[0][i], 1);
		TextDrawUseBox(Srce[0][i], 1);
		TextDrawBoxColor(Srce[0][i], 255);
		TextDrawTextSize(Srce[0][i], 24.000000, 19.000000);
		TextDrawSetSelectable(Srce[0][i], 0);
		
		Srce[1][i] = TextDrawCreate(257.000000, 410.000000, "100%");
		TextDrawBackgroundColor(Srce[1][i], 255);
		TextDrawFont(Srce[1][i], 1);
		TextDrawLetterSize(Srce[1][i], 0.330000, 1.000000);
		TextDrawColor(Srce[1][i], -16776961);
		TextDrawSetOutline(Srce[1][i], 1);
		TextDrawSetProportional(Srce[1][i], 1);
		TextDrawSetSelectable(Srce[1][i], 0);
		
		Glad[0][i] = TextDrawCreate(305.000000, 388.000000, "HUD:radar_datefood");
		TextDrawBackgroundColor(Glad[0][i], 255);
		TextDrawFont(Glad[0][i], 4);
		TextDrawLetterSize(Glad[0][i], 0.500000, 1.000000);
		TextDrawColor(Glad[0][i], -1);
		TextDrawSetOutline(Glad[0][i], 0);
		TextDrawSetProportional(Glad[0][i], 1);
		TextDrawSetShadow(Glad[0][i], 1);
		TextDrawUseBox(Glad[0][i], 1);
		TextDrawBoxColor(Glad[0][i], 255);
		TextDrawTextSize(Glad[0][i], 24.000000, 19.000000);
		TextDrawSetSelectable(Glad[0][i], 0);
		
		Glad[1][i] = TextDrawCreate(302.000000, 410.000000, "100%");
		TextDrawBackgroundColor(Glad[1][i], 255);
		TextDrawFont(Glad[1][i], 1);
		TextDrawLetterSize(Glad[1][i], 0.330000, 1.000000);
		TextDrawColor(Glad[1][i], -993737473);
		TextDrawSetOutline(Glad[1][i], 1);
		TextDrawSetProportional(Glad[1][i], 1);
		TextDrawSetSelectable(Glad[1][i], 0);
		
		Zedj[0][i] = TextDrawCreate(352.000000, 388.000000, "HUD:radar_diner");
		TextDrawBackgroundColor(Zedj[0][i], 255);
		TextDrawFont(Zedj[0][i], 4);
		TextDrawLetterSize(Zedj[0][i], 0.500000, 1.000000);
		TextDrawColor(Zedj[0][i], -1);
		TextDrawSetOutline(Zedj[0][i], 0);
		TextDrawSetProportional(Zedj[0][i], 1);
		TextDrawSetShadow(Zedj[0][i], 1);
		TextDrawUseBox(Zedj[0][i], 1);
		TextDrawBoxColor(Zedj[0][i], 255);
		TextDrawTextSize(Zedj[0][i], 24.000000, 19.000000);
		TextDrawSetSelectable(Zedj[0][i], 0);

		Zedj[1][i] = TextDrawCreate(350.000000, 410.000000, "100%");
		TextDrawBackgroundColor(Zedj[1][i], 255);
		TextDrawFont(Zedj[1][i], 1);
		TextDrawLetterSize(Zedj[1][i], 0.330000, 1.000000);
		TextDrawColor(Zedj[1][i], -16152321);
		TextDrawSetOutline(Zedj[1][i], 1);
		TextDrawSetProportional(Zedj[1][i], 1);
		TextDrawSetSelectable(Zedj[1][i], 0);
	}
	//------------------------------------------------------------------------//
	LoadTezga(); WeatherHandler(); LoadTrees();
	//------------------------------------------------------------------------//
	EnableStuntBonusForAll(0);
    ShowPlayerMarkers(0);
    ShowNameTags(0);
    DisableNameTagLOS();
    IslandSpawned = 1;
    IslandSpawn();
    IslandCantBeSpawned = 0;
	//------------------------------------------------------------------------//
	//---------------------------- [ Interijer Sator ] -----------------------//
	CreateDynamicObject(19357, 811.31305, 337.32098, -20.00000, 0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19376, 808.99738, 337.44000, -21.64000, 0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19357, 809.79755, 339.24625, -20.00000, 0.00000, 0.00000, -104.76002);
	CreateDynamicObject(19357, 809.78595, 335.33020, -20.00000, 0.00000, 0.00000, 104.76000);
	CreateDynamicObject(19357, 806.81970, 339.25024, -20.00000, 0.00000, 0.00000, 104.76000);
	CreateDynamicObject(19357, 806.81934, 335.29825, -20.00000, 0.00000, 0.00000, -104.76002);
	CreateDynamicObject(19357, 807.09882, 335.79773, -20.00000, 0.00000, 0.00000, 23.22000);
	CreateDynamicObject(19357, 806.69019, 338.69687, -20.00000, 0.00000, 0.00000, -6.95996);
	CreateDynamicObject(1771, 810.46887, 337.26111, -21.39191, 0.00000, 0.00000, -2.16000);
	CreateDynamicObject(2180, 807.25220, 338.55417, -21.55183, 0.00000, 0.00000, -97.91993);
	CreateDynamicObject(2894, 807.07208, 337.65930, -20.75107, 0.00000, 0.00000, 67.98000);
	CreateDynamicObject(2196, 807.61078, 338.75629, -20.75110, 0.00000, 0.00000, -21.60000);
	CreateDynamicObject(1721, 807.87610, 338.17511, -21.55139, 0.00000, 0.00000, 109.92000);
	CreateDynamicObject(1535, 808.28717, 334.95627, -21.60001, 0.00000, 0.00000, 14.94000);
	CreateDynamicObject(19357, 808.35486, 336.27689, -19.16000, 0.00000, 50.00000, 23.22000);
	CreateDynamicObject(19357, 807.77618, 338.42230, -19.32001, 0.00000, 50.00000, -7.00000);
	CreateDynamicObject(19357, 807.58307, 338.81314, -19.00000, 0.00000, -26.00000, 104.76000);
	CreateDynamicObject(19357, 809.40637, 336.45770, -19.25999, 0.00000, 50.00000, 104.76000);
	CreateDynamicObject(19357, 806.81927, 335.29819, -19.00000, 0.00000, 0.00000, -104.76000);
	CreateDynamicObject(19357, 810.73419, 337.27200, -19.00000, 0.00000, -22.00000, 0.00000);
	CreateDynamicObject(19357, 809.59094, 337.98309, -19.16000, 0.00000, 50.00000, -105.00000);
	//------------------------------ [ Glavni Island ] -----------------------//
	CreateDynamicObject(18359,1173.4511700,-3656.1147500,-27.2266300,6.0160000,0.0000000,-461.2500000); //object(1)
	CreateDynamicObject(18358,1181.7900400,-3725.7539100,-25.0034300,14.6060000,2.5760000,222.5720000); //object(2)
	CreateDynamicObject(18359,1297.7285200,-3438.6152300,-26.4214900,7.7340000,0.0000000,225.0000000); // ect(3)
	CreateDynamicObject(10453,1461.9428700,-3377.9511700,21.1918400,0.0000000,0.0000000,-198.0480000); //object(9)
	CreateDynamicObject(10491,1414.8818400,-3535.7168000,24.9557900,1.7190000,-3.4380000,-45.0000000); //object(10)
	CreateDynamicObject(10491,1230.9502000,-3876.8894000,45.6007000,0.0000000,0.0000000,-180.0000000); //object(11)
	CreateDynamicObject(10491,1308.7583000,-3747.6403800,25.5368200,-24.0640000,15.4700000,-295.0780000); //object(12)
	CreateDynamicObject(10492,1482.6538100,-3627.3803700,34.6102300,0.0000000,0.0000000,-67.5000000); //object(13)
	CreateDynamicObject(10960,1303.5844700,-3690.2998000,-19.5522800,0.0000000,0.0000000,135.0000000); //object(14)
	CreateDynamicObject(13120,1471.4668000,-3739.7529300,1.2761800,0.0000000,0.0000000,157.5000000); //object(17)
	CreateDynamicObject(13120,1317.7534200,-3881.4580100,4.5880600,-7.7350000,-5.1570000,-315.0000000); //object(18)
	CreateDynamicObject(13156,1504.5898400,-3917.1772500,6.1226000,0.0000000,0.0000000,157.5000000); //object(19)
	CreateDynamicObject(13165,1459.1460000,-4028.3823200,18.7978400,0.0000000,0.0000000,-180.0000000); //object(20)
	CreateDynamicObject(13212,1303.0708000,-4065.8603500,29.3664900,0.0000000,0.0000000,56.2500000); //object(22)
	CreateDynamicObject(13236,1371.9072300,-3850.9130900,-15.9248300,0.0000000,354.8420000,240.6230000); //object(23)
	CreateDynamicObject(13237,1399.6235400,-3876.8908700,-12.4025000,0.0000000,-6.8750000,-67.5000000); //object(24)
	CreateDynamicObject(18227,1374.8398400,-3802.9482400,29.8124900,37.8150000,331.6330000,146.2500000); //object(25)
	CreateDynamicObject(18227,1382.8203100,-3823.6084000,44.2993400,27.5020000,-30.0800000,-231.0160000); //object(26)
	CreateDynamicObject(18227,1373.6113300,-3858.3300800,18.1156400,0.0000000,0.0000000,-265.7030000); //object(27)
	CreateDynamicObject(18227,1358.0117200,-3868.5227100,30.8897800,0.0000000,-6.8750000,142.3480000); //object(28)
	CreateDynamicObject(18227,1349.3051800,-3878.8569300,61.7062600,0.0000000,0.0000000,78.7500000); //object(29)
	CreateDynamicObject(18227,1347.8159200,-3888.4687500,39.7386600,0.0000000,0.0000000,-293.9870000); //object(30)
	CreateDynamicObject(18227,1335.0112300,-3871.2341300,58.9134900,0.0000000,0.0000000,22.5000000); //object(31)
	CreateDynamicObject(18227,1298.2377900,-3880.2045900,59.2832300,0.0000000,0.0000000,-8.7490000); //object(32)
	CreateDynamicObject(18227,1272.0605500,-3856.2446300,50.9886400,0.0000000,0.0000000,-123.7500000); //object(33)
	CreateDynamicObject(18227,1235.7802700,-3829.1616200,39.3644600,9.4540000,0.0000000,-146.2500000); //object(34)
	CreateDynamicObject(13236,1317.5864300,-3979.5981400,43.0966800,0.0000000,-5.1570000,-153.7530000); //object(35)
	CreateDynamicObject(18227,1126.7382800,-3821.8308100,11.7806500,0.0000000,0.0000000,-191.2500000); //object(36)
	CreateDynamicObject(18227,1128.6220700,-3879.8349600,44.8211700,8.5910000,12.8870000,134.9950000); //object(37)
	CreateDynamicObject(18227,1223.2392600,-4029.3020000,63.8209800,0.0000000,0.0000000,-258.7500000); //object(38)
	CreateDynamicObject(18227,1208.2294900,-4002.8896500,80.6750200,347.9640000,350.5410000,112.5000000); //object(39)
	CreateDynamicObject(18227,1250.3564500,-3967.5551800,91.8837900,0.0000000,0.0000000,-78.7500000); //object(40)
	CreateDynamicObject(18227,1288.7661100,-3928.0422400,78.5223000,0.0000000,0.0000000,-72.7340000); //object(41)
	CreateDynamicObject(18227,1292.6152300,-3904.0078100,68.7538100,0.0000000,357.4180000,281.4040000); //object(42)
	CreateDynamicObject(18227,1241.5253900,-3913.3291000,78.7325700,0.0000000,0.0000000,-135.0000000); //object(43)
	CreateDynamicObject(18227,1224.5898400,-3891.4355500,59.9273100,0.0000000,0.0000000,258.7450000); //object(44)
	CreateDynamicObject(18227,1297.6030300,-3705.9409200,20.4154800,0.0000000,0.0000000,-78.7500000); //object(47)
	CreateDynamicObject(18227,1305.9960900,-3652.4318800,19.0416400,0.0000000,0.0000000,-56.2500000); //object(48)
	CreateDynamicObject(18227,1291.7153300,-3592.6894500,14.6575900,0.0000000,0.0000000,-22.5000000); //object(49)
	CreateDynamicObject(18227,1248.6396500,-3556.3205600,11.7197600,0.0000000,0.0000000,11.2500000); //object(50)
	CreateDynamicObject(18227,1689.9209000,-1131.5058600,-10.6708100,0.0000000,0.0000000,213.7450000); //object(51)
	CreateDynamicObject(18227,1302.3427700,-3565.5507800,16.2361400,0.0000000,0.0000000,-157.5000000); //object(52)
	CreateDynamicObject(18227,1239.0351600,-3545.0346700,8.7709100,0.0000000,0.0000000,-135.0000000); //object(53)
	CreateDynamicObject(18227,1202.3286100,-3483.6630900,0.6715600,0.0000000,0.0000000,-191.2500000); //object(54)
	CreateDynamicObject(18227,1210.2006800,-3558.0730000,-18.3207500,9.4540000,18.9080000,-41.3300000); //object(55)
	CreateDynamicObject(18227,1316.9497100,-3669.5854500,10.8544200,0.0000000,0.0000000,123.7500000); //object(56)
	CreateDynamicObject(18227,1339.4589800,-3637.5937500,1.9591900,0.0000000,0.0000000,-236.2500000); //object(57)
	CreateDynamicObject(18227,1365.1650400,-3595.4126000,9.5407900,0.0000000,0.0000000,-281.2500000); //object(58)
	CreateDynamicObject(18227,1376.2470700,-3580.5261200,14.9340500,0.0000000,0.0000000,67.5000000); //object(59)
	CreateDynamicObject(18227,1451.9335900,-3611.1872600,6.8013800,-6.8750000,4.2970000,-22.5000000); //object(60)
	CreateDynamicObject(18227,1328.6460000,-3648.7734400,-9.0034700,0.0000000,0.0000000,-174.1380000); //object(61)
	CreateDynamicObject(18227,1488.2690400,-3702.5249000,12.6585800,0.0000000,0.0000000,-45.0000000); //object(62)
	CreateDynamicObject(18227,1537.4589800,-3638.3242200,66.9138300,0.0000000,0.0000000,348.7450000); //object(63)
	CreateDynamicObject(18227,1463.4404300,-3490.1748000,43.5645100,0.0000000,0.0000000,281.2450000); //object(64)
	CreateDynamicObject(18227,1488.0483400,-3488.3330100,67.2110300,0.0000000,0.0000000,-101.2500000); //object(65)
	CreateDynamicObject(18227,1457.0322300,-3499.1823700,60.1117400,19.7670000,6.8750000,-117.5020000); //object(66)
	CreateDynamicObject(18227,1459.8281300,-3511.9948700,41.6781200,4.2970000,13.7510000,-123.7500000); //object(67)
	CreateDynamicObject(18227,1537.3164100,-3499.9687500,106.2972600,350.3570000,339.0700000,159.6370000); //object(68)
	CreateDynamicObject(18227,1480.1635700,-3560.2959000,51.8258400,25.7830000,0.0000000,-78.7500000); //object(69)
	CreateDynamicObject(18227,1411.5908200,-3436.2490200,14.9701900,0.0000000,0.0000000,-135.0000000); //object(70)
	CreateDynamicObject(18227,1388.6406300,-3321.7153300,-0.6972400,0.0000000,0.0000000,-146.2500000); //object(71)
	CreateDynamicObject(18227,1454.1235400,-3254.9155300,11.7337500,0.0000000,0.0000000,193.9080000); //object(72)
	CreateDynamicObject(17116,1615.1645500,-3766.3276400,20.9762900,0.0000000,6.8750000,101.9460000); //object(73)
	CreateDynamicObject(17116,1657.7021500,-3829.7085000,22.2952000,0.0000000,0.0000000,-11.2500000); //object(74)
	CreateDynamicObject(17116,1471.0351600,-4076.3198200,11.0603600,0.0000000,0.0000000,-112.6550000); //object(75)
	CreateDynamicObject(17116,1688.5908200,-3730.5712900,25.8147900,0.0000000,0.0000000,11.2500000); //object(76)
	CreateDynamicObject(17116,1655.5346700,-3641.3933100,19.5366600,0.0000000,0.0000000,-56.2500000); //object(77)
	CreateDynamicObject(17116,1777.9121100,-3853.2270500,63.9219400,-4.2970000,-3.4380000,0.0000000); //object(78)
	CreateDynamicObject(13212,1717.3613300,-3706.9433600,29.3127100,0.0000000,0.0000000,168.7500000); //object(79)
	CreateDynamicObject(17116,1775.7915000,-3635.7038600,46.8012000,0.0000000,0.0000000,-270.0000000); //object(80)
	CreateDynamicObject(17116,1860.0293000,-3641.4077100,58.8773500,0.0000000,0.0000000,-326.2500000); //object(81)
	CreateDynamicObject(17116,1856.0029300,-3707.4824200,62.2867900,0.0000000,0.0000000,-360.0000000); //object(82)
	CreateDynamicObject(17116,1804.8872100,-3740.7341300,55.8441400,0.0000000,-5.1570000,-382.5000000); //object(83)
	CreateDynamicObject(13236,1476.7080100,-4150.2695300,52.5206800,11.1680000,11.1680000,310.9300000); //object(86)
	CreateDynamicObject(13120,1585.2202100,-4018.5756800,28.4559400,0.0000000,12.8920000,-236.3270000); //object(87)
	CreateDynamicObject(13120,1690.1596700,-3962.2495100,51.2375100,-1.7190000,-22.3450000,0.0000000); //object(88)
	CreateDynamicObject(13120,1530.4013700,-3659.5234400,23.4912900,0.0000000,1.7140000,196.2490000); //object(89)
	CreateDynamicObject(18227,1505.5498000,-4127.9482400,41.4450000,0.0000000,2.5780000,-186.7980000); //object(90)
	CreateDynamicObject(18227,1424.3935500,-4059.7346200,26.5367900,-8.5940000,12.0320000,50.0020000); //object(91)
	CreateDynamicObject(18227,1340.3886700,-4121.1020500,64.2350600,0.0000000,0.0000000,-174.6890000); //object(92)
	CreateDynamicObject(18227,1343.6064500,-4189.8359400,59.4342100,0.0000000,0.0000000,303.7450000); //object(93)
	CreateDynamicObject(18227,1359.7363300,-4198.8095700,78.4478500,0.0000000,0.0000000,281.2450000); //object(94)
	CreateDynamicObject(18227,1297.1474600,-4200.4384800,64.8542800,0.0000000,0.0000000,225.0000000); //object(95)
	CreateDynamicObject(18227,1249.5185500,-4151.6201200,66.0333900,0.0000000,0.0000000,168.7500000); //object(96)
	CreateDynamicObject(18227,1181.7797900,-4069.1286600,69.6046000,346.5610000,347.6270000,81.5250000); //object(97)
	CreateDynamicObject(18227,1634.8085900,-4012.5610400,57.8087200,0.0000000,0.0000000,-56.2500000); //object(98)
	CreateDynamicObject(18227,1585.0029300,-3723.1084000,44.5518600,0.0000000,0.0000000,-11.2500000); //object(99)
	CreateDynamicObject(18227,1660.3828100,-3635.7182600,44.7904400,0.0000000,0.0000000,135.0000000); //object(100)
	CreateDynamicObject(10492,1659.7490200,-3499.2377900,16.8380300,0.0000000,-1.7190000,79.4550000); //object(101)
	CreateDynamicObject(18227,1607.7275400,-3610.3259300,63.7865100,17.1890000,3.4380000,68.2820000); //object(102)
	CreateDynamicObject(18227,1564.2202100,-3525.2448700,78.2851900,0.0000000,0.0000000,135.0000000); //object(103)
	CreateDynamicObject(18227,1572.1220700,-3495.9440900,75.5844700,17.1880000,12.0300000,105.5460000); //object(104)
	CreateDynamicObject(18227,1576.3256800,-3462.4414100,91.8987300,0.0000000,0.0000000,78.7500000); //object(105)
	CreateDynamicObject(18227,1625.1054700,-3491.1518600,54.9496200,0.0000000,0.0000000,104.3640000); //object(108)
	CreateDynamicObject(18227,1881.5195300,-3575.3750000,82.9600700,0.0000000,0.0000000,33.7500000); //object(110)
	CreateDynamicObject(18227,1935.0087900,-3624.3310500,87.5272800,0.0000000,0.0000000,326.2450000); //object(111)
	CreateDynamicObject(18227,1884.0112300,-3735.4614300,87.0732900,0.0000000,0.0000000,166.9570000); //object(112)
	CreateDynamicObject(18227,1922.7290000,-3663.3508300,80.0179100,0.0000000,4.2960000,187.8110000); //object(113)
	CreateDynamicObject(18227,1859.9257800,-3780.3164100,88.3077100,0.0000000,0.0000000,292.4950000); //object(114)
	CreateDynamicObject(18227,1843.0224600,-3824.7285200,90.2969100,0.0000000,353.1230000,169.6070000); //object(115)
	CreateDynamicObject(18227,1829.8432600,-3908.3056600,98.0677900,0.0000000,0.0000000,-90.0000000); //object(116)
	CreateDynamicObject(18227,1750.8076200,-3932.2441400,75.2958700,0.0000000,0.0000000,225.0000000); //object(117)
	CreateDynamicObject(18227,1703.5288100,-3911.1250000,66.2219000,0.0000000,0.0000000,-202.5000000); //object(118)
	CreateDynamicObject(18227,1424.7299800,-3961.9204100,-0.9540900,0.0000000,22.3450000,-123.7500000); //object(119)
	CreateDynamicObject(18227,1561.0883800,-3802.1582000,28.5046200,0.0000000,0.0000000,56.2500000); //object(120)
	CreateDynamicObject(18227,1592.2431600,-3915.4653300,30.4378500,2.5780000,-10.3130000,-56.2500000); //object(121)
	CreateDynamicObject(18227,1349.4843800,-4013.9492200,27.6515200,12.0320000,6.8750000,-236.2500000); //object(122)
	CreateDynamicObject(8493,1429.8252000,-4128.1367200,55.1675800,10.3130000,15.4700000,-98.7490000); //object(123)
	CreateDynamicObject(3594,1557.6372100,-3831.7465800,24.1654200,0.0000000,30.9400000,-22.5000000); //object(124)
	CreateDynamicObject(623,1327.9038100,-3460.6987300,0.1764400,11.1730000,0.0000000,33.7500000); //object(125)
	CreateDynamicObject(623,1297.2026400,-3491.1323200,3.4896600,11.1730000,0.0000000,78.7500000); //object(126)
	CreateDynamicObject(623,1357.9433600,-3443.0566400,2.7862200,11.1730000,0.0000000,11.2500000); //object(127)
	CreateDynamicObject(623,1257.7983400,-3520.1396500,3.5665000,11.1730000,0.0000000,11.2500000); //object(128)
	CreateDynamicObject(623,1314.7646500,-3523.0009800,9.4141800,11.1730000,0.0000000,56.2500000); //object(129)
	CreateDynamicObject(623,1369.9516600,-3469.6586900,13.3681700,27.5020000,0.0000000,22.5000000); //object(130)
	CreateDynamicObject(623,1340.8510700,-3498.8159200,12.4843700,27.5020000,0.0000000,78.7500000); //object(131)
	CreateDynamicObject(623,1434.0478500,-3295.4267600,14.2212000,27.5020000,0.0000000,78.7500000); //object(132)
	CreateDynamicObject(623,1378.9126000,-3386.1381800,1.3344500,27.5020000,0.0000000,67.5000000); //object(133)
	CreateDynamicObject(623,1379.2421900,-3387.8078600,0.7091800,27.5020000,0.0000000,130.5480000); //object(134)
	CreateDynamicObject(623,1239.4082000,-3603.2749000,-1.4655800,27.5020000,0.0000000,112.5000000); //object(135)
	CreateDynamicObject(623,1267.5415000,-3633.2529300,3.6021900,27.5020000,0.0000000,135.0000000); //object(136)
	CreateDynamicObject(623,1267.3042000,-3676.3820800,5.2303500,27.5020000,0.0000000,146.2500000); //object(137)
	CreateDynamicObject(623,1267.3154300,-3672.8586400,5.0379500,27.5020000,0.0000000,67.5000000); //object(138)
	CreateDynamicObject(623,1241.9902300,-3653.0107400,1.9219500,27.5020000,16.3290000,91.5640000); //object(140)
	CreateDynamicObject(623,1215.4106400,-3715.9794900,3.9472000,27.5020000,16.3290000,125.3140000); //object(141)
	CreateDynamicObject(623,1221.1743200,-3703.1752900,2.8185100,27.5020000,16.3290000,57.8140000); //object(142)
	CreateDynamicObject(623,1191.7163100,-3752.1440400,3.2766700,27.5020000,16.3290000,69.0640000); //object(143)
	CreateDynamicObject(623,1248.9375000,-3724.7558600,11.2835900,27.5020000,16.3290000,1.5640000); //object(144)
	CreateDynamicObject(623,1221.4917000,-3763.4362800,11.1462900,27.5020000,16.3290000,159.0640000); //object(145)
	CreateDynamicObject(623,1220.4311500,-3758.3027300,10.7524500,27.5020000,16.3290000,57.8140000); //object(146)
	CreateDynamicObject(623,1183.5024400,-3824.4687500,13.4950800,27.5020000,16.3290000,102.8140000); //object(147)
	CreateDynamicObject(623,1195.9169900,-3776.1967800,9.9281900,27.5020000,16.3290000,69.0640000); //object(148)
	CreateDynamicObject(623,1154.4716800,-3790.5688500,1.9146500,27.5020000,16.3290000,80.3140000); //object(149)
	CreateDynamicObject(623,1233.3344700,-3796.5471200,31.8497900,27.5020000,16.3290000,80.3140000); //object(150)
	CreateDynamicObject(623,1197.2490200,-3841.2402300,31.2917300,27.5020000,16.3290000,46.5640000); //object(151)
	CreateDynamicObject(623,1168.1484400,-3860.3073700,32.7428100,27.5020000,16.3290000,46.5640000); //object(152)
	CreateDynamicObject(10983,1412.7602500,-3743.0966800,-11.3064900,0.0000000,0.0000000,101.2500000); //object(153)
	CreateDynamicObject(10983,1409.0854500,-3638.9765600,-13.1897900,0.0000000,0.0000000,101.2500000); //object(154)
	CreateDynamicObject(791,1527.4458000,-3907.0695800,20.1680100,0.0000000,0.0000000,0.0000000); //object(156)
	CreateDynamicObject(791,1415.2075200,-4004.4887700,21.9615400,0.0000000,0.0000000,0.0000000); //object(157)
	CreateDynamicObject(791,1463.8256800,-3890.9809600,13.9482400,0.0000000,0.0000000,0.0000000); //object(158)
	CreateDynamicObject(791,1456.4072300,-3918.7353500,14.2281100,0.0000000,0.0000000,0.0000000); //object(159)
	CreateDynamicObject(791,1518.0200200,-4017.8540000,18.5588200,0.0000000,0.0000000,0.0000000); //object(160)
	CreateDynamicObject(791,1542.1762700,-3989.9792500,21.8514700,0.0000000,0.0000000,0.0000000); //object(161)
	CreateDynamicObject(791,1518.8730500,-3873.4216300,16.2835500,0.0000000,0.0000000,67.5000000); //object(162)
	CreateDynamicObject(791,1560.1772500,-3962.2031200,21.3470300,0.0000000,0.0000000,0.0000000); //object(163)
	CreateDynamicObject(791,1499.5400400,-3784.5605500,37.3043000,0.0000000,0.0000000,0.0000000); //object(164)
	CreateDynamicObject(791,1500.5913100,-3832.2832000,24.2724600,0.0000000,0.0000000,-11.2500000); //object(165)
	CreateDynamicObject(791,1457.9677700,-3742.5529800,8.7809700,0.0000000,0.0000000,0.0000000); //object(166)
	CreateDynamicObject(791,1447.8198200,-3704.7885700,1.3429000,0.0000000,0.0000000,0.0000000); //object(167)
	CreateDynamicObject(791,1350.4765600,-3793.1857900,50.2871500,0.0000000,0.0000000,0.0000000); //object(168)
	CreateDynamicObject(791,1316.0459000,-3781.8925800,33.5309200,0.0000000,0.0000000,0.0000000); //object(169)
	CreateDynamicObject(791,1337.2631800,-3755.3586400,24.3328000,0.0000000,0.0000000,0.0000000); //object(170)
	CreateDynamicObject(791,1270.3256800,-3798.7265600,29.9574700,0.0000000,0.0000000,0.0000000); //object(171)
	CreateDynamicObject(791,1290.5239300,-3746.1477100,13.6398100,0.0000000,0.0000000,0.0000000); //object(172)
	CreateDynamicObject(791,1313.6513700,-3646.8261700,9.4672300,0.0000000,0.0000000,-90.0000000); //object(173)
	CreateDynamicObject(791,1305.1752900,-3698.4597200,20.4913100,0.0000000,0.0000000,-90.0000000); //object(174)
	CreateDynamicObject(791,1365.9477500,-3848.1865200,55.4526500,0.0000000,0.0000000,-90.0000000); //object(175)
	CreateDynamicObject(791,1380.5654300,-3810.1298800,47.9016200,0.0000000,0.0000000,-90.0000000); //object(176)
	CreateDynamicObject(791,1422.8261700,-3956.6484400,8.0635200,0.0000000,0.0000000,-90.0000000); //object(177)
	CreateDynamicObject(791,1376.3227500,-4018.9614300,18.9893700,0.0000000,0.0000000,-90.0000000); //object(178)
	CreateDynamicObject(791,1397.8740200,-3981.3825700,14.1462200,0.0000000,0.0000000,-90.0000000); //object(179)
	CreateDynamicObject(791,1346.3100600,-3915.7797900,79.4802700,0.0000000,0.0000000,-90.0000000); //object(180)
	CreateDynamicObject(791,1319.7553700,-3950.6760300,83.5268700,0.0000000,0.0000000,-90.0000000); //object(181)
	CreateDynamicObject(791,1275.5835000,-3996.2900400,62.7051900,0.0000000,0.0000000,-90.0000000); //object(182)
	CreateDynamicObject(791,1221.3911100,-4057.0747100,60.2929500,0.0000000,0.0000000,-90.0000000); //object(183)
	CreateDynamicObject(791,1259.3862300,-4045.1669900,55.7100000,0.0000000,0.0000000,-90.0000000); //object(184)
	CreateDynamicObject(791,1332.4223600,-4080.0466300,51.9597200,0.0000000,0.0000000,-90.0000000); //object(185)
	CreateDynamicObject(791,1315.7504900,-4137.2578100,59.6983000,0.0000000,0.0000000,-90.0000000); //object(186)
	CreateDynamicObject(791,1406.5571300,-4143.4243200,91.2540100,0.0000000,0.0000000,-90.0000000); //object(187)
	CreateDynamicObject(791,1441.3852500,-4142.3735400,93.9889500,0.0000000,0.0000000,-90.0000000); //object(188)
	CreateDynamicObject(791,1511.9658200,-4169.7324200,49.9432600,0.0000000,0.0000000,-90.0000000); //object(189)
	CreateDynamicObject(791,1566.6533200,-4132.3286100,69.0339200,0.0000000,0.0000000,-90.0000000); //object(190)
	CreateDynamicObject(791,1626.6562500,-3899.6377000,53.9827000,0.0000000,0.0000000,-90.0000000); //object(191)
	CreateDynamicObject(791,1636.8725600,-3770.4956100,28.9827200,0.0000000,0.0000000,0.0000000); //object(195)
	CreateDynamicObject(10357,1813.4882800,-3877.6362300,172.1985800,0.0000000,0.0000000,-168.7500000); //object(198)
	CreateDynamicObject(791,1877.9897500,-3620.4453100,73.9590600,0.0000000,0.0000000,0.0000000); //object(199)
	CreateDynamicObject(791,1870.3745100,-3674.4243200,72.7810700,0.0000000,0.0000000,0.0000000); //object(200)
	CreateDynamicObject(791,1831.5903300,-3745.8881800,71.5408800,0.0000000,0.0000000,0.0000000); //object(201)
	CreateDynamicObject(791,1782.2148400,-3595.0744600,65.3429300,0.0000000,0.0000000,0.0000000); //object(202)
	CreateDynamicObject(791,1829.9624000,-3618.6530800,60.6898000,0.0000000,0.0000000,0.0000000); //object(203)
	CreateDynamicObject(791,1815.1396500,-3544.0742200,77.9980500,0.0000000,0.0000000,0.0000000); //object(204)
	CreateDynamicObject(791,1919.3164100,-3736.9521500,84.0912200,0.0000000,0.0000000,0.0000000); //object(205)
	CreateDynamicObject(791,1709.5317400,-3631.1323200,44.5498500,0.0000000,0.0000000,0.0000000); //object(206)
	CreateDynamicObject(791,1742.7104500,-3613.1516100,57.7386600,0.0000000,0.0000000,0.0000000); //object(207)
	CreateDynamicObject(791,1614.6894500,-3560.3833000,44.3472500,0.0000000,0.0000000,0.0000000); //object(208)
	CreateDynamicObject(791,1664.5273400,-3571.3960000,38.3819700,0.0000000,0.0000000,0.0000000); //object(209)
	CreateDynamicObject(791,1745.7929700,-3762.8798800,60.2404900,0.0000000,0.0000000,0.0000000); //object(210)
	CreateDynamicObject(791,1704.8627900,-3682.1716300,47.5199000,0.0000000,0.0000000,0.0000000); //object(211)
	CreateDynamicObject(791,1810.0380900,-3699.3029800,61.4386700,0.0000000,0.0000000,0.0000000); //object(212)
	CreateDynamicObject(791,1699.7089800,-3819.3027300,40.8786900,0.0000000,0.0000000,0.0000000); //object(213)
	CreateDynamicObject(791,1732.4780300,-3875.6713900,54.0278500,0.0000000,0.0000000,0.0000000); //object(216)
	CreateDynamicObject(791,1792.1044900,-3794.0288100,65.8731900,0.0000000,0.0000000,0.0000000); //object(217)
	CreateDynamicObject(791,1581.1709000,-3765.8808600,28.4622400,0.0000000,0.0000000,348.7450000); //object(218)
	CreateDynamicObject(791,1597.7959000,-3677.8852500,60.8783900,0.0000000,0.0000000,0.0000000); //object(221)
	CreateDynamicObject(791,1489.9287100,-4079.7270500,19.6892500,0.0000000,0.0000000,0.0000000); //object(222)
	CreateDynamicObject(791,1437.2553700,-4029.0219700,9.6948600,0.0000000,0.0000000,0.0000000); //object(223)
	CreateDynamicObject(791,1462.0693400,-4105.3310500,27.0111300,0.0000000,0.0000000,-33.7500000); //object(226)
	CreateDynamicObject(791,1421.4409200,-4073.1396500,24.4490900,0.0000000,0.0000000,0.0000000); //object(227)
	CreateDynamicObject(791,1226.7959000,-4173.6025400,64.6288000,0.0000000,0.0000000,0.0000000); //object(228)
	CreateDynamicObject(791,1197.3271500,-4107.5478500,56.3299100,0.0000000,0.0000000,337.4950000); //object(229)
	CreateDynamicObject(791,1303.6377000,-4209.4897500,60.3339500,0.0000000,0.0000000,0.0000000); //object(230)
	CreateDynamicObject(791,1439.7573200,-3846.4641100,1.6259300,0.0000000,0.0000000,-67.5000000); //object(231)
	CreateDynamicObject(791,1531.7490200,-3621.3154300,70.0530900,0.0000000,0.0000000,0.0000000); //object(232)
	CreateDynamicObject(791,1521.7143600,-3548.8723100,95.7488300,0.0000000,0.0000000,-33.7500000); //object(233)
	CreateDynamicObject(791,1408.2539100,-3543.3708500,20.3825700,0.0000000,0.0000000,0.0000000); //object(234)
	CreateDynamicObject(791,1391.5678700,-3557.5693400,15.8739500,0.0000000,0.0000000,-56.2500000); //object(235)
	CreateDynamicObject(791,1448.1293900,-3618.1342800,6.4121700,0.0000000,0.0000000,0.0000000); //object(236)
	CreateDynamicObject(791,1456.4340800,-3668.5087900,6.4136100,0.0000000,0.0000000,-247.5000000); //object(237)
	CreateDynamicObject(791,1492.0791000,-3978.6748000,15.1956000,0.0000000,0.0000000,-45.0000000); //object(238)
	CreateDynamicObject(789,1793.2255900,-3741.7900400,76.4423400,0.0000000,0.0000000,0.0000000); //object(240)
	CreateDynamicObject(789,1776.0004900,-3636.1774900,72.4280500,0.0000000,0.0000000,0.0000000); //object(241)
	CreateDynamicObject(789,1645.4282200,-3710.3422900,66.3121300,0.0000000,0.0000000,-67.5000000); //object(242)
	CreateDynamicObject(789,1540.3530300,-3834.0324700,44.4719800,0.0000000,0.0000000,0.0000000); //object(243)
	CreateDynamicObject(789,1698.6723600,-3724.5473600,65.3377500,0.0000000,0.0000000,0.0000000); //object(246)
	CreateDynamicObject(789,1742.0859400,-3802.6884800,69.2247900,0.0000000,0.0000000,0.0000000); //object(247)
	CreateDynamicObject(789,1673.8691400,-3840.4013700,52.4960800,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(789,1563.6782200,-3857.4506800,32.1275200,0.0000000,0.0000000,0.0000000); //object(251)
	CreateDynamicObject(789,1545.5542000,-3686.5783700,66.3059400,0.0000000,0.0000000,0.0000000); //object(253)
	CreateDynamicObject(789,1361.6674800,-3544.2758800,37.8402300,0.0000000,0.0000000,0.0000000); //object(256)
	CreateDynamicObject(789,1429.3232400,-3729.7431600,13.6086900,0.0000000,0.0000000,0.0000000); //object(257)
	CreateDynamicObject(789,1368.7807600,-3763.9165000,56.0333400,0.0000000,0.0000000,0.0000000); //object(258)
	CreateDynamicObject(789,1372.7773400,-3675.0100100,33.2499400,0.0000000,0.0000000,0.0000000); //object(259)
	CreateDynamicObject(789,1410.1518600,-3622.9487300,20.5141500,0.0000000,0.0000000,-168.7500000); //object(260)
	CreateDynamicObject(789,1385.6635700,-3483.8598600,34.0878900,0.0000000,0.0000000,0.0000000); //object(263)
	CreateDynamicObject(789,1418.5356400,-3398.5163600,32.5983500,0.0000000,0.0000000,0.0000000); //object(264)
	CreateDynamicObject(791,1461.9477500,-3411.2959000,38.9039900,0.0000000,0.0000000,0.0000000); //object(265)
	CreateDynamicObject(791,1448.3676800,-3463.1064500,29.4876600,0.0000000,0.0000000,0.0000000); //object(266)
	CreateDynamicObject(791,1449.7260700,-3370.9755900,40.5171800,0.0000000,0.0000000,0.0000000); //object(267)
	CreateDynamicObject(791,1243.9697300,-3735.7280300,6.9092200,0.0000000,0.0000000,45.0000000); //object(268)
	CreateDynamicObject(789,1247.7812500,-3727.1367200,15.6344900,0.0000000,0.0000000,0.0000000); //object(269)
	CreateDynamicObject(789,1180.0522500,-3879.4531200,55.6182800,0.0000000,0.0000000,0.0000000); //object(270)
	CreateDynamicObject(791,1173.3466800,-3913.2346200,44.9167900,0.0000000,0.0000000,0.0000000); //object(271)
	CreateDynamicObject(789,1269.4287100,-3767.7377900,36.7835500,0.0000000,0.0000000,0.0000000); //object(272)
	CreateDynamicObject(789,1335.9804700,-3829.7846700,72.1138500,0.0000000,0.0000000,0.0000000); //object(273)
	CreateDynamicObject(789,1446.0712900,-3500.5302700,84.1301300,0.0000000,0.0000000,0.0000000); //object(275)
	CreateDynamicObject(791,1343.7612300,-3521.3728000,8.0453100,0.0000000,0.0000000,0.0000000); //object(276)
	CreateDynamicObject(791,1454.6743200,-3321.5061000,19.9260000,0.0000000,0.0000000,0.0000000); //object(277)
	CreateDynamicObject(791,1418.3842800,-3359.8278800,8.3811100,0.0000000,0.0000000,0.0000000); //object(278)
	CreateDynamicObject(789,1380.8056600,-3366.0712900,18.0496100,0.0000000,0.0000000,-146.2500000); //object(279)
	CreateDynamicObject(789,1354.5791000,-3482.0190400,20.3609900,0.0000000,0.0000000,-146.2500000); //object(280)
	CreateDynamicObject(790,1394.8515600,-3411.4270000,6.9823400,0.0000000,0.0000000,-135.0000000); //object(281)
	CreateDynamicObject(790,1388.3398400,-3468.4538600,14.5184100,0.0000000,0.0000000,-135.0000000); //object(282)
	CreateDynamicObject(1683,1265.7617200,-3656.7895500,7.1044100,19.7670000,0.8590000,29.3750000); //object(283)
	CreateDynamicObject(1683,1289.8750000,-3637.2490200,-1.4366900,-1.7190000,-38.6750000,180.0000000); //object(284)
	CreateDynamicObject(1683,1255.9770500,-3674.7641600,-1.4396400,-146.9640000,-1.7190000,225.8590000); //object(285)
	CreateDynamicObject(3881,1831.3584000,-3850.3933100,96.0844800,-1.7190000,0.0000000,11.2500000); //object(286)
	CreateDynamicObject(10757,1518.3579100,-3710.7402300,32.4386700,-162.4340000,18.0480000,-45.0000000); //object(287)
	CreateDynamicObject(12990,1220.1894500,-3615.6464800,0.9442900,0.0000000,0.0000000,-101.2500000); //object(291)
	CreateDynamicObject(17068,1342.6875000,-3429.9370100,0.5606700,0.0000000,0.0000000,-135.0000000); //object(292)
	CreateDynamicObject(11495,1341.9335900,-3426.8107900,0.5702000,0.0000000,0.0000000,-315.0000000); //object(293)
	CreateDynamicObject(11495,1327.2783200,-3412.1445300,0.5917600,0.0000000,0.0000000,-315.0000000); //object(294)
	CreateDynamicObject(11495,1327.3261700,-3414.6098600,0.5795300,0.0000000,0.0000000,-135.0000000); //object(295)
	CreateDynamicObject(17068,1312.9072300,-3412.2133800,0.5920700,0.0000000,0.0000000,-405.0000000); //object(297)
	CreateDynamicObject(9958,1292.8056600,-3423.5000000,4.3482800,0.0000000,0.0000000,135.0000000); //object(298)
	CreateDynamicObject(3241,1741.0639600,-3725.8974600,64.6400500,0.0000000,0.0000000,-101.2500000); //object(299)
	CreateDynamicObject(3241,1786.7793000,-3718.0273400,64.6400500,0.0000000,0.0000000,-11.2500000); //object(300)
	CreateDynamicObject(3178,1795.0835000,-3677.5039100,66.8350500,0.0000000,0.0000000,168.7500000); //object(301)
	CreateDynamicObject(3242,1790.6215800,-3699.0949700,66.0302600,0.0000000,0.0000000,-101.2500000); //object(302)
	CreateDynamicObject(3316,1766.6860400,-3731.5324700,65.3557700,0.0000000,0.0000000,-101.2500000); //object(303)
	CreateDynamicObject(3443,1762.9829100,-3671.8725600,66.1248200,0.0000000,0.0000000,-11.2500000); //object(304)
	CreateDynamicObject(3241,1767.2504900,-3713.4121100,64.6400500,0.0000000,0.0000000,-191.2500000); //object(305)
	CreateDynamicObject(3499,1609.9018600,-3779.5856900,34.7011700,0.0000000,0.0000000,0.0000000); //object(307)
	CreateDynamicObject(3499,1621.7036100,-3801.0358900,31.8291500,0.0000000,0.0000000,0.0000000); //object(308)
	CreateDynamicObject(3499,1610.7895500,-3750.2106900,47.3289500,0.0000000,0.0000000,0.0000000); //object(309)
	CreateDynamicObject(3499,1640.9067400,-3818.7602500,33.1764100,0.0000000,0.0000000,0.0000000); //object(310)
	CreateDynamicObject(3499,1654.4174800,-3841.1767600,40.1319300,0.0000000,0.0000000,0.0000000); //object(312)
	CreateDynamicObject(3499,1655.5400400,-3866.5183100,55.3424900,0.0000000,0.0000000,0.0000000); //object(315)
	CreateDynamicObject(3499,1658.8549800,-3888.3957500,63.7636900,0.0000000,0.0000000,0.0000000); //object(316)
	CreateDynamicObject(1381,1612.2998000,-3751.0085400,51.9594300,91.1000000,0.0000000,-303.7500000); //object(320)
	CreateDynamicObject(1381,1620.6914100,-3799.6940900,36.1977100,91.1000000,0.0000000,-135.0000000); //object(321)
	CreateDynamicObject(1381,1608.9355500,-3778.1574700,39.0139800,91.1000000,0.0000000,-135.0000000); //object(322)
	CreateDynamicObject(1381,1609.5278300,-3749.1337900,51.9965800,91.1000000,0.0000000,-123.7500000); //object(323)
	CreateDynamicObject(1381,1622.9838900,-3802.1337900,36.2373200,91.1000000,0.0000000,-315.0000000); //object(325)
	CreateDynamicObject(1381,1642.0390600,-3819.9331100,37.9361300,91.1000000,0.0000000,-315.0000000); //object(326)
	CreateDynamicObject(1381,1639.8657200,-3817.3925800,37.8876700,91.1000000,0.0000000,-135.0000000); //object(327)
	CreateDynamicObject(1381,1653.2768600,-3839.9741200,44.6309700,91.1000000,0.0000000,-135.0000000); //object(328)
	CreateDynamicObject(1381,1611.1630900,-3780.6584500,38.9887400,91.1000000,0.0000000,-315.0000000); //object(329)
	CreateDynamicObject(1381,1657.7143600,-3887.1599100,67.9465300,91.1000000,0.0000000,-135.0000000); //object(332)
	CreateDynamicObject(1381,1660.1347700,-3889.4184600,67.9840500,91.1000000,0.0000000,45.0000000); //object(334)
	CreateDynamicObject(1381,1655.6455100,-3842.2744100,44.6718400,91.1000000,0.0000000,45.0000000); //object(335)
	CreateDynamicObject(1381,1656.7817400,-3867.5910600,59.7760300,91.1000000,0.0000000,-315.0000000); //object(336)
	CreateDynamicObject(1381,1654.5239300,-3865.1884800,59.7086400,91.1000000,0.0000000,-135.0000000); //object(338)
	CreateDynamicObject(789,1478.8681600,-4059.7058100,31.1243400,0.0000000,0.0000000,0.0000000); //object(344)
	CreateDynamicObject(789,1287.9770500,-4121.8632800,77.0476300,0.0000000,0.0000000,0.0000000); //object(345)
	CreateDynamicObject(789,1252.0712900,-4073.4658200,76.8648300,0.0000000,0.0000000,0.0000000); //object(346)
	CreateDynamicObject(789,1395.5258800,-4067.6140100,59.9364600,0.0000000,0.0000000,0.0000000); //object(347)
	CreateDynamicObject(789,1479.7631800,-4115.2690400,46.5876500,0.0000000,0.0000000,0.0000000); //object(348)
	CreateDynamicObject(709,1412.4028300,-4086.4802200,28.9091500,0.0000000,0.0000000,0.0000000); //object(351)
	CreateDynamicObject(705,1441.4643600,-4091.4863300,31.9417700,0.0000000,0.0000000,0.0000000); //object(356)
	CreateDynamicObject(707,1294.8320300,-4064.4541000,61.5313500,0.0000000,0.0000000,0.0000000); //object(357)
	CreateDynamicObject(707,1372.8027300,-3942.5195300,16.0702400,0.0000000,0.0000000,0.0000000); //object(358)
	CreateDynamicObject(703,1394.0419900,-4103.3027300,25.6145400,0.0000000,0.0000000,-56.2500000); //object(361)
	CreateDynamicObject(703,1403.1499000,-4081.1574700,26.2964200,0.0000000,0.0000000,0.0000000); //object(362)
	CreateDynamicObject(703,1422.4438500,-4136.2866200,36.4086600,0.0000000,0.0000000,-11.2500000); //object(363)
	CreateDynamicObject(703,1365.5273400,-4071.7294900,48.7611700,0.0000000,0.0000000,0.0000000); //object(364)
	CreateDynamicObject(703,1343.6630900,-4029.1467300,42.4495100,0.0000000,0.0000000,0.0000000); //object(365)
	CreateDynamicObject(703,1300.4755900,-4091.4096700,63.6983200,0.0000000,0.0000000,0.0000000); //object(366)
	CreateDynamicObject(703,1358.2973600,-3964.7934600,15.3937000,0.0000000,0.0000000,0.0000000); //object(368)
	CreateDynamicObject(703,1423.5717800,-3933.1899400,16.9300400,0.0000000,0.0000000,0.0000000); //object(370)
	CreateDynamicObject(703,1551.3247100,-3939.9248000,23.2535700,0.0000000,0.0000000,0.0000000); //object(372)
	CreateDynamicObject(703,1497.5546900,-3967.3444800,18.7961400,0.0000000,0.0000000,0.0000000); //object(373)
	CreateDynamicObject(703,1539.2319300,-3956.7861300,21.7328400,0.0000000,0.0000000,0.0000000); //object(374)
	CreateDynamicObject(703,1521.7749000,-3921.4348100,22.4170700,0.0000000,0.0000000,0.0000000); //object(375)
	CreateDynamicObject(703,1466.3808600,-3915.7133800,18.8532300,0.0000000,0.0000000,0.0000000); //object(376)
	CreateDynamicObject(2567,1249.3144500,-3664.1464800,5.0304000,12.8920000,-1.7190000,33.5180000); //object(319)
	CreateDynamicObject(3576,1245.3393600,-3655.8698700,2.4404900,11.1730000,20.6260000,36.9560000); //object(320)
	CreateDynamicObject(3576,1247.3413100,-3654.4062500,4.3672900,0.0000000,0.0000000,0.0000000); //object(321)
	CreateDynamicObject(3577,1253.7646500,-3675.7002000,4.7589000,0.0000000,0.0000000,11.2500000); //object(322)
	CreateDynamicObject(3796,1250.1582000,-3648.5439500,3.0508400,0.0000000,0.0000000,-45.0000000); //object(323)
	CreateDynamicObject(3761,1204.2475600,-3792.0246600,18.0759700,0.0000000,0.0000000,-33.7500000); //object(325)
	CreateDynamicObject(3798,1198.8364300,-3794.0063500,14.5927300,0.0000000,0.0000000,0.0000000); //object(326)
	CreateDynamicObject(3799,1197.2158200,-3796.2822300,14.2026500,0.0000000,0.0000000,-33.7500000); //object(327)
	CreateDynamicObject(3875,1179.4941400,-3795.1001000,17.6155100,0.0000000,0.0000000,0.0000000); //object(328)
	CreateDynamicObject(3863,1199.0327100,-3782.6276900,13.8797600,1.7190000,0.0000000,-123.7500000); //object(329)
	CreateDynamicObject(3863,1170.0532200,-3807.0000000,10.2541300,0.0000000,0.0000000,-146.2500000); //object(330)
	CreateDynamicObject(3862,1179.8081100,-3814.5939900,13.6578100,0.0000000,0.0000000,-157.5000000); //object(332)
	CreateDynamicObject(3861,1204.1215800,-3761.8918500,9.6046500,0.0000000,0.0000000,-22.5000000); //object(333)
	CreateDynamicObject(3860,1207.5844700,-3786.2497600,16.7595800,0.0000000,0.0000000,-101.2500000); //object(334)
	CreateDynamicObject(3860,1247.6103500,-3671.8779300,4.4340000,0.0000000,0.0000000,-90.0000000); //object(335)
	CreateDynamicObject(3860,1246.8940400,-3659.9060100,4.1138100,0.0000000,0.0000000,-67.5000000); //object(336)
	CreateDynamicObject(3861,1251.4545900,-3633.8496100,4.0494600,0.0000000,0.0000000,-67.5000000); //object(337)
	CreateDynamicObject(3863,1245.9404300,-3629.0485800,3.3808000,0.0000000,0.0000000,-11.2500000); //object(338)
	CreateDynamicObject(3862,1249.9775400,-3642.2529300,4.0696000,0.0000000,0.0000000,-112.5000000); //object(339)
	CreateDynamicObject(3577,1425.2856400,-4120.8955100,43.7364800,13.7510000,-12.8920000,0.0000000); //object(341)
	CreateDynamicObject(3577,1426.0429700,-4114.1606400,38.0372700,-6.0160000,4.2970000,112.5000000); //object(342)
	CreateDynamicObject(3576,1415.8657200,-4112.3222700,37.1689800,6.8750000,-7.7350000,-56.2500000); //object(343)
	CreateDynamicObject(3576,1439.8842800,-4114.9760700,40.2487500,-2.5780000,-12.0320000,-112.5000000); //object(344)
	CreateDynamicObject(3799,1433.8154300,-4116.9428700,38.5140500,-2.5780000,-8.5940000,0.0000000); //object(347)
	CreateDynamicObject(647,1432.2290000,-4108.1084000,38.0234500,0.0000000,0.0000000,0.0000000); //object(348)
	CreateDynamicObject(647,1408.1181600,-4113.7060500,34.8340000,0.0000000,0.0000000,0.0000000); //object(349)
	CreateDynamicObject(760,1421.4755900,-4107.0366200,35.8300500,0.0000000,0.0000000,0.0000000); //object(350)
	CreateDynamicObject(800,1423.5932600,-4095.6250000,34.9581200,0.0000000,0.0000000,0.0000000); //object(351)
	CreateDynamicObject(818,1443.7338900,-4080.0136700,33.8787000,0.0000000,0.0000000,0.0000000); //object(355)
	CreateDynamicObject(818,1406.2670900,-3865.8940400,10.9163000,0.0000000,0.0000000,0.0000000); //object(356)
	CreateDynamicObject(827,1507.4877900,-3930.7377900,24.8008900,0.0000000,0.0000000,0.0000000); //object(359)
	CreateDynamicObject(855,1407.8359400,-3670.2004400,1.5269400,0.0000000,0.0000000,0.0000000); //object(361)
	CreateDynamicObject(855,1416.4550800,-3708.0410200,-0.1361100,0.0000000,0.0000000,0.0000000); //object(362)
	CreateDynamicObject(855,1377.0502900,-3674.8671900,-0.7130500,0.0000000,0.0000000,0.0000000); //object(363)
	CreateDynamicObject(14596,1520.9140600,-3943.0700700,14.4638000,0.0000000,0.0000000,-742.5000000); //object(365)
	CreateDynamicObject(16649,1512.8632800,-3935.6342800,8.8175700,0.0000000,0.0000000,-22.5000000); //object(366)
	CreateDynamicObject(1698,1517.4897500,-3937.7338900,12.3696800,0.0000000,90.2410000,-22.5000000); //object(367)
	CreateDynamicObject(3095,1518.8237300,-3945.1362300,26.3509300,0.0000000,179.6230000,-22.5000000); //object(373)
	CreateDynamicObject(3095,1525.2470700,-3936.8186000,21.8739000,0.0000000,89.3810000,-112.5000000); //object(374)
	CreateDynamicObject(3095,1528.1650400,-3942.8994100,21.8504700,0.0000000,89.3810000,-202.5000000); //object(379)
	CreateDynamicObject(3095,1522.4692400,-3935.6435500,21.8670200,0.0000000,89.3810000,-112.5000000); //object(380)
	CreateDynamicObject(3095,1525.8803700,-3948.4829100,21.8504700,0.0000000,89.3810000,-202.5000000); //object(381)
	CreateDynamicObject(3095,1516.8730500,-3949.6608900,21.8585900,0.0000000,89.3810000,-292.5000000); //object(382)
	CreateDynamicObject(3095,1519.8183600,-3950.8955100,21.8670100,0.0000000,89.3810000,-292.5000000); //object(383)
	CreateDynamicObject(3095,1514.8808600,-3942.5461400,21.8698400,0.0000000,89.3810000,-22.5000000); //object(385)
	CreateDynamicObject(3095,1514.3476600,-3943.7824700,21.8591600,0.0000000,89.3810000,-22.5000000); //object(386)
	CreateDynamicObject(3095,1520.7661100,-3940.0605500,26.3598100,0.0000000,179.6230000,-22.5000000); //object(389)
	CreateDynamicObject(3095,1521.3813500,-3946.1635700,26.3622300,0.0000000,179.6230000,-22.5000000); //object(390)
	CreateDynamicObject(3095,1523.4345700,-3941.3540000,26.3615000,0.0000000,179.6230000,-22.5000000); //object(391)
	CreateDynamicObject(1698,1517.9736300,-3935.0835000,22.8159800,89.3810000,-1.7190000,-112.5000000); //object(395)
	CreateDynamicObject(1698,1517.6870100,-3935.7675800,22.8160700,89.3810000,-1.7190000,-112.5000000); //object(397)
	CreateDynamicObject(1698,1517.6035200,-3936.0048800,25.1235400,0.0000000,-89.3810000,-23.3590000); //object(399)
	CreateDynamicObject(1698,1517.2207000,-3936.8979500,25.1096600,0.0000000,-89.3810000,-23.3590000); //object(400)
	CreateDynamicObject(1698,1517.1308600,-3937.5402800,24.5684000,0.0000000,-89.3810000,-383.3590000); //object(401)
	CreateDynamicObject(789,1515.5766600,-3963.8115200,36.5436200,0.0000000,0.0000000,-135.0000000); //object(403)
	CreateDynamicObject(762,1511.4643600,-3950.6962900,25.6323500,0.0000000,0.0000000,-78.7500000); //object(404)
	CreateDynamicObject(762,1533.7255900,-3936.3286100,26.4506300,0.0000000,0.0000000,33.7500000); //object(406)
	CreateDynamicObject(762,1572.7104500,-3828.9126000,26.4054200,0.0000000,0.0000000,0.0000000); //object(407)
	CreateDynamicObject(762,1719.0273400,-3704.5659200,64.2892900,0.0000000,0.0000000,0.0000000); //object(409)
	CreateDynamicObject(762,1727.5131800,-3748.2233900,64.7817500,0.0000000,0.0000000,0.0000000); //object(410)
	CreateDynamicObject(762,1736.7685500,-3759.4792500,65.4232400,0.0000000,0.0000000,0.0000000); //object(411)
	CreateDynamicObject(762,1768.6748000,-3775.0097700,67.9312700,0.0000000,0.0000000,0.0000000); //object(412)
	CreateDynamicObject(762,1737.8325200,-3659.1469700,65.4430100,0.0000000,0.0000000,0.0000000); //object(413)
	CreateDynamicObject(1408,1738.5893600,-3696.3501000,64.6893300,0.0000000,0.0000000,-101.2500000); //object(414)
	CreateDynamicObject(1408,1737.4951200,-3701.7536600,64.6893300,0.0000000,0.0000000,-101.2500000); //object(415)
	CreateDynamicObject(1408,1736.4638700,-3707.1547900,64.6893300,0.0000000,0.0000000,-101.2500000); //object(416)
	CreateDynamicObject(1408,1736.0644500,-3709.1298800,64.6893300,0.0000000,0.0000000,-101.2500000); //object(417)
	CreateDynamicObject(1408,1738.0835000,-3712.5690900,64.6893300,0.0000000,0.0000000,-14.6880000); //object(418)
	CreateDynamicObject(1408,1746.3471700,-3700.7373000,64.6893300,0.0000000,0.0000000,78.7500000); //object(421)
	CreateDynamicObject(1408,1749.6186500,-3698.4707000,64.6893300,0.0000000,0.0000000,-11.2500000); //object(422)
	CreateDynamicObject(1408,1751.9794900,-3699.0080600,64.8084700,0.0000000,0.0000000,-11.2500000); //object(423)
	CreateDynamicObject(1408,1754.2363300,-3702.3164100,64.6893300,0.0000000,0.0000000,-101.2500000); //object(424)
	CreateDynamicObject(1408,1757.7553700,-3717.4218700,64.6893300,0.0000000,0.0000000,-11.2500000); //object(428)
	CreateDynamicObject(1408,1761.0742200,-3715.4201700,64.6893300,0.0000000,0.0000000,78.7500000); //object(429)
	CreateDynamicObject(1408,1762.2099600,-3710.0739700,64.6893300,0.0000000,0.0000000,78.7500000); //object(430)
	CreateDynamicObject(1408,1763.5590800,-3704.8691400,64.6893300,0.0000000,0.0000000,73.5930000); //object(431)
	CreateDynamicObject(1408,1760.3710900,-3697.9008800,64.6893300,0.0000000,0.0000000,-191.2500000); //object(432)
	CreateDynamicObject(1408,1741.6586900,-3694.0942400,64.6893300,0.0000000,0.0000000,-191.2500000); //object(433)
	CreateDynamicObject(1223,1740.9682600,-3713.3759800,64.0817500,0.0000000,0.0000000,-11.2500000); //object(434)
	CreateDynamicObject(1223,1757.7011700,-3697.0546900,64.0817500,0.0000000,0.0000000,-202.5000000); //object(435)
	CreateDynamicObject(1223,1744.5200200,-3694.4956100,64.0817500,0.0000000,0.0000000,-11.2500000); //object(436)
	CreateDynamicObject(1223,1755.4277300,-3716.7463400,64.0817500,0.0000000,0.0000000,168.7500000); //object(437)
	CreateDynamicObject(1223,1777.7959000,-3683.5883800,64.0621000,0.0000000,0.0000000,-101.2500000); //object(438)
	CreateDynamicObject(1223,1774.3823200,-3708.2495100,64.0817500,0.0000000,0.0000000,90.0000000); //object(440)
	CreateDynamicObject(1223,1754.1181600,-3728.9863300,64.0817500,0.0000000,0.0000000,78.7500000); //object(441)
	CreateDynamicObject(1223,1751.3281300,-3654.4343300,63.9724500,0.0000000,0.0000000,-101.2500000); //object(443)
	CreateDynamicObject(1216,1752.5771500,-3698.8767100,64.7859600,0.0000000,0.0000000,-191.2500000); //object(444)
	CreateDynamicObject(16647,1528.4736300,-3920.1352500,3.7963700,0.0000000,0.0000000,157.5000000); //object(447)
	CreateDynamicObject(3095,1528.7465800,-3937.6897000,1.3624900,0.0000000,89.3810000,-22.5000000); //object(448)
	CreateDynamicObject(3095,1523.1440400,-3905.5097700,3.8689400,0.0000000,89.3810000,-202.5000000); //object(449)
	CreateDynamicObject(3095,1517.6879900,-3941.0561500,5.0282500,0.0000000,89.3810000,-202.5000000); //object(451)
	CreateDynamicObject(3095,1534.0488300,-3900.8400900,3.6145700,0.0000000,89.3810000,67.5000000); //object(453)
	CreateDynamicObject(3095,1538.4550800,-3902.6767600,3.8689400,0.0000000,89.3790000,67.4950000); //object(454)
	CreateDynamicObject(1698,1519.3461900,-3941.3115200,7.5726600,0.0000000,-89.3810000,-113.3590000); //object(456)
	CreateDynamicObject(16643,1531.6152300,-3911.6704100,5.1376000,0.0000000,0.0000000,-22.5000000); //object(457)
	CreateDynamicObject(16665,1501.1259800,-3930.8147000,7.2856800,0.0000000,0.0000000,-22.5000000); //object(459)
	CreateDynamicObject(1698,1505.7358400,-3934.7070300,7.9870800,89.3810000,-1.7190000,-112.5000000); //object(460)
	CreateDynamicObject(1698,1507.1118200,-3931.2641600,8.0120800,89.3810000,-1.7190000,-112.5000000); //object(461)
	CreateDynamicObject(16662,1490.8110400,-3926.0100100,7.4897200,0.0000000,0.0000000,40.7030000); //object(462)
	CreateDynamicObject(3387,1491.0976600,-3930.0830100,6.2934900,0.0000000,0.0000000,-168.7500000); //object(463)
	CreateDynamicObject(3386,1493.9580100,-3923.8584000,6.2934900,0.0000000,0.0000000,-236.2500000); //object(464)
	CreateDynamicObject(3389,1492.5537100,-3924.9873000,6.2934900,0.0000000,0.0000000,-218.9070000); //object(465)
	CreateDynamicObject(3390,1496.8310500,-3929.0864300,6.6162700,0.0000000,0.0000000,-22.5000000); //object(468)
	CreateDynamicObject(1663,1495.5957000,-3927.8022500,6.7537100,0.0000000,0.0000000,56.2500000); //object(469)
	CreateDynamicObject(2063,1534.1450200,-3904.3198200,2.0781300,0.0000000,0.0000000,-382.5000000); //object(472)
	CreateDynamicObject(1742,1528.4965800,-3937.9216300,1.1802900,0.0000000,0.0000000,-112.5000000); //object(473)
	CreateDynamicObject(1717,1536.3139600,-3905.3481400,1.1663700,0.0000000,0.0000000,-67.5000000); //object(475)
	CreateDynamicObject(1799,1519.1254900,-3924.6223100,1.2317900,0.0000000,0.0000000,67.5000000); //object(476)
	CreateDynamicObject(2297,1521.7744100,-3915.7546400,1.1632000,0.0000000,0.0000000,-67.5000000); //object(477)
	CreateDynamicObject(702,1241.8457000,-3640.5502900,2.2387000,0.0000000,0.0000000,0.0000000); //object(436)
	CreateDynamicObject(3461,1242.0605500,-3640.6296400,0.4443100,0.0000000,0.0000000,0.0000000); //object(437)
	CreateDynamicObject(3461,1241.6230500,-3640.6821300,0.3800500,0.0000000,0.0000000,0.0000000); //object(438)
	CreateDynamicObject(3461,1241.9702100,-3640.9008800,0.4002900,0.0000000,0.0000000,0.0000000); //object(439)
	CreateDynamicObject(3461,1350.3364300,-3433.9982900,2.3432500,0.0000000,0.0000000,0.0000000); //object(440)
	CreateDynamicObject(3461,1504.1425800,-3936.9653300,22.0953100,0.0000000,0.0000000,0.0000000); //object(441)
	CreateDynamicObject(762,1222.9677700,-3748.8515600,14.1636500,0.0000000,0.0000000,0.0000000); //object(442)
	CreateDynamicObject(762,1227.5415000,-3767.1552700,17.2999500,0.0000000,0.0000000,0.0000000); //object(443)
	CreateDynamicObject(762,1239.7631800,-3712.6677200,8.9545000,0.0000000,0.0000000,0.0000000); //object(444)
	CreateDynamicObject(762,1254.1381800,-3709.8359400,9.6056800,0.0000000,0.0000000,22.5000000); //object(445)
	CreateDynamicObject(762,1299.9340800,-3759.5170900,25.7134000,0.0000000,0.0000000,0.0000000); //object(446)
	CreateDynamicObject(10983,1101.9438500,-3601.5512700,-26.6696400,12.8920000,0.0000000,-101.2500000); //object(447)
	CreateDynamicObject(10983,1083.7148400,-3695.3930700,-26.6294800,12.8920000,0.0000000,-101.2500000); //object(448)
	CreateDynamicObject(10983,985.7758800,-3655.5361300,-30.9715400,0.0000000,0.0000000,258.7450000); //object(449)
	CreateDynamicObject(10983,1006.7998000,-3561.6167000,-30.1110000,0.0000000,0.0000000,258.7450000); //object(450)
	CreateDynamicObject(10983,1185.0976600,-3744.7099600,-7.3842700,0.0000000,0.0000000,-101.2500000); //object(456)
	CreateDynamicObject(10828,1039.5302700,-3650.2658700,-18.8414400,89.3810000,0.0000000,-100.3910000); //object(457)
	CreateDynamicObject(4085,1023.8852500,-3648.1377000,-24.9813500,0.0000000,0.0000000,78.7500000); //object(458)
	CreateDynamicObject(10828,1035.2294900,-3643.2761200,-18.7903500,89.3810000,0.0000000,-10.3910000); //object(459)
	CreateDynamicObject(10828,1015.4555700,-3639.4643600,-18.9285600,89.3810000,0.0000000,-10.3910000); //object(460)
	CreateDynamicObject(10828,1008.9941400,-3644.3024900,-18.9324300,89.3810000,0.0000000,78.7500000); //object(461)
	CreateDynamicObject(10828,1012.9262700,-3653.8642600,-18.9657200,89.3810000,0.0000000,168.7500000); //object(462)
	CreateDynamicObject(10828,1031.8881800,-3657.5756800,-18.8515200,89.3810000,0.0000000,168.7500000); //object(463)
	CreateDynamicObject(10828,1050.8452100,-3652.5991200,-8.4116600,0.0000000,0.0000000,-101.2500000); //object(464)
	CreateDynamicObject(10828,1037.8798800,-3633.0402800,-8.3984700,0.0000000,0.0000000,-11.2500000); //object(465)
	CreateDynamicObject(10828,1017.3813500,-3628.9113800,-8.4189800,0.0000000,0.0000000,-11.2500000); //object(466)
	CreateDynamicObject(10828,997.9462900,-3641.9282200,-8.4461100,0.0000000,0.0000000,78.7500000); //object(467)
	CreateDynamicObject(10828,1011.0859400,-3664.4599600,-8.6304400,0.0000000,0.0000000,168.7500000); //object(468)
	CreateDynamicObject(10828,1030.4843800,-3668.3266600,-8.6156600,0.0000000,0.0000000,168.7500000); //object(469)
	CreateDynamicObject(10828,997.2587900,-3645.1818800,-8.4436100,0.0000000,0.0000000,78.7500000); //object(470)
	CreateDynamicObject(10828,1050.3164100,-3655.2697800,-8.5144800,0.0000000,0.0000000,78.7500000); //object(471)
	CreateDynamicObject(10828,1031.1845700,-3655.7783200,-6.9929500,89.3810000,0.0000000,168.7500000); //object(472)
	CreateDynamicObject(10828,1013.1250000,-3652.1286600,-7.1569400,89.3810000,0.0000000,168.7500000); //object(473)
	CreateDynamicObject(10828,1016.5898400,-3642.0307600,-6.7712200,89.3810000,0.0000000,-11.2500000); //object(474)
	CreateDynamicObject(10828,1033.1191400,-3645.2924800,-6.8238600,89.3810000,0.0000000,-11.2500000); //object(475)
	CreateDynamicObject(10828,1016.1333000,-3643.9951200,-6.8890200,89.3810000,0.0000000,168.7500000); //object(476)
	CreateDynamicObject(10828,1034.4301800,-3647.6323200,-6.8755500,89.3810000,0.0000000,168.7500000); //object(477)
	CreateDynamicObject(2567,1020.3344700,-3631.9704600,-15.9047100,0.0000000,0.0000000,-11.2500000); //object(479)
	CreateDynamicObject(2567,1000.0610400,-3643.6098600,-16.0517900,0.0000000,0.0000000,-101.2500000); //object(480)
	CreateDynamicObject(2669,1015.9741200,-3632.4353000,-16.6148500,0.0000000,0.0000000,-11.2500000); //object(481)
	CreateDynamicObject(3576,1023.8964800,-3640.4897500,-16.2561000,0.0000000,0.0000000,0.0000000); //object(482)
	CreateDynamicObject(3577,1008.8188500,-3646.8488800,-17.0973100,0.0000000,0.0000000,-11.2500000); //object(483)
	CreateDynamicObject(3633,1017.6704100,-3663.3276400,-17.4184800,0.0000000,0.0000000,0.0000000); //object(484)
	CreateDynamicObject(3633,1044.7446300,-3668.0581100,-17.4075600,0.0000000,0.0000000,0.0000000); //object(485)
	CreateDynamicObject(3633,1049.9721700,-3642.2348600,-17.3062200,0.0000000,0.0000000,0.0000000); //object(486)
	CreateDynamicObject(3633,1024.4433600,-3633.3508300,-17.3508500,0.0000000,0.0000000,0.0000000); //object(487)
	CreateDynamicObject(3633,1002.7641600,-3630.4287100,-17.4759100,0.0000000,0.0000000,0.0000000); //object(488)
	CreateDynamicObject(3796,1024.6782200,-3657.0856900,-17.8068400,0.0000000,0.0000000,-90.0000000); //object(491)
	CreateDynamicObject(3799,1005.0800800,-3658.6323200,-18.0127900,0.0000000,0.0000000,-11.2500000); //object(492)
	CreateDynamicObject(3799,1005.4169900,-3655.5817900,-18.0156500,0.0000000,0.0000000,-11.2500000); //object(493)
	CreateDynamicObject(3799,1005.7636700,-3657.0783700,-15.7840400,0.0000000,0.0000000,11.2500000); //object(494)
	CreateDynamicObject(5262,1042.9477500,-3640.6757800,-14.8262400,0.0000000,0.0000000,-191.2500000); //object(495)
	CreateDynamicObject(12913,1056.0146500,-3643.7522000,-12.1630800,0.0000000,90.2410000,-11.2500000); //object(496)
	CreateDynamicObject(12913,1007.8198200,-3623.9438500,-12.2212100,0.0000000,90.2410000,78.7500000); //object(497)
	CreateDynamicObject(12913,1048.2397500,-3631.8852500,-12.1272500,0.0000000,90.2410000,78.7500000); //object(498)
	CreateDynamicObject(12913,1051.4008800,-3665.8881800,-12.1394100,0.0000000,90.2410000,-11.2500000); //object(499)
	CreateDynamicObject(12913,1038.7871100,-3673.2104500,-12.1957300,0.0000000,90.2410000,-101.2500000); //object(500)
	CreateDynamicObject(12913,1000.0820300,-3665.4643600,-12.5811800,0.0000000,90.2410000,-101.2500000); //object(501)
	CreateDynamicObject(12913,992.4218800,-3653.1191400,-12.2438200,0.0000000,90.2410000,-191.2500000); //object(502)
	CreateDynamicObject(12913,996.6762700,-3630.9204100,-12.1119300,0.0000000,90.2410000,-191.2500000); //object(503)
	CreateDynamicObject(1223,1055.1059600,-3633.7675800,-18.2436300,0.0000000,0.0000000,90.0000000); //object(504)
	CreateDynamicObject(1223,1001.2202100,-3623.5029300,-19.3209100,0.0000000,0.0000000,78.7500000); //object(505)
	CreateDynamicObject(1223,993.6313500,-3663.1577100,-19.3209100,0.0000000,0.0000000,-112.5000000); //object(506)
	CreateDynamicObject(1223,1047.4863300,-3673.1591800,-18.2436300,0.0000000,0.0000000,-101.2500000); //object(507)
	CreateDynamicObject(1231,1011.0947300,-3651.4013700,-14.9596800,0.0000000,0.0000000,-112.5000000); //object(508)
	CreateDynamicObject(1231,1013.4160200,-3641.7661100,-14.8056600,0.0000000,0.0000000,-90.0000000); //object(509)
	CreateDynamicObject(1231,1036.0024400,-3655.4604500,-14.6345300,0.0000000,0.0000000,78.7500000); //object(510)
	CreateDynamicObject(1231,1037.7866200,-3647.0620100,-14.6775900,0.0000000,0.0000000,78.7500000); //object(511)
	CreateDynamicObject(7577,1078.3320300,-3660.3203100,-12.2032400,0.0000000,0.0000000,-101.2500000); //object(512)
	CreateDynamicObject(7577,1133.0742200,-3671.7959000,-9.4653900,6.0160000,0.0000000,-101.2500000); //object(513)
	CreateDynamicObject(7577,1185.8247100,-3682.2710000,-4.9299700,187.3580000,0.0000000,-101.2500000); //object(514)
	CreateDynamicObject(3530,1104.9853500,-3666.5835000,-14.0249700,0.0000000,0.0000000,0.0000000); //object(515)
	CreateDynamicObject(3530,1060.5683600,-3630.7109400,-22.5366800,0.0000000,0.0000000,-11.2500000); //object(516)
	CreateDynamicObject(3530,1065.1298800,-3649.9924300,-22.2603900,0.0000000,0.0000000,-11.2500000); //object(517)
	CreateDynamicObject(3530,1051.8403300,-3699.1272000,-22.3841000,0.0000000,0.0000000,-11.2500000); //object(518)
	CreateDynamicObject(3530,981.4843800,-3675.2548800,-21.7935200,0.0000000,0.0000000,-11.2500000); //object(519)
	CreateDynamicObject(3530,1011.1914100,-3609.0068400,-22.8637100,0.0000000,0.0000000,-11.2500000); //object(520)
	CreateDynamicObject(3675,1051.3593800,-3662.9001500,-20.7256400,0.0000000,0.0000000,78.7500000); //object(521)
	CreateDynamicObject(3675,1054.5673800,-3645.2038600,-21.1919800,0.0000000,0.0000000,90.0000000); //object(522)
	CreateDynamicObject(3675,1044.9126000,-3632.0256300,-21.1197000,0.0000000,0.0000000,157.5000000); //object(523)
	CreateDynamicObject(3675,1013.7109400,-3625.8374000,-20.7005300,0.0000000,0.0000000,157.5000000); //object(524)
	CreateDynamicObject(3675,1032.4355500,-3671.4709500,-20.7659900,0.0000000,0.0000000,-11.2500000); //object(525)
	CreateDynamicObject(3675,1033.4672900,-3634.0205100,-13.0923700,0.0000000,0.0000000,0.0000000); //object(526)
	CreateDynamicObject(1635,1514.5019500,-3941.8828100,24.0733700,0.0000000,0.0000000,-22.5000000); //object(527)
	CreateDynamicObject(1689,1525.1132800,-3944.4328600,27.5384000,0.0000000,0.0000000,-112.5000000); //object(528)
	CreateDynamicObject(3502,1356.5595700,-3623.6303700,4.1515500,0.0000000,0.0000000,59.6100000); //object(529)
	CreateDynamicObject(3502,1353.6562500,-3651.5869100,4.1921300,0.0000000,0.0000000,90.0000000); //object(531)
	CreateDynamicObject(3502,1389.2148400,-3609.3073700,4.7223800,0.0000000,0.0000000,0.0000000); //object(532)
	CreateDynamicObject(9831,1388.8730500,-3614.5918000,2.0876600,0.0000000,-5.1570000,-163.5930000); //object(533)
	CreateDynamicObject(9831,1361.9189500,-3627.1772500,1.7679900,0.0000000,0.0000000,-112.5770000); //object(535)
	CreateDynamicObject(9831,1359.4819300,-3651.8864700,1.3256600,0.0000000,0.0000000,-78.7500000); //object(537)
	CreateDynamicObject(10983,1649.6806600,-3658.3750000,45.3242000,6.8720000,0.0000000,326.2450000); //object(538)
	CreateDynamicObject(18227,1595.7876000,-3565.0097700,53.2267800,0.0000000,0.0000000,137.9480000); //object(539)
	CreateDynamicObject(18227,1712.3061500,-3572.8618200,67.2432300,0.0000000,0.0000000,-337.5000000); //object(540)
	CreateDynamicObject(18227,1813.9741200,-3556.6472200,74.4926100,344.5260000,10.3110000,42.9670000); //object(542)
	CreateDynamicObject(762,1705.2324200,-3637.8815900,57.2190000,0.0000000,0.0000000,0.0000000); //object(543)
	CreateDynamicObject(18227,1748.1176800,-3559.2109400,72.1402100,0.0000000,0.0000000,-663.7500000); //object(545)
	CreateDynamicObject(18227,1705.8173800,-3599.9919400,55.0852100,0.0000000,0.0000000,-810.8590000); //object(546)
	CreateDynamicObject(789,1665.3007800,-3605.0351600,67.2309700,0.0000000,0.0000000,22.5000000); //object(548)
	CreateDynamicObject(762,1677.3095700,-3686.5317400,51.8458200,0.0000000,0.0000000,0.0000000); //object(549)
	CreateDynamicObject(3092,1687.5752000,-3652.9599600,48.7651900,75.6300000,10.3130000,44.0630000); //object(552)
	CreateDynamicObject(11224,1687.5180700,-3651.1652800,50.3287200,6.8750000,0.8590000,-33.7500000); //object(556)
	CreateDynamicObject(3092,1688.1757800,-3651.7304700,49.7802400,75.6300000,10.3130000,-23.4370000); //object(557)
	CreateDynamicObject(3092,1686.6440400,-3654.6315900,49.2259200,75.6300000,10.3130000,201.5630000); //object(558)
	CreateDynamicObject(3092,1689.1748000,-3650.5407700,50.0314000,75.6300000,10.3130000,66.5630000); //object(559)
	CreateDynamicObject(3092,1690.2661100,-3649.4113800,50.2870300,75.6300000,10.3130000,-124.6870000); //object(560)
	CreateDynamicObject(3092,1689.7021500,-3647.8942900,50.3836500,75.6300000,10.3130000,66.5630000); //object(561)
	CreateDynamicObject(3092,1687.9531300,-3649.6372100,49.8842700,75.6300000,10.3130000,-12.1870000); //object(562)
	CreateDynamicObject(3092,1686.0673800,-3652.8979500,49.3066300,75.6300000,10.3130000,21.5630000); //object(563)
	CreateDynamicObject(3092,1686.6611300,-3651.0966800,49.5599400,75.6300000,10.3130000,89.0630000); //object(564)
	CreateDynamicObject(2907,1687.3085900,-3649.3403300,48.9949500,0.0000000,0.0000000,0.0000000); //object(565)
	CreateDynamicObject(2907,1689.4550800,-3650.1816400,49.2009800,0.0000000,0.0000000,0.0000000); //object(567)
	CreateDynamicObject(2907,1687.1684600,-3650.2775900,48.7912900,0.0000000,0.0000000,0.0000000); //object(568)
	CreateDynamicObject(2907,1688.5527300,-3647.0251500,49.7509700,0.0000000,0.0000000,101.2500000); //object(569)
	CreateDynamicObject(2907,1685.6196300,-3651.2063000,48.4375500,0.0000000,0.0000000,146.2500000); //object(570)
	CreateDynamicObject(2907,1687.5683600,-3652.5314900,48.6460100,0.0000000,0.0000000,33.7500000); //object(571)
	CreateDynamicObject(2907,1691.5014600,-3646.5561500,49.8105700,0.0000000,0.0000000,-11.2500000); //object(572)
	CreateDynamicObject(2905,1689.0644500,-3648.8347200,49.2625400,0.0000000,0.0000000,-56.2500000); //object(573)
	CreateDynamicObject(2905,1687.1591800,-3654.0405300,48.5944700,0.0000000,0.0000000,-146.2500000); //object(574)
	CreateDynamicObject(2905,1691.4707000,-3648.4887700,49.7195800,0.0000000,0.0000000,-258.7500000); //object(575)
	CreateDynamicObject(2905,1684.5791000,-3653.1005900,48.1358000,0.0000000,0.0000000,-348.7500000); //object(576)
	CreateDynamicObject(818,1687.2275400,-3642.8090800,55.1314900,0.0000000,0.0000000,0.0000000); //object(577)
	CreateDynamicObject(16287,1269.3901400,-4107.5903300,63.8477200,0.0000000,0.0000000,-33.7500000); //object(578)
	CreateDynamicObject(1717,1269.7026400,-4101.0888700,64.1449400,0.0000000,0.0000000,-45.0000000); //object(579)
	CreateDynamicObject(1717,1273.6489300,-4103.2187500,64.1449400,0.0000000,0.0000000,-78.7500000); //object(580)
	CreateDynamicObject(1717,1266.8608400,-4106.5800800,64.1449400,0.0000000,0.0000000,11.2500000); //object(581)
	CreateDynamicObject(1738,1271.1787100,-4111.4575200,64.8023700,0.0000000,0.0000000,-123.7500000); //object(583)
	CreateDynamicObject(1771,1268.7514600,-4114.1318400,64.7814000,0.0000000,0.0000000,-33.7500000); //object(584)
	CreateDynamicObject(3276,1296.7304700,-4084.1062000,65.0502500,0.0000000,0.0000000,-33.7500000); //object(585)
	CreateDynamicObject(3276,1286.2646500,-4078.0937500,65.0502500,0.0000000,0.0000000,-22.5000000); //object(586)
	CreateDynamicObject(3276,1269.3837900,-4079.8732900,65.0431300,0.0000000,0.0000000,45.0000000); //object(587)
	CreateDynamicObject(3276,1261.3925800,-4088.5004900,65.0502500,0.0000000,0.0000000,51.9530000); //object(588)
	CreateDynamicObject(3276,1253.4589800,-4098.3886700,65.0502500,0.0000000,0.0000000,-132.4220000); //object(589)
	CreateDynamicObject(3276,1246.9746100,-4109.5268600,65.0502500,0.0000000,0.0000000,-109.9220000); //object(590)
	CreateDynamicObject(3276,1299.6928700,-4100.7773400,65.0502500,0.0000000,0.0000000,-303.7500000); //object(591)
	CreateDynamicObject(3276,1292.7226600,-4110.7758800,65.0502500,0.0000000,0.0000000,45.0000000); //object(592)
	CreateDynamicObject(3276,1283.9506800,-4111.6069300,65.0502500,0.0000000,0.0000000,-33.7500000); //object(593)
	CreateDynamicObject(3276,1256.0708000,-4114.8696300,65.0431300,0.0000000,0.0000000,-22.5000000); //object(594)
	CreateDynamicObject(826,1282.2504900,-4098.0419900,65.5398700,0.0000000,0.0000000,0.0000000); //object(595)
	CreateDynamicObject(825,1268.1635700,-4089.7700200,65.2399000,0.0000000,0.0000000,0.0000000); //object(596)
	CreateDynamicObject(827,1289.4409200,-4088.3376500,67.7883800,0.0000000,0.0000000,0.0000000); //object(597)
	CreateDynamicObject(874,1263.0952100,-4073.9973100,64.9900300,0.0000000,0.0000000,-33.7500000); //object(598)
	CreateDynamicObject(874,1300.2934600,-4119.9375000,65.5412800,0.0000000,0.0000000,-22.5000000); //object(599)
	CreateDynamicObject(874,1459.5258800,-3879.4526400,19.4026300,-2.5780000,-7.7350000,0.0000000); //object(600)
	CreateDynamicObject(1457,1352.6572300,-3818.8784200,61.2601900,0.0000000,0.0000000,-123.7500000); //object(601)
	CreateDynamicObject(1457,1347.0839800,-3805.1298800,61.8556500,0.0000000,0.0000000,-78.7500000); //object(602)
	CreateDynamicObject(1458,1346.7695300,-3811.9992700,60.5380400,0.0000000,0.0000000,-45.0000000); //object(603)
	CreateDynamicObject(1452,1352.5600600,-3814.1992200,61.4087300,0.0000000,0.0000000,-56.2500000); //object(604)
	CreateDynamicObject(3461,1345.6757800,-3807.7976100,61.0875900,0.0000000,0.0000000,0.0000000); //object(605)
	CreateDynamicObject(14409,1519.8188500,-3940.5112300,-0.1286600,31.7990000,0.0000000,-22.5000000); //object(581)
	CreateDynamicObject(3095,1520.7236300,-3942.2395000,5.0809900,0.0000000,89.3810000,-382.5000000); //object(582)
	CreateDynamicObject(1497,1517.0727500,-3938.1794400,15.3580800,0.0000000,0.0000000,67.5000000); //object(583)
	CreateDynamicObject(1499,1517.2539100,-3936.7019000,21.2613300,0.0000000,0.0000000,-112.5000000); //object(585)
	CreateDynamicObject(3095,1519.7045900,-3941.2968700,-0.7418800,0.0000000,89.3810000,-472.5000000); //object(569)
	CreateDynamicObject(18227,1515.1289100,-3427.5119600,55.0626300,343.4570000,16.1510000,330.6360000); //object(64)
	CreateDynamicObject(18307,1513.6953100,-3384.7734400,20.8578700,0.0000000,0.0000000,301.5750000); //object(cs_landbit_18)(1)
	CreateDynamicObject(18309,1710.8945300,-3404.5830100,-4.5956100,353.1270000,0.0000000,294.7020000); //object(cs_landbit_20)(1)
	CreateDynamicObject(18309,1781.6533200,-3430.7377900,5.6690300,353.1230000,0.0000000,313.5990000); //object(cs_landbit_20)(2)
	CreateDynamicObject(18309,1910.9277300,-3507.0947300,8.0288200,353.1170000,0.0000000,296.4110000); //object(cs_landbit_20)(3)
	CreateDynamicObject(18309,2004.4482400,-3568.7763700,15.9254400,353.1170000,0.0000000,284.3830000); //object(cs_landbit_20)(4)
	CreateDynamicObject(18309,2043.2963900,-3561.8188500,6.9828600,353.1170000,0.0000000,263.7610000); //object(cs_landbit_20)(5)
	CreateDynamicObject(18309,2026.8076200,-3508.1967800,-0.0157300,358.2720000,0.0000000,296.4090000); //object(cs_landbit_20)(6)
	CreateDynamicObject(18309,2068.2734400,-3714.4609400,15.2742800,358.2700000,0.0000000,229.3890000); //object(cs_landbit_20)(7)
	CreateDynamicObject(18309,1973.8115200,-3862.0766600,13.2520700,358.2700000,0.0000000,196.7400000); //object(cs_landbit_20)(8)
	CreateDynamicObject(18309,1961.2270500,-3919.5251500,11.6316800,358.2700000,0.0000000,203.6110000); //object(cs_landbit_20)(9)
	CreateDynamicObject(18309,1925.0849600,-3971.4619100,26.6092400,358.2700000,0.0000000,227.6640000); //object(cs_landbit_20)(10)
	CreateDynamicObject(18309,1874.9721700,-4089.0053700,15.0354100,358.2700000,0.0000000,227.6640000); //object(cs_landbit_20)(11)
	CreateDynamicObject(18309,1758.0517600,-4225.6572300,18.1082700,358.2700000,0.0000000,188.1410000); //object(cs_landbit_20)(12)
	CreateDynamicObject(18309,1631.3579100,-4281.8496100,16.1931100,358.2700000,0.0000000,188.1410000); //object(cs_landbit_20)(13)
	CreateDynamicObject(18309,1471.5234400,-4319.2587900,14.8773800,358.2700000,0.0000000,145.1810000); //object(cs_landbit_20)(14)
	CreateDynamicObject(18309,1344.2045900,-4290.9267600,14.7834200,358.2700000,0.0000000,146.8970000); //object(cs_landbit_20)(15)
	CreateDynamicObject(18309,1157.0800800,-4204.3945300,13.8250300,358.2700000,0.0000000,109.0880000); //object(cs_landbit_20)(16)
	CreateDynamicObject(18309,1105.5263700,-4007.8198200,12.3765000,358.2700000,0.0000000,57.5320000); //object(cs_landbit_20)(17)
	CreateDynamicObject(18309,1059.7207000,-3940.6298800,6.5670100,358.2700000,0.0000000,38.6280000); //object(cs_landbit_20)(18)
	CreateDynamicObject(18309,1055.5849600,-4062.8364300,5.6701600,358.2700000,0.0000000,79.8690000); //object(cs_landbit_20)(19)
	CreateDynamicObject(18309,1045.6694300,-3828.0249000,-35.2895600,3.4250000,0.0000000,48.9380000); //object(cs_landbit_20)(20)
	CreateDynamicObject(18227,1119.4882800,-3922.1547900,34.8586500,3.5050000,343.4960000,313.8060000); //object(37)
	CreateDynamicObject(18227,1123.6396500,-3947.7934600,43.2911200,8.1800000,338.1360000,317.7520000); //object(37)
	CreateDynamicObject(18227,1119.9458000,-3965.5427200,53.1679800,3.4990000,343.4930000,313.8020000); //object(37)
	CreateDynamicObject(13236,1209.9614300,-3896.5505400,28.2798400,356.6390000,12.0470000,22.7760000); //object(23)
	CreateDynamicObject(13236,1101.1865200,-3987.5681200,19.3826900,356.6380000,12.0470000,67.5580000); //object(23)
	CreateDynamicObject(13236,1165.8481400,-3925.7680700,26.4441100,356.6330000,12.0470000,19.9420000); //object(23)
	CreateDynamicObject(18227,1195.3852500,-3990.0781200,85.0684800,347.9640000,350.5410000,111.2830000); //object(39)
	CreateDynamicObject(18227,1155.4116200,-4028.1298800,75.1102900,347.9640000,350.5410000,281.2270000); //object(39)
	CreateDynamicObject(18227,1156.3969700,-4009.1962900,76.0803600,347.9640000,350.5410000,25.8590000); //object(39)
	CreateDynamicObject(18227,1153.0151400,-4008.3015100,81.9683100,347.9640000,350.5410000,48.8060000); //object(39)
	CreateDynamicObject(13236,1139.5683600,-4089.0000000,13.9077800,1.7080000,3.4330000,89.0720000); //object(23)
	CreateDynamicObject(18227,1152.4628900,-4035.3984400,83.3800900,346.5580000,347.6240000,138.2300000); //object(97)
	CreateDynamicObject(10985,1188.5869100,-4102.4101600,59.8037800,5.1550000,0.0000000,265.6730000); //object(rubbled02_sfs)(1)
	CreateDynamicObject(10985,1201.9980500,-4113.0127000,61.4694800,359.9970000,358.2820000,270.8260000); //object(rubbled02_sfs)(2)
	CreateDynamicObject(10985,1191.7373000,-4110.9223600,59.5093800,359.9950000,358.2810000,270.8240000); //object(rubbled02_sfs)(3)
	CreateDynamicObject(10985,1195.4599600,-4110.4990200,61.0948600,5.1470000,358.2740000,307.0650000); //object(rubbled02_sfs)(4)
	CreateDynamicObject(10985,1190.9365200,-4106.3095700,60.6283300,5.1290000,354.8190000,307.3710000); //object(rubbled02_sfs)(5)
	CreateDynamicObject(18227,1240.6909200,-4154.5844700,75.3674200,0.0000000,0.0000000,173.9050000); //object(96)
	CreateDynamicObject(18227,1243.1953100,-4165.9394500,88.2072600,6.6760000,346.1570000,175.5430000); //object(96)
	CreateDynamicObject(18227,1352.6147500,-4208.5888700,66.5238400,0.0000000,0.0000000,303.7450000); //object(93)
	CreateDynamicObject(18309,1191.0664100,-4249.2744100,14.6065900,358.2700000,0.0000000,122.8270000); //object(cs_landbit_20)(21)
	CreateDynamicObject(18227,1332.1416000,-4207.5659200,50.9694500,0.0000000,0.0000000,49.0900000); //object(95)
	CreateDynamicObject(3095,1537.3564500,-3904.9150400,5.1758800,0.0000000,89.3790000,67.4950000); //object(454)
	CreateDynamicObject(3095,1531.9643600,-3901.8996600,3.8901200,0.0000000,89.3790000,67.4950000); //object(454)
	CreateDynamicObject(13236,1385.9023400,-4250.7294900,23.3111900,354.2090000,4.1010000,151.8720000); //object(86)
	CreateDynamicObject(18227,1425.4448200,-4203.1640600,82.7170500,0.0000000,0.0000000,26.9920000); //object(94)
	CreateDynamicObject(18227,1481.3857400,-4228.0468700,76.4639600,0.0000000,0.0000000,21.8330000); //object(94)
	CreateDynamicObject(13236,1569.3291000,-4149.9682600,51.1394000,11.1680000,11.1680000,355.1050000); //object(86)
	CreateDynamicObject(13236,1658.4633800,-4107.1059600,51.8847100,11.1680000,11.1680000,349.3370000); //object(86)
	CreateDynamicObject(13236,1738.5175800,-4031.1687000,52.6138300,11.1680000,11.1680000,27.7440000); //object(86)
	CreateDynamicObject(13236,1780.5864300,-3968.5481000,50.2668500,11.1680000,11.1680000,32.8960000); //object(86)
	CreateDynamicObject(18227,1881.0454100,-3844.4135700,89.8018900,0.0000000,353.1230000,112.9010000); //object(115)
	CreateDynamicObject(18227,1922.2319300,-3782.5293000,79.2002000,0.0000000,353.1170000,112.8960000); //object(115)
	CreateDynamicObject(18227,1919.8252000,-3765.8564500,93.3502500,337.8490000,335.7720000,214.0300000); //object(112)
	CreateDynamicObject(18227,1957.5180700,-3680.7358400,92.4961600,0.0000000,4.2960000,348.8480000); //object(113)
	CreateDynamicObject(18227,1965.6782200,-3661.9914600,90.0523600,346.5190000,348.5040000,145.4470000); //object(113)
	CreateDynamicObject(13236,2003.3916000,-3647.3439900,36.8684700,359.3500000,2.3620000,255.3910000); //object(86)
	CreateDynamicObject(13236,2060.4565400,-3777.1738300,-17.9776300,359.3460000,2.3570000,235.1640000); //object(86)
	CreateDynamicObject(13236,1973.7421900,-3886.9536100,-16.5278900,359.3460000,2.3570000,202.5130000); //object(86)
	CreateDynamicObject(18227,2018.7768600,-3744.8779300,25.5997500,346.5140000,348.5030000,88.6300000); //object(113)
	CreateDynamicObject(18227,1947.8422900,-3603.0913100,89.8653900,0.0000000,4.2900000,141.2880000); //object(113)
	CreateDynamicObject(18227,1941.1284200,-3647.7905300,83.9168700,0.0000000,0.8480000,345.5980000); //object(113)
	CreateDynamicObject(18227,1991.3325200,-3654.3923300,74.4730300,349.0490000,322.2450000,189.8340000); //object(113)
	CreateDynamicObject(18227,1878.8295900,-3566.2434100,71.3481000,15.6510000,334.9540000,219.3670000); //object(110)
	CreateDynamicObject(18227,1917.3627900,-3550.1240200,62.5327100,22.9200000,18.7060000,201.2300000); //object(110)
	CreateDynamicObject(18227,1835.9213900,-3578.5791000,65.1096900,344.5350000,0.0000000,42.3420000); //object(110)
	CreateDynamicObject(13236,1834.1440400,-3503.8613300,33.6685900,359.3460000,2.3570000,315.2410000); //object(86)
	CreateDynamicObject(18227,1835.1245100,-3558.4328600,81.3522900,344.5260000,10.3110000,209.3710000); //object(542)
	CreateDynamicObject(18227,1718.4550800,-3536.0598100,78.7826200,344.5200000,10.3050000,87.7460000); //object(542)
	CreateDynamicObject(18227,1756.7441400,-3557.6608900,73.0216400,344.5200000,10.3000000,221.8930000); //object(542)
	CreateDynamicObject(13236,1708.5151400,-3456.7915000,21.6318700,359.4640000,35.0070000,29.6870000); //object(86)
	CreateDynamicObject(18227,1721.6543000,-3508.2863800,85.7453500,356.3090000,1.3330000,109.1080000); //object(542)
	CreateDynamicObject(18227,1681.9731400,-3588.8173800,64.0525400,24.6940000,344.4040000,298.6510000); //object(542)
	CreateDynamicObject(18227,1710.4409200,-3523.1872600,37.9316300,0.0000000,13.7470000,77.8050000); //object(539)
	CreateDynamicObject(18227,1701.2763700,-3536.5920400,39.8863300,0.0000000,13.7440000,77.8000000); //object(539)
	CreateDynamicObject(10983,1632.8393600,-3546.7697800,50.7773400,6.8720000,0.0000000,48.7260000); //object(538)
	CreateDynamicObject(18227,1647.4589800,-3558.5888700,47.8238600,0.0000000,0.0000000,76.0830000); //object(539)
	CreateDynamicObject(789,1677.2602500,-3570.4660600,61.5708100,0.0000000,0.0000000,27.6550000); //object(548)
	CreateDynamicObject(18227,1607.1406300,-3484.3374000,79.3560500,0.0000000,358.2820000,61.4000000); //object(108)
	CreateDynamicObject(18227,1607.3535200,-3457.7377900,83.6891600,348.0210000,5.2690000,35.0000000); //object(108)
	CreateDynamicObject(13236,1598.9223600,-3485.9816900,36.9773200,359.3490000,5.7940000,222.4830000); //object(86)
	CreateDynamicObject(18307,1570.2348600,-3339.6777300,-12.8073700,0.0000000,0.0000000,294.7010000); //object(cs_landbit_18)(1)
	CreateDynamicObject(18227,1572.7822300,-3409.9401900,60.4600200,3.4210000,354.8330000,260.6500000); //object(108)
	CreateDynamicObject(18227,1558.8378900,-3425.1586900,67.5931900,3.3320000,346.2250000,263.7320000); //object(108)
	CreateDynamicObject(18227,1541.7216800,-3355.9104000,69.1203400,16.6670000,345.6310000,177.4400000); //object(108)
	CreateDynamicObject(13236,1623.4248000,-3363.0332000,21.2345400,359.3460000,5.7900000,288.7030000); //object(86)
	CreateDynamicObject(13236,1559.2080100,-3267.8085900,-6.4348000,7.9330000,358.9000000,305.2530000); //object(86)
	CreateDynamicObject(18227,1503.9550800,-3279.2490200,32.1149800,0.0000000,0.0000000,178.9450000); //object(72)
	CreateDynamicObject(18227,1449.8437500,-3277.2680700,15.9259700,356.6620000,13.7710000,127.7090000); //object(72)
	CreateDynamicObject(18227,1473.8134800,-3316.1381800,33.0749500,356.5760000,5.1590000,185.6210000); //object(72)
	CreateDynamicObject(18227,1496.1835900,-3306.6240200,44.3475200,356.6340000,12.0430000,148.2240000); //object(72)
	CreateDynamicObject(18227,1522.2724600,-3367.7104500,63.2926600,356.6330000,12.0410000,173.9980000); //object(72)
	CreateDynamicObject(18227,1521.8994100,-3327.2016600,58.8881200,16.6660000,345.6300000,177.4350000); //object(108)
	CreateDynamicObject(18227,1563.8842800,-3507.7700200,81.1059500,0.0000000,0.0000000,131.5630000); //object(103)
	CreateDynamicObject(18227,1623.9716800,-3507.2292500,48.6311800,0.0000000,0.0000000,73.4280000); //object(108)
	CreateDynamicObject(18227,1545.4248000,-3617.4397000,78.5924100,0.0000000,339.3800000,26.4240000); //object(103)
	CreateDynamicObject(18227,1519.6767600,-3613.7163100,69.8539300,0.0000000,354.8450000,314.3770000); //object(63)
	CreateDynamicObject(18227,1533.0048800,-3620.6450200,62.7036400,0.0000000,349.6870000,257.6680000); //object(63)
	CreateDynamicObject(18227,1541.4570300,-3604.1147500,80.0462300,0.0000000,354.8420000,298.9080000); //object(63)
	CreateDynamicObject(789,1472.6591800,-3562.3217800,79.1528100,0.0000000,0.0000000,0.0000000); //object(275)
	CreateDynamicObject(13236,1520.9765600,-3392.7121600,25.6481800,359.3460000,5.7840000,43.0380000); //object(86)
	CreateDynamicObject(18227,1519.9472700,-3468.6377000,98.3892400,0.0000000,339.3800000,249.0370000); //object(68)
	CreateDynamicObject(18227,1517.1855500,-3460.5048800,77.4842200,0.0000000,339.3790000,249.0330000); //object(68)
	CreateDynamicObject(13236,1662.5576200,-3332.9914600,-2.5276900,7.8650000,7.5700000,304.0550000); //object(86)
	CreateDynamicObject(13236,1726.5390600,-3400.0039100,-13.0413200,1.0550000,0.6210000,294.7690000); //object(86)
	CreateDynamicObject(18359,1830.5761700,-3352.6816400,-25.9904200,7.7290000,0.0000000,154.2260000); //object(3)
	CreateDynamicObject(13236,1828.3989300,-3465.0249000,-6.9489800,359.3460000,2.3570000,315.2360000); //object(86)
	CreateDynamicObject(13236,1724.4111300,-3355.3789100,-20.3674700,1.0550000,0.6210000,293.0490000); //object(86)
	CreateDynamicObject(13236,1974.4375000,-3485.9511700,-25.9904200,359.3460000,2.3570000,313.5180000); //object(86)
	CreateDynamicObject(18227,1921.0566400,-3442.7690400,6.1079300,1.6960000,351.4000000,104.1720000); //object(110)
	CreateDynamicObject(791,1785.4917000,-3449.1762700,31.1116300,0.0000000,0.0000000,0.0000000); //object(204)
	CreateDynamicObject(791,1894.0249000,-3554.6015600,54.4307700,0.0000000,0.0000000,0.0000000); //object(204)
	CreateDynamicObject(791,1932.6894500,-3485.0212400,16.3441200,0.0000000,0.0000000,0.0000000); //object(204)
	CreateDynamicObject(791,1749.7460900,-3513.8715800,79.0497100,0.0000000,0.0000000,0.0000000); //object(204)
	CreateDynamicObject(791,1700.9414100,-3405.0239300,27.8712000,0.0000000,0.0000000,0.0000000); //object(204)
	CreateDynamicObject(791,1675.2744100,-3377.2275400,29.3389200,0.0000000,0.0000000,0.0000000); //object(204)
	CreateDynamicObject(791,1679.9882800,-3327.5390600,19.7531800,0.0000000,0.0000000,0.0000000); //object(204)
	CreateDynamicObject(791,1584.5634800,-3344.2915000,66.1814300,0.0000000,0.0000000,0.0000000); //object(204)
	CreateDynamicObject(791,1603.1103500,-3423.2834500,83.6126000,0.0000000,0.0000000,0.0000000); //object(204)
	CreateDynamicObject(791,1630.6074200,-3515.5908200,52.0979400,0.0000000,0.0000000,0.0000000); //object(204)
	CreateDynamicObject(791,1529.2363300,-3285.4658200,31.9546700,0.0000000,0.0000000,0.0000000); //object(204)
	CreateDynamicObject(791,1607.3496100,-3315.2522000,36.9536900,0.0000000,0.0000000,0.0000000); //object(204)
	CreateDynamicObject(791,1626.7627000,-3638.9902300,44.7334400,0.0000000,0.0000000,0.0000000); //object(204)
	CreateDynamicObject(789,1616.9086900,-3657.4624000,77.2330300,0.0000000,0.0000000,22.5000000); //object(548)
	CreateDynamicObject(789,1650.0752000,-3758.2053200,47.3533400,0.0000000,0.0000000,22.5000000); //object(548)
	CreateDynamicObject(791,1587.9502000,-3839.5542000,18.9728000,0.0000000,0.0000000,348.7450000); //object(218)
	CreateDynamicObject(789,1706.2793000,-3379.9384800,45.0882900,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(789,1794.7026400,-3449.5288100,53.4429200,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(789,1691.3095700,-3324.0156200,38.5285100,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(789,1929.6093800,-3477.1626000,34.6570500,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(789,1857.7514600,-3546.3364300,101.1230100,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(789,1867.4824200,-3642.6352500,85.3056000,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(791,1997.5800800,-3834.5673800,28.1006900,0.0000000,0.0000000,0.0000000); //object(205)
	CreateDynamicObject(791,2048.1967800,-3717.5539600,26.3270600,0.0000000,0.0000000,0.0000000); //object(205)
	CreateDynamicObject(791,2051.1347700,-3756.9541000,26.1587800,0.0000000,0.0000000,0.0000000); //object(205)
	CreateDynamicObject(791,1962.2202100,-3865.1928700,25.7368400,0.0000000,0.0000000,0.0000000); //object(205)
	CreateDynamicObject(791,1895.6713900,-3874.7490200,68.0840200,0.0000000,0.0000000,0.0000000); //object(205)
	CreateDynamicObject(791,1814.5800800,-3948.8110400,71.6492800,0.0000000,0.0000000,0.0000000); //object(205)
	CreateDynamicObject(18227,1779.3598600,-3957.7981000,84.2270700,0.0000000,0.0000000,276.6570000); //object(117)
	CreateDynamicObject(18227,1817.1054700,-3940.8991700,90.6765400,348.2390000,347.7100000,79.7990000); //object(117)
	CreateDynamicObject(791,1786.8330100,-4001.4223600,86.9830700,0.0000000,0.0000000,0.0000000); //object(205)
	CreateDynamicObject(791,1755.7168000,-4054.7065400,90.5991400,0.0000000,0.0000000,0.0000000); //object(205)
	CreateDynamicObject(791,1730.2055700,-4089.5539600,89.9935600,0.0000000,0.0000000,0.0000000); //object(205)
	CreateDynamicObject(791,1696.4980500,-4150.6621100,77.3902900,0.0000000,0.0000000,0.0000000); //object(205)
	CreateDynamicObject(791,1651.4741200,-4139.4267600,84.2369500,0.0000000,0.0000000,0.0000000); //object(205)
	CreateDynamicObject(791,1604.1220700,-4162.2524400,87.2074500,0.0000000,0.0000000,0.0000000); //object(205)
	CreateDynamicObject(791,1648.4418900,-3986.7724600,56.5151700,0.0000000,0.0000000,0.0000000); //object(205)
	CreateDynamicObject(791,1728.0644500,-3977.8496100,71.3798400,0.0000000,0.0000000,0.0000000); //object(205)
	CreateDynamicObject(791,1673.4008800,-4093.1940900,61.1148400,0.0000000,0.0000000,0.0000000); //object(205)
	CreateDynamicObject(791,1597.5937500,-4086.0874000,82.9958600,0.0000000,0.0000000,0.0000000); //object(205)
	CreateDynamicObject(791,1628.1015600,-4043.0087900,57.3294100,0.0000000,0.0000000,0.0000000); //object(205)
	CreateDynamicObject(791,1438.4560500,-3885.8471700,8.4616400,0.0000000,0.0000000,0.0000000); //object(205)
	CreateDynamicObject(791,1434.0835000,-4238.2915000,71.5700500,0.0000000,0.0000000,0.0000000); //object(205)
	CreateDynamicObject(791,1151.8974600,-3973.0251500,77.9785200,0.0000000,0.0000000,0.0000000); //object(205)
	CreateDynamicObject(791,1524.4951200,-4224.4506800,83.2100400,0.0000000,0.0000000,0.0000000); //object(205)
	CreateDynamicObject(791,1679.5893600,-4035.3151900,49.7032700,0.0000000,0.0000000,0.0000000); //object(205)
	CreateDynamicObject(791,1890.3305700,-3791.6801800,80.3432300,0.0000000,0.0000000,0.0000000); //object(205)
	CreateDynamicObject(18227,1873.9941400,-3785.3151900,87.2520500,0.0000000,353.1230000,128.3660000); //object(115)
	CreateDynamicObject(18227,1900.8320300,-3784.6352500,80.9756900,0.0000000,353.1170000,128.3640000); //object(115)
	CreateDynamicObject(18227,1875.8330100,-3941.2041000,69.0143600,20.5820000,336.0430000,115.2780000); //object(117)
	CreateDynamicObject(18227,1843.9296900,-4000.6491700,80.3672600,20.5770000,336.0390000,115.2740000); //object(117)
	CreateDynamicObject(18227,1782.7148400,-4091.3225100,72.8933600,6.8660000,358.2610000,103.1670000); //object(117)
	CreateDynamicObject(18227,1791.7509800,-4068.2324200,72.3630400,6.8610000,358.2590000,103.1670000); //object(117)
	CreateDynamicObject(18227,1810.7817400,-4051.7331500,80.2514300,9.6340000,339.0600000,127.2430000); //object(117)
	CreateDynamicObject(18227,1789.9487300,-4081.6477100,73.1603400,8.3040000,323.4600000,129.6850000); //object(117)
	CreateDynamicObject(18227,1678.6240200,-4172.1928700,79.9758600,9.5110000,337.3210000,66.5630000); //object(117)
	CreateDynamicObject(18227,1643.4238300,-4181.6220700,74.3991200,9.5090000,337.3190000,66.5610000); //object(117)
	CreateDynamicObject(18227,1656.7793000,-4193.9121100,62.6889000,9.5090000,337.3190000,66.5610000); //object(117)
	CreateDynamicObject(18227,1685.8242200,-4100.9223600,69.5113200,9.5090000,337.3190000,246.1030000); //object(117)
	CreateDynamicObject(18227,1729.7739300,-4130.2211900,84.0254500,351.3850000,1.7240000,244.1290000); //object(117)
	CreateDynamicObject(18227,1599.7021500,-4180.7221700,84.5383000,351.3810000,1.7190000,254.4370000); //object(117)
	CreateDynamicObject(18227,1509.6743200,-4228.0068400,84.0986700,336.6550000,344.9850000,13.9810000); //object(117)
	CreateDynamicObject(18227,1569.7304700,-4213.6093700,88.6878100,351.4840000,351.2950000,75.5620000); //object(117)
	CreateDynamicObject(18227,1540.0327100,-4239.9589800,77.4573100,4.3160000,327.2280000,53.8560000); //object(117)
	CreateDynamicObject(789,1668.6357400,-3954.8308100,95.0781600,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(789,1791.9497100,-4033.0769000,95.4826500,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(789,1842.9614300,-3912.1975100,116.3608200,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(789,1736.7744100,-4124.7753900,93.8847000,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(789,1634.2177700,-4014.1323200,88.9720300,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(789,1636.2211900,-3896.0610400,73.9661400,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(789,1570.4677700,-3904.8745100,36.4824600,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(789,1479.0151400,-3989.9917000,29.4380800,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(789,2000.2211900,-3728.0046400,84.8994900,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(789,2006.3637700,-3806.9360400,43.8101200,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(789,2064.5092800,-3716.7504900,42.5904400,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(789,1989.4555700,-3610.1198700,97.2774400,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(789,1787.2495100,-3485.2661100,94.6169400,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(789,1657.8505900,-3535.7519500,65.6553100,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(789,1507.3823200,-3746.1604000,57.3583300,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(789,1488.8217800,-3706.7910200,45.5189800,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(789,1315.6582000,-3713.9448200,52.0315000,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(789,1456.1210900,-3799.9707000,33.6967600,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(789,1395.9155300,-3896.5478500,31.7003800,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(789,1403.3598600,-3955.0297900,29.4234400,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(789,1445.2353500,-3842.6240200,24.0542300,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(817,1420.6938500,-4115.8740200,37.0814400,0.0000000,0.0000000,0.0000000); //object(veg_pflowers01)(1)
	CreateDynamicObject(825,1442.6518600,-4121.5678700,41.1165100,0.0000000,0.0000000,0.0000000); //object(genveg_bushy)(1)
	CreateDynamicObject(825,1500.2016600,-3916.3454600,23.0668800,0.0000000,0.0000000,0.0000000); //object(genveg_bushy)(2)
	CreateDynamicObject(825,1498.8867200,-3921.1894500,23.2591700,0.0000000,0.0000000,0.0000000); //object(genveg_bushy)(3)
	CreateDynamicObject(856,1472.5263700,-3916.7924800,20.3675700,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass12)(1)
	CreateDynamicObject(856,1475.5507800,-3949.2666000,18.5623100,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass12)(2)
	CreateDynamicObject(856,1525.3501000,-3986.1267100,22.2291500,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass12)(3)
	CreateDynamicObject(856,1436.1464800,-3836.6367200,7.6842300,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass12)(4)
	CreateDynamicObject(856,1440.6425800,-3882.0991200,15.0449600,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass12)(5)
	CreateDynamicObject(856,1371.4199200,-3984.3916000,17.2281400,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass12)(6)
	CreateDynamicObject(856,1166.8774400,-4123.7763700,60.4078900,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass12)(7)
	CreateDynamicObject(856,1193.3598600,-4112.4033200,61.8136400,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass12)(8)
	CreateDynamicObject(789,1163.3696300,-4104.0127000,88.2931400,20.6200000,0.0000000,0.0000000); //object(346)
	CreateDynamicObject(789,1426.4267600,-4053.8000500,57.6224500,20.6160000,0.0000000,184.0900000); //object(346)
	CreateDynamicObject(856,1392.8662100,-4040.1330600,29.8743500,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass12)(9)
	CreateDynamicObject(856,1280.7050800,-4165.6762700,64.1477400,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass12)(10)
	CreateDynamicObject(856,1404.5800800,-4109.9707000,32.1121500,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass12)(11)
	CreateDynamicObject(856,1707.7978500,-4049.7539100,55.7601500,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass12)(12)
	CreateDynamicObject(856,1648.8486300,-4010.8100600,54.3903400,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass12)(13)
	CreateDynamicObject(856,1768.4799800,-3945.8305700,88.8105600,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass12)(14)
	CreateDynamicObject(856,1722.4995100,-3969.9614300,72.6074800,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass12)(15)
	CreateDynamicObject(874,1686.2382800,-4043.6752900,55.6049800,0.0000000,0.0000000,0.0000000); //object(veg_procgrasspatch)(1)
	CreateDynamicObject(815,1732.8906300,-4012.3220200,72.7146700,0.0000000,0.0000000,0.0000000); //object(genveg_bush19)(1)
	CreateDynamicObject(803,1746.2299800,-4035.1909200,93.8387500,0.0000000,0.0000000,0.0000000); //object(genveg_bush09)(1)
	CreateDynamicObject(805,1749.8867200,-4038.8486300,95.4516700,0.0000000,0.0000000,0.0000000); //object(genveg_bush11)(1)
	CreateDynamicObject(803,1757.3623000,-4101.3310500,90.7852000,0.0000000,0.0000000,0.0000000); //object(genveg_bush09)(2)
	CreateDynamicObject(800,1744.6665000,-4017.1093700,75.2858900,0.0000000,0.0000000,0.0000000); //object(genveg_bush07)(1)
	CreateDynamicObject(762,1741.6577100,-4023.4663100,88.5227500,0.0000000,0.0000000,0.0000000); //object(new_bushtest)(1)
	CreateDynamicObject(762,1700.9521500,-4075.7592800,69.4152400,0.0000000,0.0000000,0.0000000); //object(new_bushtest)(2)
	CreateDynamicObject(762,1739.2016600,-3943.2934600,74.4894900,0.0000000,0.0000000,0.0000000); //object(new_bushtest)(3)
	CreateDynamicObject(762,1747.8745100,-3980.2265600,79.4056500,0.0000000,0.0000000,0.0000000); //object(new_bushtest)(4)
	CreateDynamicObject(762,1565.5034200,-3787.7937000,35.5743000,0.0000000,0.0000000,0.0000000); //object(new_bushtest)(5)
	CreateDynamicObject(762,1703.2114300,-3803.1755400,51.0844000,0.0000000,0.0000000,0.0000000); //object(new_bushtest)(6)
	CreateDynamicObject(762,1838.2739300,-3793.5498000,91.4489300,0.0000000,0.0000000,0.0000000); //object(new_bushtest)(7)
	CreateDynamicObject(762,1819.0864300,-3650.4418900,66.7413200,0.0000000,0.0000000,0.0000000); //object(new_bushtest)(8)
	CreateDynamicObject(762,2007.1279300,-3789.7478000,27.9821200,0.0000000,0.0000000,0.0000000); //object(new_bushtest)(9)
	CreateDynamicObject(762,2023.4433600,-3754.8598600,35.8825000,0.0000000,0.0000000,0.0000000); //object(new_bushtest)(10)
	CreateDynamicObject(762,1970.9375000,-3762.1909200,63.2681400,0.0000000,0.0000000,0.0000000); //object(new_bushtest)(11)
	CreateDynamicObject(762,1959.0009800,-3872.9221200,33.4785700,0.0000000,0.0000000,0.0000000); //object(new_bushtest)(12)
	CreateDynamicObject(803,1819.2119100,-3961.9609400,77.3428000,0.0000000,0.0000000,0.0000000); //object(genveg_bush09)(3)
	CreateDynamicObject(803,1978.2309600,-3873.9816900,30.5966400,0.0000000,0.0000000,0.0000000); //object(genveg_bush09)(4)
	CreateDynamicObject(2912,1736.3813500,-3346.9389600,5.9359900,0.0000000,0.0000000,0.0000000); //object(temp_crate1)(1)
	CreateDynamicObject(3572,1763.6704100,-3370.1987300,6.6616700,0.0000000,0.0000000,58.0290000); //object(lasdkrt4)(1)
	CreateDynamicObject(3572,1761.6005900,-3368.9238300,6.6626500,0.0000000,0.0000000,58.0240000); //object(lasdkrt4)(2)
	CreateDynamicObject(3572,1765.8081100,-3366.7797900,6.1558000,0.0000000,0.0000000,58.0240000); //object(lasdkrt4)(3)
	CreateDynamicObject(3572,1763.7421900,-3365.4834000,6.1703600,0.0000000,0.0000000,58.0240000); //object(lasdkrt4)(4)
	CreateDynamicObject(3572,1765.8007800,-3366.7758800,6.6491900,0.0000000,0.0000000,58.0240000); //object(lasdkrt4)(5)
	CreateDynamicObject(3572,1763.7197300,-3365.4790000,6.6529000,0.0000000,0.0000000,58.0240000); //object(lasdkrt4)(6)
	CreateDynamicObject(3572,1759.4404300,-3367.5683600,6.6735800,0.0000000,0.0000000,58.0240000); //object(lasdkrt4)(7)
	CreateDynamicObject(3572,1761.5717800,-3364.1269500,6.6529600,0.0000000,0.0000000,58.0240000); //object(lasdkrt4)(8)
	CreateDynamicObject(3502,1761.5766600,-3369.0983900,10.3092400,271.5030000,0.0000000,327.3510000); //object(vgsn_con_tube)(1)
	CreateDynamicObject(3643,1763.1430700,-3368.6335400,3.7798700,0.0000000,0.0000000,321.4820000); //object(la_chem_piping)(1)
	CreateDynamicObject(3643,1762.3935500,-3368.1555200,3.7915800,0.0000000,0.0000000,328.3500000); //object(la_chem_piping)(2)
	CreateDynamicObject(3643,1761.7929700,-3367.6337900,3.8002900,0.0000000,0.0000000,333.5030000); //object(la_chem_piping)(3)
	CreateDynamicObject(3643,1760.9340800,-3367.9946300,3.7255600,0.0000000,0.0000000,340.3740000); //object(la_chem_piping)(4)
	CreateDynamicObject(3502,1761.6040000,-3368.9672900,4.0657100,271.5000000,0.0000000,327.3490000); //object(vgsn_con_tube)(2)
	CreateDynamicObject(789,1702.1967800,-3449.0776400,79.9833800,335.9430000,0.0000000,15.4650000); //object(248)
	CreateDynamicObject(789,1652.2011700,-3353.0395500,51.5118600,0.0000000,0.0000000,0.0000000); //object(248)
	CreateDynamicObject(14872,1527.3144500,-3268.8178700,35.5808700,0.0000000,0.0000000,0.0000000); //object(kylie_logs)(1)
	CreateDynamicObject(1463,1524.8276400,-3269.2973600,35.1096800,0.0000000,0.0000000,0.0000000); //object(dyn_woodpile2)(1)
	CreateDynamicObject(13435,1564.7417000,-3339.3083500,74.1369200,5.1550000,0.0000000,0.0000000); //object(sw_logs08)(1)
	CreateDynamicObject(845,1594.0156300,-3288.7937000,35.1016700,4.8240000,20.6970000,236.8620000); //object(dead_tree_17)(1)
	CreateDynamicObject(845,1589.8081100,-3291.1462400,31.9098500,15.2860000,8.9050000,267.2440000); //object(dead_tree_17)(2)
	CreateDynamicObject(845,1638.7485400,-3293.1782200,24.1032600,4.8230000,20.6930000,236.8600000); //object(dead_tree_17)(3)
	CreateDynamicObject(845,1617.9902300,-3287.5258800,36.3656700,3.7700000,43.0710000,235.1620000); //object(dead_tree_17)(4)
	CreateDynamicObject(845,1587.2597700,-3303.7475600,58.2467300,15.2820000,8.9040000,267.2420000); //object(dead_tree_17)(5)
	CreateDynamicObject(844,1603.1640600,-3293.2192400,36.2767400,0.0000000,0.0000000,123.0370000); //object(dead_tree_16)(1)
	CreateDynamicObject(842,1544.3281300,-3266.5415000,37.5398400,0.0000000,0.0000000,0.0000000); //object(dead_tree_14)(1)
	CreateDynamicObject(842,1625.2934600,-3316.4152800,45.2704800,0.0000000,0.0000000,0.0000000); //object(dead_tree_14)(2)
	CreateDynamicObject(837,1626.7793000,-3326.2094700,44.0019500,0.0000000,0.0000000,335.9430000); //object(dead_tree_1)(1)
	CreateDynamicObject(830,1685.9091800,-3374.5327100,32.5639700,0.0000000,0.0000000,332.5060000); //object(dead_tree_2)(1)
	CreateDynamicObject(829,1681.5039100,-3383.4375000,32.2244700,0.0000000,0.0000000,0.0000000); //object(dead_tree_3)(1)
	CreateDynamicObject(831,1566.9311500,-3321.4804700,73.5505900,0.0000000,0.0000000,0.0000000); //object(dead_tree_5)(1)
	CreateDynamicObject(831,1540.3100600,-3277.9499500,36.7844700,0.0000000,0.0000000,0.0000000); //object(dead_tree_5)(2)
	CreateDynamicObject(833,1519.1547900,-3273.7944300,34.6759900,0.0000000,0.0000000,0.0000000); //object(dead_tree_6)(1)
	CreateDynamicObject(691,1578.4111300,-3320.4165000,72.5226000,0.0000000,0.0000000,0.0000000); //object(sm_veg_tree4_big)(1)
	CreateDynamicObject(691,1611.8823200,-3298.1049800,40.8634600,0.0000000,0.0000000,0.0000000); //object(sm_veg_tree4_big)(2)
	CreateDynamicObject(691,1649.6577100,-3317.1884800,40.7116400,0.0000000,27.4940000,22.3390000); //object(sm_veg_tree4_big)(3)
	CreateDynamicObject(691,1526.4243200,-3247.9619100,35.6268800,3.4370000,0.0000000,0.0000000); //object(sm_veg_tree4_big)(4)
	CreateDynamicObject(703,1458.5981400,-3284.9494600,26.5803400,0.0000000,0.0000000,0.0000000); //object(sm_veg_tree7_big)(1)
	CreateDynamicObject(703,1660.0654300,-3397.8544900,31.5286900,0.0000000,0.0000000,0.0000000); //object(sm_veg_tree7_big)(2)
	CreateDynamicObject(703,1672.7177700,-3432.2255900,37.0767700,341.1330000,3.6320000,350.8660000); //object(sm_veg_tree7_big)(3)
	CreateDynamicObject(703,1709.2612300,-3356.5473600,24.6022800,0.0000000,0.0000000,0.0000000); //object(sm_veg_tree7_big)(4)
	CreateDynamicObject(704,1656.7109400,-3302.3027300,13.1951100,0.0000000,10.3100000,52.4780000); //object(bg_fir_dead)(1)
	CreateDynamicObject(704,1457.6108400,-3258.7475600,24.4845500,0.0000000,0.0000000,0.0000000); //object(bg_fir_dead)(2)
	CreateDynamicObject(704,1853.6274400,-3515.6103500,53.0474600,0.0000000,0.0000000,0.0000000); //object(bg_fir_dead)(3)
	CreateDynamicObject(703,1806.6752900,-3451.2255900,38.0715300,0.0000000,0.0000000,0.0000000); //object(sm_veg_tree7_big)(5)
	CreateDynamicObject(703,1767.9995100,-3530.8024900,82.2584100,0.0000000,0.0000000,0.0000000); //object(sm_veg_tree7_big)(6)
	CreateDynamicObject(704,2031.7519500,-3788.8764600,18.6851700,0.0000000,0.0000000,0.0000000); //object(bg_fir_dead)(4)
	CreateDynamicObject(703,2003.5981400,-3857.6101100,30.4614900,0.0000000,0.0000000,0.0000000); //object(sm_veg_tree7_big)(7)
	CreateDynamicObject(703,2069.9184600,-3737.8078600,28.9555700,0.0000000,0.0000000,0.0000000); //object(sm_veg_tree7_big)(8)
	CreateDynamicObject(703,1741.9375000,-3998.1406200,72.2755100,0.0000000,0.0000000,0.0000000); //object(sm_veg_tree7_big)(9)
	CreateDynamicObject(703,1701.4418900,-4050.5397900,54.9832500,0.0000000,0.0000000,0.0000000); //object(sm_veg_tree7_big)(10)
	CreateDynamicObject(703,1578.6235400,-4103.6992200,84.4978900,0.0000000,339.3800000,10.3100000); //object(sm_veg_tree7_big)(11)
	CreateDynamicObject(703,1434.6835900,-4013.5009800,23.9664700,0.0000000,25.7760000,0.0000000); //object(sm_veg_tree7_big)(12)
	CreateDynamicObject(703,1637.1323200,-3482.4921900,83.4408600,0.0000000,41.2410000,335.9430000); //object(sm_veg_tree7_big)(13)
	CreateDynamicObject(703,1519.0063500,-3418.9270000,73.2133100,347.9930000,3.5140000,355.5770000); //object(sm_veg_tree7_big)(14)
	CreateDynamicObject(700,1534.0332000,-3415.7270500,71.9709500,0.0000000,0.0000000,0.0000000); //object(sm_veg_tree6)(1)
	CreateDynamicObject(704,1523.8520500,-3397.3989300,71.2261700,0.0000000,0.0000000,94.8290000); //object(bg_fir_dead)(5)
	CreateDynamicObject(704,1490.5112300,-3673.9809600,24.5240900,0.0000000,0.0000000,0.0000000); //object(bg_fir_dead)(6)
	CreateDynamicObject(703,1533.5214800,-3717.5102500,32.4379100,0.0000000,0.0000000,0.0000000); //object(sm_veg_tree7_big)(15)
	CreateDynamicObject(703,1510.1894500,-3661.3064000,49.4670000,0.0000000,313.6040000,34.3670000); //object(sm_veg_tree7_big)(16)
	CreateDynamicObject(703,1496.5654300,-3713.4580100,23.4585900,0.0000000,0.0000000,0.0000000); //object(sm_veg_tree7_big)(17)
	CreateDynamicObject(703,1510.7578100,-3683.2695300,25.4048400,0.0000000,0.0000000,0.0000000); //object(sm_veg_tree7_big)(18)
	CreateDynamicObject(726,1683.1054700,-3630.7431600,53.6631200,0.0000000,0.0000000,0.0000000); //object(tree_hipoly19)(1)
	CreateDynamicObject(726,1634.0625000,-3664.8635300,56.7857100,0.0000000,0.0000000,0.0000000); //object(tree_hipoly19)(2)
	CreateDynamicObject(726,1795.4960900,-3658.4213900,62.8817800,0.0000000,0.0000000,0.0000000); //object(tree_hipoly19)(3)
	CreateDynamicObject(726,1728.3452100,-3729.0312500,64.1010900,0.0000000,0.0000000,0.0000000); //object(tree_hipoly19)(4)
	CreateDynamicObject(726,1584.5576200,-3809.7614700,27.1416400,0.0000000,0.0000000,0.0000000); //object(tree_hipoly19)(5)
	CreateDynamicObject(726,1710.1162100,-3883.0566400,55.4689400,0.0000000,0.0000000,0.0000000); //object(tree_hipoly19)(6)
	CreateDynamicObject(726,1677.5708000,-3926.0385700,76.9175900,0.0000000,0.0000000,0.0000000); //object(tree_hipoly19)(7)
	CreateDynamicObject(726,1466.0268600,-3939.3347200,18.6951800,0.0000000,0.0000000,0.0000000); //object(tree_hipoly19)(8)
	CreateDynamicObject(726,1419.0668900,-4012.3930700,29.2078100,0.0000000,0.0000000,0.0000000); //object(tree_hipoly19)(9)
	CreateDynamicObject(726,1525.2636700,-4065.1635700,47.2201200,0.0000000,0.0000000,0.0000000); //object(tree_hipoly19)(10)
	CreateDynamicObject(726,1653.3754900,-4015.6694300,53.2581500,0.0000000,0.0000000,0.0000000); //object(tree_hipoly19)(11)
	CreateDynamicObject(726,1630.3051800,-4119.9033200,100.3967300,0.0000000,0.0000000,0.0000000); //object(tree_hipoly19)(12)
	CreateDynamicObject(726,1570.6206100,-4185.0117200,90.3392800,0.0000000,0.0000000,0.0000000); //object(tree_hipoly19)(13)
	CreateDynamicObject(726,1402.7163100,-4187.8154300,90.0817100,0.0000000,0.0000000,0.0000000); //object(tree_hipoly19)(14)
	CreateDynamicObject(726,1227.1460000,-4117.1640600,64.0673200,0.0000000,0.0000000,0.0000000); //object(tree_hipoly19)(15)
	CreateDynamicObject(18227,1318.6435500,-3875.7360800,70.1799200,0.0000000,345.3900000,37.5670000); //object(42)
	CreateDynamicObject(18227,1235.9580100,-3880.2627000,46.5409000,0.0000000,0.0000000,203.7560000); //object(44)
	CreateDynamicObject(18227,1284.6845700,-3891.0937500,59.5320600,0.0000000,345.3880000,230.8520000); //object(42)
	CreateDynamicObject(18227,1372.0800800,-3847.9531200,47.9730400,37.8150000,331.6330000,92.9800000); //object(25)
	CreateDynamicObject(707,1394.0405300,-3829.6064500,53.8848400,0.0000000,0.0000000,0.0000000); //object(358)
	CreateDynamicObject(707,1347.3291000,-3952.3193400,84.9551800,0.0000000,0.0000000,0.0000000); //object(357)
	CreateDynamicObject(9831,1457.4000200,-2792.6001000,4.0000000,0.0000000,358.0000000,190.0000000); //object(sfw_waterfall) (1)
	//-------------------[ Submarine
	CreateDynamicObject(3117,538.0274658,-2431.0000000,1203.0253906,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3117,534.5021973,-2431.0000000,1203.0253906,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3117,530.9400024,-2431.0000000,1203.0253906,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3117,527.3886719,-2431.0000000,1203.0253906,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(9820,533.2081299,-2434.4289551,1203.9852295,0.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(3117,538.0186157,-2433.1201172,1203.0253906,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3117,534.5019531,-2433.1201172,1203.0253906,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3117,530.9394531,-2433.1201172,1203.0253906,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3117,527.3886719,-2433.1201172,1203.0253906,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3117,523.8378906,-2433.1201172,1203.0253906,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3117,520.2861328,-2433.1201172,1203.0253906,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3095,535.3297729,-2429.9628906,1207.4162598,90.0000000,0.0000000,180.0000000); //
	CreateDynamicObject(3095,533.5431519,-2432.1628418,1207.4665527,90.0000000,0.0000000,180.0000000); //
	CreateDynamicObject(3095,539.5791016,-2428.3574219,1205.7175293,90.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(3095,540.3007812,-2434.3935547,1206.4172363,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3095,543.3359375,-2435.3017578,1205.6912842,90.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(3095,544.6347656,-2432.8378906,1205.6922607,90.0000000,0.0000000,179.9945068); //
	CreateDynamicObject(3095,531.3433838,-2434.4631348,1206.4172363,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3095,544.2868652,-2435.7065430,1203.1677246,180.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3095,539.8144531,-2438.6484375,1205.7423096,90.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(3095,544.1376953,-2438.8251953,1204.4417725,90.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2944,539.6057739,-2434.2741699,1204.5452881,0.0000000,0.0000000,261.2038574); //
	CreateDynamicObject(3095,534.7754517,-2434.1518555,1207.4167480,90.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3095,533.5185547,-2431.5751953,1207.4672852,90.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(9819,542.2545776,-2437.5654297,1203.9002686,0.0000000,0.0000000,270.2702637); //
	CreateDynamicObject(1663,541.2622681,-2436.9877930,1203.6245117,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3095,526.5888062,-2428.4353027,1202.9417725,90.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(3095,522.0738525,-2432.9611816,1202.6665039,90.0000000,0.0000000,180.2701416); //
	CreateDynamicObject(3095,522.3655396,-2434.4746094,1206.4172363,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(16782,539.8995972,-2435.6579590,1204.6827393,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3095,524.5236816,-2434.1721191,1202.7666016,90.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2944,530.3496704,-2434.3896484,1204.5452881,0.0000000,0.0000000,351.4147949); //
	CreateDynamicObject(3095,530.4645996,-2438.6704102,1203.1427002,179.9945068,0.0000000,0.0000000); //
	CreateDynamicObject(10227,530.4657593,-2436.7365723,1204.9790039,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(3095,526.0382080,-2438.9262695,1203.2921143,90.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(3095,534.9108276,-2438.8146973,1207.3671875,90.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(3095,530.5050049,-2438.7270508,1203.2661133,90.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3095,530.6582031,-2439.1062012,1205.8416748,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3095,524.5474243,-2434.7482910,1203.3907471,90.0000000,0.0000000,179.9945068); //
	CreateDynamicObject(3095,534.7741699,-2434.7270508,1207.4172363,90.0000000,0.0000000,179.9945068); //
	CreateDynamicObject(2690,529.8286133,-2438.5744629,1203.4986572,0.0000000,0.0000000,192.5404053); //
	CreateDynamicObject(918,533.1274414,-2433.9267578,1203.5219727,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(918,532.1974487,-2433.8847656,1203.5219727,0.0000000,0.0000000,300.1801758); //
	CreateDynamicObject(2312,530.3375244,-2432.1123047,1205.3646240,6.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2886,529.6884766,-2432.1235352,1204.5522461,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2886,532.0635986,-2432.1220703,1204.5522461,0.0000000,0.0000000,1.9849854); //
	CreateDynamicObject(2312,532.6873779,-2432.1074219,1205.3646240,5.9985352,0.0000000,0.0000000); //
	CreateDynamicObject(2063,535.6181641,-2432.4604492,1203.9842529,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1242,534.5807495,-2432.4663086,1204.0692139,0.0000000,0.0000000,338.1201172); //
	CreateDynamicObject(1242,534.9793091,-2432.4438477,1204.0692139,0.0000000,0.0000000,23.9050903); //
	CreateDynamicObject(1242,535.4018555,-2432.4643555,1204.0692139,0.0000000,0.0000000,351.9606934); //
	CreateDynamicObject(2043,534.8395386,-2432.5034180,1203.5206299,0.0000000,0.0000000,270.2702637); //
	CreateDynamicObject(2043,535.9238892,-2432.5273438,1203.5206299,0.0000000,0.0000000,70.8692322); //
	CreateDynamicObject(2969,536.1965332,-2432.4033203,1203.9854736,0.0000000,0.0000000,357.7500000); //
	CreateDynamicObject(2690,534.4155273,-2431.4472656,1203.4986572,0.0000000,0.0000000,190.5084229); //
	CreateDynamicObject(2690,534.8697510,-2431.4250488,1203.4986572,0.0000000,0.0000000,250.3280640); //
	CreateDynamicObject(2359,535.0068359,-2432.4235840,1204.9534912,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2359,536.2907104,-2432.3913574,1204.9534912,0.0000000,0.0000000,356.0300293); //
	CreateDynamicObject(2358,535.4421997,-2432.4882812,1204.4558105,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1271,531.3440552,-2431.2106934,1203.5003662,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1271,532.0678101,-2431.1884766,1203.5003662,0.0000000,0.0000000,358.7800293); //
	CreateDynamicObject(1271,531.7960205,-2431.1955566,1204.1760254,0.0000000,0.0000000,359.9984131); //
	CreateDynamicObject(3879,522.7996826,-2430.4990234,1216.5125732,0.0000000,180.0000000,180.0000000); //
	CreateDynamicObject(3095,520.3348999,-2430.3913574,1202.5418701,90.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(2634,521.6284790,-2433.5488281,1206.4168701,270.0000000,0.0000000,270.0202637); //
	CreateDynamicObject(2690,543.0354004,-2433.1096191,1203.4986572,0.0000000,0.0000000,312.1301270); //
	CreateDynamicObject(3111,524.6917114,-2434.1579590,1204.6546631,270.0000000,90.0000000,270.0000000); //
	CreateDynamicObject(3386,528.3854370,-2434.1892090,1203.1496582,0.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(12985,530.9605713,-2429.4606934,1200.5476074,0.0000000,0.0000000,270.2500000); //
	CreateDynamicObject(3095,530.2828369,-2425.4687500,1207.6424561,90.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(3095,530.0217285,-2428.9338379,1202.0416260,90.0000000,0.0000000,180.0000000); //
	CreateDynamicObject(3095,527.6177979,-2429.9677734,1198.6169434,90.0000000,0.0000000,359.7500000); //
	CreateDynamicObject(3095,529.7753296,-2425.4687500,1206.4172363,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3095,535.2802734,-2425.4484863,1202.9177246,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3095,533.5009766,-2425.4375000,1202.0418701,90.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(3095,533.0244141,-2434.4638672,1198.9937744,179.9945068,0.0000000,0.0000000); //
	CreateDynamicObject(3095,531.0474243,-2425.9897461,1199.6657715,48.0000000,180.0000000,90.2500000); //
	CreateDynamicObject(1800,528.2965698,-2431.0593262,1198.9904785,0.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(1800,528.2958984,-2431.0585938,1199.8658447,0.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(1800,528.0446777,-2434.0410156,1198.9904785,0.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(1800,528.3222656,-2437.9799805,1199.8656006,0.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(1800,528.3327637,-2437.9785156,1198.9904785,0.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(1800,531.6816406,-2437.9492188,1198.9904785,0.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(1800,531.6821289,-2437.9492188,1199.8653564,0.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(3095,524.1156006,-2434.4887695,1198.9937744,179.9945068,0.0000000,0.0000000); //
	CreateDynamicObject(3095,529.3964844,-2440.3095703,1198.1677246,90.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(3095,528.8237305,-2440.3239746,1198.1677246,90.0000000,0.0000000,90.2901611); //
	CreateDynamicObject(2514,520.8049927,-2433.5725098,1198.9903564,0.0000000,0.0000000,89.7300110); //
	CreateDynamicObject(2739,521.4255371,-2433.4611816,1198.9903564,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2739,522.2747192,-2433.4450684,1198.9903564,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2944,526.4873047,-2432.8095703,1200.3696289,0.0000000,0.0000000,99.5581055); //
	CreateDynamicObject(3095,533.1416016,-2434.5673828,1201.7415771,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3095,524.1779785,-2434.5625000,1201.7415771,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3117,533.5820312,-2430.0791016,1202.0744629,89.3243408,0.0000000,359.7473145); //
	CreateDynamicObject(3095,527.6489258,-2430.5646973,1197.2668457,90.0000000,0.0000000,179.9945068); //
	CreateDynamicObject(2527,526.6665039,-2437.2890625,1198.9655762,0.0000000,0.0000000,180.0000000); //
	CreateDynamicObject(2527,528.3558960,-2437.2658691,1198.9655762,0.0000000,0.0000000,179.9945068); //
	CreateDynamicObject(11631,534.9181519,-2430.9252930,1200.2359619,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3095,538.0605469,-2430.2431641,1197.3377686,90.0000000,0.0000000,179.9945068); //
	CreateDynamicObject(1663,535.2305908,-2431.5083008,1199.4191895,0.0000000,0.0000000,160.6005249); //
	CreateDynamicObject(2007,526.5126953,-2435.2265625,1198.9904785,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2416,527.4266968,-2431.1213379,1198.8720703,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1800,528.0439453,-2434.0410156,1199.6906738,0.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(2690,532.3095703,-2438.2602539,1199.3232422,0.0000000,0.0000000,170.7437744); //
	CreateDynamicObject(2690,536.4322510,-2430.5341797,1199.3232422,0.0000000,0.0000000,335.3536377); //
	CreateDynamicObject(3095,539.2568359,-2438.7294922,1198.2911377,90.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3095,537.3273926,-2436.1455078,1198.2918701,90.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(2944,537.4234009,-2431.7294922,1200.3696289,0.0000000,0.0000000,324.7624512); //
	CreateDynamicObject(1800,536.5028076,-2437.6374512,1198.9654541,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1800,536.5019531,-2437.6367188,1199.8663330,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3386,537.3440552,-2438.6044922,1198.9655762,0.0000000,0.0000000,319.6185303); //
	CreateDynamicObject(2007,529.8137207,-2436.6037598,1198.9654541,0.0000000,0.0000000,89.6849365); //
	CreateDynamicObject(2007,536.8504028,-2433.5270996,1198.9654541,0.0000000,0.0000000,270.2214355); //
	CreateDynamicObject(2007,525.0335083,-2433.8515625,1198.9654541,0.0000000,0.0000000,180.4897461); //
	CreateDynamicObject(3095,537.9447632,-2434.2509766,1197.2440186,179.9945068,0.0000000,0.0000000); //
	CreateDynamicObject(3095,546.9387207,-2434.2585449,1197.2440186,179.9945068,0.0000000,0.0000000); //
	CreateDynamicObject(3095,547.0192261,-2430.2373047,1197.3377686,90.0000000,0.0000000,179.9945068); //
	CreateDynamicObject(3095,548.2366943,-2438.7329102,1198.2906494,90.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3095,542.1332397,-2434.6682129,1201.1927490,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3095,550.7652588,-2434.6833496,1198.3181152,90.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(3095,551.0667114,-2434.6713867,1201.1927490,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3095,538.1410522,-2436.1105957,1197.1429443,90.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(3787,541.8390503,-2432.0568848,1197.7816162,0.0000000,0.0000000,89.7300110); //
	CreateDynamicObject(8572,538.3886719,-2433.0817871,1197.7409668,0.0000000,0.0000000,89.7300415); //
	CreateDynamicObject(964,539.8051758,-2434.8369141,1197.2407227,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(964,540.0001221,-2433.5756836,1197.2407227,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(964,539.9645386,-2434.0815430,1198.1666260,0.0000000,0.0000000,352.0600586); //
	CreateDynamicObject(964,541.2709351,-2434.4355469,1197.2407227,0.0000000,0.0000000,344.1201172); //
	CreateDynamicObject(964,540.3788452,-2432.2858887,1197.2407227,0.0000000,0.0000000,358.0141602); //
	CreateDynamicObject(964,540.4444580,-2430.9887695,1197.2407227,0.0000000,0.0000000,359.0114746); //
	CreateDynamicObject(964,540.2364502,-2431.6215820,1198.1666260,0.0000000,0.0000000,352.3212891); //
	CreateDynamicObject(3117,537.9900513,-2431.9519043,1197.8988037,89.3243408,0.0000000,89.9772949); //
	CreateDynamicObject(3788,539.7269287,-2438.1269531,1197.7603760,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3788,545.8870239,-2432.2800293,1197.7600098,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3788,545.8733521,-2434.2255859,1197.7600098,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3788,545.8590698,-2436.2758789,1197.7600098,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3786,546.2118530,-2432.2673340,1197.9476318,0.0000000,0.0000000,180.0000000); //
	CreateDynamicObject(3786,546.2186279,-2434.2109375,1197.9476318,0.0000000,0.0000000,180.0000000); //
	CreateDynamicObject(3786,546.2024536,-2436.2770996,1197.9476318,0.0000000,0.0000000,180.0000000); //
	CreateDynamicObject(14450,549.7406616,-2434.4230957,1200.4025879,0.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(927,526.0692749,-2436.9543457,1199.9611816,0.0000000,0.0000000,89.7300110); //
	CreateDynamicObject(927,523.0219727,-2434.1232910,1199.9611816,0.0000000,0.0000000,179.7052002); //
	CreateDynamicObject(934,550.0137939,-2433.0434570,1198.5690918,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(958,550.3486938,-2437.2211914,1198.0677490,0.0000000,0.0000000,89.7300110);
	//----------------------------------------//
	printf("Objekti su napravljeni...");
	//----------------------------------------//
	//----------------------------------------------------------------------------//
    SetTimer("WeatherHandler", 1800000, 1);
	SetTimer("VrijemeUpdate", 1000, 1);
	SetTimer("SatiIgre", 60000, 1);
	SetTimer("Systems",1000,1);
	SetTimer("TD_Update", 500, 1);
	SetTimer("SaveDotUpdate", 300, 1);
	SetTimer("SpremiKorisnike", 500000, true);
    return 1;
}
//----------------------------------------------------------------------------//
public OnPlayerConnect(playerid)
{
    GetPlayerIp(playerid, PlayerInfo[playerid][pIP], 16);
    //------------------------------------------------------------------------//
    PlayerInfo[playerid][pSator] = -1;
	//------------------------------------------------------------------------//
	LoggedOn[playerid] = 0; EatMin[playerid] = 0; Thirst[playerid] = 0;
	pChoppingTree[playerid] = -1; pFishing[playerid] = 0;
	FishingProgress[playerid] = 0; ChoppingProgress[playerid] = 0;
	IgracEdituje[playerid] = 0;
	//------------------------------------------------------------------------//
	strmid(PlayerInfo[playerid][pNote1], "None", 0, strlen("None"), 255);
	PlayerInfo[playerid][pNote1s] = 0;
	strmid(PlayerInfo[playerid][pNote2], "None", 0, strlen("None"), 255);
	PlayerInfo[playerid][pNote2s] = 0;
	strmid(PlayerInfo[playerid][pNote3], "None", 0, strlen("None"), 255);
	PlayerInfo[playerid][pNote3s] = 0;
	strmid(PlayerInfo[playerid][pNote4], "None", 0, strlen("None"), 255);
	PlayerInfo[playerid][pNote4s] = 0;
	strmid(PlayerInfo[playerid][pNote5], "None", 0, strlen("None"), 255);
	PlayerInfo[playerid][pNote5s] = 0;
	//------------------------------------------------------------------------//
	if(fexist(UserPath(playerid)))
    {
        InterpolateCameraPos(playerid, 1191.636108, -3595.597412, 20.135456, 2040.568603, -3738.187255, 142.894180, 1000);
		InterpolateCameraLookAt(playerid, 1195.420166, -3598.632568, 18.923944, 2036.583129, -3739.517822, 140.183975, 1000);
        PlayAudioStreamForPlayer(playerid, "http://www.artistroster.com/currentemail/assets/2012/Q3/7-JUL/MP3/Something%20Good.mp3");
		INI_ParseFile(UserPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
        new loginstring[2048], stringz[101];
		strcat(loginstring, ""SIVA"~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~\n\n", sizeof(loginstring));
		format(stringz, sizeof( stringz ), ""SIVA"Pozdrav"ZELENA" %s,\n", GetName(playerid));
		strcat(loginstring, stringz );
		strcat(loginstring, ""SIVA"Lijepo vas je vidjeti opet na nasem serveru.\n", sizeof(loginstring));
		strcat(loginstring, ""SIVA"Sada morate unesti lozinku vaseg korisnickog racuna\n", sizeof(loginstring));
		strcat(loginstring, ""SIVA"Imate"ZELENA" 60"SIVA" sekundi da se prijavite, ili ce te biti iskljuceni sa servera.\n\n", sizeof(loginstring));
       	strcat(loginstring, ""ZELENA"Destory Survival © 2015\n", sizeof(loginstring));
		strcat(loginstring, ""SIVA"~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~", sizeof(loginstring));
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT,""ZELENA"•"BELA" Login", loginstring, "Login","Exit");
		LoggingTimer[playerid] = SetTimerEx("KickCountdown",60000,0,"i",playerid);
    }
    else
    {
        new regstring[2048], stringz[101];
		strcat(regstring, ""SIVA"~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~\n\n", sizeof(regstring));
		format(stringz, sizeof( stringz ), ""SIVA"Dobrodosao/la"ZELENA" %s"SIVA" na nasu zajednicu,\n", GetName(playerid));
		strcat(regstring, stringz );
		strcat(regstring, ""SIVA"Radi daljnih registracijskih koraka duzni ste upisati korisnicku sifru koju ce te koristiti tokom igre\n", sizeof(regstring));
		strcat(regstring, ""ZELENA"(( Morate ju zapisati/zapamtiti i ne smijete staviti neku laku npr. 123123 ))\n\n", sizeof(regstring));
     	strcat(regstring, ""ZELENA"Destory Survival © 2015\n", sizeof(regstring));
     	strcat(regstring, ""SIVA"~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~\n\n", sizeof(regstring));
        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, ""ZELENA"•"BELA" Register", regstring ,"Register","Exit");
    }
	return 1;
}
//----------------------------------------------------------------------------//
public OnPlayerDisconnect(playerid, reason)
{
   	SaveUser(playerid);
   	//-------------------------------------------------------------------------//
   	new string[256];
	format(string, sizeof(string), "~r~%s~w~ je napustio server.", GetName(playerid));
	TextDrawSetString(Informacije[1], string);
	TextDrawShowForAll(Informacije[0]);
	TextDrawShowForAll(Informacije[1]);
	TextDrawShowForAll(Informacije[2]);
	SetTimer("SakrijInfo", 5000, 0);
 	return 1;
}
//----------------------------------------------------------------------------//
public OnGameModeExit()
{
    SaveTrees(); SaveTezga();
    //------------------------------------------------------------------------//
    for(new s = 0; s < sizeof(SatorInfo); s++) { SacuvajSator(s); }
    //------------------------------------------------------------------------//
    //------------------------------------------------------------------------//
    return 1;
}
//----------------------------------------------------------------------------//
public OnPlayerSpawn(playerid)
{
    new coord_switch = random(sizeof(pl_RandSpawn));
    SetPlayerPos(playerid, pl_RandSpawn[coord_switch][0], pl_RandSpawn[coord_switch][1], pl_RandSpawn[coord_switch][2]);
    SetPlayerFacingAngle(playerid, pl_RandSpawn[coord_switch][3]);
    //------------------------------------------------------------------------//
    SetPlayerAttachedObject(playerid, 1, 3026, 1, -0.125, -0.046, -0.004, -1.299, -0.5, -6.297, 1.0, 1.0, 1.0); // Backpack
	//------------------------------------------------------------------------//
	GangZoneShowForPlayer(playerid, HiddenMap, 0x000000FF);
    SetPlayerColor(playerid, 0xDEDEDEFF); // light grey
    //------------------------------------------------------------------------//
	TextDrawShowForPlayer(playerid, Logo);
	TextDrawShowForPlayer(playerid, Vrijeme[0]);
	TextDrawShowForPlayer(playerid, Vrijeme[1]);
	TextDrawShowForPlayer(playerid, Srce[0][playerid]); TextDrawShowForPlayer(playerid, Srce[1][playerid]);
    TextDrawShowForPlayer(playerid, Zedj[0][playerid]); TextDrawShowForPlayer(playerid, Zedj[1][playerid]);
    TextDrawShowForPlayer(playerid, Glad[0][playerid]); TextDrawShowForPlayer(playerid, Glad[1][playerid]);
    TextDrawShowForPlayer(playerid, Dodaci[0]); TextDrawShowForPlayer(playerid, Dodaci[1]);
	//------------------------------------------------------------------------//
	PreloadAnimLib(playerid, "PED");
    SCM(playerid, -1, ""ZELENA"(("SIVA" Spawnovani ste uspjesno, ukoliko trebate pomoc ukucajte /askq"ZELENA" ))");
    SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
    GivePlayerMoney(playerid, PlayerInfo[playerid][pMoney]);
    LoadObjects(playerid, 3);
	//------------------------------------------------------------------------//
    return 1;
}
//----------------------------------------------------------------------------//
public OnPlayerDeath(playerid, killerid, reason)
{
	Bleeding[playerid] = 0;
	//------------------------------------------------------------------------//
	new string[256];
	format(string, sizeof(string), "~r~%s~w~ je umro.", GetName(playerid));
	TextDrawSetString(Informacije[1], string);
	TextDrawShowForAll(Informacije[0]);
	TextDrawShowForAll(Informacije[1]);
	TextDrawShowForAll(Informacije[2]);
	SetTimer("SakrijInfo", 5000, 0);
	return 1;
}
//----------------------------------------------------------------------------//
public OnPlayerUpdate(playerid)
{
	//------------------------------------------------------------------------//
	if(GetPlayerWeapon(playerid) > 1)
	{
		ResetPlayerWeapons(playerid);
	}
	//------------------------------------------------------------------------//
	if(pChoppingTree[playerid] == -1)
	{
		HidePlayerProgressBar(playerid, ChoppingBar[playerid]);
	}
	//------------------------------------------------------------------------//
	if(pFishing[playerid] == 0)
	{
		HidePlayerProgressBar(playerid, FishingBar[playerid]);
	}
	//------------------------------------------------------------------------//
	if(IsPlayerInWater(playerid))    // Provera za praznu vodu, ako je u vodi igrac da se napuni
	{
		if(PlayerInfo[playerid][pFlasaVode] == 1)
		{
			if(PlayerInfo[playerid][pFlasaPuna] == 0)
			{
				PlayerInfo[playerid][pFlasaPuna] = 1;
			}
		}
	}
	//------------------------------------------------------------------------//
	if(HoldForFish[playerid])
	{
        if(pFishing[playerid] == 1)
		{
            FishingProgress[playerid] += 5;
    		SetPlayerProgressBarValue(playerid, FishingBar[playerid], FishingProgress[playerid]);
    		UpdatePlayerProgressBar(playerid, FishingBar[playerid]);
		}
	}
	//------------------------------------------------------------------------//
	return 1;
}
//----------------------------------------------------------------------------//
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	//------------------------------------------------------------------------//
    if(HOLDING(KEY_FIRE))HoldForFish[playerid] = true;
    else if(RELEASED(KEY_FIRE))HoldForFish[playerid] = false;
	//------------------------------------------------------------------------//
	if( newkeys == KEY_SECONDARY_ATTACK )
	{
		for(new i; i < MAX_SATOR; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 5.0, SatorInfo[i][sPozX], SatorInfo[i][sPozY], SatorInfo[i][sPozZ]) && !IsPlayerInAnyVehicle(playerid))
			{
			    if(SatorInfo[i][sZakljucan] == 1) return GameTextForPlayer(playerid,"~r~ZATVOREN!",5000,3);
				SetPlayerVirtualWorld(playerid, SatorInfo[i][sVW]);
				SetPlayerInterior(playerid, SatorInfo[i][sInt]);
				SetPlayerPos(playerid, SatorInfo[i][sPozX2], SatorInfo[i][sPozY2], SatorInfo[i][sPozZ2]);
				LoadObjects(playerid, 3);
				return 1;
			}
        	if(IsPlayerInRangeOfPoint(playerid, 3.0, SatorInfo[i][sPozX2], SatorInfo[i][sPozY2], SatorInfo[i][sPozZ2])
	        && GetPlayerVirtualWorld(playerid) == SatorInfo[i][sVW] && !IsPlayerInAnyVehicle(playerid))
	        {
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerPos(playerid, SatorInfo[i][sPozX], SatorInfo[i][sPozY], SatorInfo[i][sPozZ]);
				LoadObjects(playerid, 3);
				return 1;
			}
		}
	}
    //------------------------------------------------------------------------//
	if(newkeys == KEY_FIRE)
	{
		if(pChoppingTree[playerid] != -1)
		{
			ChoppingProgress[playerid] += 5;
    		SetPlayerProgressBarValue(playerid, ChoppingBar[playerid], ChoppingProgress[playerid]);
    		UpdatePlayerProgressBar(playerid, ChoppingBar[playerid]);
		}
	}
	//------------------------------------------------------------------------//
	if(newkeys & KEY_YES)
    {
    	return cmd_rezidrvo(playerid);
    }
    if(newkeys & KEY_NO)
    {
        ChoppingProgress[playerid] = 0;
        KillTimer(TreeHealthUpdater[playerid]);
        HidePlayerProgressBar(playerid, ChoppingBar[playerid]);
        TogglePlayerControllable(playerid, 1);
    }
    //------------------------------------------------------------------------//
    if(newkeys & KEY_SPRINT)
    {
        if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		{
			EatMin[playerid] ++;
			Thirst[playerid] ++;
		}
	}
    //------------------------------------------------------------------------//
    if(newkeys == KEY_SPRINT) // Tezge
	{
        if(IsPlayerInRangeOfPoint(playerid, 3.0, 1248.3463,-3641.6392,3.7160)) // Ribe
		{
            SPD(playerid, TEZGA_RIBE, DSL, ""PLAVA"Tezga #1 -"BELA" Ribe", "Trenutno Stanje\nUzmi\nOstavi", "Odaberi", "Izlaz");
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 1249.7458,-3634.2498,3.7087)) // Voce
		{
            SPD(playerid, TEZGA_VOCE, DSL, ""PLAVA"Tezga #2 -"BELA" Voce", "Trenutno Stanje\nUzmi\nOstavi", "Odaberi", "Izlaz");
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 1245.5681,-3630.7461,3.2048)) // Voda
		{
            SPD(playerid, TEZGA_VODA, DSL, ""PLAVA"Tezga #3 -"BELA" Voda", "Trenutno Stanje\nUzmi\nOstavi", "Odaberi", "Izlaz");
		}
	}
	//------------------------------------------------------------------------//
    return 1;
}
//----------------------------------------------------------------------------//
public OnPlayerText(playerid, text[])
{
    new string[256];
    if(strlen(text) > 100) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Ne vise od 100 slova!");
    format(string, sizeof(string), "%s (%d): %s", GetName(playerid), playerid, text);
   	ProxDetector(30.0, playerid, string, -1, -1, -1, -1, -1);
    return 0;
}
//----------------------------------------------------------------------------//
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_COOK)
	{
		if(response)
		{
			if(listitem == 0)
			{
				if(PlayerInfo[playerid][pRibe] < 1) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Nemas ni jednu ribu koju mozes ispeci!");
				PlayerInfo[playerid][pRibe] --;
				PlayerInfo[playerid][pJRibe] ++;
				SCM(playerid, -1, ""ZELENA"*"BELA" Uspesno si ispekao ribu.");
			}
		}
	}
	//------------------------------------------------------------------------//
	if(dialogid == DIALOG_CRAFT)
	{
		if(response)
		{
			if(listitem == 0)
			{
				if(PlayerInfo[playerid][pRStap] == 1) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Vec imas ribarski stap!");
				if(PlayerInfo[playerid][pDrvo] < 5) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Nemas dovoljno drva!");
				PlayerInfo[playerid][pDrvo] -= 5;
				PlayerInfo[playerid][pRStap] = 1;
				SCM(playerid, -1, ""ZELENA"*"BELA" Uspesno si napravio Ribarski Stap!");
			}
			if(listitem == 1)
			{
				if(PlayerInfo[playerid][pSator] != -1) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Mozes imati samo 1 sator!");
				if(PlayerInfo[playerid][pDrvo] < 50) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Nemas dovoljno drva!");
				if(PlayerInfo[playerid][pKamen] < 10) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Nemas dovoljno kamenja!");
				PlayerInfo[playerid][pDrvo] -= 50;
				PlayerInfo[playerid][pKamen] -= 10;
    			new Float:X2, Float:Y2, Float:Z2, Float:Angle, sfajl[60];
    			new satorid = SledeciSatorID();
				GetPlayerPos(playerid, X2, Y2, Z2); GetPlayerFacingAngle(playerid, Angle);
				format(sfajl, sizeof(sfajl), SATOR_FILE, satorid);
				SatorInfo[satorid][sPostavljen] = 1; SatorInfo[satorid][sAngle] = Angle;
				SatorInfo[satorid][sPozX] = X2; SatorInfo[satorid][sPozY] = Y2; SatorInfo[satorid][sPozZ] = Z2;
				SatorInfo[satorid][sPozX2] = 808.6020; SatorInfo[satorid][sPozY2] = 336.8693; SatorInfo[satorid][sPozZ2] = -20.5541;
				SatorInfo[satorid][sProveraVlasnika] = 1; PlayerInfo[playerid][pSator] = satorid;
				SatorInfo[satorid][sInt] = GetPlayerInterior(playerid); SatorInfo[satorid][sVW] = GetPlayerVirtualWorld(playerid);
    			strmid(SatorInfo[satorid][sVlasnik], GetName(playerid), 0, strlen(GetName(playerid)), 255);
				KreirajSator(satorid); SacuvajSator(satorid); SCM(playerid,-1,""ZELENA"*"BELA" Uspesno si napravio sator!");
			}
		}
	}
	//------------------------------------------------------------------------//
	if(dialogid == TEZGA_VODA)
	{
    	if(response)
		{
            if(listitem == 0)
		    {
				SCMF(playerid, -1, ""PLAVA"[STATUS]:"BELA" Ukupno vode: %d casa.", tezga3);
			}
			if(listitem == 1)
			{
				if(tezga3 < 1) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Zao nam je, ali ovde vise nije nista ostalo.");
				if(PlayerInfo[playerid][pZedj] < 70) return SCM(playerid, -1, ""CRVENA"*"SIVA" Nisi toliko zedan da moras uzimati vodu ovde!");
                tezga3 -= 1;
    			PlayerInfo[playerid][pZedj] -= 10;
    			if(PlayerInfo[playerid][pZedj] < 0) { PlayerInfo[playerid][pZedj] = 0; }
    			SCM(playerid, -1, ""ZELENA"*"BELA" Popio si vodu.");
			}
			if(listitem == 2)
			{
                if(PlayerInfo[playerid][pFlasaVode] < 1) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Nemate flasu!");
                if(PlayerInfo[playerid][pFlasaPuna] < 1) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Vasa flasa je prazna!");
                tezga3 += 1;
                PlayerInfo[playerid][pFlasaPuna] = 0;
                SCM(playerid, -1, ""ZELENA"*"BELA" Dao si vodu na tezgu, ostala ti je prazna flasa.");
				if(PlayerInfo[playerid][pSatiIgre] == 1)
				{
					SCM(playerid, -1, ""ZELENA"#QUICK TIP:"SIVA" Flasu mozete ponovno nasuti vodom ako udjete u rijeku/more.");
				}
			}
		}
	}
	//------------------------------------------------------------------------//
	if(dialogid == TEZGA_VOCE)
	{
    	if(response)
		{
            if(listitem == 0)
		    {
				SCMF(playerid, -1, ""PLAVA"[STATUS]:"BELA" Ukupno voca: %d.", tezga2);
			}
			if(listitem == 1)
			{
                new Float: health;
    			GetPlayerHealth(playerid, health);
				if(tezga2 < 1) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Zao nam je, ali ovde vise nije nista ostalo.");
				if(PlayerInfo[playerid][pGlad] > 30) return SCM(playerid, -1, ""CRVENA"*"SIVA" Nisi toliko gladan da moras uzimati hranu ovde!");
                tezga2 -= 1;
    			PlayerInfo[playerid][pGlad] += 5;
    			if(PlayerInfo[playerid][pGlad] > 100) { PlayerInfo[playerid][pGlad] = 100; }
    			SCM(playerid, -1, ""ZELENA"*"BELA" Pojeo si vocku.");
    			if(health < 30)
    			{
        			health += 10.0;
        			SetPlayerHealth(playerid, health);
    			}
			}
			if(listitem == 2)
			{
                SPD(playerid, TEZGA_VOCEOS, DSI, ""PLAVA"Tezga #2 -"BELA" Ostavi", ""BELA"Unesite kolicinu voca koju zelite ostaviti.", "Ostavi", "Odustani");
			}
		}
	}
	if(dialogid == TEZGA_RIBEOS)
	{
		if(response)
		{
			new kol = strval(inputtext);
			if(kol < 1 || kol > 20)
			{
				SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Ne mozete ostaviti manje od 1 ili vise od 20 od jednom.");
			}
			else
			{
				if(PlayerInfo[playerid][pVoce] < kol) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Nemas toliko voca!");
				PlayerInfo[playerid][pVoce] -= kol;
				tezga2 += kol;
				SaveTezga();
			}
		}
	}
	//------------------------------------------------------------------------//
	if(dialogid == TEZGA_RIBE)
	{
    	if(response)
		{
            if(listitem == 0)
		    {
				SCMF(playerid, -1, ""PLAVA"[STATUS]:"BELA" Ukupno riba: %d.", tezga1);
			}
			if(listitem == 1)
			{
                new Float: health;
    			GetPlayerHealth(playerid, health);
				if(tezga1 < 1) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Zao nam je, ali ovde vise nije nista ostalo.");
				if(PlayerInfo[playerid][pGlad] > 30) return SCM(playerid, -1, ""CRVENA"*"SIVA" Nisi toliko gladan da moras uzimati hranu ovde!");
                tezga1 -= 1;
    			PlayerInfo[playerid][pGlad] += 10;
    			if(PlayerInfo[playerid][pGlad] > 100) { PlayerInfo[playerid][pGlad] = 100; }
    			SCM(playerid, -1, ""ZELENA"*"BELA" Pojeo si ribu.");
    			if(health < 50)
    			{
        			health += 10.0;
        			SetPlayerHealth(playerid, health);
    			}
			}
			if(listitem == 2)
			{
                SPD(playerid, TEZGA_RIBEOS, DSI, ""PLAVA"Tezga #1 -"BELA" Ostavi", ""BELA"Unesite kolicinu riba koju zelite ostaviti.", "Ostavi", "Odustani");
			}
		}
	}
	if(dialogid == TEZGA_RIBEOS)
	{
		if(response)
		{
			new kol = strval(inputtext);
			if(kol < 1 || kol > 20)
			{
				SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Ne mozete ostaviti manje od 1 ili vise od 20 od jednom.");
			}
			else
			{
				if(PlayerInfo[playerid][pJRibe] < kol) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Nemas toliko jestivih riba!");
				PlayerInfo[playerid][pJRibe] -= kol;
				tezga1 += kol;
				SaveTezga();
			}
		}
	}
	//------------------------------------------------------------------------//
	switch(dialogid)
    {
        case DIALOG_REGISTER:
        {
            if (!response) return Kick(playerid);
            if(response)
            {
                if(!strlen(inputtext))
				return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Register", "You have entered an invalid password.\n\nType your password below to register a new account.","Register","Exit");
			    new INI:File = INI_Open(UserPath(playerid));
                INI_SetTag(File,"data");
                INI_WriteInt(File,"Password",udb_hash(inputtext));
                INI_WriteInt(File,"Money",200);
                INI_WriteInt(File,"Admin",0);
                INI_WriteInt(File,"Skin",291);
                INI_WriteInt(File,"FlasaVode",1);
                INI_WriteInt(File,"FlasaPuna",1);
                INI_WriteInt(File,"RStap",0);
                INI_WriteInt(File,"Ribe",0);
                INI_WriteInt(File,"JRibe",0);
                INI_WriteInt(File,"Voce",0);
                INI_WriteInt(File,"Drvo",0);
                INI_WriteInt(File,"Glad",0);
                INI_WriteInt(File,"Zedj",0);
                INI_WriteInt(File,"Povez",1);
                INI_WriteInt(File,"Sator",-1);
                INI_Close(File);
				SetSpawnInfo(playerid, 0, 0, 1206.6125,-3612.6697,2.2549, 0, 0, 0, 0, 0, 0, 0);
                SpawnPlayer(playerid);
                LoggedOn[playerid] = 1;
                SCM(playerid, -1, ""SIVA"** Ostalo mi je samo flasa vode i povez.");
                SCM(playerid, -1, ""SIVA"** Posluzice mi veoma mnogo, nadam se...");
			}
        }
        case DIALOG_LOGIN:
        {
            if(!response) return Kick(playerid);
            if(response)
            {
				KillTimer(LoggingTimer[playerid]);
				if(udb_hash(inputtext) == PlayerInfo[playerid][pPass])
                {
                	if(PlayerInfo[playerid][pBan] == 1)
                	{
                		Kick(playerid);
                	}
               		INI_ParseFile(UserPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
                	SetSpawnInfo(playerid, 0, 0, -187.7972,1207.6548,19.6931, 0, 0, 0, 0, 0, 0, 0);
                	SpawnPlayer(playerid);
                	LoggedOn[playerid] = 1;
                	StopAudioStreamForPlayer(playerid);
                	new string[256];
					format(string, sizeof(string), "~y~%s~w~ se ulogovao.", GetName(playerid));
					TextDrawSetString(Informacije[1], string);
					TextDrawShowForAll(Informacije[0]);
					TextDrawShowForAll(Informacije[1]);
					TextDrawShowForAll(Informacije[2]);
					SetTimer("SakrijInfo", 5000, 0);
                }
                else
                {
					new loginstring[2048], stringz[101];
					strcat(loginstring, ""SIVA"~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~\n\n", sizeof(loginstring));
					format(stringz, sizeof( stringz ), ""SIVA"Pozdrav"ZELENA" %s,\n", GetName(playerid));
					strcat(loginstring, stringz );
					strcat(loginstring, ""SIVA"Lijepo vas je vidjeti opet na nasem serveru.\n", sizeof(loginstring));
					strcat(loginstring, ""SIVA"Sada morate unesti lozinku vaseg korisnickog racuna\n", sizeof(loginstring));
					strcat(loginstring, ""SIVA"Imate"ZELENA" 60"SIVA" sekundi da se prijavite, ili ce te biti iskljuceni sa servera.\n\n", sizeof(loginstring));
       				strcat(loginstring, ""ZELENA"Destory Survival © 2015\n", sizeof(loginstring));
					strcat(loginstring, ""SIVA"~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~", sizeof(loginstring));
        			ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT,""ZELENA"•"BELA" Login", loginstring, "Login","Exit");
                	LoggingTimer[playerid] = SetTimerEx("KickCountdown",60000,0,"i",playerid);
				}
                return 1;
            }
        }
    }
    return 1;
}
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
CMD:savestats(playerid, params[])
{
    if(LoggedOn[playerid] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Niste se prijavili!");
    SaveUser(playerid);
    SCM(playerid, -1, ""ZELENA"*"BELA" Uspesno ste sacuvali trenutni status!");
    return 1;
}
//----------------------------------------------------------------------------//
CMD:gotopos(playerid, params[])
{
    if(LoggedOn[playerid] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Niste se prijavili!");
    if(PlayerInfo[playerid][pAdmin] < 6) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Niste admin!");
    new Float:gx, Float:gy, Float:gz, interior;
    if(sscanf(params, "fffi",gx,gy,gz,interior)) return SCM(playerid, -1, ""ZELENA"[INFO]:"BELA"/gotopos [X] [Y] [Z] [Interior ID]");
	SetPlayerPos(playerid, gx, gy, gz);
	SetPlayerInterior(playerid, interior);
	return 1;
}
//----------------------------------------------------------------------------//
CMD:koristivodu(playerid, params[])
{
	//#pragma unused help
	if(LoggedOn[playerid] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Niste se prijavili!");
	if(PlayerInfo[playerid][pFlasaVode] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Nemas flasu!");
	if(PlayerInfo[playerid][pFlasaPuna] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Tvoja flasa je prazna!");
	PlayerInfo[playerid][pFlasaPuna] = 0;
	PlayerInfo[playerid][pZedj] -= 30;
	if(PlayerInfo[playerid][pZedj] < 0) { PlayerInfo[playerid][pZedj] = 0; }
	SCM(playerid, -1, ""ZELENA"*"BELA" Popio si vodu iz flase.");
	new string[256];
	format(string, sizeof(string), "* %s uzima svoju flasu i pije vodu.", GetName(playerid));
	ProxDetector(30.0, playerid, string, PURPLE1,PURPLE2,PURPLE3,PURPLE4,PURPLE5);
	return 1;
}
//----------------------------------------------------------------------------//
CMD:koristipovez(playerid, params[])
{
    //#pragma unused help
	if(LoggedOn[playerid] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Niste se prijavili!");
	if(PlayerInfo[playerid][pPovez] < 1) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Nemas povez!");
	if(Bleeding[playerid] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Ne krvaris!");
	Bleeding[playerid] = 0;
	PlayerInfo[playerid][pPovez] -= 1;
	SCM(playerid, -1, ""ZELENA"*"BELA" Zavezao si povez na ranu, ne krvaris vise!");
	new string[256];
	format(string, sizeof(string), "* %s veze povez na ranu.", GetName(playerid));
	ProxDetector(30.0, playerid, string, PURPLE1,PURPLE2,PURPLE3,PURPLE4,PURPLE5);
	return 1;
}
//----------------------------------------------------------------------------//
CMD:shownotes(playerid, params[])
{
    //#pragma unused help
	if(LoggedOn[playerid] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Niste se prijavili!");
	new string[256];
	SCM(playerid, -1, ""CRVENA"_____________Note Book_____________");
	format(string, sizeof(string), ""CRVENA"~ (1). "BELA"%s", PlayerInfo[playerid][pNote1]);
	SCM(playerid, -1, string);
	format(string, sizeof(string), ""CRVENA"~ (2). "BELA"%s", PlayerInfo[playerid][pNote2]);
	SCM(playerid, -1, string);
	format(string, sizeof(string), ""CRVENA"~ (3). "BELA"%s", PlayerInfo[playerid][pNote3]);
	SCM(playerid, -1, string);
	format(string, sizeof(string), ""CRVENA"~ (4). "BELA"%s", PlayerInfo[playerid][pNote4]);
	SCM(playerid, -1, string);
	format(string, sizeof(string), ""CRVENA"~ (5). "BELA"%s", PlayerInfo[playerid][pNote5]);
	SCM(playerid, -1, string);
	SCM(playerid, -1, ""CRVENA"___________________________________");
	format(string, sizeof(string), "* %s gleda svoje beleske.", GetName(playerid));
	ProxDetector(30.0, playerid, string, PURPLE1,PURPLE2,PURPLE3,PURPLE4,PURPLE5);
	return 1;
}
//----------------------------------------------------------------------------//
CMD:deletenote(playerid, params[])
{
    //#pragma unused help
	if(LoggedOn[playerid] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Niste se prijavili!");
	new id, string[256];
	if(sscanf(params, "i",id)) return SCM(playerid, -1, ""ZELENA"[HELP]:"BELA" /deletenote [id]");
	if(id < 1 || id > 5) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Samo od 1,2,3,4 i 5.");
	if(id == 1)
	{
        if(PlayerInfo[playerid][pNote1s] == 1)
 		{
			strmid(PlayerInfo[playerid][pNote1], "None", 0, strlen("None"), 255);
			PlayerInfo[playerid][pNote1s] = 0;
			SCM(playerid, -1, ""ZELENA"(DS):"SIVA" Obrisao si belesku na slotu 1.");
			format(string, sizeof(string), "* %s uzima gumicu i brise belesku.", GetName(playerid));
			ProxDetector(30.0, playerid, string, PURPLE1,PURPLE2,PURPLE3,PURPLE4,PURPLE5);
		}
		else
		{
	        SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Nemas belesku na slotu 1.");
		}
	}
	else if(id == 2)
	{
        if(PlayerInfo[playerid][pNote2s] == 1)
 		{
			strmid(PlayerInfo[playerid][pNote2], "None", 0, strlen("None"), 255);
			PlayerInfo[playerid][pNote2s] = 0;
			SCM(playerid, -1, ""ZELENA"(DS):"SIVA" Obrisao si belesku na slotu 2.");
			format(string, sizeof(string), "* %s uzima gumicu i brise belesku.", GetName(playerid));
			ProxDetector(30.0, playerid, string, PURPLE1,PURPLE2,PURPLE3,PURPLE4,PURPLE5);
		}
		else
		{
	        SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Nemas belesku na slotu 2.");
		}
	}
	else if(id == 3)
	{
        if(PlayerInfo[playerid][pNote3s] == 1)
 		{
			strmid(PlayerInfo[playerid][pNote3], "None", 0, strlen("None"), 255);
			PlayerInfo[playerid][pNote3s] = 0;
   			SCM(playerid, -1, ""ZELENA"(DS):"SIVA" Obrisao si belesku na slotu 3.");
   			format(string, sizeof(string), "* %s uzima gumicu i brise belesku.", GetName(playerid));
			ProxDetector(30.0, playerid, string, PURPLE1,PURPLE2,PURPLE3,PURPLE4,PURPLE5);
		}
		else
		{
		    SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Nemas belesku na slotu 3.");
		}
	}
	else if(id == 4)
	{
        if(PlayerInfo[playerid][pNote4s] == 1)
 		{
			strmid(PlayerInfo[playerid][pNote4], "None", 0, strlen("None"), 255);
			PlayerInfo[playerid][pNote4s] = 0;
			SCM(playerid, -1, ""ZELENA"(DS):"SIVA" Obrisao si belesku na slotu 4.");
			format(string, sizeof(string), "* %s uzima gumicu i brise belesku.", GetName(playerid));
			ProxDetector(30.0, playerid, string, PURPLE1,PURPLE2,PURPLE3,PURPLE4,PURPLE5);
		}
		else
		{
	        SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Nemas belesku na slotu 4.");
		}
	}
	else if(id == 5)
	{
        if(PlayerInfo[playerid][pNote5s] == 1)
 		{
			strmid(PlayerInfo[playerid][pNote5], "None", 0, strlen("None"), 255);
			PlayerInfo[playerid][pNote5s] = 0;
			SCM(playerid, -1, ""ZELENA"(DS):"SIVA" Obrisao si belesku na slotu 5.");
			format(string, sizeof(string), "* %s uzima gumicu i brise belesku.", GetName(playerid));
			ProxDetector(30.0, playerid, string, PURPLE1,PURPLE2,PURPLE3,PURPLE4,PURPLE5);
		}
		else
		{
	        SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Nemas belesku na slotu 5.");
		}
	}
	else return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Samo od 1 do 5.");
	return 1;
}
//----------------------------------------------------------------------------//
CMD:createnote(playerid, params[])
{
    //#pragma unused help
	if(LoggedOn[playerid] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Niste se prijavili!");
	new slot1 = PlayerInfo[playerid][pNote1s];
	new slot2 = PlayerInfo[playerid][pNote2s];
	new slot3 = PlayerInfo[playerid][pNote3s];
	new slot4 = PlayerInfo[playerid][pNote4s];
	new slot5 = PlayerInfo[playerid][pNote5s];
	if(slot1 == 1 && slot2 == 1 && slot3 == 1 && slot4 == 1 && slot5 == 1) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Tvoja knjiga beleski je puna!");
	new slot, text[256];
	if(sscanf(params, "is[100]",slot,text)) return SCM(playerid, -1, ""ZELENA"[HELP]:"BELA" /createnote [slot] [tekst]");
	if(slot < 1 || slot > 5) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Samo od 1 do 5!");
	if(slot == 1)
	{
	    if(PlayerInfo[playerid][pNote1s] == 0)
		{
		    strmid(PlayerInfo[playerid][pNote1], text, 0, strlen(text), 255);
		    PlayerInfo[playerid][pNote1s] = 1;
		    SCMF(playerid, -1, ""ZELENA"(DS):"BELA" Zapisao si u belesku na slotu 1:"ZELENA" %s", text);
		}
		else return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Vec imas belesku na slotu 1!");
	}
	else if(slot == 2)
	{
	    if(PlayerInfo[playerid][pNote2s] == 0)
		{
		    strmid(PlayerInfo[playerid][pNote2], text, 0, strlen(text), 255);
		    PlayerInfo[playerid][pNote2s] = 1;
		    SCMF(playerid, -1, ""ZELENA"(DS):"BELA" Zapisao si u belesku na slotu 2:"ZELENA" %s", text);
		}
		else return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Vec imas belesku na slotu 1!");
	}
	else if(slot == 3)
	{
	    if(PlayerInfo[playerid][pNote3s] == 0)
		{
		    strmid(PlayerInfo[playerid][pNote3], text, 0, strlen(text), 255);
		    PlayerInfo[playerid][pNote3s] = 1;
		    SCMF(playerid, -1, ""ZELENA"(DS):"BELA" Zapisao si u belesku na slotu 3:"ZELENA" %s", text);
		}
		else return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Vec imas belesku na slotu 1!");
	}
	else if(slot == 4)
	{
	    if(PlayerInfo[playerid][pNote4s] == 0)
		{
		    strmid(PlayerInfo[playerid][pNote4], text, 0, strlen(text), 255);
		    PlayerInfo[playerid][pNote4s] = 1;
		    SCMF(playerid, -1, ""ZELENA"(DS):"BELA" Zapisao si u belesku na slotu 4:"ZELENA" %s", text);
		}
		else return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Vec imas belesku na slotu 1!");
	}
	else if(slot == 5)
	{
	    if(PlayerInfo[playerid][pNote5s] == 0)
		{
		    strmid(PlayerInfo[playerid][pNote5], text, 0, strlen(text), 255);
		    PlayerInfo[playerid][pNote5s] = 1;
		    SCMF(playerid, -1, ""ZELENA"(DS):"BELA" Zapisao si u belesku na slotu 5:"ZELENA" %s", text);
		}
		else return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Vec imas belesku na slotu 1!");
	}
	return 1;
}
//----------------------------------------------------------------------------//
CMD:givenote(playerid, params[])
{
    //#pragma unused help
	if(LoggedOn[playerid] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Niste se prijavili!");
	new id, bid, string[256];
    if(sscanf(params, "ui", id, bid))
	{
		SCM(playerid, -1, ""ZELENA"[HELP]:"BELA" /givenote [id] [slot]");
		return 1;
	}
	if(!IsPlayerConnected(id)) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Pogresan ID!");
	if(id == playerid) return SCM(playerid, -1, ""ZLATNA"#QUICK TIP ~"SIVA" Ne mozes sebi davati svoje beleske, koristi /shownotes ako zelis da ih pregledas!");
    new Float:Poz[3]; GetPlayerPos(playerid, Poz[0], Poz[1], Poz[2]);
    if(!IsPlayerInRangeOfPoint(id, 5.0, Poz[0], Poz[1], Poz[2])) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Nisi u blizini tog igraca!");
	//~~~~~~~~~~~~~~~~~~~
	if(bid == 1)
    {
		if(PlayerInfo[playerid][pNote1s] == 1)
		{
			if(PlayerInfo[id][pNote1s] == 0)
			{
	            strmid(PlayerInfo[id][pNote1], PlayerInfo[playerid][pNote1], 0, strlen(PlayerInfo[playerid][pNote1]), 255);
	            PlayerInfo[id][pNote1s] = 1;
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dao si belesku sa slota 1 igracu %s.", GetName(id));
	     		SCM(playerid, -1, string);
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dobio si belesku od %s i stavio je na slot 1.", GetName(playerid));
	     		SCM(id, -1, string);
			}
			else if(PlayerInfo[id][pNote2s] == 0)
			{
	            strmid(PlayerInfo[id][pNote2], PlayerInfo[playerid][pNote1], 0, strlen(PlayerInfo[playerid][pNote1]), 255);
	            PlayerInfo[id][pNote2s] = 1;
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dao si belesku sa slota 1 igracu %s.", GetName(id));
	     		SCM(playerid, -1, string);
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dobio si belesku od %s i stavio je na slot 2.", GetName(playerid));
	     		SCM(id, -1, string);
			}
			else if(PlayerInfo[id][pNote3s] == 0)
			{
	            strmid(PlayerInfo[id][pNote3], PlayerInfo[playerid][pNote1], 0, strlen(PlayerInfo[playerid][pNote1]), 255);
	            PlayerInfo[id][pNote3s] = 1;
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dao si belesku sa slota 1 igracu %s.", GetName(id));
	     		SCM(playerid, -1, string);
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dobio si belesku od %s i stavio je na slot 3.", GetName(playerid));
	     		SCM(id, -1, string);
			}
			else if(PlayerInfo[id][pNote4s] == 0)
			{
	            strmid(PlayerInfo[id][pNote4], PlayerInfo[playerid][pNote1], 0, strlen(PlayerInfo[playerid][pNote1]), 255);
	            PlayerInfo[id][pNote4s] = 1;
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dao si belesku sa slota 1 igracu %s.", GetName(id));
	     		SCM(playerid, -1, string);
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dobio si belesku od %s i stavio je na slot 4.", GetName(playerid));
	     		SCM(id, -1, string);
			}
			else if(PlayerInfo[id][pNote5s] == 0)
			{
	            strmid(PlayerInfo[id][pNote5], PlayerInfo[playerid][pNote1], 0, strlen(PlayerInfo[playerid][pNote1]), 255);
	            PlayerInfo[id][pNote5s] = 1;
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dao si belesku sa slota 1 igracu %s.", GetName(id));
	     		SCM(playerid, -1, string);
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dobio si belesku od %s i stavio je na slot 5.", GetName(playerid));
	     		SCM(id, -1, string);
			}
			else
			{
				SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Igraceva knjiga beleski je puna!");
			}
		}
		else
		{
			SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Nemas belesku na slotu 1!");
		}
	}
	//~~~~~~~~
	if(bid == 2)
    {
		if(PlayerInfo[playerid][pNote2s] == 1)
		{
			if(PlayerInfo[id][pNote1s] == 0)
			{
	            strmid(PlayerInfo[id][pNote1], PlayerInfo[playerid][pNote2], 0, strlen(PlayerInfo[playerid][pNote2]), 255);
	            PlayerInfo[id][pNote1s] = 1;
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dao si belesku sa slota 2 igracu %s.", GetName(id));
	     		SCM(playerid, -1, string);
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dobio si belesku od %s i stavio je na slot 1.", GetName(playerid));
	     		SCM(id, -1, string);
			}
			else if(PlayerInfo[id][pNote2s] == 0)
			{
	            strmid(PlayerInfo[id][pNote2], PlayerInfo[playerid][pNote2], 0, strlen(PlayerInfo[playerid][pNote2]), 255);
	            PlayerInfo[id][pNote2s] = 1;
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dao si belesku sa slota 2 igracu %s.", GetName(id));
	     		SCM(playerid, -1, string);
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dobio si belesku od %s i stavio je na slot 2.", GetName(playerid));
	     		SCM(id, -1, string);
			}
			else if(PlayerInfo[id][pNote3s] == 0)
			{
	            strmid(PlayerInfo[id][pNote3], PlayerInfo[playerid][pNote2], 0, strlen(PlayerInfo[playerid][pNote2]), 255);
	            PlayerInfo[id][pNote3s] = 1;
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dao si belesku sa slota 2 igracu %s.", GetName(id));
	     		SCM(playerid, -1, string);
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dobio si belesku od %s i stavio je na slot 3.", GetName(playerid));
	     		SCM(id, -1, string);
			}
			else if(PlayerInfo[id][pNote4s] == 0)
			{
	            strmid(PlayerInfo[id][pNote4], PlayerInfo[playerid][pNote2], 0, strlen(PlayerInfo[playerid][pNote2]), 255);
	            PlayerInfo[id][pNote4s] = 1;
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dao si belesku sa slota 2 igracu %s.", GetName(id));
	     		SCM(playerid, -1, string);
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dobio si belesku od %s i stavio je na slot 4.", GetName(playerid));
	     		SCM(id, -1, string);
			}
			else if(PlayerInfo[id][pNote5s] == 0)
			{
	            strmid(PlayerInfo[id][pNote5], PlayerInfo[playerid][pNote2], 0, strlen(PlayerInfo[playerid][pNote2]), 255);
	            PlayerInfo[id][pNote5s] = 1;
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dao si belesku sa slota 2 igracu %s.", GetName(id));
	     		SCM(playerid, -1, string);
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dobio si belesku od %s i stavio je na slot 5.", GetName(playerid));
	     		SCM(id, -1, string);
			}
			else
			{
				SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Igraceva knjiga beleski je puna!");
			}
		}
		else
		{
			SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Nemas belesku na slotu 2!");
		}
	}
	//~~~~~~~~~~
	if(bid == 3)
    {
		if(PlayerInfo[playerid][pNote3s] == 1)
		{
			if(PlayerInfo[id][pNote1s] == 0)
			{
	            strmid(PlayerInfo[id][pNote1], PlayerInfo[playerid][pNote3], 0, strlen(PlayerInfo[playerid][pNote3]), 255);
	            PlayerInfo[id][pNote1s] = 1;
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dao si belesku sa slota 3 igracu %s.", GetName(id));
	     		SCM(playerid, -1, string);
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dobio si belesku od %s i stavio je na slot 1.", GetName(playerid));
	     		SCM(id, -1, string);
			}
			else if(PlayerInfo[id][pNote2s] == 0)
			{
	            strmid(PlayerInfo[id][pNote2], PlayerInfo[playerid][pNote3], 0, strlen(PlayerInfo[playerid][pNote3]), 255);
	            PlayerInfo[id][pNote2s] = 1;
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dao si belesku sa slota 3 igracu %s.", GetName(id));
	     		SCM(playerid, -1, string);
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dobio si belesku od %s i stavio je na slot 2.", GetName(playerid));
	     		SCM(id, -1, string);
			}
			else if(PlayerInfo[id][pNote3s] == 0)
			{
	            strmid(PlayerInfo[id][pNote3], PlayerInfo[playerid][pNote3], 0, strlen(PlayerInfo[playerid][pNote3]), 255);
	            PlayerInfo[id][pNote3s] = 1;
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dao si belesku sa slota 3 igracu %s.", GetName(id));
	     		SCM(playerid, -1, string);
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dobio si belesku od %s i stavio je na slot 3.", GetName(playerid));
	     		SCM(id, -1, string);
			}
			else if(PlayerInfo[id][pNote4s] == 0)
			{
	            strmid(PlayerInfo[id][pNote4], PlayerInfo[playerid][pNote3], 0, strlen(PlayerInfo[playerid][pNote3]), 255);
	            PlayerInfo[id][pNote4s] = 1;
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dao si belesku sa slota 3 igracu %s.", GetName(id));
	     		SCM(playerid, -1, string);
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dobio si belesku od %s i stavio je na slot 4.", GetName(playerid));
	     		SCM(id, -1, string);
			}
			else if(PlayerInfo[id][pNote5s] == 0)
			{
	            strmid(PlayerInfo[id][pNote5], PlayerInfo[playerid][pNote3], 0, strlen(PlayerInfo[playerid][pNote3]), 255);
	            PlayerInfo[id][pNote5s] = 1;
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dao si belesku sa slota 3 igracu %s.", GetName(id));
	     		SCM(playerid, -1, string);
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dobio si belesku od %s i stavio je na slot 5.", GetName(playerid));
	     		SCM(id, -1, string);
			}
			else
			{
				SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Igraceva knjiga beleski je puna!");
			}
		}
		else
		{
			SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Nemas belesku na slotu 3!");
		}
	}
	//~~~~~~~~~~~~~~~~~
	if(bid == 4)
    {
		if(PlayerInfo[playerid][pNote4s] == 1)
		{
			if(PlayerInfo[id][pNote1s] == 0)
			{
	            strmid(PlayerInfo[id][pNote1], PlayerInfo[playerid][pNote4], 0, strlen(PlayerInfo[playerid][pNote4]), 255);
	            PlayerInfo[id][pNote1s] = 1;
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dao si belesku sa slota 4 igracu %s.", GetName(id));
	     		SCM(playerid, -1, string);
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dobio si belesku od %s i stavio je na slot 1.", GetName(playerid));
	     		SCM(id, -1, string);
			}
			else if(PlayerInfo[id][pNote2s] == 0)
			{
	            strmid(PlayerInfo[id][pNote2], PlayerInfo[playerid][pNote4], 0, strlen(PlayerInfo[playerid][pNote4]), 255);
	            PlayerInfo[id][pNote2s] = 1;
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dao si belesku sa slota 4 igracu %s.", GetName(id));
	     		SCM(playerid, -1, string);
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dobio si belesku od %s i stavio je na slot 2.", GetName(playerid));
	     		SCM(id, -1, string);
			}
			else if(PlayerInfo[id][pNote3s] == 0)
			{
	            strmid(PlayerInfo[id][pNote3], PlayerInfo[playerid][pNote4], 0, strlen(PlayerInfo[playerid][pNote4]), 255);
	            PlayerInfo[id][pNote3s] = 1;
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dao si belesku sa slota 4 igracu %s.", GetName(id));
	     		SCM(playerid, -1, string);
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dobio si belesku od %s i stavio je na slot 3.", GetName(playerid));
	     		SCM(id, -1, string);
			}
			else if(PlayerInfo[id][pNote4s] == 0)
			{
	            strmid(PlayerInfo[id][pNote4], PlayerInfo[playerid][pNote4], 0, strlen(PlayerInfo[playerid][pNote4]), 255);
	            PlayerInfo[id][pNote4s] = 1;
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dao si belesku sa slota 4 igracu %s.", GetName(id));
	     		SCM(playerid, -1, string);
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dobio si belesku od %s i stavio je na slot 4.", GetName(playerid));
	     		SCM(id, -1, string);
			}
			else if(PlayerInfo[id][pNote5s] == 0)
			{
	            strmid(PlayerInfo[id][pNote5], PlayerInfo[playerid][pNote4], 0, strlen(PlayerInfo[playerid][pNote4]), 255);
	            PlayerInfo[id][pNote5s] = 1;
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dao si belesku sa slota 4 igracu %s.", GetName(id));
	     		SCM(playerid, -1, string);
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dobio si belesku od %s i stavio je na slot 5.", GetName(playerid));
	     		SCM(id, -1, string);
			}
			else
			{
				SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Igraceva knjiga beleski je puna!");
			}
		}
		else
		{
			SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Nemas belesku na slotu 4!");
		}
	}
	//~~~~~~~~~~~~~
	if(bid == 5)
    {
		if(PlayerInfo[playerid][pNote5s] == 1)
		{
			if(PlayerInfo[id][pNote1s] == 0)
			{
	            strmid(PlayerInfo[id][pNote1], PlayerInfo[playerid][pNote5], 0, strlen(PlayerInfo[playerid][pNote5]), 255);
	            PlayerInfo[id][pNote1s] = 1;
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dao si belesku sa slota 5 igracu %s.", GetName(id));
	     		SCM(playerid, -1, string);
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dobio si belesku od %s i stavio je na slot 1.", GetName(playerid));
	     		SCM(id, -1, string);
			}
			else if(PlayerInfo[id][pNote2s] == 0)
			{
	            strmid(PlayerInfo[id][pNote2], PlayerInfo[playerid][pNote5], 0, strlen(PlayerInfo[playerid][pNote5]), 255);
	            PlayerInfo[id][pNote2s] = 1;
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dao si belesku sa slota 5 igracu %s.", GetName(id));
	     		SCM(playerid, -1, string);
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dobio si belesku od %s i stavio je na slot 2.", GetName(playerid));
	     		SCM(id, -1, string);
			}
			else if(PlayerInfo[id][pNote3s] == 0)
			{
	            strmid(PlayerInfo[id][pNote3], PlayerInfo[playerid][pNote5], 0, strlen(PlayerInfo[playerid][pNote5]), 255);
	            PlayerInfo[id][pNote3s] = 1;
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dao si belesku sa slota 5 igracu %s.", GetName(id));
	     		SCM(playerid, -1, string);
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dobio si belesku od %s i stavio je na slot 3.", GetName(playerid));
	     		SCM(id, -1, string);
			}
			else if(PlayerInfo[id][pNote4s] == 0)
			{
	            strmid(PlayerInfo[id][pNote4], PlayerInfo[playerid][pNote5], 0, strlen(PlayerInfo[playerid][pNote5]), 255);
	            PlayerInfo[id][pNote4s] = 1;
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dao si belesku sa slota 5 igracu %s.", GetName(id));
	     		SCM(playerid, -1, string);
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dobio si belesku od %s i stavio je na slot 4.", GetName(playerid));
	     		SCM(id, -1, string);
			}
			else if(PlayerInfo[id][pNote5s] == 0)
			{
	            strmid(PlayerInfo[id][pNote5], PlayerInfo[playerid][pNote5], 0, strlen(PlayerInfo[playerid][pNote5]), 255);
	            PlayerInfo[id][pNote5s] = 1;
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dao si belesku sa slota 5 igracu %s.", GetName(id));
	     		SCM(playerid, -1, string);
	     		format(string, sizeof(string), ""ZELENA"(DS):"BELA" Dobio si belesku od %s i stavio je na slot 5.", GetName(playerid));
	     		SCM(id, -1, string);
			}
			else
			{
				SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Igraceva knjiga beleski je puna!");
			}
		}
		else
		{
			SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Nemas belesku na slotu 5!");
		}
	}
	else return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Mozete samo od 1 do 5!");
	return 1;
}
//----------------------------------------------------------------------------//
CMD:ooc(playerid, params[])
{
    //#pragma unused help
	if(LoggedOn[playerid] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Niste se prijavili!");
	new text[100], string[145];
    if(sscanf(params, "s[100]", text)) return SCM(playerid, -1, ""ZELENA"[HELP]:"BELA" /g(lobal)c(hat) [text]");
    if(strlen(text) > 100) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Ne vise od 100 slova!");
    format(string, sizeof(string), ""SIVA"[OOC]: %s (%d): %s", GetName(playerid), playerid, text);
    SendClientMessageToAll(-1, string);
    return 1;
}
//----------------------------------------------------------------------------//
CMD:inv(playerid, params[])
{
    //#pragma unused help
	return cmd_inventory(playerid);
}
CMD:inventory(playerid)
{
    if(LoggedOn[playerid] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Niste se prijavili!");
	new string[256], holder[4], voda[8];
    if(PlayerInfo[playerid][pRStap] == 1) holder = "Da";
    else holder = "Ne";
    if(PlayerInfo[playerid][pFlasaPuna] == 1) voda = "Puna";
    else voda = "Prazna";
    SCM(playerid, -1, ""ZELENA"____________________Inventar____________________");
    format(string, sizeof(string), "Ribe:[%d] | Jestive Ribe:[%d] | Voce:[%d]", PlayerInfo[playerid][pRibe], PlayerInfo[playerid][pJRibe], PlayerInfo[playerid][pVoce]);
    SCM(playerid, -1, string);
    format(string, sizeof(string), "Flasa:[%d(%s)] | Ribarski Stap:[%s] | Daske:[%d]", PlayerInfo[playerid][pFlasaVode], voda, holder, PlayerInfo[playerid][pDrvo]);
    SCM(playerid, -1, string);
    format(string, sizeof(string), "Povez: [%d] | Sibice: [%d] | Kamenje: [%d]", PlayerInfo[playerid][pPovez], PlayerInfo[playerid][pSibice], PlayerInfo[playerid][pKamen]);
    SCM(playerid, -1, ""ZELENA"____________________Kraj Inventara______________________________");
    return 1;
}
//----------------------------------------------------------------------------//
CMD:cmds(playerid, params[])
{
    //#pragma unused help
	return cmd_help(playerid);
}
CMD:help(playerid)
{
    if(LoggedOn[playerid] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Niste se prijavili!");
	SCM(playerid, -1, ""ZELENA"Komande:");
    SCM(playerid, -1, ""ZELENA"[INFO]:"SIVA" /inv, /ooc");
    SCM(playerid, -1, ""ZELENA"[HRANA]:"SIVA" /ribari, /prekiniribarenje /napravi, /ispeci, /jediribu");
    SCM(playerid, -1, ""ZELENA"[VATRA]:"SIVA" /zapalivatru, /ugasivatru");
    SCM(playerid, -1, ""ZELENA"[DRVO]:"SIVA" /rezidrvo (ili Y)");
    if(PlayerInfo[playerid][pAdmin] > 1)
    {
        SCM(playerid, -1, ""CRVENA"[ADMIN]:"SIVA" /napravidrvo, /gotodrvo, /izbrisidrvo");
    }
    return 1;
}
//----------------------------------------------------------------------------//
CMD:jediribu(playerid, params[])
{
    //#pragma unused help
	if(LoggedOn[playerid] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Niste se prijavili!");
	new Float: health;
    GetPlayerHealth(playerid, health);
    if(PlayerInfo[playerid][pJRibe] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Nemas ni jednu jestivu ribu!");
    if(PlayerInfo[playerid][pGlad] > 80) return SCM(playerid, -1, ""ZELENA"*"SIVA" Nisi gladan!");
    PlayerInfo[playerid][pJRibe] -= 1;
    PlayerInfo[playerid][pGlad] += 10;
    if(PlayerInfo[playerid][pGlad] > 100) { PlayerInfo[playerid][pGlad] = 100; }
    SCM(playerid, -1, ""ZELENA"*"BELA" Stanje ti se poboljsalo, sada si manje gladan!");
    if(health < 50)
    {
        health += 10.0;
        SetPlayerHealth(playerid, health);
    }
    return 1;
}
//----------------------------------------------------------------------------//
CMD:napravi(playerid, params[])
{
    //#pragma unused help
	if(LoggedOn[playerid] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Niste se prijavili!");
	SCM(playerid, -1, ""ZELENA"[LEGEND]:"BELA" D = Drvo | K = Kamen");
	SPD(playerid, DIALOG_CRAFT, DSL, ""ZELENA"Izrada", "Ribarski Stap (5 D)\nSator (50 D, 10 K)", "Odaberi", "Izlaz");
    return 1;
}
//----------------------------------------------------------------------------//
CMD:ribari(playerid, params[])
{
    //#pragma unused help
	if(LoggedOn[playerid] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Niste se prijavili!");
    if(PlayerInfo[playerid][pRStap] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Moras imati ribarski stap da bi mogao pecati!");
	if(pFishing[playerid] == 1) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Vec ribaris!");
	if(IsPlayerInWater(playerid))
    {
        pFishing[playerid] = 1;
		FishingBar[playerid] = CreatePlayerProgressBar(playerid, 220.0, 350.0, 90.0, 6.0, 0x00FF00FF, 100.0);
    	SetPlayerProgressBarMaxValue(playerid, FishingBar[playerid], 100);
    	ShowPlayerProgressBar(playerid, FishingBar[playerid]);
	    FishingUpdate[playerid] = SetTimerEx("EndOfFishing", 1, 1, "i", playerid);
    	SCM(playerid, -1, ""ZELENA"*"BELA" Poceo si da ribaris, drzi LMB.");
    	SCM(playerid, -1, ""CRVENA"*"SIVA" Ako vam se prvi put ne pokaze linija kucajte /prekiniribarenje i ponovite!");
		TogglePlayerControllable(playerid, 0);
	}
	else
	{
        SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Moras biti kod vode da pecas ribe!");
	}
	return 1;
}
//----------------------------------------------------------------------------//
CMD:prekiniribarenje(playerid, params[])
{
    if(LoggedOn[playerid] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Niste se prijavili!");
    if(pFishing[playerid] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Ne ribaris!");
	pFishing[playerid] = 0;
	FishingProgress[playerid] = 0;
	HidePlayerProgressBar(playerid, FishingBar[playerid]);
	TogglePlayerControllable(playerid, 1);
	return 1;
}
//----------------------------------------------------------------------------//
CMD:ispeci(playerid, params[])
{
    //#pragma unused help
	if(LoggedOn[playerid] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Niste se prijavili!");
    for(new i; i < MAX_CAMPFIRES; i ++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, cfInfo[i][xPos], cfInfo[i][yPos], cfInfo[i][zPos]) || IsPlayerInRangeOfPoint(playerid, 3.0, 1241.9054,-3640.5500,3.0278))
        {
			SPD(playerid, DIALOG_COOK, DSL, ""ZELENA"Ispeci", "Riba", "Odaberi", "Izlaz");
		}
	}
	return 1;
}
//----------------------------------------------------------------------------//
CMD:zapalivatru(playerid, params[])
{
    //#pragma unused help
	if(LoggedOn[playerid] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Niste se prijavili!");
	new Float: X, Float: Y, Float: Z;
    GetPlayerPos(playerid, X, Y, Z);
    new message = random(2);
    if(PlayerInfo[playerid][pDrvo] < 3) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Moras imati bar 3 daske da napravis vatru!");
	if(PlayerInfo[playerid][pSibice] < 1) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Nemas sibice!");
    if(message == 0)
	{
		PlayerInfo[playerid][pDrvo] -= 3;
		PlayerInfo[playerid][pSibice] -= 1;
        SCM(playerid, -1, ""CRVENA"*"SIVA" Nisi uspio da zapalis vatru!");
		new prox[256];
		format(prox, sizeof(prox), "%s uzima drva,stavlja ih na pod, pokusava zapaliti vatru i ne uspijeva.", GetName(playerid));
		ProxDetector(30.0, playerid, prox, PURPLE1,PURPLE2,PURPLE3,PURPLE4,PURPLE5);
	}
	else if(message == 1)
	{
		cfInfo[cfCount][xPos] = X;
	    cfInfo[cfCount][yPos] = Y;
	    cfInfo[cfCount][zPos] = Z;
	    cfInfo[cfCount][LogObj] = CreateDynamicObject(18688, X, Y, Z - 1, 0.0, 0.0, 0.0);
	    cfInfo[cfCount][FireObj] = CreateDynamicObject(18692, X, Y, Z - 2.5, 0.0, 0.0, 0.0);
        PlayerInfo[playerid][pDrvo] -= 3;
		PlayerInfo[playerid][pSibice] -= 1;
		SCM(playerid, -1, ""ZELENA"*"BELA" Napravio si logorsku vatru, trajace 10 minuta.");
	    SetTimerEx("ExtFire", 600000, 0, "i", cfCount);
	    cfCount ++;
	    new prox[256];
		format(prox, sizeof(prox), "%s uzima drva,stavlja ih na pod, pokusava zapaliti vatru i uspijeva.", GetName(playerid));
		ProxDetector(30.0, playerid, prox, PURPLE1,PURPLE2,PURPLE3,PURPLE4,PURPLE5);
    }
    return 1;
}
//----------------------------------------------------------------------------//
CMD:ugasivatru(playerid, params[])
{
    //#pragma unused help
	if(LoggedOn[playerid] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Niste se prijavili!");
	new string[256];
	format(string, sizeof(string), ""CRVENA"[ERROR]:"BELA" Nisi u blizini logorske vatre!");
	for(new i; i < MAX_CAMPFIRES; i ++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 2.0, cfInfo[i][xPos], cfInfo[i][yPos], cfInfo[i][zPos]))
	    {
  			ApplyAnimation(playerid, "PED", "FightA_G", 4.1, 0, 1, 1, 0, 0, 1);
			format(string, sizeof(string), ""CRVENA"*"SIVA" Ugasio si logorsku vatru.", i);
			SetTimerEx("ExtFire", 800, 0, "i", i);
			break;
	    }
	}
	SCM(playerid, -1, string);
	return 1;
}
//----------------------------------------------------------------------------//
CMD:napravidrvo(playerid, params[])
{
    //#pragma unused help
	if(LoggedOn[playerid] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Niste se prijavili!");
	new type, health, randobj, Float: X, Float: Y, Float: Z;
	GetPlayerPos(playerid, X, Y, Z);
	if(PlayerInfo[playerid][pAdmin] < 5) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Nisi Administrator!");
	if(sscanf(params, "ii", type, health)) return SCM(playerid, -1, ""ZELENA"[HELP]:"BELA" /napravidrvo [tip] [health]");
	if(type < 0 || type > 1) { SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Ne mozes manje od 0 ili vise od 1!"); }
	if(type == 0)
	{
		switch(random(5))
		{
		    case 0: randobj = 661;
		    case 1: randobj = 657;
		    case 2: randobj = 654;
		    case 3: randobj = 655;
	    	case 4: randobj = 656;
		}
	}
	else if(type == 1)
	{
		switch(random(5))
		{
		    case 0: randobj = 615;
		    case 1: randobj = 616;
		    case 2: randobj = 617;
		    case 3: randobj = 618;
	    	case 4: randobj = 700;
		}
	}
	tInfo[tCount][Obj] = CreateDynamicObject(randobj, X +1, Y +1, Z -1, 0.0, 0.0, 0.0);
	EditObject(playerid, tInfo[tCount][Obj]);
	new INI:File = INI_Open(TreePath(tCount));
   	INI_SetTag(File, "Tree Data");
    INI_WriteInt(File, "Model", randobj);
	tInfo[tCount][Model] = randobj;
 	INI_WriteInt(File, "Type", type);
	tInfo[tCount][Type] = type;
 	INI_WriteFloat(File, "Health", health);
	tInfo[tCount][Health] = health;
 	INI_WriteFloat(File, "xPos", X);
	tInfo[tCount][xPos] = X;
 	INI_WriteFloat(File, "yPos", Y);
	tInfo[tCount][yPos] = Y;
	INI_WriteFloat(File, "zPos", Z);
	tInfo[tCount][zPos] = Z;
	INI_WriteFloat(File, "rxPos", 0.0);
	INI_WriteFloat(File, "ryPos", 0.0);
	INI_WriteFloat(File, "rzPos", 0.0);
	INI_Close(File);
	tCount ++;
	SCM(playerid, -1, ""ZELENA"*"BELA" Napravio si drvo!");
	return 1;
}
//----------------------------------------------------------------------------//
CMD:izbrisidrvo(playerid, params[])
{
    //#pragma unused help
	if(LoggedOn[playerid] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Niste se prijavili!");
	new tid, string[256];
	if(PlayerInfo[playerid][pAdmin] < 1) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Samo Admini!") ;
	if(sscanf(params, "i", tid)) return SCM(playerid, -1, ""ZELENA"[HELP]:"BELA" /izbrisidrvo [id]");
	format(string, sizeof(string), "Trees/%d.ini", tid);
	if(!fexist(string)) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Drvo sa tim IDem ne postoji!");
	else if(fexist(string))
	{
		DestroyDynamicObject(tInfo[tid][Obj]);
		tCount --;
		fremove(string);
	}
	format(string, sizeof(string), ""ZELENA"*"SIVA" Obrisao si drvo. (ID:%d)", tid);
	SCM(playerid, -1, string);
	return 1;
}
//----------------------------------------------------------------------------//
CMD:gotodrvo(playerid, params[])
{
    //#pragma unused help
	if(LoggedOn[playerid] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Niste se prijavili!");
	new treeid, string[256];
	if(PlayerInfo[playerid][pAdmin] < 1) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Ti nisi administrator!");
	if(sscanf(params, "i", treeid)) return SCM(playerid, -1, ""ZELENA"[HELP]:"BELA" /gotodrvo [id]");
	if(!IsValidDynamicObject(treeid)) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Drvo sa tim ID-em ne postoji!");
	format(string, sizeof(string), ""ZELENA"*"SIVA" Teleportovao si se do drveta - ID %d.", treeid);
	SCM(playerid, -1, string);
	SetPlayerPos(playerid, tInfo[treeid][xPos] +1, tInfo[treeid][yPos] +1, tInfo[treeid][zPos]);
	return 1;
}
//----------------------------------------------------------------------------//
CMD:rezidrvo(playerid)
{
    //#pragma unused help
	if(LoggedOn[playerid] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Niste se prijavili!");
	new string[256];
	format(string, sizeof(string), ""CRVENA"[ERROR]:"BELA" Nisi blizu drveta!");
	for(new i; i < MAX_TREES; i ++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3.0, tInfo[i][xPos], tInfo[i][yPos], tInfo[i][zPos]))
     	{
			if(tInfo[i][Health] <= 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Ovo drvo je vec neko odrezao!");
			pChoppingTree[playerid] = i;
			ChoppingBar[playerid] = CreatePlayerProgressBar(playerid, 220.0, 350.0, 90.0, 6.0, 0x783800FF, 100.0);
		    ShowPlayerProgressBar(playerid, ChoppingBar[playerid]);
		    SetPlayerProgressBarMaxValue(playerid, ChoppingBar[playerid], 100);
		    TreeHealthUpdater[playerid] = SetTimerEx("TreeCutDownBar", 1, 1, "i", playerid);
	       	format(string, sizeof(string), ""ZELENA"*"BELA" Poceo si da rezes drvo pritisci LMB. Pritisni ~k~~CONVERSATION_NO~ da zaustavis!", i);
			TogglePlayerControllable(playerid, 0);
			break;
	    }
	}
	SCM(playerid, -1, string);
	return 1;
}
//----------------------------------------------------------------------------//
CMD:spawnthefuckingisland(playerid,params[])
{
    //#pragma unused help
	if(LoggedOn[playerid] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Niste se prijavili!");
	IslandSpawn();
	return 1;
}
//----------------------------------------------------------------------------//
CMD:esator(playerid, params[])
{
    if(LoggedOn[playerid] == 0) return SCM(playerid, -1, ""CRVENA"[ERROR]:"BELA" Niste se prijavili!");
	if(PlayerInfo[playerid][pAdmin] < 6) return SCM(playerid,-1,""CRVENA"[ERROR]:"BELA" Niste Admin.");
	new sfajl[80], satorid;
	if(sscanf(params, "i",satorid)) return SCM(playerid,-1,""ZELENA"[INFO]:"BELA" /esator [ID]");
	format(sfajl, sizeof(sfajl), SATOR_FILE, satorid);
	if(!fexist(sfajl)) return SCM(playerid,-1, ""CRVENA"[ERROR]:"BELA" Pogresan ID!");
	if(!IsPlayerInRangeOfPoint(playerid, 10.0, SatorInfo[satorid][sPozX], SatorInfo[satorid][sPozY], SatorInfo[satorid][sPozZ])) return SCM(playerid,-1,""CRVENA"[ERROR]:"BELA" Niste u blizini tog satora!");
	DestroyDynamic3DTextLabel(SatorInfo[satorid][SatorLabel]); esData[playerid] = satorid; EditDynamicObject(playerid,SatorInfo[satorid][sObjekat]);
    IgracEdituje[playerid] = 1;
	return 1;
}
//----------------------------------------------------------------------------//
stock ResetTree(treeid)
{
	DestroyDynamicObject(tInfo[treeid][Obj]);
    tInfo[treeid][Obj] = CreateDynamicObject(832, tInfo[treeid][xPos], tInfo[treeid][yPos], tInfo[treeid][zPos], tInfo[treeid][rxPos], tInfo[treeid][ryPos], tInfo[treeid][rzPos]);
	SetTimerEx("RegrowDeadTrees", 1200000, 0, "i", treeid);
	printf("Drvo %d je zamijenjeno sa panj-em.", treeid);
	return 1;
}
//----------------------------------------------------------------------------//
forward RegrowDeadTrees(treeid);
public RegrowDeadTrees(treeid)
{
	if(tInfo[treeid][Health] == 0)
	{
		DestroyDynamicObject(tInfo[treeid][Obj]);
    	tInfo[treeid][Obj] = CreateDynamicObject(tInfo[treeid][Model], tInfo[treeid][xPos], tInfo[treeid][yPos], tInfo[treeid][zPos], tInfo[treeid][rxPos], tInfo[treeid][ryPos], tInfo[treeid][rzPos]);
		printf("Drvo %d je ponovo izraslo i sad ima 100.0 healta.", treeid);
		tInfo[treeid][Health] = 100;
	}
	return 1;
}
//----------------------------------------------------------------------------//
forward TreeCutDownBar(playerid);
public TreeCutDownBar(playerid)
{
    if(GetPlayerProgressBarValue(playerid, ChoppingBar[playerid]) == 100)
    {
        ChoppingProgress[playerid] = 0;
        SetPlayerProgressBarValue(playerid, ChoppingBar[playerid], ChoppingProgress[playerid]);
		tInfo[pChoppingTree[playerid]][Health] = 0;
        HidePlayerProgressBar(playerid, ChoppingBar[playerid]);
		TogglePlayerControllable(playerid, 1);
        KillTimer(TreeHealthUpdater[playerid]);
		ResetTree(pChoppingTree[playerid]);
		RandomTreeLoot(playerid);
		pChoppingTree[playerid] = -1;
        return 1; // close loop
    }
    return 1;
}
//----------------------------------------------------------------------------//
stock TreePath(treeid)
{
	new tree[64];
	format(tree, 30, "Trees/%d.ini", treeid);
	tInfo[treeid][ID] ++; // multiplying
	return tree;
}
//----------------------------------------------------------------------------//
forward LoadTreeData(i, name[], value[]);
public LoadTreeData(i, name[], value[])
{
	INI_Int("Type", tInfo[i][Type]);
	INI_Int("Model", tInfo[i][Model]);
	INI_Float("Health", tInfo[i][Health]);
	INI_Float("xPos", tInfo[i][xPos]);
	INI_Float("yPos", tInfo[i][yPos]);
	INI_Float("zPos", tInfo[i][zPos]);
	INI_Float("rxPos", tInfo[i][rxPos]);
	INI_Float("ryPos", tInfo[i][ryPos]);
	INI_Float("rzPos", tInfo[i][rzPos]);
	return 1;
}
//----------------------------------------------------------------------------//
stock SaveTrees()
{
	new file[64];
	for(new i; i < MAX_TREES; i ++)
	{
		format(file, sizeof(file), "Trees/%d.ini", i);
	    if(fexist(file))
	    {
	  		new INI:File = INI_Open(file);
		    INI_SetTag(File, "Tree Data");
        	INI_WriteInt(File, "Type", tInfo[i][Type]);
			INI_WriteInt(File, "Model", tInfo[i][Model]);
			INI_WriteFloat(File, "Health", tInfo[i][Health]);
			INI_WriteFloat(File, "xPos", tInfo[i][xPos]);
			INI_WriteFloat(File, "yPos", tInfo[i][yPos]);
			INI_WriteFloat(File, "zPos", tInfo[i][zPos]);
			INI_WriteFloat(File, "rxPos", tInfo[i][rxPos]);
			INI_WriteFloat(File, "ryPos", tInfo[i][ryPos]);
			INI_WriteFloat(File, "rzPos", tInfo[i][rzPos]);
		    INI_Close(File);
		}
	}
	return 1;
}
//----------------------------------------------------------------------------//
stock LoadTrees()
{
	new string[256], file[64];
	print("\n  Loading Trees: \n");
	for(new i; i < MAX_TREES; i ++)
	{
		format(file, sizeof(file), "Trees/%d.ini", i);
	    if(fexist(file))
	    {
	        INI_ParseFile(TreePath(i), "LoadTreeData", false, true, i, true, false);
			tInfo[i][Obj] = CreateDynamicObject(tInfo[i][Model], tInfo[i][xPos], tInfo[i][yPos], tInfo[i][zPos] -1, tInfo[i][rxPos], tInfo[i][ryPos], tInfo[i][rzPos]);
            format(string, sizeof(string), "  Ucitano drvo ID: %d kod %f %f %f sa rotacijom: %f %f %f", i, tInfo[i][xPos], tInfo[i][yPos], tInfo[i][zPos], tInfo[i][rxPos], tInfo[i][ryPos], tInfo[i][rzPos]);
			if(tInfo[i][Health] == 0)
			{
			    ResetTree(i);
			    printf("Drvo ID %d je ucitan sa %f healta, Resetovano!\n", i, tInfo[i][Health]);
			}
			print(string);
			tCount ++;
		}
	}
	printf("\n  %d drva ucitano!", tCount);
	return 1;
}
//----------------------------------------------------------------------------//
public OnPlayerEditObject(playerid, playerobject, objectid, response, Float: fX, Float: fY, Float: fZ, Float: fRotX, Float: fRotY, Float: fRotZ)
{
	if(response == EDIT_RESPONSE_FINAL)
	{
    	SetObjectPos(objectid, fX, fY, fZ);
    	SetObjectRot(objectid, fRotX, fRotY, fRotZ);
		tInfo[objectid][xPos] = fX;
		tInfo[objectid][yPos] = fY;
		tInfo[objectid][zPos] = fZ;
		tInfo[objectid][rxPos] = fRotX;
		tInfo[objectid][ryPos] = fRotY;
		tInfo[objectid][rzPos] = fRotZ;
	}
	return 1;
}
//----------------------------------------------------------------------------//
public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(response == EDIT_RESPONSE_FINAL)
	{
	    new Float:angle, string[100];
		new ida = esData[playerid];
		GetPlayerFacingAngle(playerid, angle);
	 	if(IgracEdituje[playerid] == 1)
		{
		    if(ida != -1)
			{
				SatorInfo[ida][sPozX] = x; SatorInfo[ida][sPozY] = y; SatorInfo[ida][sPozZ] = z;
				SatorInfo[ida][sAngle] = rz; DestroyDynamicObject(SatorInfo[ida][sObjekat]);
				KreirajSator(ida); SacuvajSator(ida);
				format(string,sizeof(string),""ZELENA"*"BELA" Sator (%d) je uspesno editovan!",ida);
				SCM(playerid,-1,string);
				ida = -1;
				IgracEdituje[playerid] = 0;
				return 1;
			}
		}
	}
	return 1;
}
//----------------------------------------------------------------------------//
public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid)
{
	PlayerPlaySound(playerid, 5201, 0, 0, 0);
	return 1;
}
//----------------------------------------------------------------------------//
public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid)
{
	if(amount > 10.0)
	{
		Bleeding[playerid] = 1;
        BleedingTimer[playerid] = SetTimerEx("BleedTimer", 5000, true, "i", playerid);
	}
	if(pFishing[playerid] == 1 || pChoppingTree[playerid] == 1)
	{
		SCM(issuerid, -1, ""CRVENA"[!]"SIVA" Svaka sila akcije ima svoju silu reakcije!");
		SCM(issuerid, -1, ""CRVENA"[!]"SIVA" Poceo si da krvaris!");
		Bleeding[issuerid] = 1;
	}
	return 1;
}
//----------------------------------------------------------------------------//
public OnPlayerEnterCheckpoint(playerid)
{
	DisablePlayerCheckpoint(playerid);
	return 1;
}
//----------------------------------------------------------------------------//
forward WeatherHandler();
public WeatherHandler()
{
	switch(random(6))
	{
	    case 0: SetWeather(0);
		case 1: SetWeather(1);
		case 2: SetWeather(2);
		case 3: SetWeather(3);
		case 4: SetWeather(4); 
		case 5: SetWeather(17);
	}
	return 1;
}
//----------------------------------------------------------------------------//
stock RandomTreeLoot(playerid)
{
	new loot, string[256];
	switch(random(5))
	{
		case 0: loot = 3;
		case 1: loot = 5;
		case 2: loot = 7;
		case 3: loot = 9;
		case 4: loot = 0;
	}
	PlayerInfo[playerid][pDrvo] += loot;
	format(string, sizeof(string), ""ZELENA"*"SIVA" Dobio si %d korisnih daski od drveta. Sada imas ukupno %d daski.", loot, PlayerInfo[playerid][pDrvo]);
	SCM(playerid, -1, string);
	return 1;
}
//----------------------------------------------------------------------------//
stock GetPlayerFirstName(playerid)
{
    new szName[MAX_PLAYER_NAME], iPos;
    GetPlayerName(playerid, szName, sizeof(szName));
    iPos = strfind(szName, "_");
    if(iPos != -1) szName[iPos] = EOS;
    return szName;
}
//----------------------------------------------------------------------------//
stock GetPlayerNameEx(playerid)
{
    new szName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, szName, sizeof(szName));
    return szName;
}
//----------------------------------------------------------------------------//
forward ExtFire(fireid);
public ExtFire(fireid)
{
	printf("Kamp vatra ID %d je ugasena.");
	DestroyDynamicObject(cfInfo[fireid][LogObj]);
	DestroyDynamicObject(cfInfo[fireid][FireObj]);
	cfCount --;
	return 1;
}
//----------------------------------------------------------------------------//
forward IslandSpawn();
public IslandSpawn()
{
	island1 = CreateDynamicObject(18227,1607.0000000,-3610.1001000,58.3000000,17.1880000,3.4330000,68.2800000); //object(cunt_rockgp2_20) (1)
	island2 = CreateDynamicObject(17026,1693.5999800,-3575.1999500,57.6000000,0.0000000,0.0000000,340.0000000); //object(cunt_rockgp2_) (1)
	island3 = CreateDynamicObject(18359,1006.7999900,-3467.0000000,-26.2000000,6.0000000,0.0000000,40.0000000); //object(cs_landbit_74) (1)
	island4 = CreateDynamicObject(18227,888.9000200,-3515.1001000,6.0000000,0.0000000,0.0000000,0.0000000); //object(cunt_rockgp2_20) (2)
	island5 = CreateDynamicObject(18227,856.2999900,-3433.1001000,7.2000000,0.0000000,0.0000000,130.0000000); //object(cunt_rockgp2_20) (3)
	island6 = CreateDynamicObject(18227,847.0000000,-3437.3999000,-8.2000000,0.0000000,0.0000000,260.0000000); //object(cunt_rockgp2_20) (6)
	island7 = CreateDynamicObject(18227,908.2999900,-3386.5000000,8.5000000,0.0000000,0.0000000,90.0000000); //object(cunt_rockgp2_20) (7)
	island8 = CreateDynamicObject(18227,950.9000200,-3344.6999500,9.0000000,0.0000000,0.0000000,80.0000000); //object(cunt_rockgp2_20) (8)
	island9 = CreateDynamicObject(18227,995.9000200,-3324.0000000,12.3000000,0.0000000,0.0000000,50.0000000); //object(cunt_rockgp2_20) (9)
	island10 = CreateDynamicObject(18227,1059.0000000,-3348.6999500,14.5000000,356.0000000,0.0000000,0.0000000); //object(cunt_rockgp2_20) (11)
	island11 = CreateDynamicObject(13120,955.0999800,-3352.3000500,-24.4000000,0.0000000,0.0000000,280.0000000); //object(ce_grndpalcst03) (1)
	island12 = CreateDynamicObject(13120,1104.0999800,-3300.0000000,-19.3000000,0.0000000,0.0000000,10.0000000); //object(ce_grndpalcst03) (3)
	island13 = CreateDynamicObject(13120,1119.1999500,-3337.5000000,-21.4000000,0.0000000,0.0000000,0.0000000); //object(ce_grndpalcst03) (4)
	island14 = CreateDynamicObject(13120,901.0999800,-3263.1001000,-15.1000000,0.0000000,0.0000000,120.0000000); //object(ce_grndpalcst03) (5)
	island15 = CreateDynamicObject(13120,818.5999800,-3386.6001000,-21.0000000,0.0000000,0.0000000,120.0000000); //object(ce_grndpalcst03) (6)
	island16 = CreateDynamicObject(13120,868.5999800,-3530.8000500,-13.8000000,0.0000000,0.0000000,10.0000000); //object(ce_grndpalcst03) (7)
	island17 = CreateDynamicObject(17027,866.2000100,-3456.6999500,19.0000000,0.0000000,0.0000000,60.0000000); //object(cunt_rockgp1_03) (1)
	island18 = CreateDynamicObject(17029,1038.4000200,-3345.1999500,10.2000000,0.0000000,0.0000000,150.0000000); //object(cunt_rockgp2_09) (1)
	island19 = CreateDynamicObject(17029,982.0999800,-3331.6001000,9.0000000,0.0000000,0.0000000,34.0000000); //object(cunt_rockgp2_09) (2)
	island20 = CreateDynamicObject(683,954.5000000,-3374.1001000,6.7000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group) (1)
	island21 = CreateDynamicObject(685,948.2000100,-3385.8000500,4.8000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_scabby) (1)
	island22 = CreateDynamicObject(688,966.4000200,-3373.3000500,8.0000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_scabg) (1)
	island23 = CreateDynamicObject(791,907.7999900,-3465.3000500,0.7000000,0.0000000,0.0000000,0.0000000); //object(vbg_fir_copse) (1)
	island24 = CreateDynamicObject(791,932.5999800,-3434.0000000,0.5000000,0.0000000,0.0000000,0.0000000); //object(vbg_fir_copse) (2)
	island25 = CreateDynamicObject(791,952.7000100,-3402.8999000,-0.9000000,0.0000000,0.0000000,0.0000000); //object(vbg_fir_copse) (3)
	island26 = CreateDynamicObject(791,997.7000100,-3405.5000000,-1.2000000,0.0000000,0.0000000,0.0000000); //object(vbg_fir_copse) (4)
	island27 = CreateDynamicObject(791,964.9000200,-3431.1001000,-3.3000000,0.0000000,0.0000000,0.0000000); //object(vbg_fir_copse) (5)
	island28 = CreateDynamicObject(789,925.2999900,-3462.0000000,6.1000000,0.0000000,0.0000000,0.0000000); //object(hashburytree4sfs) (1)
	island29 = CreateDynamicObject(789,951.0999800,-3447.0000000,6.3000000,0.0000000,0.0000000,0.0000000); //object(hashburytree4sfs) (2)
	island30 = CreateDynamicObject(789,972.0999800,-3432.3000500,7.8000000,0.0000000,0.0000000,0.0000000); //object(hashburytree4sfs) (3)
	island31 = CreateDynamicObject(789,992.5999800,-3413.0000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(hashburytree4sfs) (4)
	island32 = CreateDynamicObject(789,1021.2999900,-3401.8000500,7.1000000,0.0000000,0.0000000,30.0000000); //object(hashburytree4sfs) (5)
	island33 = CreateDynamicObject(789,1047.5000000,-3384.3999000,9.1000000,0.0000000,0.0000000,40.0000000); //object(hashburytree4sfs) (6)
	island34 = CreateDynamicObject(789,920.2999900,-3493.5000000,8.3000000,0.0000000,0.0000000,280.0000000); //object(hashburytree4sfs) (7)
	island35 = CreateDynamicObject(789,888.2000100,-3461.8999000,16.5000000,0.0000000,0.0000000,0.0000000); //object(hashburytree4sfs) (8)
	island36 = CreateDynamicObject(789,904.9000200,-3500.0000000,14.6000000,0.0000000,0.0000000,0.0000000); //object(hashburytree4sfs) (9)
	island37 = CreateDynamicObject(789,897.7999900,-3475.1001000,14.6000000,0.0000000,0.0000000,0.0000000); //object(hashburytree4sfs) (10)
	island38 = CreateDynamicObject(789,1017.4000200,-3375.8000500,17.5000000,0.0000000,0.0000000,0.0000000); //object(hashburytree4sfs) (11)
	island39 = CreateDynamicObject(789,993.9000200,-3386.8000500,11.7000000,0.0000000,0.0000000,0.0000000); //object(hashburytree4sfs) (12)
	island40 = CreateDynamicObject(789,970.4000200,-3395.6001000,10.3000000,0.0000000,0.0000000,0.0000000); //object(hashburytree4sfs) (13)
	island41 = CreateDynamicObject(789,943.4000200,-3415.0000000,10.6000000,0.0000000,0.0000000,0.0000000); //object(hashburytree4sfs) (14)
	island42 = CreateDynamicObject(789,916.4000200,-3431.8999000,11.4000000,0.0000000,0.0000000,0.0000000); //object(hashburytree4sfs) (15)
	island43 = CreateDynamicObject(789,895.7999900,-3445.6001000,14.4000000,0.0000000,0.0000000,0.0000000); //object(hashburytree4sfs) (16)
	island44 = CreateDynamicObject(789,943.0999800,-3386.1999500,11.9000000,0.0000000,0.0000000,0.0000000); //object(hashburytree4sfs) (17)
	island45 = CreateDynamicObject(789,961.9000200,-3363.3999000,12.8000000,0.0000000,0.0000000,0.0000000); //object(hashburytree4sfs) (18)
	island46 = CreateDynamicObject(789,1018.0999800,-3357.3000500,17.0000000,0.0000000,0.0000000,0.0000000); //object(hashburytree4sfs) (19)
	island47 = CreateDynamicObject(789,985.2000100,-3361.1001000,15.7000000,0.0000000,0.0000000,0.0000000); //object(hashburytree4sfs) (20)
	island48 = CreateDynamicObject(789,915.2000100,-3409.3000500,17.4000000,0.0000000,0.0000000,0.0000000); //object(hashburytree4sfs) (21)
	island49 = CreateDynamicObject(789,917.2999900,-3517.1001000,7.8000000,0.0000000,0.0000000,0.0000000); //object(hashburytree4sfs) (22)
	island50 = CreateDynamicObject(17026,859.5999800,-3452.3999000,12.9000000,0.0000000,0.0000000,140.0000000); //object(cunt_rockgp2_) (2)
	island51 = CreateDynamicObject(17026,858.7000100,-3453.3000500,16.4000000,0.0000000,0.0000000,320.0000000); //object(cunt_rockgp2_) (3)
	island52 = island1 = CreateDynamicObject(17026,855.5000000,-3390.3000500,0.0000000,0.0000000,0.0000000,0.0000000); //object(cunt_rockgp2_) (4)
	island53 = CreateDynamicObject(17026,863.9000200,-3394.0000000,2.7000000,0.0000000,0.0000000,30.0000000); //object(cunt_rockgp2_) (6)
	island54 = CreateDynamicObject(18359,872.9000200,-3369.3999000,-15.8000000,0.0000000,0.0000000,50.0000000); //object(cs_landbit_74) (2)
	island55 = CreateDynamicObject(18227,896.2999900,-3226.6001000,6.0000000,0.0000000,0.0000000,170.0000000); //object(cunt_rockgp2_20) (4)
	island56 = CreateDynamicObject(18227,848.7999900,-3227.8000500,6.4000000,0.0000000,0.0000000,240.0000000); //object(cunt_rockgp2_20) (5)
	island57 = CreateDynamicObject(18227,812.4000200,-3230.8999000,17.7000000,0.0000000,0.0000000,72.0000000); //object(cunt_rockgp2_20) (10)
	island58 = CreateDynamicObject(18227,789.2000100,-3253.3000500,17.4000000,0.0000000,0.0000000,90.0000000); //object(cunt_rockgp2_20) (12)
	island59 = CreateDynamicObject(18227,754.5999800,-3330.8000500,0.6000000,0.0000000,0.0000000,300.0000000); //object(cunt_rockgp2_20) (13)
	island60 = CreateDynamicObject(18227,731.2999900,-3341.8000500,6.1000000,0.0000000,0.0000000,300.0000000); //object(cunt_rockgp2_20) (15)
	island61 = CreateDynamicObject(18227,726.2000100,-3354.8000500,15.9000000,0.0000000,0.0000000,120.0000000); //object(cunt_rockgp2_20) (16)
	island62 = CreateDynamicObject(18227,761.7000100,-3434.6999500,9.6000000,0.0000000,0.0000000,0.0000000); //object(cunt_rockgp2_20) (17)
	island63 = CreateDynamicObject(18227,734.5999800,-3313.5000000,15.5000000,0.0000000,0.0000000,130.0000000); //object(cunt_rockgp2_20) (18)
	island64 = CreateDynamicObject(18227,712.2000100,-3407.6001000,6.4000000,0.0000000,0.0000000,200.0000000); //object(cunt_rockgp2_20) (19)
	island65 = CreateDynamicObject(18227,809.2000100,-3465.3999000,4.5000000,0.0000000,0.0000000,0.0000000); //object(cunt_rockgp2_20) (20)
	island66 = CreateDynamicObject(18227,824.0000000,-3467.1001000,7.0000000,0.0000000,0.0000000,0.0000000); //object(cunt_rockgp2_20) (21)
	island67 = CreateDynamicObject(12940,782.0000000,-3344.8000500,10.7000000,0.0000000,0.0000000,50.0000000); //object(sw_apartments07) (1)
	island68 = CreateDynamicObject(12940,810.4000200,-3313.3000500,10.5000000,0.0000000,0.0000000,230.0000000); //object(sw_apartments07) (2)
	island69 = CreateDynamicObject(969,860.5999800,-3245.6999500,16.0000000,0.0000000,0.0000000,312.0000000); //object(electricgate) (2)
	island70 = CreateDynamicObject(969,860.5999800,-3245.6999500,13.2000000,0.0000000,0.0000000,312.0000000); //object(electricgate) (3)
	island71 = CreateDynamicObject(969,853.7999900,-3251.1999500,13.3000000,0.0000000,0.0000000,40.0000000); //object(electricgate) (4)
	island72 = CreateDynamicObject(969,853.7999900,-3251.3000500,16.0000000,0.0000000,0.0000000,40.0000000); //object(electricgate) (5)
	island73 = CreateDynamicObject(969,854.0000000,-3251.1001000,13.1000000,0.0000000,0.0000000,310.0000000); //object(electricgate) (6)
	island74 = CreateDynamicObject(969,854.2000100,-3251.0000000,16.0000000,0.0000000,0.0000000,308.0000000); //object(electricgate) (7)
	island75 = CreateDynamicObject(969,859.2999900,-3257.8000500,16.3000000,0.0000000,0.0000000,38.0000000); //object(electricgate) (8)
	island76 = CreateDynamicObject(969,859.7999900,-3257.8000500,13.5000000,0.0000000,0.0000000,40.0000000); //object(electricgate) (9)
	island77 = CreateDynamicObject(791,781.0000000,-3396.1001000,-0.2000000,0.0000000,0.0000000,0.0000000); //object(vbg_fir_copse) (6)
	island78 = CreateDynamicObject(791,819.7000100,-3365.1999500,-8.3000000,0.0000000,0.0000000,0.0000000); //object(vbg_fir_copse) (7)
	island79 = CreateDynamicObject(791,844.5000000,-3331.8999000,0.1000000,0.0000000,0.0000000,0.0000000); //object(vbg_fir_copse) (8)
	island80 = CreateDynamicObject(791,848.7999900,-3290.6999500,3.7000000,0.0000000,0.0000000,0.0000000); //object(vbg_fir_copse) (9)
	island81 = CreateDynamicObject(791,880.7999900,-3265.8999000,7.6000000,0.0000000,0.0000000,0.0000000); //object(vbg_fir_copse) (10)
	island82 = CreateDynamicObject(791,829.7000100,-3273.8000500,4.8000000,0.0000000,0.0000000,0.0000000); //object(vbg_fir_copse) (11)
	island83 = CreateDynamicObject(791,746.7999900,-3379.5000000,-1.6000000,0.0000000,0.0000000,0.0000000); //object(vbg_fir_copse) (12)
	island84 = CreateDynamicObject(17026,809.2999900,-3460.3000500,21.7000000,0.0000000,0.0000000,20.0000000); //object(cunt_rockgp2_) (7)
	island85 = CreateDynamicObject(17026,907.4000200,-3235.3000500,14.7000000,0.0000000,0.0000000,190.0000000); //object(cunt_rockgp2_) (8)
	island86 = CreateDynamicObject(17026,862.5000000,-3210.3000500,18.6000000,0.0000000,0.0000000,240.0000000); //object(cunt_rockgp2_) (9)
	island87 = CreateDynamicObject(17026,819.2999900,-3221.6001000,18.8000000,0.0000000,0.0000000,280.0000000); //object(cunt_rockgp2_) (10)
	island88 = CreateDynamicObject(17026,735.7999900,-3472.8999000,-1.1000000,0.0000000,0.0000000,330.0000000); //object(cunt_rockgp2_) (11)
	island89 = CreateDynamicObject(17026,741.0999800,-3523.0000000,-2.6000000,0.0000000,0.0000000,340.0000000); //object(cunt_rockgp2_) (12)
	island90 = CreateDynamicObject(17026,750.7999900,-3568.3000500,-3.7000000,0.0000000,0.0000000,350.0000000); //object(cunt_rockgp2_) (13)
	island91 = CreateDynamicObject(17026,779.5000000,-3605.5000000,0.0000000,0.0000000,0.0000000,50.0000000); //object(cunt_rockgp2_) (14)
	island92 = CreateDynamicObject(17026,822.0999800,-3602.3000500,0.0000000,0.0000000,0.0000000,80.0000000); //object(cunt_rockgp2_) (15)
	island93 = CreateDynamicObject(17026,865.0999800,-3580.3000500,0.0000000,0.0000000,0.0000000,90.0000000); //object(cunt_rockgp2_) (16)
	island94 = CreateDynamicObject(17026,892.5999800,-3557.1001000,-2.7000000,0.0000000,0.0000000,110.0000000); //object(cunt_rockgp2_) (17)
	island95 = CreateDynamicObject(17026,942.5000000,-3300.0000000,22.2000000,0.0000000,0.0000000,170.0000000); //object(cunt_rockgp2_) (18)
	island96 = CreateDynamicObject(3461,853.5000000,-3250.8999000,14.7000000,0.0000000,0.0000000,0.0000000); //object(tikitorch01_lvs) (4)
	island97 = CreateDynamicObject(3461,859.7999900,-3258.1999500,15.1000000,0.0000000,0.0000000,0.0000000); //object(tikitorch01_lvs) (5)
	island98 = CreateDynamicObject(3461,867.0000000,-3251.5000000,14.8000000,0.0000000,0.0000000,0.0000000); //object(tikitorch01_lvs) (6)
	island99 = CreateDynamicObject(3461,861.2000100,-3244.8999000,15.3000000,0.0000000,0.0000000,0.0000000); //object(tikitorch01_lvs) (7)
	island100 = CreateDynamicObject(3461,799.2999900,-3338.8999000,14.1000000,0.0000000,0.0000000,0.0000000); //object(tikitorch01_lvs) (8)
	island101 = CreateDynamicObject(3461,786.9000200,-3353.6999500,14.1000000,0.0000000,0.0000000,0.0000000); //object(tikitorch01_lvs) (9)
	island102 = CreateDynamicObject(3461,774.2000100,-3342.6999500,14.0000000,0.0000000,0.0000000,0.0000000); //object(tikitorch01_lvs) (10)
	island103 = CreateDynamicObject(3461,786.4000200,-3328.1001000,14.0000000,0.0000000,0.0000000,0.0000000); //object(tikitorch01_lvs) (11)
	island104 = CreateDynamicObject(3461,793.0000000,-3319.1001000,13.9000000,0.0000000,0.0000000,0.0000000); //object(tikitorch01_lvs) (12)
	island105 = CreateDynamicObject(3461,805.5000000,-3304.5000000,13.8000000,0.0000000,0.0000000,0.0000000); //object(tikitorch01_lvs) (13)
	island106 = CreateDynamicObject(3461,818.5000000,-3315.1999500,13.8000000,0.0000000,0.0000000,0.0000000); //object(tikitorch01_lvs) (14)
	island107 = CreateDynamicObject(3461,806.0999800,-3330.1001000,13.9000000,0.0000000,0.0000000,0.0000000); //object(tikitorch01_lvs) (15)
	island108 = CreateDynamicObject(2971,964.2000100,-3416.8000500,3.2000000,0.0000000,0.0000000,0.0000000); //object(k_smashboxes) (1)
	island109 = CreateDynamicObject(2971,961.7999900,-3416.6001000,3.4000000,0.0000000,0.0000000,0.0000000); //object(k_smashboxes) (2)
    SetTimer("IslandAway",1800000, 0);
    IslandSpawned = 1;
    for(new i; i<MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    SCM(i, -1, ""ZELENA"**"SIVA" Zemlja se pocinje tresti, novi otok se pojavio"ZELENA" **");
		    SetPlayerDrunkLevel (i, 4000);
		    SetTimer("DrunkAway",4000, 0);
		}
	}
}
//----------------------------------------------------------------------------//
forward IslandBeSpawned();
public IslandBeSpawned()
{
	IslandCantBeSpawned = 0;
	return 1;
}
//----------------------------------------------------------------------------//
forward DrunkAway();
public DrunkAway()
{
    for(new i; i<MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			SetPlayerDrunkLevel (i, 0);
		}
	}
}
//----------------------------------------------------------------------------//
forward IslandAway();
public IslandAway()
{
	DestroyDynamicObject(island1); //
	DestroyDynamicObject(island2); //
	DestroyDynamicObject(island3); //
	DestroyDynamicObject(island4); //
	DestroyDynamicObject(island5); //
	DestroyDynamicObject(island6); //
	DestroyDynamicObject(island7); //
	DestroyDynamicObject(island8); //
	DestroyDynamicObject(island9); //
	DestroyDynamicObject(island10); //
	DestroyDynamicObject(island11); //
	DestroyDynamicObject(island12); //
	DestroyDynamicObject(island13); //
	DestroyDynamicObject(island14); //
	DestroyDynamicObject(island15); //
	DestroyDynamicObject(island16); //
	DestroyDynamicObject(island17); //
	DestroyDynamicObject(island18); //
	DestroyDynamicObject(island19); //
	DestroyDynamicObject(island20); //
	DestroyDynamicObject(island21); //
	DestroyDynamicObject(island22); //
	DestroyDynamicObject(island23); //
	DestroyDynamicObject(island24); //
	DestroyDynamicObject(island25); //
	DestroyDynamicObject(island26); //
	DestroyDynamicObject(island27); //
	DestroyDynamicObject(island28); //
	DestroyDynamicObject(island29); //
	DestroyDynamicObject(island30); //
	DestroyDynamicObject(island31); //
	DestroyDynamicObject(island32); //
	DestroyDynamicObject(island33); //
	DestroyDynamicObject(island34); //
	DestroyDynamicObject(island35); //
	DestroyDynamicObject(island36); //
	DestroyDynamicObject(island37); //
	DestroyDynamicObject(island38); //
	DestroyDynamicObject(island39); //
	DestroyDynamicObject(island40); //
	DestroyDynamicObject(island41); //
	DestroyDynamicObject(island42); //
	DestroyDynamicObject(island43); //
	DestroyDynamicObject(island44); //
	DestroyDynamicObject(island45); //
	DestroyDynamicObject(island46); //
	DestroyDynamicObject(island47); //
	DestroyDynamicObject(island48); //
	DestroyDynamicObject(island49); //
	DestroyDynamicObject(island50); //
	DestroyDynamicObject(island51); //
	DestroyDynamicObject(island52); //
	DestroyDynamicObject(island53); //
	DestroyDynamicObject(island54); //
	DestroyDynamicObject(island55); //
	DestroyDynamicObject(island56); //
	DestroyDynamicObject(island57); //
	DestroyDynamicObject(island58); //
	DestroyDynamicObject(island59); //
	DestroyDynamicObject(island60); //
	DestroyDynamicObject(island61); //
	DestroyDynamicObject(island62); //
	DestroyDynamicObject(island63); //
	DestroyDynamicObject(island64); //
	DestroyDynamicObject(island65); //
	DestroyDynamicObject(island66); //
	DestroyDynamicObject(island67); //
	DestroyDynamicObject(island68); //
	DestroyDynamicObject(island69); //
	DestroyDynamicObject(island70); //
	DestroyDynamicObject(island71); //
	DestroyDynamicObject(island72); //
	DestroyDynamicObject(island73); //
	DestroyDynamicObject(island74); //
	DestroyDynamicObject(island75); //
	DestroyDynamicObject(island76); //
	DestroyDynamicObject(island77); //
	DestroyDynamicObject(island78); //
	DestroyDynamicObject(island79); //
	DestroyDynamicObject(island80); //
	DestroyDynamicObject(island81); //
	DestroyDynamicObject(island82); //
	DestroyDynamicObject(island83); //
	DestroyDynamicObject(island84); //
	DestroyDynamicObject(island85); //
	DestroyDynamicObject(island86); //
	DestroyDynamicObject(island87); //
	DestroyDynamicObject(island88); //
	DestroyDynamicObject(island89); //
	DestroyDynamicObject(island90); //
	DestroyDynamicObject(island91); //
	DestroyDynamicObject(island92); //
	DestroyDynamicObject(island93); //
	DestroyDynamicObject(island94); //
	DestroyDynamicObject(island95); //
	DestroyDynamicObject(island96); //
	DestroyDynamicObject(island97); //
	DestroyDynamicObject(island98); //
	DestroyDynamicObject(island99); //
	DestroyDynamicObject(island100); //
	DestroyDynamicObject(island101); //
	DestroyDynamicObject(island102); //
	DestroyDynamicObject(island103); //
	DestroyDynamicObject(island104); //
	DestroyDynamicObject(island105); //
	DestroyDynamicObject(island106); //
	DestroyDynamicObject(island107); //
	DestroyDynamicObject(island108); //
	DestroyDynamicObject(island109); //
	IslandSpawned = 0;
	SetTimer("IslandBeSpawned",3600000, 0);
    for(new i; i<MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    SCM(i, -1, ""ZELENA"**"SIVA" Zemlja se pocinje tresti, otok je nestao"ZELENA" **");
		    SetPlayerCheckpoint(i, 1206.7040,-3613.7375,2.1710, 3.0);
		    SetPlayerDrunkLevel (i, 4000);
		    SetTimer("DrunkAway",4000, 0);
		}
	}
	return 1;
}
//----------------------------------------------------------------------------//
forward LoadUser_data(playerid,name[],value[]);
public LoadUser_data(playerid,name[],value[])
{
    INI_Int("Password",PlayerInfo[playerid][pPass]);
    INI_Int("Money", PlayerInfo[playerid][pMoney]);
	INI_Int("Ban",PlayerInfo[playerid][pBan]);
	INI_Int("Admin", PlayerInfo[playerid][pAdmin]);
	INI_Int("IP", PlayerInfo[playerid][pIP]);
    INI_Int("Skin", PlayerInfo[playerid][pSkin]);
    INI_Int("Glad", PlayerInfo[playerid][pGlad]);
    INI_Int("Zedj", PlayerInfo[playerid][pZedj]);
    INI_Int("RStap", PlayerInfo[playerid][pRStap]);
    INI_Int("Ribe", PlayerInfo[playerid][pRibe]);
    INI_Int("JRibe", PlayerInfo[playerid][pJRibe]);
    INI_Int("Drvo", PlayerInfo[playerid][pDrvo]);
    INI_Int("Kamen", PlayerInfo[playerid][pKamen]);
    INI_Int("SatiIgre", PlayerInfo[playerid][pSatiIgre]);
    INI_Int("Voce", PlayerInfo[playerid][pVoce]);
    INI_Int("FlasaVode", PlayerInfo[playerid][pFlasaVode]);
    INI_Int("FlasaPuna", PlayerInfo[playerid][pFlasaPuna]);
    INI_Int("Sibice", PlayerInfo[playerid][pSibice]);
    INI_Int("Povez", PlayerInfo[playerid][pPovez]);
    INI_Int("Sator", PlayerInfo[playerid][pSator]);
    return 1;
}
//----------------------------------------------------------------------------//
forward LoadObjects(playerid, vreme);
public LoadObjects(playerid, vreme)
{
	TogglePlayerControllable(playerid, 0);
	GameTextForPlayer(playerid, "~y~ucitavanje objekata...", vreme*1000, 3);
	SetTimerEx("ObjectsLoaded", vreme*1000, 0, "i", playerid);
	return 1;
}
//----------------------------------------------------------------------------//
forward ObjectsLoaded(playerid);
public ObjectsLoaded(playerid)
{
	GameTextForPlayer(playerid, "~b~objekti ucitani!", 2000, 3);
	TogglePlayerControllable(playerid, 1);
	return 1;
}
//----------------------------------------------------------------------------//
forward KickCountdown(playerid);
public KickCountdown(playerid)
{
	if(LoggedOn[playerid] == 0)
	{
		Kick(playerid);
	}
	return 1;
}
//----------------------------------------------------------------------------//
forward VrijemeUpdate();
public VrijemeUpdate()
{
    new string[256],sati,minute;
   	gettime(sati, minute);
    format(string, sizeof string, "%s%d:%s%d",  (sati < 10) ? ("0") : (""), sati, (minute < 10) ? ("0") : (""), minute);
    TextDrawSetString(Vrijeme[1], string);
	return 1;
}
//----------------------------------------------------------------------------//
forward SatiIgre();
public SatiIgre()
{
    new hh, mm, ss;
    gettime(hh,mm,ss);
	SetWorldTime(hh);
    if(mm == 0)
    {
	    for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i))
	    {
			PlayerInfo[i][pSatiIgre] += 1;
			SetPlayerScore(i, PlayerInfo[i][pSatiIgre]);
	    }
	}
    return 1;
}
//----------------------------------------------------------------------------//
forward SaveTezga();
public SaveTezga()
{
	new coordsstring[256];
	format(coordsstring, sizeof(coordsstring), "%d,%d,%d",tezga1,tezga2,tezga3);
	new File: file2 = fopen("Config/tezge.ini", io_write);
	fwrite(file2, coordsstring);
	fclose(file2);
	return 1;
}
//----------------------------------------------------------------------------//
forward LoadTezga();
public LoadTezga()
{
	new arrCoords[3][64];
	new strFromFile2[256];
	new File: file = fopen("Config/tezge.ini", io_read);
	if (file)
	{
		fread(file, strFromFile2);
		split(strFromFile2, arrCoords, ',');
		tezga1 = strval(arrCoords[0]);
		tezga2 = strval(arrCoords[1]);
		tezga3 = strval(arrCoords[2]);
		fclose(file);
	}
	return 1;
}
//----------------------------------------------------------------------------//
forward Systems();
public Systems()
{
	foreach(Player, i)
	{
		EatMin[i]++;
		if(EatMin[i] >= 120)
		{
			PlayerInfo[i][pGlad]--;
			EatMin[i] = 0;
			if(PlayerInfo[i][pGlad] == 5)
			{
				SCM(i, -1,""ZELENA"*"BELA" Gladan si, moras nesto da pojedes.");
			}
			if(PlayerInfo[i][pGlad] == 0)
			{
				SetPlayerHealth(i, 0.0);
				PlayerInfo[i][pGlad] = 100;
				new string[256];
				format(string, sizeof(string), ""CRVENA"*"SIVA" %s je umro od gladi.", GetName(i));
				SCMTA(-1, string);
			}
		}
		Thirst[i]++;
		if(Thirst[i] >= 60)
		{
			PlayerInfo[i][pZedj]++;
			Thirst[i] = 0;
			if(PlayerInfo[i][pZedj] == 95)
			{
				SCM(i, -1,""ZELENA"*"SIVA" Veoma si zedan, moras ici da popijes nesto!");
			}
			if(PlayerInfo[i][pZedj] >= 100)
			{
                SetPlayerHealth(i, 0.0);
				PlayerInfo[i][pZedj] = 0;
				new string[256];
				format(string, sizeof(string), ""CRVENA"*"SIVA" %s je umro od zedji.", GetName(i));
				SCMTA(-1, string);
			}
		}
	}
	return 1;
}
//----------------------------------------------------------------------------//
forward TD_Update();
public TD_Update()
{
    for(new d=0; d<MAX_PLAYERS; d++)
	{
		new sstring[5], srstring[5];
		{
			new Float:helth;
			GetPlayerHealth(d,helth);
			format(sstring, sizeof(sstring),"%d%",PlayerInfo[d][pGlad]);
			TextDrawSetString(Glad[1][d], sstring);
			format(sstring, sizeof(sstring),"%d%",PlayerInfo[d][pZedj]);
			TextDrawSetString(Zedj[1][d], sstring);
			format(srstring, sizeof(srstring),"%.0f%",helth);
			TextDrawSetString(Srce[1][d], srstring);
		}
	}
	return 1;
}
//----------------------------------------------------------------------------//
forward BleedTimer(playerid);
public BleedTimer(playerid)
{
	if(Bleeding[playerid] == 1)
	{
		new Float:health;
    	GetPlayerHealth(playerid, health);
    	SetPlayerHealth(playerid, health-5);
    	new Float:PX, Float:PY, Float:PZ;
    	GetPlayerPos(playerid, PX, PY, PZ);
	    new bobjct = CreateObject(18668, PX+3.5, PY+3.5, PZ, 0.0, 0.0, 0.0);
		//AttachObjectToPlayer(bobjct, playerid, PX, PY, PZ+2, 0.0, 0.0, 0.0);
		//SetPlayerAttachedObject(playerid,7,18668,5,0,0,3.0,-90,180, 0, 0.03, 0.03, 0.03);
	}
	else
	{
		KillTimer(BleedingTimer[playerid]);
	}
	return 1;
}
//----------------------------------------------------------------------------//
forward EndOfFishing(playerid);
public EndOfFishing(playerid)
{
    if(GetPlayerProgressBarValue(playerid, FishingBar[playerid]) == 100)
    {
        FishingProgress[playerid] = 0;
        HidePlayerProgressBar(playerid, FishingBar[playerid]);
		TogglePlayerControllable(playerid, 1);
		pFishing[playerid] = 0;
		SetPlayerProgressBarValue(playerid, FishingBar[playerid], FishingProgress[playerid]);
		KillTimer(FishingUpdate[playerid]);
		new reward;
		switch(random(4))
        {
            case 0: reward = 2;
            case 1: reward = 3;
            case 2: reward = 4;
            case 3: reward = 5;
        }
        PlayerInfo[playerid][pRibe] += reward;
		new string[256];
		format(string, sizeof(string), ""ZELENA"*"BELA" Uhvatio si %d ribe! Sada ih mozes ispeci!", reward);
        SCM(playerid, -1, string);
        return 1;
    }
    return 1;
}
//----------------------------------------------------------------------------//
forward UcitajSator(satorid,  name[], value[]);
public UcitajSator(satorid, name[], value[])
{
	INI_String("Vlasnik",SatorInfo[satorid][sVlasnik],32);
	INI_Int("ProveraVlasnika",SatorInfo[satorid][sProveraVlasnika]);
	INI_Int("Postavljen",SatorInfo[satorid][sPostavljen]);
	INI_Float("PozX",SatorInfo[satorid][sPozX]);
    INI_Float("PozY",SatorInfo[satorid][sPozY]);
    INI_Float("PozZ",SatorInfo[satorid][sPozZ]);
    INI_Float("PozX2",SatorInfo[satorid][sPozX2]);
    INI_Float("PozY2",SatorInfo[satorid][sPozY2]);
    INI_Float("PozZ2",SatorInfo[satorid][sPozZ2]);
    INI_Int("Int",SatorInfo[satorid][sInt]);
    INI_Int("Zakljucan",SatorInfo[satorid][sZakljucan]);
    INI_Float("Angle",SatorInfo[satorid][sAngle]);
    INI_Int("VW",SatorInfo[satorid][sVW]);
	return 1;
}
//----------------------------------------------------------------------------//
forward SakrijInfo();
public SakrijInfo()
{
	TextDrawHideForAll(Informacije[0]);
	TextDrawHideForAll(Informacije[1]);
	TextDrawHideForAll(Informacije[2]);
}
//----------------------------------------------------------------------------//
forward SaveDotUpdate();
public SaveDotUpdate()
{
	new dot = 0;
	if(dot == 0)
	{
		new string[5];
		format(string, sizeof(string), " ");
		TextDrawSetString(SaveIcon[0], string);
		dot = 1;
	}
	else if(dot == 1)
	{
        new string[5];
		format(string, sizeof(string), ".");
		TextDrawSetString(SaveIcon[0], string);
		dot = 2;
	}
	else if(dot == 2)
	{
        new string[5];
		format(string, sizeof(string), "..");
		TextDrawSetString(SaveIcon[0], string);
		dot = 3;
	}
	else if(dot == 3)
	{
        new string[5];
		format(string, sizeof(string), "...");
		TextDrawSetString(SaveIcon[0], string);
		dot = 0;
	}
}
//----------------------------------------------------------------------------//
forward IconHide(playerid);
public IconHide(playerid)
{
    TextDrawHideForPlayer(playerid, SaveIcon[0]);
	TextDrawHideForPlayer(playerid, SaveIcon[1]);
	TextDrawHideForPlayer(playerid, SaveIcon[2]);
	TextDrawHideForPlayer(playerid, SaveIcon[3]);
	TextDrawHideForPlayer(playerid, SaveIcon[4]);
	TextDrawHideForPlayer(playerid, SaveIcon[5]);
	TextDrawHideForPlayer(playerid, SaveIcon[6]);
	TextDrawHideForPlayer(playerid, SaveIcon[7]);
}
//----------------------------------------------------------------------------//
forward SpremiKorisnike();
public SpremiKorisnike()
{
	foreach(Player, i)
	{
	    if(IsPlayerConnected(i) && LoggedOn[i] == 1)
	    {
			SaveUser(i);
		}
	}
	print("- Svi korisnicki racuni su uspesno sacuvani. (Auto)");
	return 1;
}
//----------------------------------------------------------------------------//
stock PreloadAnimLib(playerid, animlib[])
{
	ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0);
}
//----------------------------------------------------------------------------//
stock SaveUser(playerid)
{
    new INI:File = INI_Open(UserPath(playerid));
    //------------------------------------------------------------------------//
    INI_SetTag(File,"data");
    INI_WriteInt(File,"Skin", GetPlayerSkin(playerid));
    INI_WriteInt(File,"Ban", PlayerInfo[playerid][pBan]);
    INI_WriteInt(File,"Money", GetPlayerMoney(playerid));
    INI_WriteInt(File,"Admin", PlayerInfo[playerid][pAdmin]);
    INI_WriteString(File,"IP", PlayerInfo[playerid][pIP]);
    INI_WriteInt(File,"Glad", PlayerInfo[playerid][pGlad]);
    INI_WriteInt(File,"Zedj", PlayerInfo[playerid][pZedj]);
    INI_WriteInt(File,"RStap", PlayerInfo[playerid][pRStap]);
    INI_WriteInt(File,"Ribe", PlayerInfo[playerid][pRibe]);
    INI_WriteInt(File,"JRibe", PlayerInfo[playerid][pJRibe]);
    INI_WriteInt(File,"Drvo", PlayerInfo[playerid][pDrvo]);
    INI_WriteInt(File,"Kamen", PlayerInfo[playerid][pKamen]);
    INI_WriteInt(File,"SatiIgre", PlayerInfo[playerid][pSatiIgre]);
    INI_WriteInt(File,"Voce", PlayerInfo[playerid][pVoce]);
    INI_WriteInt(File,"FlasaVode", PlayerInfo[playerid][pFlasaVode]);
    INI_WriteInt(File,"FlasaPuna", PlayerInfo[playerid][pFlasaPuna]);
    INI_WriteInt(File,"Sibice", PlayerInfo[playerid][pSibice]);
    INI_WriteInt(File,"Povez", PlayerInfo[playerid][pPovez]);
    INI_WriteInt(File,"Sator", PlayerInfo[playerid][pSator]);
    INI_Close(File);
    //------------------------------------------------------------------------//
    if(IsPlayerConnected(playerid))
    {
		TextDrawShowForPlayer(playerid, SaveIcon[0]);
		TextDrawShowForPlayer(playerid, SaveIcon[1]);
		TextDrawShowForPlayer(playerid, SaveIcon[2]);
		TextDrawShowForPlayer(playerid, SaveIcon[3]);
		TextDrawShowForPlayer(playerid, SaveIcon[4]);
		TextDrawShowForPlayer(playerid, SaveIcon[5]);
		TextDrawShowForPlayer(playerid, SaveIcon[6]);
		TextDrawShowForPlayer(playerid, SaveIcon[7]);
		SetTimerEx("IconHide", 3000, 0, "i", playerid);
	}
    return 1;
}
//----------------------------------------------------------------------------//
stock UserPath(playerid)
{
    new string[128],playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),KORISNICI,playername);
    return string;
}
//----------------------------------------------------------------------------//
stock ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5)
{
    if(IsPlayerConnected(playerid))
	{
		new Float:posx, Float:posy, Float:posz;
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		foreach(Player,i)
		{
			if(IsPlayerConnected(i))
			{
				if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))
				{
					GetPlayerPos(i, posx, posy, posz);
					tempposx = (oldposx -posx);
					tempposy = (oldposy -posy);
					tempposz = (oldposz -posz);
					if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)))
					{
						SCM(i, col1, string);
					}
					else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))
					{
						SCM(i, col2, string);
					}
					else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))
					{
						SCM(i, col3, string);
					}
					else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))
					{
						SCM(i, col4, string);
					}
					else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
					{
						SCM(i, col5, string);
					}
			}   }
		}
	}
}
//----------------------------------------------------------------------------//
stock GetName(playerid)
{
    new name[24];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}
//----------------------------------------------------------------------------//
stock udb_hash(buf[])
{
    new length=strlen(buf);
    new s1 = 1;
    new s2 = 0;
    new n;
    for (n=0; n<length; n++)
    {
       s1 = (s1 + buf[n]) % 65521;
       s2 = (s2 + s1)     % 65521;
    }
    return (s2 << 16) + s1;
}
//----------------------------------------------------------------------------//
stock IsPlayerInArea(playerid, Float:minx, Float:miny, Float:maxx, Float:maxy)
{
	new Float:Poz[3];
	GetPlayerPos(playerid, Poz[0], Poz[1], Poz[2]);
	if(Poz[0] > minx && Poz[0] < maxx && Poz[1] > miny && Poz[1] < maxy) return 1;
	return 0;
}
//----------------------------------------------------------------------------//
stock IsPlayerInWater(playerid)
{
	new Float:Float[3];
	GetPlayerPos(playerid, Float[0], Float[1], Float[2]);
	if((IsPlayerInArea(playerid, 2032.1371, 1841.2656, 1703.1653, 1467.1099) && Float[2] <= 9.0484)
  	|| (IsPlayerInArea(playerid, 2109.0725, 2065.8232, 1962.5355, 10.8547) && Float[2] <= 10.0792)
  	|| (IsPlayerInArea(playerid, -492.5810, -1424.7122, 2836.8284, 2001.8235) && Float[2] <= 41.06)
  	|| (IsPlayerInArea(playerid, -2675.1492, -2762.1792, -413.3973, -514.3894) && Float[2] <= 4.24)
  	|| (IsPlayerInArea(playerid, -453.9256, -825.7167, -1869.9600, -2072.8215) && Float[2] <= 5.72)
  	|| (IsPlayerInArea(playerid, 1281.0251, 1202.2368, -2346.7451, -2414.4492) && Float[2] <= 9.3145)
  	|| (IsPlayerInArea(playerid, 2012.6154, 1928.9028, -1178.6207, -1221.4043) && Float[2] <= 18.45)
  	|| (IsPlayerInArea(playerid, 2326.4858, 2295.7471, -1400.2797, -1431.1266) && Float[2] <= 22.615)
  	|| (IsPlayerInArea(playerid, 2550.0454, 2513.7588, 1583.3751, 1553.0753) && Float[2] <= 9.4171)
  	|| (IsPlayerInArea(playerid, 1102.3634, 1087.3705, -663.1653, -682.5446) && Float[2] <= 112.45)
  	|| (IsPlayerInArea(playerid, 1287.7906, 1270.4369, -801.3882, -810.0527) && Float[2] <= 87.123)
  	|| (Float[2] < 1.5))
	{
		return 1;
	}
	return 0;
}
//----------------------------------------------------------------------------//
stock SCMF(playerid,color,fstring[],{Float, _}:...)
{
   new n=(numargs()-3)*4;
   if(n)
   {
      new message[128],arg_start,arg_end;
      #emit CONST.alt                fstring
      #emit LCTRL                    5
      #emit ADD
      #emit STOR.S.pri               arg_start
      #emit LOAD.S.alt               n
      #emit ADD
      #emit STOR.S.pri               arg_end
      do
      {
         #emit LOAD.I
         #emit PUSH.pri
         arg_end-=4;
         #emit LOAD.S.pri           arg_end
      }
      while(arg_end>arg_start);
      #emit PUSH.S                   fstring
      #emit PUSH.C                   255
      #emit PUSH.ADR                 message
      n+=4*3;
      #emit PUSH.S                   n
      #emit SYSREQ.C                 format
      n+=4;
      #emit LCTRL                    4
      #emit LOAD.S.alt               n
      #emit ADD
      #emit SCTRL                    4
      return SCM(playerid,color,message);
   }
   else return SCM(playerid,color,fstring);
}
//----------------------------------------------------------------------------//
stock split(const strsrc[], strdest[][], delimiter)
{
    new i, li;
    new aNum;
    new len;
    while(i <= strlen(strsrc))
    {
        if(strsrc[i] == delimiter || i == strlen(strsrc))
        {
            len = strmid(strdest[aNum], strsrc, li, i, 128);
            strdest[aNum][len] = 0;
            li = i+1;
            aNum++;
        }
        i++;
    }
    return 1;
}
//----------------------------------------------------------------------------//
stock SacuvajSator(satorid)
{
	new kFile[80];
    format(kFile, sizeof(kFile), SATOR_FILE, satorid);
	new INI:File = INI_Open(kFile);
	INI_WriteString(File,"Vlasnik",SatorInfo[satorid][sVlasnik]);
 	INI_WriteInt(File,"ProveraVlasnika",SatorInfo[satorid][sProveraVlasnika]);
	INI_WriteInt(File,"Postavljen",SatorInfo[satorid][sPostavljen]);
	INI_WriteFloat(File,"PozX",SatorInfo[satorid][sPozX]);
    INI_WriteFloat(File,"PozY",SatorInfo[satorid][sPozY]);
    INI_WriteFloat(File,"PozZ",SatorInfo[satorid][sPozZ]);
    INI_WriteFloat(File,"PozX2",SatorInfo[satorid][sPozX2]);
    INI_WriteFloat(File,"PozY2",SatorInfo[satorid][sPozY2]);
    INI_WriteFloat(File,"PozZ2",SatorInfo[satorid][sPozZ2]);
    INI_WriteFloat(File,"Angle",SatorInfo[satorid][sAngle]);
    INI_WriteInt(File,"Int",SatorInfo[satorid][sInt]);
    INI_WriteInt(File,"Zakljucan",SatorInfo[satorid][sZakljucan]);
    INI_WriteInt(File,"VW",SatorInfo[satorid][sVW]);
	INI_Close(File);
	return 1;
}
//----------------------------------------------------------------------------//
stock KreirajSator(satorid)
{
	if(SatorInfo[satorid][sPostavljen] == 1)
	{
	    new string[256];
	    DestroyDynamic3DTextLabel(SatorInfo[satorid][SatorLabel]);
	    DestroyDynamicObject(SatorInfo[satorid][sObjekat]);
	    if(SatorInfo[satorid][sProveraVlasnika] == 0)
	    {
			format(string, sizeof(string), ""CRVENA"(( Sator ))\n"CRVENA"- Vlasnik:"SIVA" N/A\n"CRVENA"- ID:"SIVA" %d\n"CRVENA"- Za kupovinu kucajte "SIVA"/kupisator"CRVENA" -", satorid);
		}
		else
		{
            format(string, sizeof(string), ""CRVENA"(( Sator ))\n"CRVENA"- Vlasnik:"SIVA" %s\n"CRVENA"- ID:"SIVA" %d\n"CRVENA"- Za ulaz pritisnite "SIVA"F ili ENTER"CRVENA" -", SatorInfo[satorid][sVlasnik], satorid);
		}
		SatorInfo[satorid][SatorLabel] = CreateDynamic3DTextLabel(string, -1, SatorInfo[satorid][sPozX], SatorInfo[satorid][sPozY], SatorInfo[satorid][sPozZ], 10.0,_,_,_, SatorInfo[satorid][sVW], SatorInfo[satorid][sInt],_,_);
		SatorInfo[satorid][sObjekat] = CreateDynamicObject(SATOR_OBJEKAT, SatorInfo[satorid][sPozX], SatorInfo[satorid][sPozY], SatorInfo[satorid][sPozZ], 0.0, 0.0, SatorInfo[satorid][sAngle], SatorInfo[satorid][sVW], SatorInfo[satorid][sInt],_,_);
	}
	return 1;
}
//----------------------------------------------------------------------------//
stock SledeciSatorID()
{
	new sator[64];
	for(new s = 1; s<= 200; s++)
	{
		format(sator, sizeof(sator), "Satori/Sator_%i.ini", s);
		if(!fexist(sator)) return s;
	}
	return true;
}
//----------------------------------------------------------------------------//
//							END OF THE GAMEMODE								  //
//----------------------------------------------------------------------------//
