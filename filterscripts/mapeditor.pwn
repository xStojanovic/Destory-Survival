/*

  __  __          _____
 |  \/  |   /\   |  __ \
 | \  / |  /  \  | |__) |
 | |\/| | / /\ \ |  ___/
 | |  | |/ ____ \| |
 |_|  |_/_/    \_\_|
  ______ _____ _____ _______ ____  _____
 |  ____|  __ \_   _|__   __/ __ \|  __ \
 | |__  | |  | || |    | | | |  | | |__) |
 |  __| | |  | || |    | | | |  | |  _  /
 | |____| |__| || |_   | | | |__| | | \ \
 |______|_____/_____|  |_|  \____/|_|  \_|


	Map Editor	V1.0 BETA by adri1.
	Move, texture and text your maps.
	Mueve, texturiza y inserteta textos en tus mapas.
	
	| REAL CREDITS
	|
	|   adri1	(Map Editor, MapMover plugin)
	|   Pottus  (Texture viewer)
	|   Y_Less  (YSI, sscanf)
	|   Incognito (Streamer plugin/include)
	|   SDraw   (3DMenu)
	|   Zeex    (ZCMD)
	|   irinel1996 (some codes from her iText object editor)
	|
	| KEEP THE CREDITS
	
	You may modify and re-release this script if you keep the original credits.
	Puedes modificar y publicar este código si mantienes los créditos originales.
	
	The use is very simple, just type the command /map and keep the steps.
	El uso es muy sencillo, solamente escribe el comando /map y sigue los pasos.
	
	Thanks you for download.
	Gracias por descargarlo.
	
	http://forum.sa-mp.com/index.php
    http://forum.sa-mp.com/member.php?u=106967

*/

forward OnAnyKeyDownRelease(status, key);
forward OnObjectImported(modelid, objectid, variable[]);
forward OnObjectTexturedText(objectid, text[], materialindex, materialsize, fontface[], fontsize, bold, fontcolor, backcolor, textalignment);
forward OnObjectTextured(objectid, materialindex, modelid, txdname[], texturename[], materialcolor);
forward OnMouseWheelScroll(val);
forward OnMouseMove(X, Y);
forward OnMouseLeftClick(X, Y, status);
forward LoadTheMap(playerid);
forward Finish(playerid, de);
forward Float:GetPlayerCameraFacingAngle(playerid);
forward OnPlayerKeyChange(playerid,newkeys);

native _duplicate(file[], to[]);
native _rename(file[], name[]);
native _winexec(path[]);
native _screensize(&Width, &Height);
native _mousepos(&X, &Y);
native _keystate(key);

#define MAX_MAPMOVER_OBJECTS    (500)
#define MAX_MAPMOVER_REMOVEBUILDING 1
#define IsObjectTextured(%0) MAPMOVER_OBJECTS[%0][ObjectTextured]
#define IsObjectIndexTextured(%0,%1) MAPMOVER_TEXTURES[%0][%1][IndexTextured]
#define GetTexturedObjectModelid(%0,%1) MAPMOVER_TEXTURES[%0][%1][M_Modelid]
#define GetTexturedObjectTxdName(%0,%1) MAPMOVER_TEXTURES[%0][%1][M_Txd]
#define GetTexturedObjectTextureName(%0,%1) MAPMOVER_TEXTURES[%0][%1][M_Texture]
#define GetTexturedObjectMaterialColor(%0,%1) MAPMOVER_TEXTURES[%0][%1][M_Color]
#define GetTexturedObjectID(%0,%1) MAPMOVER_TEXTURES[%0][%1][M_ObjectID]
#define IsObjectTextTextured(%0) MAPMOVER_OBJECTS[%0][ObjectTextTextured]
#define IsObjectIndexText(%0,%1) TEXT_TEXTURE_MAPMOVER_OBJECT[%0][%1][I_IndexTextured]
#define GetTextObjectText(%0,%1) TEXT_TEXTURE_MAPMOVER_OBJECT[%0][%1][I_Text]
#define GetTextObjectMaterialSize(%0,%1) TEXT_TEXTURE_MAPMOVER_OBJECT[%0][%1][I_MaterialSize]
#define GetTextObjectFontFace(%0,%1) TEXT_TEXTURE_MAPMOVER_OBJECT[%0][%1][I_FontFace]
#define GetTextObjectFontSize(%0,%1) TEXT_TEXTURE_MAPMOVER_OBJECT[%0][%1][I_FontSize]
#define GetTextObjectBold(%0,%1) TEXT_TEXTURE_MAPMOVER_OBJECT[%0][%1][I_Bold]
#define GetTextObjectFontColor(%0,%1) TEXT_TEXTURE_MAPMOVER_OBJECT[%0][%1][I_FontColor]
#define GetTextObjectBackColor(%0,%1) TEXT_TEXTURE_MAPMOVER_OBJECT[%0][%1][I_BackColor]
#define GetTextObjectAlignment(%0,%1) TEXT_TEXTURE_MAPMOVER_OBJECT[%0][%1][I_TextAlignment]
#define GetTexturedTextObjectID(%0,%1) TEXT_TEXTURE_MAPMOVER_OBJECT[%0][%1][I_ObjectID]
#define TKEY_RELEASE 0
#define TKEY_DOWN    1
#define VK_UP		0x26
#define VK_DOWN		0x28
#define VK_LEFT		0x25
#define VK_RIGHT	0x27
#define VK_KEY_W	0x57
#define VK_KEY_A 	0x41
#define VK_KEY_S	0x53
#define VK_KEY_D	0x44
#define CAMERA_MODE_NONE    	0
#define CAMERA_MODE_FLY     	1
#define         MAX_MATERIALS           1000
#define         PREVIEW_STATE_NONE              0
#define         PREVIEW_STATE_ALLTEXTURES       1
#define         DEFAULT_TEXTURE                 1000




#include <a_samp>

#undef MAX_PLAYERS
#define MAX_PLAYERS 10 //Redefine if you need

#include <sscanf2>
#include <streamer>
#include <alltextures>
#include <3dmenu>
#include <zcmd>




enum MENU3DINFO
{
    TPreviewState,
	CurrTextureIndex,
    Menus3D,
    PlayerText:Menu3D_Model_Info,
}

new Menu3DData[MAX_PLAYERS][MENU3DINFO];

new DIALOG_showed, DIALOG_dialogid, DIALOG_style, DIALOG_caption[64], DIALOG_info[1048], DIALOG_button1[64], DIALOG_button2[64];
new info[512];
new Float:RRot[3];
new CurrentPlayerID = -1;
new Index;
new Object_String[512];
new Player_MovingMap[MAX_PLAYERS];
new Player_EditMode[MAX_PLAYERS];
new Player_MovingObjects[MAX_PLAYERS];
new SelectedObject;
new ConfirmTexture = -1;
new Texture_EditIndex;
new ObjectCenter;
new mapnamefile[24];
new Float:CamOffSetX;
new Float:CamOffSetY;
new Float:CamOffSetZ;
enum OBJECT_INFORMATION
{
	ObjectTextured,
	ObjectTextTextured,
	VariableName[32],
	ModelID,
	Float:PositionX,
	Float:PositionY,
	Float:PositionZ,
	Float:RotationX,
	Float:RotationY,
	Float:RotationZ,
	Float:OffSetX,
	Float:OffSetY,
	Float:OffSetZ,
	ObjectID,
};
new MAPMOVER_OBJECTS[MAX_MAPMOVER_OBJECTS][OBJECT_INFORMATION];

enum TEXTURE_INFORMATION
{
	IndexTextured,
	M_ObjectID,
	M_Index,
	M_Modelid,
	M_Txd[64],
	M_Texture[64],
	M_Color,
};
new MAPMOVER_TEXTURES[MAX_MAPMOVER_OBJECTS][16][TEXTURE_INFORMATION];

enum TEXT_TEXTURE_OBJECT_INFORMATION
{
	I_IndexTextured,
	I_ObjectID,
	I_Text[256],
	I_MaterialIndex,
	I_MaterialSize,
	I_FontFace[64],
	I_FontSize,
	I_Bold,
	I_FontColor,
	I_BackColor,
	I_TextAlignment
};
new TEXT_TEXTURE_MAPMOVER_OBJECT[MAX_MAPMOVER_OBJECTS][16][TEXT_TEXTURE_OBJECT_INFORMATION];

enum noclipenum
{
	cameramode,
	flyobject,
	Float:speed
}
new noclipdata[MAX_PLAYERS][noclipenum];


public OnFilterScriptInit()
{
    print("Map editor filterscript loaded");
	return 1;
}

public OnFilterScriptExit()
{
	print("Map editor filterscript unloaded");
	new playerid = CurrentPlayerID;
	if(Player_MovingMap[playerid] == 0) return 1;

	DestroyObject(ObjectCenter);
	Player_MovingObjects[playerid] = 0;
	Player_MovingMap[playerid] = 0;
	Player_EditMode[playerid] = 0;
	ObjectCenter = 0;
	DIALOG_showed = 0;
	DIALOG_dialogid = 0;
	DIALOG_style = 0;
	format(DIALOG_caption, 64, "");
	format(DIALOG_info, 1048, "");
 	format(DIALOG_button1, 64, "");
 	format(DIALOG_button2, 64, "");
	format(info, 512, "");
	RRot[0] = 0.0;
    RRot[1] = 0.0;
    RRot[2] = 0.0;
	noclipdata[playerid][speed] = 5.0;
	Index = 0;
	format(Object_String, 512, "");
	SelectedObject = 0;
	ConfirmTexture = -1;
	Texture_EditIndex = 0;
	format(mapnamefile, 24, "");
	CamOffSetX = 0.0;
	CamOffSetY = 0.0;
	CamOffSetZ = 0.0;
	DestroyTexViewer(playerid);
	CancelFlyMode(playerid);
	CurrentPlayerID = -1;
	for(new i = 0; i != MAX_MAPMOVER_OBJECTS; i++)
    {
        if(MAPMOVER_OBJECTS[i][ModelID] != 0)
        {
            DestroyObject(MAPMOVER_OBJECTS[i][ObjectID]);
			DeleteMapObjectIndex(i);
		}
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	// Reset the data belonging to this player slot
	noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
    noclipdata[playerid][speed] = 5.0;
    InitText3DDraw(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	PlayerTextDrawDestroy(playerid, Menu3DData[playerid][Menu3D_Model_Info]);
	if(Player_MovingMap[playerid] == 0) return 1;
	DestroyObject(ObjectCenter);
	
	// Out of preview state
    Menu3DData[playerid][TPreviewState] = PREVIEW_STATE_NONE;
	CancelSelect3DMenu(playerid);

	// Did the player have a menu?
	if(Menu3DData[playerid][Menus3D] != INVALID_3DMENU)
	{
		// Destroy it
        Destroy3DMenu(Menu3DData[playerid][Menus3D]);
        Menu3DData[playerid][Menus3D] = INVALID_3DMENU;
	}
	
	Player_MovingObjects[playerid] = 0;
	Player_MovingMap[playerid] = 0;
	Player_EditMode[playerid] = 0;
	ObjectCenter = 0;
	DIALOG_showed = 0;
	DIALOG_dialogid = 0;
	DIALOG_style = 0;
	format(DIALOG_caption, 64, "");
	format(DIALOG_info, 1048, "");
 	format(DIALOG_button1, 64, "");
 	format(DIALOG_button2, 64, "");
	format(info, 512, "");
	RRot[0] = 0.0;
    RRot[1] = 0.0;
    RRot[2] = 0.0;
	noclipdata[playerid][speed] = 5.0;
	Index = 0;
	format(Object_String, 512, "");
	SelectedObject = 0;
	ConfirmTexture = -1;
	Texture_EditIndex = 0;
	format(mapnamefile, 24, "");
	CamOffSetX = 0.0;
	CamOffSetY = 0.0;
	CamOffSetZ = 0.0;
	DestroyTexViewer(playerid);
	CancelFlyMode(playerid);
	CancelEdit(playerid);
	CurrentPlayerID = -1;
	for(new i = 0; i != MAX_MAPMOVER_OBJECTS; i++)
    {
        if(MAPMOVER_OBJECTS[i][ModelID] != 0)
        {
            DestroyObject(MAPMOVER_OBJECTS[i][ObjectID]);
			DeleteMapObjectIndex(i);
		}
	}
	return 1;
}

CMD:map(playerid, params[])
{
	new plrIP[16];
    GetPlayerIp(playerid, plrIP, sizeof(plrIP));
    if(strcmp(plrIP, "127.0.0.1")) return SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Only localhost.");
    
    if(GetPVarType(playerid, "FlyMode"))
	{
	    if(Player_MovingObjects[playerid] >= 1) return SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Finish move the map before showing the menu.");
		if(Player_MovingMap[playerid] == 1) ShowPlayerDialog_A(playerid, 803, DIALOG_STYLE_LIST, "Map editor", "1. Go to map\n2. Edit Map\n3. Edit an object\n4. Export map\n5. Exit (save first!)", ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	}
	else
	{
        if(Player_MovingMap[playerid] == 1) return 1;
        
        SendClientMessage(playerid, -1, " ");
		SendClientMessage(playerid, -1, " ");
		SendClientMessage(playerid, -1, " ");
		SendClientMessage(playerid, -1, " ");
		SendClientMessage(playerid, -1, " ");
		SendClientMessage(playerid, -1, " ");
		SendClientMessage(playerid, -1, " ");
		SendClientMessage(playerid, -1, " ");
		SendClientMessage(playerid, -1, " ");
		SendClientMessage(playerid, -1, " ");
		SendClientMessage(playerid, -1, " ");
		SendClientMessage(playerid, -1, " ");
		SendClientMessage(playerid, -1, " ");
		SendClientMessage(playerid, -1, " ");
	 	SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Welcome.");
	 	
        CurrentPlayerID = playerid;
        Player_MovingMap[playerid] = 1;
	    ShowPlayerDialog_A(playerid, 800, DIALOG_STYLE_INPUT, "Map editor", "\n\nEnter the file name .txt with the map\nthat has been saved in the folder scriptfiles.\n\n\t(You must enter the extension .txt)\n\n", "Load", "X");
		FlyMode(playerid);
		noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	}
	return 1;
}

CMD:camspeed(playerid, params[])
{
	if(Player_MovingMap[playerid] == 0) return 0;
    if(noclipdata[playerid][cameramode] == CAMERA_MODE_NONE) return 1;
    if(!IsValidObject(noclipdata[playerid][flyobject])) return 0;
    new Float:movspeed;
    if(sscanf(params, "f", movspeed)) return SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Bad format.");
	noclipdata[playerid][speed] = movspeed;
	return 1;
}

CMD:gotocam(playerid, params[])
{
	if(Player_MovingMap[playerid] == 0) return 0;
	if(noclipdata[playerid][cameramode] == CAMERA_MODE_NONE) return 1;
	new Float:_pos[3];
    if(sscanf(params, "fff", _pos[0], _pos[1], _pos[2])) return SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Bad format.");
	SetObjectPos(noclipdata[playerid][flyobject], _pos[0], _pos[1], _pos[2]);
	noclipdata[playerid][cameramode] = CAMERA_MODE_FLY;
	return 1;
}

CMD:time(playerid, params[])
{
	if(Player_MovingMap[playerid] == 0) return 0;
    if(sscanf(params, "d", params[0])) return SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Bad format.");
	SetWorldTime(params[0]);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    DIALOG_showed = 0;
    if(dialogid == 800)
    {
        if(response)
        {
            ShowPlayerDialog_A(playerid, 801, DIALOG_STYLE_MSGBOX, "Map editor", "\n\n\tLoading Map...\n\n", "WAIT", "");
            noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
            if(!fexist(inputtext))
            {
                SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}File does not exist.");
                ShowPlayerDialog_A(playerid, 800, DIALOG_STYLE_INPUT, "Map editor", "\n\nEnter the file name .txt with the map\nthat has been saved in the folder scriptfiles.\n\n\t(You must enter the extension .txt)\n\n", "Load", "X");
				return 1;
			}
            LoadMap(playerid, inputtext);
        }
        else
        {
            Player_MovingMap[playerid] = 0;
            CancelFlyMode(playerid);
        }
    }
    if(dialogid == 801) ShowPlayerDialog_A(playerid, 800, DIALOG_STYLE_INPUT, "Map editor", "\n\nEnter the file name .txt with the map\nthat has been saved in the folder scriptfiles.\n\n\t(You must enter the extension .txt)\n\n", "Load", "X"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
    if(dialogid == 802) ShowPlayerDialog_A(playerid, 803, DIALOG_STYLE_LIST, "Map editor", "1. Go to map\n2. Edit Map\n3. Edit an object\n4. Export map\n5. Exit (save first!)", ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
    if(dialogid == 803)
    {
        if(response)
        {
            switch(listitem)
            {
	            case 0:
	            {
	                if(ObjectCenter == 0)
	                {
						new Float:CameraX = MAPMOVER_OBJECTS[0][PositionX];
						new Float:CameraY = MAPMOVER_OBJECTS[0][PositionY];
						new Float:CameraZ = MAPMOVER_OBJECTS[0][PositionZ];
                        SetObjectPos(noclipdata[playerid][flyobject], CameraX, CameraY, CameraZ);
                        noclipdata[playerid][cameramode] = CAMERA_MODE_FLY;
                        SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Use the {FFFF00}/map {FFFFFF}command again to show the main menu.");
	                }
	                else
	                {
	                    new Float:CameraX;
						new Float:CameraY;
						new Float:CameraZ;
						GetObjectPos(ObjectCenter, CameraX, CameraY, CameraZ);
                        SetObjectPos(noclipdata[playerid][flyobject], CameraX, CameraY, CameraZ);
                        noclipdata[playerid][cameramode] = CAMERA_MODE_FLY;
                        SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Use the {FFFF00}/map {FFFFFF}command again to show the main menu.");
	                }
				}
				case 1:
				{
				    
		            if(ObjectCenter == 0) format(info, 512, "1. Add a new object\n2. Destroy an object\n3. Center position\n{999999}4. Move map\n{999999}5. PositionX: 0.0\n{999999}6. PositionY: 0.0\n{999999}7. PositionZ: 0.0\n{999999}8. RotationX: 0.0\n{999999}9. RotationY: 0.0\n{999999}10. RotationZ: 0.0");
				    else
					{
					    new Float:pos[3]; GetObjectPos(ObjectCenter, pos[0], pos[1], pos[2]);
						format(info, 512, "1. Add a new object\n2. Destroy an object\n3. Center position\n4. Move map\n5. PositionX: %f\n6. PositionY: %f\n7. PositionZ: %f\n8. OffSet RotX: %f\n9. OffSet RotY: %f\n10. OffSet RotZ: %f", pos[0], pos[1], pos[2], RRot[0], RRot[1], RRot[2]);
					}
				    
				    ShowPlayerDialog_A(playerid, 808, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
				   
				}
				case 2:
				{
				    Player_EditMode[playerid] = 1;
				    noclipdata[playerid][cameramode] = CAMERA_MODE_FLY;
				    SelectObject(playerid);
				}
				case 3:
				{
					ExportMap();
					new stre[145], f_name[24]; format(f_name, 24, "%s_converted.txt", mapnamefile);
					format(stre, 145, "{FFFF00}Map editor: {FFFFFF}Your map has been exported to {FFFF00}../scriptfiles/%s", f_name);
					SendClientMessage(playerid, -1, stre);
					ShowPlayerDialog_A(playerid, 803, DIALOG_STYLE_LIST, "Map editor", "1. Go to map\n2. Edit Map\n3. Edit an object\n4. Export map\n5. Exit (save first!)", ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
				}
				case 4:
				{
					DestroyObject(ObjectCenter);
					Player_MovingObjects[playerid] = 0;
					Player_MovingMap[playerid] = 0;
					Player_EditMode[playerid] = 0;
					ObjectCenter = 0;
					DIALOG_showed = 0;
					DIALOG_dialogid = 0;
					DIALOG_style = 0;
					format(DIALOG_caption, 64, "");
					format(DIALOG_info, 1048, "");
				 	format(DIALOG_button1, 64, "");
				 	format(DIALOG_button2, 64, "");
					format(info, 512, "");
					RRot[0] = 0.0;
                    RRot[1] = 0.0;
                    RRot[2] = 0.0;
					noclipdata[playerid][speed] = 5.0;
					Index = 0;
					format(Object_String, 512, "");
					SelectedObject = 0;
					ConfirmTexture = -1;
					Texture_EditIndex = 0;
					format(mapnamefile, 24, "");
					CamOffSetX = 0.0;
					CamOffSetY = 0.0;
					CamOffSetZ = 0.0;
     				DestroyTexViewer(playerid);
					CancelFlyMode(playerid);
					CancelEdit(playerid);
					CurrentPlayerID = -1;
					for(new i = 0; i != MAX_MAPMOVER_OBJECTS; i++)
			        {
						if(MAPMOVER_OBJECTS[i][ModelID] != 0)
				        {
				            DestroyObject(MAPMOVER_OBJECTS[i][ObjectID]);
							DeleteMapObjectIndex(i);
						}
					}
					SendClientMessage(playerid, -1, " ");
					SendClientMessage(playerid, -1, " ");
					SendClientMessage(playerid, -1, " ");
					SendClientMessage(playerid, -1, " ");
					SendClientMessage(playerid, -1, " ");
					SendClientMessage(playerid, -1, " ");
					SendClientMessage(playerid, -1, " ");
					SendClientMessage(playerid, -1, " ");
					SendClientMessage(playerid, -1, " ");
					SendClientMessage(playerid, -1, " ");
					SendClientMessage(playerid, -1, " ");
					SendClientMessage(playerid, -1, " ");
					SendClientMessage(playerid, -1, " ");
					SendClientMessage(playerid, -1, " ");
				 	SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Goodbye.");
				}
			}
        }
        else SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Use the {FFFF00}/map {FFFFFF}command again to show the main menu."), noclipdata[playerid][cameramode] = CAMERA_MODE_FLY;
	}
	if(dialogid == 808)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0: ShowPlayerDialog_A(playerid, 806, DIALOG_STYLE_INPUT, "Map editor", "Insert the object model ID:\n", ">>", "<<");
	            case 1:
	            {
	                Player_EditMode[playerid] = 3;
				    noclipdata[playerid][cameramode] = CAMERA_MODE_FLY;
				    SelectObject(playerid);
	            }
	            case 2:
	            {
	                if(ObjectCenter == 0)
	                {
	                    new Float:CameraX;
						new Float:CameraY;
						new Float:CameraZ;
						GetObjectPos(noclipdata[playerid][flyobject], CameraX, CameraY, CameraZ);
	                    ObjectCenter = CreateObject(1220, CameraX, CameraY, CameraZ, 0.0, 0.0, 0.0);
	                    SetObjectMaterial(ObjectCenter, 0, 18646, "matcolours", "white");
	                    EditObject(playerid, ObjectCenter);
	                    noclipdata[playerid][cameramode] = CAMERA_MODE_FLY;
	                    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Place your object in the center of the map.");
	                }
	                else
	                {
	                    SetObjectMaterial(ObjectCenter, 0, 18646, "matcolours", "white");
	                    EditObject(playerid, ObjectCenter);
	                    noclipdata[playerid][cameramode] = CAMERA_MODE_FLY;
	                    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Place your object in the center of the map.");
	                }
	            }
	            case 3:
	            {
	                if(ObjectCenter == 0)
					{
					    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				    	ShowPlayerDialog_A(playerid, 808, DIALOG_STYLE_LIST, "Map editor", "1. Add a new object\n2. Destroy an object\n3. Center position\n{999999}4. Move map\n{999999}5. PositionX: 0.0\n{999999}6. PositionY: 0.0\n{999999}7. PositionZ: 0.0\n{999999}8. RotationX: 0.0\n{999999}9. RotationY: 0.0\n{999999}10. RotationZ: 0.0", ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
						SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}You must create the center object first.");
						return 1;
					}
				    ShowPlayerDialog_A(playerid, 804, DIALOG_STYLE_LIST, "Map editor", "1. Move with cursor (EditObject)\n2. Move with the camera", ">>", "<<");
				    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	            }
	            case 4:
	            {
	                if(ObjectCenter == 0)
					{
					    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				    	ShowPlayerDialog_A(playerid, 808, DIALOG_STYLE_LIST, "Map editor", "1. Add a new object\n2. Destroy an object\n3. Center position\n{999999}4. Move map\n{999999}5. PositionX: 0.0\n{999999}6. PositionY: 0.0\n{999999}7. PositionZ: 0.0\n{999999}8. RotationX: 0.0\n{999999}9. RotationY: 0.0\n{999999}10. RotationZ: 0.0", ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
						SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}You must create the center object first.");
						return 1;
					}
					
				    new Float:_pos[3]; GetObjectPos(ObjectCenter, _pos[0], _pos[1], _pos[2]);
					format(info, 128, "Map position X: %f", _pos[0]);
				    ShowPlayerDialog_A(playerid, 809, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
				    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	            }
	            case 5:
	            {
	                if(ObjectCenter == 0)
					{
					    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				    	ShowPlayerDialog_A(playerid, 808, DIALOG_STYLE_LIST, "Map editor", "1. Add a new object\n2. Destroy an object\n3. Center position\n{999999}4. Move map\n{999999}5. PositionX: 0.0\n{999999}6. PositionY: 0.0\n{999999}7. PositionZ: 0.0\n{999999}8. RotationX: 0.0\n{999999}9. RotationY: 0.0\n{999999}10. RotationZ: 0.0", ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
						SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}You must create the center object first.");
						return 1;
					}

				    new Float:_pos[3]; GetObjectPos(ObjectCenter, _pos[0], _pos[1], _pos[2]);
					format(info, 128, "Map position Y: %f", _pos[1]);
				    ShowPlayerDialog_A(playerid, 810, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
				    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	            }
	            case 6:
	            {
	                if(ObjectCenter == 0)
					{
					    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				    	ShowPlayerDialog_A(playerid, 808, DIALOG_STYLE_LIST, "Map editor", "1. Add a new object\n2. Destroy an object\n3. Center position\n{999999}4. Move map\n{999999}5. PositionX: 0.0\n{999999}6. PositionY: 0.0\n{999999}7. PositionZ: 0.0\n{999999}8. RotationX: 0.0\n{999999}9. RotationY: 0.0\n{999999}10. RotationZ: 0.0", ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
						SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}You must create the center object first.");
						return 1;
					}

				    new Float:_pos[3]; GetObjectPos(ObjectCenter, _pos[0], _pos[1], _pos[2]);
					format(info, 128, "Map position Z: %f", _pos[2]);
				    ShowPlayerDialog_A(playerid, 811, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
				    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	            }
	            case 7:
	            {
	                if(ObjectCenter == 0)
					{
					    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				    	ShowPlayerDialog_A(playerid, 808, DIALOG_STYLE_LIST, "Map editor", "1. Add a new object\n2. Destroy an object\n3. Center position\n{999999}4. Move map\n{999999}5. PositionX: 0.0\n{999999}6. PositionY: 0.0\n{999999}7. PositionZ: 0.0\n{999999}8. RotationX: 0.0\n{999999}9. RotationY: 0.0\n{999999}10. RotationZ: 0.0", ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
						SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}You must create the center object first.");
						return 1;
					}
					format(info, 128, "Map offset rotation X: %f", RRot[0]);
				    ShowPlayerDialog_A(playerid, 812, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
				    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	            }
	            case 8:
	            {
	                if(ObjectCenter == 0)
					{
					    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				    	ShowPlayerDialog_A(playerid, 808, DIALOG_STYLE_LIST, "Map editor", "1. Add a new object\n2. Destroy an object\n3. Center position\n{999999}4. Move map\n{999999}5. PositionX: 0.0\n{999999}6. PositionY: 0.0\n{999999}7. PositionZ: 0.0\n{999999}8. RotationX: 0.0\n{999999}9. RotationY: 0.0\n{999999}10. RotationZ: 0.0", ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
						SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}You must create the center object first.");
						return 1;
					}
					format(info, 128, "Map offset rotation Y: %f", RRot[1]);
				    ShowPlayerDialog_A(playerid, 813, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
				    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	            }
	            case 9:
	            {
	                if(ObjectCenter == 0)
					{
					    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				    	ShowPlayerDialog_A(playerid, 808, DIALOG_STYLE_LIST, "Map editor", "1. Add a new object\n2. Destroy an object\n3. Center position\n{999999}4. Move map\n{999999}5. PositionX: 0.0\n{999999}6. PositionY: 0.0\n{999999}7. PositionZ: 0.0\n{999999}8. RotationX: 0.0\n{999999}9. RotationY: 0.0\n{999999}10. RotationZ: 0.0", ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
						SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}You must create the center object first.");
						return 1;
					}
					format(info, 128, "Map offset rotation Z: %f", RRot[2]);
				    ShowPlayerDialog_A(playerid, 814, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
				    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	            }

	        }
	    }
	    else ShowPlayerDialog_A(playerid, 803, DIALOG_STYLE_LIST, "Map editor", "1. Go to map\n2. Edit Map\n3. Edit an object\n4. Export map\n5. Exit (save first!)", ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	}
	if(dialogid == 809)
	{
	    if(response)
	    {
	        new Float:pos;
	        if(sscanf(inputtext, "f", pos))
			{
			    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Bad format.");
			    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				new Float:_pos[3]; GetObjectPos(ObjectCenter, _pos[0], _pos[1], _pos[2]);
				format(info, 128, "Map position X: %f", _pos[0]);
			    ShowPlayerDialog_A(playerid, 809, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
			    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
				return 1;
			}
	        
	        new Float:CenterX, Float:CenterY, Float:CenterZ;
		    GetObjectPos(ObjectCenter, CenterX, CenterY, CenterZ);
            for(new i = 0; i != MAX_MAPMOVER_OBJECTS; i++)
            {
                if(MAPMOVER_OBJECTS[i][ModelID] != 0)
                {
					new Float:aOffSetX, Float:aOffSetY, Float:aOffSetZ;
					aOffSetX = floatsub(MAPMOVER_OBJECTS[i][PositionX], CenterX);
					aOffSetY = floatsub(MAPMOVER_OBJECTS[i][PositionY], CenterY);
					aOffSetZ = floatsub(MAPMOVER_OBJECTS[i][PositionZ], CenterZ);
                    MAPMOVER_OBJECTS[i][OffSetX] = aOffSetX;
                    MAPMOVER_OBJECTS[i][OffSetY] = aOffSetY;
                    MAPMOVER_OBJECTS[i][OffSetZ] = aOffSetZ;
					AttachObjectToObject(MAPMOVER_OBJECTS[i][ObjectID], ObjectCenter, aOffSetX, aOffSetY, aOffSetZ, MAPMOVER_OBJECTS[i][RotationX], MAPMOVER_OBJECTS[i][RotationY], MAPMOVER_OBJECTS[i][RotationZ], true);
                }
            }
            
            
            SetObjectPos(ObjectCenter, pos, CenterY, CenterZ);
	        for(new i = 0; i != MAX_MAPMOVER_OBJECTS; i++)
            {
                if(MAPMOVER_OBJECTS[i][ModelID] != 0)
                {
				    new Float:PX, Float:PY, Float:PZ;
				    new Float:RX, Float:RY, Float:RZ;
				    AttachObjectToObjectEx(ObjectCenter, MAPMOVER_OBJECTS[i][OffSetX], MAPMOVER_OBJECTS[i][OffSetY], MAPMOVER_OBJECTS[i][OffSetZ], MAPMOVER_OBJECTS[i][RotationX], MAPMOVER_OBJECTS[i][RotationY], MAPMOVER_OBJECTS[i][RotationZ], PX, PY, PZ, RX, RY, RZ);

					MAPMOVER_OBJECTS[i][OffSetX] = 0.0;
                    MAPMOVER_OBJECTS[i][OffSetY] = 0.0;
                    MAPMOVER_OBJECTS[i][OffSetZ] = 0.0;

                    DestroyObject(MAPMOVER_OBJECTS[i][ObjectID]);
                    MAPMOVER_OBJECTS[i][ObjectID] = CreateObject(MAPMOVER_OBJECTS[i][ModelID], PX, PY, PZ, RX, RY, RZ);
                    MAPMOVER_OBJECTS[i][PositionX] = PX;
                    MAPMOVER_OBJECTS[i][PositionY] = PY;
                    MAPMOVER_OBJECTS[i][PositionZ] = PZ;
                    MAPMOVER_OBJECTS[i][RotationX] = RX;
                    MAPMOVER_OBJECTS[i][RotationY] = RY;
                    MAPMOVER_OBJECTS[i][RotationZ] = RZ;
                    if(MAPMOVER_OBJECTS[i][ObjectTextured] == 1)
					{
                        for(new s = 0; s != sizeof(MAPMOVER_TEXTURES[]); s++)
						{
						    if(MAPMOVER_TEXTURES[i][s][IndexTextured] == 1)
						    {
						        MAPMOVER_TEXTURES[i][s][M_ObjectID] = MAPMOVER_OBJECTS[i][ObjectID];
				        		SetObjectMaterial(MAPMOVER_TEXTURES[i][s][M_ObjectID], MAPMOVER_TEXTURES[i][s][M_Index], MAPMOVER_TEXTURES[i][s][M_Modelid],  MAPMOVER_TEXTURES[i][s][M_Txd], MAPMOVER_TEXTURES[i][s][M_Texture], MAPMOVER_TEXTURES[i][s][M_Color]);
							}
						}
					}

					if(MAPMOVER_OBJECTS[i][ObjectTextTextured] == 1)
					{
                        for(new s = 0; s != sizeof(TEXT_TEXTURE_MAPMOVER_OBJECT[]); s++)
						{
						    if(TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_IndexTextured] == 1)
						    {
						        TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_ObjectID] = MAPMOVER_OBJECTS[i][ObjectID];
				        		SetObjectMaterialText(TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_ObjectID],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_Text],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_MaterialIndex],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_MaterialSize],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_FontFace],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_FontSize],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_Bold],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_FontColor],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_BackColor],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_TextAlignment]);
							}
						}
					}
				}
		    }
		    new Float:_pos[3]; GetObjectPos(ObjectCenter, _pos[0], _pos[1], _pos[2]);
			format(info, 512, "1. Add a new object\n2. Destroy an object\n3. Center position\n4. Move map\n5. PositionX: %f\n6. PositionY: %f\n7. PositionZ: %f\n8. OffSet RotX: %f\n9. OffSet RotY: %f\n10. OffSet RotZ: %f", _pos[0], _pos[1], _pos[2], RRot[0], RRot[1], RRot[2]);
		    ShowPlayerDialog_A(playerid, 808, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	        
	    }
	    else
	    {
		    new Float:_pos[3]; GetObjectPos(ObjectCenter, _pos[0], _pos[1], _pos[2]);
			format(info, 512, "1. Add a new object\n2. Destroy an object\n3. Center position\n4. Move map\n5. PositionX: %f\n6. PositionY: %f\n7. PositionZ: %f\n8. OffSet RotX: %f\n9. OffSet RotY: %f\n10. OffSet RotZ: %f", _pos[0], _pos[1], _pos[2], RRot[0], RRot[1], RRot[2]);
		    ShowPlayerDialog_A(playerid, 808, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	}
	
	if(dialogid == 810)
	{
	    if(response)
	    {
	        new Float:pos;
	        if(sscanf(inputtext, "f", pos))
			{
			    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Bad format.");
			    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				new Float:_pos[3]; GetObjectPos(ObjectCenter, _pos[0], _pos[1], _pos[2]);
				format(info, 128, "Map position Y: %f", _pos[1]);
			    ShowPlayerDialog_A(playerid, 810, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
			    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
				return 1;
			}

	        new Float:CenterX, Float:CenterY, Float:CenterZ;
		    GetObjectPos(ObjectCenter, CenterX, CenterY, CenterZ);
            for(new i = 0; i != MAX_MAPMOVER_OBJECTS; i++)
            {
                if(MAPMOVER_OBJECTS[i][ModelID] != 0)
                {
					new Float:aOffSetX, Float:aOffSetY, Float:aOffSetZ;
					aOffSetX = floatsub(MAPMOVER_OBJECTS[i][PositionX], CenterX);
					aOffSetY = floatsub(MAPMOVER_OBJECTS[i][PositionY], CenterY);
					aOffSetZ = floatsub(MAPMOVER_OBJECTS[i][PositionZ], CenterZ);
                    MAPMOVER_OBJECTS[i][OffSetX] = aOffSetX;
                    MAPMOVER_OBJECTS[i][OffSetY] = aOffSetY;
                    MAPMOVER_OBJECTS[i][OffSetZ] = aOffSetZ;
					AttachObjectToObject(MAPMOVER_OBJECTS[i][ObjectID], ObjectCenter, aOffSetX, aOffSetY, aOffSetZ, MAPMOVER_OBJECTS[i][RotationX], MAPMOVER_OBJECTS[i][RotationY], MAPMOVER_OBJECTS[i][RotationZ], true);
                }
            }


            SetObjectPos(ObjectCenter, CenterX, pos, CenterZ);
	        for(new i = 0; i != MAX_MAPMOVER_OBJECTS; i++)
            {
                if(MAPMOVER_OBJECTS[i][ModelID] != 0)
                {
				    new Float:PX, Float:PY, Float:PZ;
				    new Float:RX, Float:RY, Float:RZ;
				    AttachObjectToObjectEx(ObjectCenter, MAPMOVER_OBJECTS[i][OffSetX], MAPMOVER_OBJECTS[i][OffSetY], MAPMOVER_OBJECTS[i][OffSetZ], MAPMOVER_OBJECTS[i][RotationX], MAPMOVER_OBJECTS[i][RotationY], MAPMOVER_OBJECTS[i][RotationZ], PX, PY, PZ, RX, RY, RZ);

					MAPMOVER_OBJECTS[i][OffSetX] = 0.0;
                    MAPMOVER_OBJECTS[i][OffSetY] = 0.0;
                    MAPMOVER_OBJECTS[i][OffSetZ] = 0.0;

                    DestroyObject(MAPMOVER_OBJECTS[i][ObjectID]);
                    MAPMOVER_OBJECTS[i][ObjectID] = CreateObject(MAPMOVER_OBJECTS[i][ModelID], PX, PY, PZ, RX, RY, RZ);
                    MAPMOVER_OBJECTS[i][PositionX] = PX;
                    MAPMOVER_OBJECTS[i][PositionY] = PY;
                    MAPMOVER_OBJECTS[i][PositionZ] = PZ;
                    MAPMOVER_OBJECTS[i][RotationX] = RX;
                    MAPMOVER_OBJECTS[i][RotationY] = RY;
                    MAPMOVER_OBJECTS[i][RotationZ] = RZ;
                    if(MAPMOVER_OBJECTS[i][ObjectTextured] == 1)
					{
                        for(new s = 0; s != sizeof(MAPMOVER_TEXTURES[]); s++)
						{
						    if(MAPMOVER_TEXTURES[i][s][IndexTextured] == 1)
						    {
						        MAPMOVER_TEXTURES[i][s][M_ObjectID] = MAPMOVER_OBJECTS[i][ObjectID];
				        		SetObjectMaterial(MAPMOVER_TEXTURES[i][s][M_ObjectID], MAPMOVER_TEXTURES[i][s][M_Index], MAPMOVER_TEXTURES[i][s][M_Modelid],  MAPMOVER_TEXTURES[i][s][M_Txd], MAPMOVER_TEXTURES[i][s][M_Texture], MAPMOVER_TEXTURES[i][s][M_Color]);
							}
						}
					}

					if(MAPMOVER_OBJECTS[i][ObjectTextTextured] == 1)
					{
                        for(new s = 0; s != sizeof(TEXT_TEXTURE_MAPMOVER_OBJECT[]); s++)
						{
						    if(TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_IndexTextured] == 1)
						    {
						        TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_ObjectID] = MAPMOVER_OBJECTS[i][ObjectID];
				        		SetObjectMaterialText(TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_ObjectID],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_Text],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_MaterialIndex],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_MaterialSize],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_FontFace],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_FontSize],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_Bold],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_FontColor],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_BackColor],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_TextAlignment]);
							}
						}
					}
				}
		    }
		    new Float:_pos[3]; GetObjectPos(ObjectCenter, _pos[0], _pos[1], _pos[2]);
			format(info, 512, "1. Add a new object\n2. Destroy an object\n3. Center position\n4. Move map\n5. PositionX: %f\n6. PositionY: %f\n7. PositionZ: %f\n8. OffSet RotX: %f\n9. OffSet RotY: %f\n10. OffSet RotZ: %f", _pos[0], _pos[1], _pos[2], RRot[0], RRot[1], RRot[2]);
		    ShowPlayerDialog_A(playerid, 808, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;

	    }
	    else
	    {
		    new Float:_pos[3]; GetObjectPos(ObjectCenter, _pos[0], _pos[1], _pos[2]);
			format(info, 512, "1. Add a new object\n2. Destroy an object\n3. Center position\n4. Move map\n5. PositionX: %f\n6. PositionY: %f\n7. PositionZ: %f\n8. OffSet RotX: %f\n9. OffSet RotY: %f\n10. OffSet RotZ: %f", _pos[0], _pos[1], _pos[2], RRot[0], RRot[1], RRot[2]);
		    ShowPlayerDialog_A(playerid, 808, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	}
	
	if(dialogid == 811)
	{
	    if(response)
	    {
	        new Float:pos;
	        if(sscanf(inputtext, "f", pos))
			{
			    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Bad format.");
			    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				new Float:_pos[3]; GetObjectPos(ObjectCenter, _pos[0], _pos[1], _pos[2]);
				format(info, 128, "Map position Z: %f", _pos[2]);
			    ShowPlayerDialog_A(playerid, 811, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
			    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
				return 1;
			}

	        new Float:CenterX, Float:CenterY, Float:CenterZ;
		    GetObjectPos(ObjectCenter, CenterX, CenterY, CenterZ);
            for(new i = 0; i != MAX_MAPMOVER_OBJECTS; i++)
            {
                if(MAPMOVER_OBJECTS[i][ModelID] != 0)
                {
					new Float:aOffSetX, Float:aOffSetY, Float:aOffSetZ;
					aOffSetX = floatsub(MAPMOVER_OBJECTS[i][PositionX], CenterX);
					aOffSetY = floatsub(MAPMOVER_OBJECTS[i][PositionY], CenterY);
					aOffSetZ = floatsub(MAPMOVER_OBJECTS[i][PositionZ], CenterZ);
                    MAPMOVER_OBJECTS[i][OffSetX] = aOffSetX;
                    MAPMOVER_OBJECTS[i][OffSetY] = aOffSetY;
                    MAPMOVER_OBJECTS[i][OffSetZ] = aOffSetZ;
					AttachObjectToObject(MAPMOVER_OBJECTS[i][ObjectID], ObjectCenter, aOffSetX, aOffSetY, aOffSetZ, MAPMOVER_OBJECTS[i][RotationX], MAPMOVER_OBJECTS[i][RotationY], MAPMOVER_OBJECTS[i][RotationZ], true);
                }
            }


            SetObjectPos(ObjectCenter, CenterX, CenterY, pos);
	        for(new i = 0; i != MAX_MAPMOVER_OBJECTS; i++)
            {
                if(MAPMOVER_OBJECTS[i][ModelID] != 0)
                {
				    new Float:PX, Float:PY, Float:PZ;
				    new Float:RX, Float:RY, Float:RZ;
				    AttachObjectToObjectEx(ObjectCenter, MAPMOVER_OBJECTS[i][OffSetX], MAPMOVER_OBJECTS[i][OffSetY], MAPMOVER_OBJECTS[i][OffSetZ], MAPMOVER_OBJECTS[i][RotationX], MAPMOVER_OBJECTS[i][RotationY], MAPMOVER_OBJECTS[i][RotationZ], PX, PY, PZ, RX, RY, RZ);

					MAPMOVER_OBJECTS[i][OffSetX] = 0.0;
                    MAPMOVER_OBJECTS[i][OffSetY] = 0.0;
                    MAPMOVER_OBJECTS[i][OffSetZ] = 0.0;

                    DestroyObject(MAPMOVER_OBJECTS[i][ObjectID]);
                    MAPMOVER_OBJECTS[i][ObjectID] = CreateObject(MAPMOVER_OBJECTS[i][ModelID], PX, PY, PZ, RX, RY, RZ);
                    MAPMOVER_OBJECTS[i][PositionX] = PX;
                    MAPMOVER_OBJECTS[i][PositionY] = PY;
                    MAPMOVER_OBJECTS[i][PositionZ] = PZ;
                    MAPMOVER_OBJECTS[i][RotationX] = RX;
                    MAPMOVER_OBJECTS[i][RotationY] = RY;
                    MAPMOVER_OBJECTS[i][RotationZ] = RZ;
                    if(MAPMOVER_OBJECTS[i][ObjectTextured] == 1)
					{
                        for(new s = 0; s != sizeof(MAPMOVER_TEXTURES[]); s++)
						{
						    if(MAPMOVER_TEXTURES[i][s][IndexTextured] == 1)
						    {
						        MAPMOVER_TEXTURES[i][s][M_ObjectID] = MAPMOVER_OBJECTS[i][ObjectID];
				        		SetObjectMaterial(MAPMOVER_TEXTURES[i][s][M_ObjectID], MAPMOVER_TEXTURES[i][s][M_Index], MAPMOVER_TEXTURES[i][s][M_Modelid],  MAPMOVER_TEXTURES[i][s][M_Txd], MAPMOVER_TEXTURES[i][s][M_Texture], MAPMOVER_TEXTURES[i][s][M_Color]);
							}
						}
					}

					if(MAPMOVER_OBJECTS[i][ObjectTextTextured] == 1)
					{
                        for(new s = 0; s != sizeof(TEXT_TEXTURE_MAPMOVER_OBJECT[]); s++)
						{
						    if(TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_IndexTextured] == 1)
						    {
						        TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_ObjectID] = MAPMOVER_OBJECTS[i][ObjectID];
				        		SetObjectMaterialText(TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_ObjectID],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_Text],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_MaterialIndex],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_MaterialSize],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_FontFace],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_FontSize],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_Bold],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_FontColor],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_BackColor],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_TextAlignment]);
							}
						}
					}
				}
		    }
		    new Float:_pos[3]; GetObjectPos(ObjectCenter, _pos[0], _pos[1], _pos[2]);
			format(info, 512, "1. Add a new object\n2. Destroy an object\n3. Center position\n4. Move map\n5. PositionX: %f\n6. PositionY: %f\n7. PositionZ: %f\n8. OffSet RotX: %f\n9. OffSet RotY: %f\n10. OffSet RotZ: %f", _pos[0], _pos[1], _pos[2], RRot[0], RRot[1], RRot[2]);
		    ShowPlayerDialog_A(playerid, 808, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;

	    }
	    else
	    {
		    new Float:_pos[3]; GetObjectPos(ObjectCenter, _pos[0], _pos[1], _pos[2]);
			format(info, 512, "1. Add a new object\n2. Destroy an object\n3. Center position\n4. Move map\n5. PositionX: %f\n6. PositionY: %f\n7. PositionZ: %f\n8. OffSet RotX: %f\n9. OffSet RotY: %f\n10. OffSet RotZ: %f", _pos[0], _pos[1], _pos[2], RRot[0], RRot[1], RRot[2]);
		    ShowPlayerDialog_A(playerid, 808, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	}

	if(dialogid == 812)
	{
	    if(response)
	    {
	        new Float:pos;
	        if(sscanf(inputtext, "f", pos))
			{
			    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Bad format.");
			    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				new Float:_pos[3]; GetObjectRot(ObjectCenter, _pos[0], _pos[1], _pos[2]);
				format(info, 128, "Map offset rotation X: %f", _pos[0]);
			    ShowPlayerDialog_A(playerid, 812, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
			    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
				return 1;
			}

	        new Float:CenterX, Float:CenterY, Float:CenterZ;
		    GetObjectPos(ObjectCenter, CenterX, CenterY, CenterZ);
		    new Float:CenterRX, Float:CenterRY, Float:CenterRZ;
		    GetObjectRot(ObjectCenter, CenterRX, CenterRY, CenterRZ);
		    
		    SetObjectRot(ObjectCenter, 0.0, 0.0, 0.0);
            for(new i = 0; i != MAX_MAPMOVER_OBJECTS; i++)
            {
                if(MAPMOVER_OBJECTS[i][ModelID] != 0)
                {
					new Float:aOffSetX, Float:aOffSetY, Float:aOffSetZ;
					aOffSetX = floatsub(MAPMOVER_OBJECTS[i][PositionX], CenterX);
					aOffSetY = floatsub(MAPMOVER_OBJECTS[i][PositionY], CenterY);
					aOffSetZ = floatsub(MAPMOVER_OBJECTS[i][PositionZ], CenterZ);
                    MAPMOVER_OBJECTS[i][OffSetX] = aOffSetX;
                    MAPMOVER_OBJECTS[i][OffSetY] = aOffSetY;
                    MAPMOVER_OBJECTS[i][OffSetZ] = aOffSetZ;
					AttachObjectToObject(MAPMOVER_OBJECTS[i][ObjectID], ObjectCenter, aOffSetX, aOffSetY, aOffSetZ, MAPMOVER_OBJECTS[i][RotationX], MAPMOVER_OBJECTS[i][RotationY], MAPMOVER_OBJECTS[i][RotationZ], true);
                }
            }


            SetObjectRot(ObjectCenter, pos, CenterRY, CenterRZ);
            RRot[0] += pos;
	        for(new i = 0; i != MAX_MAPMOVER_OBJECTS; i++)
            {
                if(MAPMOVER_OBJECTS[i][ModelID] != 0)
                {
				    new Float:PX, Float:PY, Float:PZ;
				    new Float:RX, Float:RY, Float:RZ;
				    AttachObjectToObjectEx(ObjectCenter, MAPMOVER_OBJECTS[i][OffSetX], MAPMOVER_OBJECTS[i][OffSetY], MAPMOVER_OBJECTS[i][OffSetZ], MAPMOVER_OBJECTS[i][RotationX], MAPMOVER_OBJECTS[i][RotationY], MAPMOVER_OBJECTS[i][RotationZ], PX, PY, PZ, RX, RY, RZ);

					MAPMOVER_OBJECTS[i][OffSetX] = 0.0;
                    MAPMOVER_OBJECTS[i][OffSetY] = 0.0;
                    MAPMOVER_OBJECTS[i][OffSetZ] = 0.0;

                    DestroyObject(MAPMOVER_OBJECTS[i][ObjectID]);
                    MAPMOVER_OBJECTS[i][ObjectID] = CreateObject(MAPMOVER_OBJECTS[i][ModelID], PX, PY, PZ, RX, RY, RZ);
                    MAPMOVER_OBJECTS[i][PositionX] = PX;
                    MAPMOVER_OBJECTS[i][PositionY] = PY;
                    MAPMOVER_OBJECTS[i][PositionZ] = PZ;
                    MAPMOVER_OBJECTS[i][RotationX] = RX;
                    MAPMOVER_OBJECTS[i][RotationY] = RY;
                    MAPMOVER_OBJECTS[i][RotationZ] = RZ;
                    if(MAPMOVER_OBJECTS[i][ObjectTextured] == 1)
					{
                        for(new s = 0; s != sizeof(MAPMOVER_TEXTURES[]); s++)
						{
						    if(MAPMOVER_TEXTURES[i][s][IndexTextured] == 1)
						    {
						        MAPMOVER_TEXTURES[i][s][M_ObjectID] = MAPMOVER_OBJECTS[i][ObjectID];
				        		SetObjectMaterial(MAPMOVER_TEXTURES[i][s][M_ObjectID], MAPMOVER_TEXTURES[i][s][M_Index], MAPMOVER_TEXTURES[i][s][M_Modelid],  MAPMOVER_TEXTURES[i][s][M_Txd], MAPMOVER_TEXTURES[i][s][M_Texture], MAPMOVER_TEXTURES[i][s][M_Color]);
							}
						}
					}

					if(MAPMOVER_OBJECTS[i][ObjectTextTextured] == 1)
					{
                        for(new s = 0; s != sizeof(TEXT_TEXTURE_MAPMOVER_OBJECT[]); s++)
						{
						    if(TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_IndexTextured] == 1)
						    {
						        TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_ObjectID] = MAPMOVER_OBJECTS[i][ObjectID];
				        		SetObjectMaterialText(TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_ObjectID],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_Text],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_MaterialIndex],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_MaterialSize],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_FontFace],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_FontSize],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_Bold],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_FontColor],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_BackColor],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_TextAlignment]);
							}
						}
					}
				}
		    }
		    SetObjectRot(ObjectCenter, 0.0, 0.0, 0.0);
		    new Float:_pos[3]; GetObjectPos(ObjectCenter, _pos[0], _pos[1], _pos[2]);
			format(info, 512, "1. Add a new object\n2. Destroy an object\n3. Center position\n4. Move map\n5. PositionX: %f\n6. PositionY: %f\n7. PositionZ: %f\n8. OffSet RotX: %f\n9. OffSet RotY: %f\n10. OffSet RotZ: %f", _pos[0], _pos[1], _pos[2], RRot[0], RRot[1], RRot[2]);
		    ShowPlayerDialog_A(playerid, 808, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;

	    }
	    else
	    {
		    new Float:_pos[3]; GetObjectPos(ObjectCenter, _pos[0], _pos[1], _pos[2]);
			format(info, 512, "1. Add a new object\n2. Destroy an object\n3. Center position\n4. Move map\n5. PositionX: %f\n6. PositionY: %f\n7. PositionZ: %f\n8. OffSet RotX: %f\n9. OffSet RotY: %f\n10. OffSet RotZ: %f", _pos[0], _pos[1], _pos[2], RRot[0], RRot[1], RRot[2]);
		    ShowPlayerDialog_A(playerid, 808, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	}
	
	if(dialogid == 813)
	{
	    if(response)
	    {
	        new Float:pos;
	        if(sscanf(inputtext, "f", pos))
			{
			    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Bad format.");
			    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				new Float:_pos[3]; GetObjectRot(ObjectCenter, _pos[0], _pos[1], _pos[2]);
				format(info, 128, "Map offset rotation Y: %f", _pos[1]);
			    ShowPlayerDialog_A(playerid, 813, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
			    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
				return 1;
			}

	        new Float:CenterX, Float:CenterY, Float:CenterZ;
		    GetObjectPos(ObjectCenter, CenterX, CenterY, CenterZ);
		    new Float:CenterRX, Float:CenterRY, Float:CenterRZ;
		    GetObjectRot(ObjectCenter, CenterRX, CenterRY, CenterRZ);
		    
		    SetObjectRot(ObjectCenter, 0.0, 0.0, 0.0);
            for(new i = 0; i != MAX_MAPMOVER_OBJECTS; i++)
            {
                if(MAPMOVER_OBJECTS[i][ModelID] != 0)
                {
					new Float:aOffSetX, Float:aOffSetY, Float:aOffSetZ;
					aOffSetX = floatsub(MAPMOVER_OBJECTS[i][PositionX], CenterX);
					aOffSetY = floatsub(MAPMOVER_OBJECTS[i][PositionY], CenterY);
					aOffSetZ = floatsub(MAPMOVER_OBJECTS[i][PositionZ], CenterZ);
                    MAPMOVER_OBJECTS[i][OffSetX] = aOffSetX;
                    MAPMOVER_OBJECTS[i][OffSetY] = aOffSetY;
                    MAPMOVER_OBJECTS[i][OffSetZ] = aOffSetZ;
					AttachObjectToObject(MAPMOVER_OBJECTS[i][ObjectID], ObjectCenter, aOffSetX, aOffSetY, aOffSetZ, MAPMOVER_OBJECTS[i][RotationX], MAPMOVER_OBJECTS[i][RotationY], MAPMOVER_OBJECTS[i][RotationZ], true);
                }
            }


            SetObjectRot(ObjectCenter, CenterRX, pos, CenterRZ);
            RRot[1] += pos;
	        for(new i = 0; i != MAX_MAPMOVER_OBJECTS; i++)
            {
                if(MAPMOVER_OBJECTS[i][ModelID] != 0)
                {
				    new Float:PX, Float:PY, Float:PZ;
				    new Float:RX, Float:RY, Float:RZ;
				    AttachObjectToObjectEx(ObjectCenter, MAPMOVER_OBJECTS[i][OffSetX], MAPMOVER_OBJECTS[i][OffSetY], MAPMOVER_OBJECTS[i][OffSetZ], MAPMOVER_OBJECTS[i][RotationX], MAPMOVER_OBJECTS[i][RotationY], MAPMOVER_OBJECTS[i][RotationZ], PX, PY, PZ, RX, RY, RZ);

					MAPMOVER_OBJECTS[i][OffSetX] = 0.0;
                    MAPMOVER_OBJECTS[i][OffSetY] = 0.0;
                    MAPMOVER_OBJECTS[i][OffSetZ] = 0.0;

                    DestroyObject(MAPMOVER_OBJECTS[i][ObjectID]);
                    MAPMOVER_OBJECTS[i][ObjectID] = CreateObject(MAPMOVER_OBJECTS[i][ModelID], PX, PY, PZ, RX, RY, RZ);
                    MAPMOVER_OBJECTS[i][PositionX] = PX;
                    MAPMOVER_OBJECTS[i][PositionY] = PY;
                    MAPMOVER_OBJECTS[i][PositionZ] = PZ;
                    MAPMOVER_OBJECTS[i][RotationX] = RX;
                    MAPMOVER_OBJECTS[i][RotationY] = RY;
                    MAPMOVER_OBJECTS[i][RotationZ] = RZ;
                    if(MAPMOVER_OBJECTS[i][ObjectTextured] == 1)
					{
                        for(new s = 0; s != sizeof(MAPMOVER_TEXTURES[]); s++)
						{
						    if(MAPMOVER_TEXTURES[i][s][IndexTextured] == 1)
						    {
						        MAPMOVER_TEXTURES[i][s][M_ObjectID] = MAPMOVER_OBJECTS[i][ObjectID];
				        		SetObjectMaterial(MAPMOVER_TEXTURES[i][s][M_ObjectID], MAPMOVER_TEXTURES[i][s][M_Index], MAPMOVER_TEXTURES[i][s][M_Modelid],  MAPMOVER_TEXTURES[i][s][M_Txd], MAPMOVER_TEXTURES[i][s][M_Texture], MAPMOVER_TEXTURES[i][s][M_Color]);
							}
						}
					}

					if(MAPMOVER_OBJECTS[i][ObjectTextTextured] == 1)
					{
                        for(new s = 0; s != sizeof(TEXT_TEXTURE_MAPMOVER_OBJECT[]); s++)
						{
						    if(TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_IndexTextured] == 1)
						    {
						        TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_ObjectID] = MAPMOVER_OBJECTS[i][ObjectID];
				        		SetObjectMaterialText(TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_ObjectID],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_Text],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_MaterialIndex],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_MaterialSize],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_FontFace],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_FontSize],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_Bold],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_FontColor],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_BackColor],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_TextAlignment]);
							}
						}
					}
				}
		    }
		    SetObjectRot(ObjectCenter, 0.0, 0.0, 0.0);
		    new Float:_pos[3]; GetObjectPos(ObjectCenter, _pos[0], _pos[1], _pos[2]);
			format(info, 512, "1. Add a new object\n2. Destroy an object\n3. Center position\n4. Move map\n5. PositionX: %f\n6. PositionY: %f\n7. PositionZ: %f\n8. OffSet RotX: %f\n9. OffSet RotY: %f\n10. OffSet RotZ: %f", _pos[0], _pos[1], _pos[2], RRot[0], RRot[1], RRot[2]);
		    ShowPlayerDialog_A(playerid, 808, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;

	    }
	    else
	    {
		    new Float:_pos[3]; GetObjectPos(ObjectCenter, _pos[0], _pos[1], _pos[2]);
			format(info, 512, "1. Add a new object\n2. Destroy an object\n3. Center position\n4. Move map\n5. PositionX: %f\n6. PositionY: %f\n7. PositionZ: %f\n8. OffSet RotX: %f\n9. OffSet RotY: %f\n10. OffSet RotZ: %f", _pos[0], _pos[1], _pos[2], RRot[0], RRot[1], RRot[2]);
		    ShowPlayerDialog_A(playerid, 808, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	}
	
	if(dialogid == 814)
	{
	    if(response)
	    {
	        new Float:pos;
	        if(sscanf(inputtext, "f", pos))
			{
			    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Bad format.");
			    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				format(info, 128, "Map offset rotation Z: %f", RRot[2]);
			    ShowPlayerDialog_A(playerid, 814, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
			    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
				return 1;
			}

	        new Float:CenterX, Float:CenterY, Float:CenterZ;
		    GetObjectPos(ObjectCenter, CenterX, CenterY, CenterZ);
		    new Float:CenterRX, Float:CenterRY, Float:CenterRZ;
		    GetObjectRot(ObjectCenter, CenterRX, CenterRY, CenterRZ);

            SetObjectRot(ObjectCenter, CenterRX, CenterRY, pos);
            RRot[2] += pos;
	        for(new i = 0; i != MAX_MAPMOVER_OBJECTS; i++)
            {
                if(MAPMOVER_OBJECTS[i][ModelID] != 0)
				{
				    new Float:aOffSetX, Float:aOffSetY, Float:aOffSetZ;
					aOffSetX = floatsub(MAPMOVER_OBJECTS[i][PositionX], CenterX);
					aOffSetY = floatsub(MAPMOVER_OBJECTS[i][PositionY], CenterY);
					aOffSetZ = floatsub(MAPMOVER_OBJECTS[i][PositionZ], CenterZ);
                    MAPMOVER_OBJECTS[i][OffSetX] = aOffSetX;
                    MAPMOVER_OBJECTS[i][OffSetY] = aOffSetY;
                    MAPMOVER_OBJECTS[i][OffSetZ] = aOffSetZ;
                    
				    new Float:PX, Float:PY, Float:PZ;
				    new Float:RX, Float:RY, Float:RZ;
				    AttachObjectToObjectEx(ObjectCenter, MAPMOVER_OBJECTS[i][OffSetX], MAPMOVER_OBJECTS[i][OffSetY], MAPMOVER_OBJECTS[i][OffSetZ], MAPMOVER_OBJECTS[i][RotationX], MAPMOVER_OBJECTS[i][RotationY], MAPMOVER_OBJECTS[i][RotationZ], PX, PY, PZ, RX, RY, RZ);

					MAPMOVER_OBJECTS[i][OffSetX] = 0.0;
                    MAPMOVER_OBJECTS[i][OffSetY] = 0.0;
                    MAPMOVER_OBJECTS[i][OffSetZ] = 0.0;

                    DestroyObject(MAPMOVER_OBJECTS[i][ObjectID]);
                    MAPMOVER_OBJECTS[i][ObjectID] = CreateObject(MAPMOVER_OBJECTS[i][ModelID], PX, PY, PZ, RX, RY, RZ);
                    MAPMOVER_OBJECTS[i][PositionX] = PX;
                    MAPMOVER_OBJECTS[i][PositionY] = PY;
                    MAPMOVER_OBJECTS[i][PositionZ] = PZ;
                    MAPMOVER_OBJECTS[i][RotationX] = RX;
                    MAPMOVER_OBJECTS[i][RotationY] = RY;
                    MAPMOVER_OBJECTS[i][RotationZ] = RZ;
                    if(MAPMOVER_OBJECTS[i][ObjectTextured] == 1)
					{
                        for(new s = 0; s != sizeof(MAPMOVER_TEXTURES[]); s++)
						{
						    if(MAPMOVER_TEXTURES[i][s][IndexTextured] == 1)
						    {
						        MAPMOVER_TEXTURES[i][s][M_ObjectID] = MAPMOVER_OBJECTS[i][ObjectID];
				        		SetObjectMaterial(MAPMOVER_TEXTURES[i][s][M_ObjectID], MAPMOVER_TEXTURES[i][s][M_Index], MAPMOVER_TEXTURES[i][s][M_Modelid],  MAPMOVER_TEXTURES[i][s][M_Txd], MAPMOVER_TEXTURES[i][s][M_Texture], MAPMOVER_TEXTURES[i][s][M_Color]);
							}
						}
					}

					if(MAPMOVER_OBJECTS[i][ObjectTextTextured] == 1)
					{
                        for(new s = 0; s != sizeof(TEXT_TEXTURE_MAPMOVER_OBJECT[]); s++)
						{
						    if(TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_IndexTextured] == 1)
						    {
						        TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_ObjectID] = MAPMOVER_OBJECTS[i][ObjectID];
				        		SetObjectMaterialText(TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_ObjectID],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_Text],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_MaterialIndex],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_MaterialSize],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_FontFace],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_FontSize],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_Bold],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_FontColor],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_BackColor],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_TextAlignment]);
							}
						}
					}
				}
		    }
		    SetObjectRot(ObjectCenter, 0.0, 0.0, 0.0);
		    new Float:_pos[3]; GetObjectPos(ObjectCenter, _pos[0], _pos[1], _pos[2]);
			format(info, 512, "1. Add a new object\n2. Destroy an object\n3. Center position\n4. Move map\n5. PositionX: %f\n6. PositionY: %f\n7. PositionZ: %f\n8. OffSet RotX: %f\n9. OffSet RotY: %f\n10. OffSet RotZ: %f", _pos[0], _pos[1], _pos[2], RRot[0], RRot[1], RRot[2]);
		    ShowPlayerDialog_A(playerid, 808, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;

	    }
	    else
	    {
		    new Float:pos[3]; GetObjectPos(ObjectCenter, pos[0], pos[1], pos[2]);
			format(info, 512, "1. Add a new object\n2. Destroy an object\n3. Center position\n4. Move map\n5. PositionX: %f\n6. PositionY: %f\n7. PositionZ: %f\n8. OffSet RotX: %f\n9. OffSet RotY: %f\n10. OffSet RotZ: %f", pos[0], pos[1], pos[2], RRot[0], RRot[1], RRot[2]);
		    ShowPlayerDialog_A(playerid, 808, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	}
	
	if(dialogid == 804)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0:
	            {
	                new Float:CenterX, Float:CenterY, Float:CenterZ;
				    GetObjectPos(ObjectCenter, CenterX, CenterY, CenterZ);
				    new Float:CenterRX, Float:CenterRY, Float:CenterRZ;
				    GetObjectRot(ObjectCenter, CenterRX, CenterRY, CenterRZ);
				    
				    SetObjectRot(ObjectCenter, 0.0, 0.0, 0.0);
                    for(new i = 0; i != MAX_MAPMOVER_OBJECTS; i++)
                    {
                        if(MAPMOVER_OBJECTS[i][ModelID] != 0)
                        {
							new Float:aOffSetX, Float:aOffSetY, Float:aOffSetZ;
							aOffSetX = floatsub(MAPMOVER_OBJECTS[i][PositionX], CenterX);
							aOffSetY = floatsub(MAPMOVER_OBJECTS[i][PositionY], CenterY);
							aOffSetZ = floatsub(MAPMOVER_OBJECTS[i][PositionZ], CenterZ);
                            MAPMOVER_OBJECTS[i][OffSetX] = aOffSetX;
                            MAPMOVER_OBJECTS[i][OffSetY] = aOffSetY;
                            MAPMOVER_OBJECTS[i][OffSetZ] = aOffSetZ;
							AttachObjectToObject(MAPMOVER_OBJECTS[i][ObjectID], ObjectCenter, aOffSetX, aOffSetY, aOffSetZ, MAPMOVER_OBJECTS[i][RotationX], MAPMOVER_OBJECTS[i][RotationY], MAPMOVER_OBJECTS[i][RotationZ], true);
                        }
                    }
                    Player_MovingObjects[playerid] = 1;
                    EditObject(playerid, ObjectCenter);
                    noclipdata[playerid][cameramode] = CAMERA_MODE_FLY;
	            }
	            case 1:
	            {
	                SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Move the camera to move the map. Press {FFFF00}~k~~PED_DUCK~ {FFFFFF}for stop.");
	                new Float:CenterX, Float:CenterY, Float:CenterZ;
				    GetObjectPos(ObjectCenter, CenterX, CenterY, CenterZ);
				    new Float:CenterRX, Float:CenterRY, Float:CenterRZ;
				    GetObjectRot(ObjectCenter, CenterRX, CenterRY, CenterRZ);

				    SetObjectRot(ObjectCenter, 0.0, 0.0, 0.0);
                    for(new i = 0; i != MAX_MAPMOVER_OBJECTS; i++)
                    {
                        if(MAPMOVER_OBJECTS[i][ModelID] != 0)
                        {
							new Float:aOffSetX, Float:aOffSetY, Float:aOffSetZ;
							aOffSetX = floatsub(MAPMOVER_OBJECTS[i][PositionX], CenterX);
							aOffSetY = floatsub(MAPMOVER_OBJECTS[i][PositionY], CenterY);
							aOffSetZ = floatsub(MAPMOVER_OBJECTS[i][PositionZ], CenterZ);
                            MAPMOVER_OBJECTS[i][OffSetX] = aOffSetX;
                            MAPMOVER_OBJECTS[i][OffSetY] = aOffSetY;
                            MAPMOVER_OBJECTS[i][OffSetZ] = aOffSetZ;
							AttachObjectToObject(MAPMOVER_OBJECTS[i][ObjectID], ObjectCenter, aOffSetX, aOffSetY, aOffSetZ, MAPMOVER_OBJECTS[i][RotationX], MAPMOVER_OBJECTS[i][RotationY], MAPMOVER_OBJECTS[i][RotationZ], true);
						}
                    }
                    new Float:fVX, Float:fVY, Float:fVZ, Float:object_x, Float:object_y, Float:object_z;
					GetPlayerCameraFrontVector(playerid, fVX, fVY, fVZ);
					object_x = floatmul(fVX, 50.0);
					object_y = floatmul(fVY, 50.0);
					object_z = floatmul(fVZ, 50.0);
					CamOffSetX = object_x;
					CamOffSetY = object_y;
					CamOffSetZ = object_z;
					AttachObjectToObject(ObjectCenter, noclipdata[playerid][flyobject], object_x, object_y, object_z, 0.0, 0.0, 0.0, false);
                    Player_MovingObjects[playerid] = 2;
                    noclipdata[playerid][cameramode] = CAMERA_MODE_FLY;
	            }
			}
	    }
	    else 
	    {
	        new Float:pos[3]; GetObjectPos(ObjectCenter, pos[0], pos[1], pos[2]);
			format(info, 512, "1. Add a new object\n2. Destroy an object\n3. Center position\n4. Move map\n5. PositionX: %f\n6. PositionY: %f\n7. PositionZ: %f\n8. OffSet RotX: %f\n9. OffSet RotY: %f\n10. OffSet RotZ: %f", pos[0], pos[1], pos[2], RRot[0], RRot[1], RRot[2]);
		    ShowPlayerDialog_A(playerid, 808, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	}
	if(dialogid == 806)
	{
	    if(response)
	    {
	        if(sscanf(inputtext, "d", inputtext[0]))
			{
			    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Bad format.");
			    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				ShowPlayerDialog_A(playerid, 806, DIALOG_STYLE_INPUT, "Map editor - New object", "Insert the object model ID:\n", "OK", "<<");
				return 1;
			}
	        new Float:pos[3];
			GetObjectPos(noclipdata[playerid][flyobject], pos[0], pos[1], pos[2]);
			new Indexe = GetAviableIndex();
			if(Indexe == -1)
			{
			    if(Index == MAX_MAPMOVER_OBJECTS-1) return SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Map editor can't create new objects.");
				MAPMOVER_OBJECTS[Index][ObjectTextured] = 0;
				MAPMOVER_OBJECTS[Index][ObjectTextTextured] = 0;
				format(MAPMOVER_OBJECTS[Index][VariableName], 32, "");
				MAPMOVER_OBJECTS[Index][ModelID] = inputtext[0];
				MAPMOVER_OBJECTS[Index][PositionX] = pos[0];
				MAPMOVER_OBJECTS[Index][PositionY] = pos[1];
				MAPMOVER_OBJECTS[Index][PositionZ] = pos[2];
				MAPMOVER_OBJECTS[Index][RotationX] = 0.0;
				MAPMOVER_OBJECTS[Index][RotationY] = 0.0;
				MAPMOVER_OBJECTS[Index][RotationZ] = 0.0;
				MAPMOVER_OBJECTS[Index][ObjectID] = CreateObject(MAPMOVER_OBJECTS[Index][ModelID], MAPMOVER_OBJECTS[Index][PositionX], MAPMOVER_OBJECTS[Index][PositionY], MAPMOVER_OBJECTS[Index][PositionZ], MAPMOVER_OBJECTS[Index][RotationX], MAPMOVER_OBJECTS[Index][RotationY], MAPMOVER_OBJECTS[Index][RotationZ]);
				SelectedObject = MAPMOVER_OBJECTS[Index][ObjectID];
				EditObject(playerid, MAPMOVER_OBJECTS[Index][ObjectID]);
	            noclipdata[playerid][cameramode] = CAMERA_MODE_FLY;
				Index ++;
			}
			else
			{
                MAPMOVER_OBJECTS[Indexe][ObjectTextured] = 0;
				MAPMOVER_OBJECTS[Indexe][ObjectTextTextured] = 0;
				format(MAPMOVER_OBJECTS[Indexe][VariableName], 32, "");
				MAPMOVER_OBJECTS[Indexe][ModelID] = inputtext[0];
				MAPMOVER_OBJECTS[Indexe][PositionX] = pos[0];
				MAPMOVER_OBJECTS[Indexe][PositionY] = pos[1];
				MAPMOVER_OBJECTS[Indexe][PositionZ] = pos[2];
				MAPMOVER_OBJECTS[Indexe][RotationX] = 0.0;
				MAPMOVER_OBJECTS[Indexe][RotationY] = 0.0;
				MAPMOVER_OBJECTS[Indexe][RotationZ] = 0.0;
				MAPMOVER_OBJECTS[Indexe][ObjectID] = CreateObject(MAPMOVER_OBJECTS[Indexe][ModelID], MAPMOVER_OBJECTS[Indexe][PositionX], MAPMOVER_OBJECTS[Indexe][PositionY], MAPMOVER_OBJECTS[Indexe][PositionZ], MAPMOVER_OBJECTS[Indexe][RotationX], MAPMOVER_OBJECTS[Indexe][RotationY], MAPMOVER_OBJECTS[Indexe][RotationZ]);
                SelectedObject = MAPMOVER_OBJECTS[Index][ObjectID];
				EditObject(playerid, MAPMOVER_OBJECTS[Indexe][ObjectID]);
	            noclipdata[playerid][cameramode] = CAMERA_MODE_FLY;
			}
	    }
	    else
	    {
     		if(ObjectCenter == 0) format(info, 512, "1. Add a new object\n2. Destroy an object\n3. Center position\n{999999}4. Move map\n{999999}5. PositionX: 0.0\n{999999}6. PositionY: 0.0\n{999999}7. PositionZ: 0.0\n{999999}8. RotationX: 0.0\n{999999}9. RotationY: 0.0\n{999999}10. RotationZ: 0.0");
		    else
			{
			    new Float:pos[3]; GetObjectPos(ObjectCenter, pos[0], pos[1], pos[2]);
				format(info, 512, "1. Add a new object\n2. Destroy an object\n3. Center position\n4. Move map\n5. PositionX: %f\n6. PositionY: %f\n7. PositionZ: %f\n8. OffSet RotX: %f\n9. OffSet RotY: %f\n10. OffSet RotZ: %f", pos[0], pos[1], pos[2], RRot[0], RRot[1], RRot[2]);
			}

		    ShowPlayerDialog_A(playerid, 808, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	}
	if(dialogid == 815)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0:
	            {
	                noclipdata[playerid][cameramode] = CAMERA_MODE_FLY;
	                ConfirmTexture = -1;
	                Player_EditMode[playerid] = 2;
	                // Get position
					new Float:x, Float: y, Float:z, Float:fa;
					GetPlayerCameraPos(playerid, x, y, z);
					fa = GetPlayerCameraFacingAngle(playerid);

					// Calculate position to left of player
					x = (x + 1.75 * floatsin(-fa + -90,degrees));
					y = (y + 1.75 * floatcos(-fa + -90,degrees));

					// Calculate create offset
					x = (x + 4.0 * floatsin(-fa,degrees));
					y = (y + 4.0 * floatcos(-fa,degrees));
					z -= 1.5;
					new index = 0;

					// Out of bounds use default value
					if(index < 1 || index > sizeof(ObjectTextures) - 1) Menu3DData[playerid][CurrTextureIndex] = 1;
					else Menu3DData[playerid][CurrTextureIndex] = index;

					// Make sure we compensate for the end of the list
					if(sizeof(ObjectTextures) - 1 - Menu3DData[playerid][CurrTextureIndex] - 16 < 0) Menu3DData[playerid][CurrTextureIndex] = sizeof(ObjectTextures) - 16 - 1;

					// Player was not in preview mode open editor
					if(Menu3DData[playerid][TPreviewState] == PREVIEW_STATE_NONE)
					{
					    Menu3DData[playerid][Menus3D] = Create3DMenu(playerid, x, y, z, fa, 16);
						Select3DMenu(playerid, Menu3DData[playerid][Menus3D]);
					    Menu3DData[playerid][TPreviewState] = PREVIEW_STATE_ALLTEXTURES;
					    PlayerTextDrawShow(playerid, Menu3DData[playerid][Menu3D_Model_Info]);

						// Update textures
						for(new i = 0; i < 16; i++)
						{
						    SetBoxMaterial(Menu3DData[playerid][Menus3D],i,0,ObjectTextures[i+Menu3DData[playerid][CurrTextureIndex]][TModel],ObjectTextures[i+Menu3DData[playerid][CurrTextureIndex]][TXDName],ObjectTextures[i+Menu3DData[playerid][CurrTextureIndex]][TextureName], 0, 0xFF999999);
						}

						// Update the info texdraw
						UpdateTextureInfo(playerid, SelectedBox[playerid]);
                        SendClientMessage(playerid, -1, " ");
						SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Use {FFFF00}arrow keys {FFFFFF}to change preview. Press {FFFF00}NUMPAD 4/6 {FFFFFF}for change the page.");
                        SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Press {FFFF00}+/- {FFFFFF} to change object materialindex. Press {FFFF00}ENTER {FFFFFF}to apply texture.");
                        SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Press {FFFF00}N {FFFFFF}to go back.");
					}

					// Player specified a new view slot
					else if(Menu3DData[playerid][TPreviewState] == PREVIEW_STATE_ALLTEXTURES)
					{
						for(new i = 0; i < 16; i++)
						{
						    SetBoxMaterial(Menu3DData[playerid][Menus3D],i,0,ObjectTextures[i+Menu3DData[playerid][CurrTextureIndex]][TModel],ObjectTextures[i+Menu3DData[playerid][CurrTextureIndex]][TXDName],ObjectTextures[i+Menu3DData[playerid][CurrTextureIndex]][TextureName], 0, 0xFF999999);

						}

						UpdateTextureInfo(playerid, SelectedBox[playerid]);

				   		SendClientMessage(playerid, -1, " ");
				   		SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Use {FFFF00}arrow keys {FFFFFF}to change preview. Press {FFFF00}NUMPAD 4/6 {FFFFFF}for change the page.");
                        SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Press {FFFF00}+/- {FFFFFF} to change object materialindex. Press {FFFF00}ENTER {FFFFFF}to apply texture.");
                        SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Press {FFFF00}N {FFFFFF}to go back.");
					}
	            }
	            case 1:
	            {
	                #if defined DIALOG_STYLE_TABLIST_HEADERS
		                new dialog[1048];
		                format(dialog, 1048, "Modelid\tTxd name\tTexture name\tMaterial color\n");
		                new Indexe = GetIndexFromObjectID(SelectedObject);
						for(new i = 0; i != 16; i++)
						{
						    if(MAPMOVER_TEXTURES[Indexe][i][IndexTextured] == 1) format(dialog, sizeof(dialog), "%s%d\t%s\t%s\t%d\n", dialog, MAPMOVER_TEXTURES[Indexe][i][M_Modelid], MAPMOVER_TEXTURES[Indexe][i][M_Txd], MAPMOVER_TEXTURES[Indexe][i][M_Texture], MAPMOVER_TEXTURES[Indexe][i][M_Color]);
							else format(dialog, sizeof(dialog), "%s0\tempty\tempty\t0\n", dialog);
						}
						ShowPlayerDialog_A(playerid, 816, 5, "Map editor", dialog, ">>", "<<");
					#else
					    new dialog[1048];
		                new Indexe = GetIndexFromObjectID(SelectedObject);
						for(new i = 0; i != 16; i++)
						{
						    if(MAPMOVER_TEXTURES[Indexe][i][IndexTextured] == 1) format(dialog, sizeof(dialog), "%s%d\t%s\t%s\t%d\n", dialog, MAPMOVER_TEXTURES[Indexe][i][M_Modelid], MAPMOVER_TEXTURES[Indexe][i][M_Txd], MAPMOVER_TEXTURES[Indexe][i][M_Texture], MAPMOVER_TEXTURES[Indexe][i][M_Color]);
							else format(dialog, sizeof(dialog), "%s0\tempty\tempty\t0\n", dialog);
						}
						ShowPlayerDialog_A(playerid, 816, DIALOG_STYLE_LIST, "Map editor", dialog, ">>", "<<");
					#endif
	            }
	        }
		}
		else
		{
		    new Indexer = GetIndexFromObjectID(SelectedObject);
			format(info, 512, "1. Texture object\n2. Text object\n3. Move object\n4. Duplicate object\n5. OriginX: %.4f\n6. OriginY: %.4f\n7. OriginZ: %.4f\n8. OriginRX: %.4f\n9. OriginRY: %.4f\n10. OriginRZ: %.4f\n11. Delete object\n12. Reset object\n13. Change modelid", MAPMOVER_OBJECTS[Indexer][PositionX], MAPMOVER_OBJECTS[Indexer][PositionY], MAPMOVER_OBJECTS[Indexer][PositionZ], MAPMOVER_OBJECTS[Indexer][RotationX], MAPMOVER_OBJECTS[Indexer][RotationY], MAPMOVER_OBJECTS[Indexer][RotationZ]);
	        ShowPlayerDialog_A(playerid, 807, DIALOG_STYLE_LIST, "Map editor - Edit object", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
		}
	}
	if(dialogid == 816)
	{
	    if(response)
	    {
	        new Indexe = GetIndexFromObjectID(SelectedObject);
			if(MAPMOVER_TEXTURES[Indexe][listitem][IndexTextured] == 1) format(info, 512, "You will edit index: %d\n\n\tUse this format:\n\t%d, %s, %s, %d\n\tIndex (from Pottus texture viewer)\n\tWrite 'DELETE' to remove this material index\n\tWrite 'COPY' to copy this index\n\n", listitem, MAPMOVER_TEXTURES[Indexe][listitem][M_Modelid], MAPMOVER_TEXTURES[Indexe][listitem][M_Txd], MAPMOVER_TEXTURES[Indexe][listitem][M_Texture], MAPMOVER_TEXTURES[Indexe][listitem][M_Color]);
			else format(info, 512, "You will edit index: %d\n\n\tUse this formats:\n\tModelID, TXDName, TextureName, MaterialColor (integer)\n\tIndex (from Pottus texture viewer)\n\tWrite 'DELETE' to remove this material index\n\tWrite 'COPY' to copy this index\n\n", listitem);
		    Texture_EditIndex = listitem;
	        ShowPlayerDialog_A(playerid, 817, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	    else ShowPlayerDialog_A(playerid, 815, DIALOG_STYLE_LIST, "Map editor", "Pottus texture viewer\nApply a texture", ">>", "<<");
	}
	if(dialogid == 817)
	{
	    if(response)
	    {
	        new Indexe = GetIndexFromObjectID(SelectedObject);
	        new modelid, txdname[64], texturename[64], materialcolor, mmindex = -1;
	    	if(sscanf(inputtext, "p<,>ds[64]s[64]d", modelid, txdname, texturename, materialcolor))
	    	{
	    	    if(!strcmp(inputtext, "delete", true))
	    	    {
	    	        format(MAPMOVER_OBJECTS[Indexe][VariableName], 32, "");
	    	        MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][IndexTextured] = 0;
		            MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_ObjectID] = 0;
		            MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_Index] = 0;
		            MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_Modelid] = 0;
		            format(MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_Txd], 64, "");
		            format(MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_Texture], 64, "");
		            MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_Color] = 0;
		            new comp;
		            for(new i = 0; i != 16; i++)
					{
						if(MAPMOVER_TEXTURES[Indexe][i][IndexTextured] == 1) comp = 1;
					}
					if(comp == 0) MAPMOVER_OBJECTS[Indexe][ObjectTextured] = 0;
					SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Texture removed.");
                    DestroyObject(SelectedObject);
			    	SelectedObject = RecreateObjectIndex(Indexe);
			        Texture_EditIndex = 0;
			        #if defined DIALOG_STYLE_TABLIST_HEADERS
			            new dialog[1048];
			            format(dialog, 1048, "Modelid\tTxd name\tTexture name\tMaterial color\n");
						for(new i = 0; i != 16; i++)
						{
						    if(MAPMOVER_TEXTURES[Indexe][i][IndexTextured] == 1) format(dialog, sizeof(dialog), "%s%d\t%s\t%s\t%d\n", dialog, MAPMOVER_TEXTURES[Indexe][i][M_Modelid], MAPMOVER_TEXTURES[Indexe][i][M_Txd], MAPMOVER_TEXTURES[Indexe][i][M_Texture], MAPMOVER_TEXTURES[Indexe][i][M_Color]);
							else format(dialog, sizeof(dialog), "%s0\tempty\tempty\t0\n", dialog);
						}
						ShowPlayerDialog_A(playerid, 816, 5, "Map editor", dialog, ">>", "<<");

					#else
					    new dialog[1048];
		                new Indexe = GetIndexFromObjectID(SelectedObject);
						for(new i = 0; i != 16; i++)
						{
						    if(MAPMOVER_TEXTURES[Indexe][i][IndexTextured] == 1) format(dialog, sizeof(dialog), "%s%d\t%s\t%s\t%d\n", dialog, MAPMOVER_TEXTURES[Indexe][i][M_Modelid], MAPMOVER_TEXTURES[Indexe][i][M_Txd], MAPMOVER_TEXTURES[Indexe][i][M_Texture], MAPMOVER_TEXTURES[Indexe][i][M_Color]);
							else format(dialog, sizeof(dialog), "%s0\tempty\tempty\t0\n", dialog);
						}
						ShowPlayerDialog_A(playerid, 816, DIALOG_STYLE_LIST, "Map editor", dialog, ">>", "<<");
					#endif
	    	        return 1;
	    	    }
	    	    if(!strcmp(inputtext, "copy", true))
	    	    {
			        #if defined DIALOG_STYLE_TABLIST_HEADERS
			        	SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Select the new index.");
			            new dialog[1048];
			            format(dialog, 1048, "Modelid\tTxd name\tTexture name\tMaterial color\n");
						for(new i = 0; i != 16; i++)
						{
						    if(MAPMOVER_TEXTURES[Indexe][i][IndexTextured] == 1) format(dialog, sizeof(dialog), "%s%d\t%s\t%s\t%d\n", dialog, MAPMOVER_TEXTURES[Indexe][i][M_Modelid], MAPMOVER_TEXTURES[Indexe][i][M_Txd], MAPMOVER_TEXTURES[Indexe][i][M_Texture], MAPMOVER_TEXTURES[Indexe][i][M_Color]);
							else format(dialog, sizeof(dialog), "%s0\tempty\tempty\t0\n", dialog);
						}
						ShowPlayerDialog_A(playerid, 836, 5, "Map editor", dialog, ">>", "<<");

					#else
					    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Select the new index.");
			            new dialog[1048];
						for(new i = 0; i != 16; i++)
						{
						    if(MAPMOVER_TEXTURES[Indexe][i][IndexTextured] == 1) format(dialog, sizeof(dialog), "%s%d\t%s\t%s\t%d\n", dialog, MAPMOVER_TEXTURES[Indexe][i][M_Modelid], MAPMOVER_TEXTURES[Indexe][i][M_Txd], MAPMOVER_TEXTURES[Indexe][i][M_Texture], MAPMOVER_TEXTURES[Indexe][i][M_Color]);
							else format(dialog, sizeof(dialog), "%s0\tempty\tempty\t0\n", dialog);
						}
						ShowPlayerDialog_A(playerid, 836, DIALOG_STYLE_LIST, "Map editor", dialog, ">>", "<<");
					#endif
	    	        return 1;
	    	    }
	    	    if(!sscanf(inputtext, "d", mmindex))
		    	{
					format(MAPMOVER_OBJECTS[Indexe][VariableName], 32, "MAP_tmpobjid");
		    	    MAPMOVER_OBJECTS[Indexe][ObjectTextured] = 1;
   					MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][IndexTextured] = 1;
		            MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_ObjectID] = SelectedObject;
		            MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_Index] = Texture_EditIndex;
		            MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_Modelid] = ObjectTextures[mmindex][TModel];
		            format(MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_Txd], 64, "%s", ObjectTextures[mmindex][TXDName]);
		            format(MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_Texture], 64, "%s", ObjectTextures[mmindex][TextureName]);
		            MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_Color] = 0;
		            SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Texture applied.");
		            DestroyObject(SelectedObject);
			    	SelectedObject = RecreateObjectIndex(Indexe);
			        Texture_EditIndex = 0;
			        #if defined DIALOG_STYLE_TABLIST_HEADERS
			            new dialog[1048];
			            format(dialog, 1048, "Modelid\tTxd name\tTexture name\tMaterial color\n");
						for(new i = 0; i != 16; i++)
						{
						    if(MAPMOVER_TEXTURES[Indexe][i][IndexTextured] == 1) format(dialog, sizeof(dialog), "%s%d\t%s\t%s\t%d\n", dialog, MAPMOVER_TEXTURES[Indexe][i][M_Modelid], MAPMOVER_TEXTURES[Indexe][i][M_Txd], MAPMOVER_TEXTURES[Indexe][i][M_Texture], MAPMOVER_TEXTURES[Indexe][i][M_Color]);
							else format(dialog, sizeof(dialog), "%s0\tempty\tempty\t0\n", dialog);
						}
						ShowPlayerDialog_A(playerid, 816, 5, "Map editor", dialog, ">>", "<<");

					#else
					    new dialog[1048];
		                new Indexe = GetIndexFromObjectID(SelectedObject);
						for(new i = 0; i != 16; i++)
						{
						    if(MAPMOVER_TEXTURES[Indexe][i][IndexTextured] == 1) format(dialog, sizeof(dialog), "%s%d\t%s\t%s\t%d\n", dialog, MAPMOVER_TEXTURES[Indexe][i][M_Modelid], MAPMOVER_TEXTURES[Indexe][i][M_Txd], MAPMOVER_TEXTURES[Indexe][i][M_Texture], MAPMOVER_TEXTURES[Indexe][i][M_Color]);
							else format(dialog, sizeof(dialog), "%s0\tempty\tempty\t0\n", dialog);
						}
						ShowPlayerDialog_A(playerid, 816, DIALOG_STYLE_LIST, "Map editor", dialog, ">>", "<<");
					#endif
					return 1;
		    	}
		    	
                PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
		    	
				if(MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][IndexTextured] == 1) format(info, 512, "You will edit index: %d\n\n\tUse this format:\n\t%d, %s, %s, %d\n\tIndex (from Pottus texture viewer)\n\tWrite 'DELETE' to remove this material index\n\tWrite 'COPY' to copy this index\n\n", 	Texture_EditIndex,
																																																																										MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_Modelid],
																																																																										MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_Txd],
																																																																										MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_Texture],
																																																																										MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_Color]);
				else format(info, 512, "You will edit index: %d\n\n\tUse this format:\n\tModelID, TXDName, TextureName, MaterialColor (integer)\n\tIndex (from Pottus texture viewer)\n\tWrite 'DELETE' to remove this material index\n\tWrite 'COPY' to copy this index\n\n", Texture_EditIndex);
		        ShowPlayerDialog_A(playerid, 817, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
		        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
		        SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Bad format.");
		        return 1;
	    	}
	    	
			format(MAPMOVER_OBJECTS[Indexe][VariableName], 32, "MAP_tmpobjid");
	    	MAPMOVER_OBJECTS[Indexe][ObjectTextured] = 1;
            MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][IndexTextured] = 1;
            MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_ObjectID] = SelectedObject;
            MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_Index] = Texture_EditIndex;
            MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_Modelid] = modelid;
            format(MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_Txd], 64, "%s", txdname);
            format(MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_Texture], 64, "%s", texturename);
            MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_Color] = materialcolor;
            SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Texture applied.");
	    	DestroyObject(SelectedObject);
	    	SelectedObject = RecreateObjectIndex(Indexe);
	        Texture_EditIndex = 0;
	        #if defined DIALOG_STYLE_TABLIST_HEADERS
	            new dialog[1048];
	            format(dialog, 1048, "Modelid\tTxd name\tTexture name\tMaterial color\n");
				for(new i = 0; i != 16; i++)
				{
				    if(MAPMOVER_TEXTURES[Indexe][i][IndexTextured] == 1) format(dialog, sizeof(dialog), "%s%d\t%s\t%s\t%d\n", dialog, MAPMOVER_TEXTURES[Indexe][i][M_Modelid], MAPMOVER_TEXTURES[Indexe][i][M_Txd], MAPMOVER_TEXTURES[Indexe][i][M_Texture], MAPMOVER_TEXTURES[Indexe][i][M_Color]);
					else format(dialog, sizeof(dialog), "%s0\tempty\tempty\t0\n", dialog);
				}
				ShowPlayerDialog_A(playerid, 816, 5, "Map editor", dialog, ">>", "<<");
				
			#else
			    new dialog[1048];
                new Indexe = GetIndexFromObjectID(SelectedObject);
				for(new i = 0; i != 16; i++)
				{
				    if(MAPMOVER_TEXTURES[Indexe][i][IndexTextured] == 1) format(dialog, sizeof(dialog), "%s%d\t%s\t%s\t%d\n", dialog, MAPMOVER_TEXTURES[Indexe][i][M_Modelid], MAPMOVER_TEXTURES[Indexe][i][M_Txd], MAPMOVER_TEXTURES[Indexe][i][M_Texture], MAPMOVER_TEXTURES[Indexe][i][M_Color]);
					else format(dialog, sizeof(dialog), "%s0\tempty\tempty\t0\n", dialog);
				}
				ShowPlayerDialog_A(playerid, 816, DIALOG_STYLE_LIST, "Map editor", dialog, ">>", "<<");
			#endif
		}
		else
		{
		    #if defined DIALOG_STYLE_TABLIST_HEADERS
	            new dialog[1048];
	            format(dialog, 1048, "Modelid\tTxd name\tTexture name\tMaterial color\n");
	            new Indexe = GetIndexFromObjectID(SelectedObject);
				for(new i = 0; i != 16; i++)
				{
				    if(MAPMOVER_TEXTURES[Indexe][i][IndexTextured] == 1) format(dialog, sizeof(dialog), "%s%d\t%s\t%s\t%d\n", dialog, MAPMOVER_TEXTURES[Indexe][i][M_Modelid], MAPMOVER_TEXTURES[Indexe][i][M_Txd], MAPMOVER_TEXTURES[Indexe][i][M_Texture], MAPMOVER_TEXTURES[Indexe][i][M_Color]);
					else format(dialog, sizeof(dialog), "%s0\tempty\tempty\t0\n", dialog);
				}
				ShowPlayerDialog_A(playerid, 816, 5, "Map editor", dialog, ">>", "<<");
			#else
				new dialog[1048];
                new Indexe = GetIndexFromObjectID(SelectedObject);
				for(new i = 0; i != 16; i++)
				{
				    if(MAPMOVER_TEXTURES[Indexe][i][IndexTextured] == 1) format(dialog, sizeof(dialog), "%s%d\t%s\t%s\t%d\n", dialog, MAPMOVER_TEXTURES[Indexe][i][M_Modelid], MAPMOVER_TEXTURES[Indexe][i][M_Txd], MAPMOVER_TEXTURES[Indexe][i][M_Texture], MAPMOVER_TEXTURES[Indexe][i][M_Color]);
					else format(dialog, sizeof(dialog), "%s0\tempty\tempty\t0\n", dialog);
				}
				ShowPlayerDialog_A(playerid, 816, DIALOG_STYLE_LIST, "Map editor", dialog, ">>", "<<");
			#endif
			
		}
	}
	if(dialogid == 807)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0: ShowPlayerDialog_A(playerid, 815, DIALOG_STYLE_LIST, "Map editor", "Pottus texture viewer\nApply a texture", ">>", "<<");
	            case 1:
	            {
	                #if defined DIALOG_STYLE_TABLIST_HEADERS
		                new dialog[1048];
		                format(dialog, 1048, "Index\tText\n");
		                new Indexe = GetIndexFromObjectID(SelectedObject);
						for(new i = 0; i != 16; i++)
						{
						    if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_IndexTextured] == 1) format(dialog, sizeof(dialog), "%s%d\t%s\n", dialog, i, ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_Text]));
							else format(dialog, sizeof(dialog), "%s%d\tempty\n", dialog, i);
						}
						ShowPlayerDialog_A(playerid, 825, 5, "Map editor", dialog, ">>", "<<");
					#else
						new dialog[1048];
		                new Indexe = GetIndexFromObjectID(SelectedObject);
						for(new i = 0; i != 16; i++)
						{
						    if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_IndexTextured] == 1) format(dialog, sizeof(dialog), "%s%d\t%s\n", dialog, i, ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_Text]));
							else format(dialog, sizeof(dialog), "%s%d\tempty\n", dialog, i);
						}
						ShowPlayerDialog_A(playerid, 825, DIALOG_STYLE_LIST, "Map editor", dialog, ">>", "<<");
					#endif
	            }
	            case 2: EditObject(playerid, SelectedObject), noclipdata[playerid][cameramode] = CAMERA_MODE_FLY;
				case 3: DuplicateObject(SelectedObject);
	            case 4:
				{
					new Float:_pos[3]; GetObjectPos(SelectedObject, _pos[0], _pos[1], _pos[2]);
					format(info, 128, "Object position X: %f", _pos[0]);
				    ShowPlayerDialog_A(playerid, 818, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
				    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
				}
				case 5:
				{
					new Float:_pos[3]; GetObjectPos(SelectedObject, _pos[0], _pos[1], _pos[2]);
					format(info, 128, "Object position Y: %f", _pos[1]);
				    ShowPlayerDialog_A(playerid, 819, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
				    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
				}
				case 6:
				{
					new Float:_pos[3]; GetObjectPos(SelectedObject, _pos[0], _pos[1], _pos[2]);
					format(info, 128, "Object position Z: %f", _pos[2]);
				    ShowPlayerDialog_A(playerid, 820, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
				    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
				}
				case 7:
				{
					new Float:_pos[3]; GetObjectRot(SelectedObject, _pos[0], _pos[1], _pos[2]);
					format(info, 128, "Object rotation X: %f", _pos[0]);
				    ShowPlayerDialog_A(playerid, 821, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
				    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
				}
				case 8:
				{
					new Float:_pos[3]; GetObjectRot(SelectedObject, _pos[0], _pos[1], _pos[2]);
					format(info, 128, "Object rotation Y: %f", _pos[1]);
				    ShowPlayerDialog_A(playerid, 822, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
				    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
				}
				case 9:
				{
					new Float:_pos[3]; GetObjectRot(SelectedObject, _pos[0], _pos[1], _pos[2]);
					format(info, 128, "Object rotation Z: %f", _pos[2]);
				    ShowPlayerDialog_A(playerid, 823, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
				    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
				}
				case 10:
				{
					DeleteMapObject(SelectedObject);
					SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Object deleted.");
					ShowPlayerDialog_A(playerid, 803, DIALOG_STYLE_LIST, "Map editor", "1. Go to map\n2. Edit Map\n3. Edit an object\n4. Export map\n5. Exit (save first!)", ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
				}
				case 11:
				{
					ResetMapObject(SelectedObject);
					SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Object reseted.");
					
					new Indexer = GetIndexFromObjectID(SelectedObject);
					format(info, 512, "1. Texture object\n2. Text object\n3. Move object\n4. Duplicate object\n5. OriginX: %.4f\n6. OriginY: %.4f\n7. OriginZ: %.4f\n8. OriginRX: %.4f\n9. OriginRY: %.4f\n10. OriginRZ: %.4f\n11. Delete object\n12. Reset object\n13. Change modelid", MAPMOVER_OBJECTS[Indexer][PositionX], MAPMOVER_OBJECTS[Indexer][PositionY], MAPMOVER_OBJECTS[Indexer][PositionZ], MAPMOVER_OBJECTS[Indexer][RotationX], MAPMOVER_OBJECTS[Indexer][RotationY], MAPMOVER_OBJECTS[Indexer][RotationZ]);
			        ShowPlayerDialog_A(playerid, 807, DIALOG_STYLE_LIST, "Map editor - Edit object", info, ">>", "<<");
			        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
				}
				case 12:
				{
				    new Indexer = GetIndexFromObjectID(SelectedObject);
					format(info, 128, "Object modelid: %d", MAPMOVER_OBJECTS[Indexer][ModelID]);
				    ShowPlayerDialog_A(playerid, 837, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
				    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
				}
	        }
	    }
	    else ShowPlayerDialog_A(playerid, 803, DIALOG_STYLE_LIST, "Map editor", "1. Go to map\n2. Edit Map\n3. Edit an object\n4. Export map\n5. Exit (save first!)", ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	}
	if(dialogid == 818)
	{
	    if(response)
	    {
	        new Float:pos;
	        if(sscanf(inputtext, "f", pos))
			{
			    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Bad format.");
			    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
			    new Float:_pos[3]; GetObjectPos(SelectedObject, _pos[0], _pos[1], _pos[2]);
				format(info, 128, "Object position X: %f", _pos[0]);
			    ShowPlayerDialog_A(playerid, 818, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
			    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
			    return 1;
			}
			new Indexer = GetIndexFromObjectID(SelectedObject);
	        MAPMOVER_OBJECTS[Indexer][PositionX] = pos;
			SetObjectPos(SelectedObject, MAPMOVER_OBJECTS[Indexer][PositionX], MAPMOVER_OBJECTS[Indexer][PositionY], MAPMOVER_OBJECTS[Indexer][PositionZ]);
			format(info, 512, "1. Texture object\n2. Text object\n3. Move object\n4. Duplicate object\n5. OriginX: %.4f\n6. OriginY: %.4f\n7. OriginZ: %.4f\n8. OriginRX: %.4f\n9. OriginRY: %.4f\n10. OriginRZ: %.4f\n11. Delete object\n12. Reset object\n13. Change modelid", MAPMOVER_OBJECTS[Indexer][PositionX], MAPMOVER_OBJECTS[Indexer][PositionY], MAPMOVER_OBJECTS[Indexer][PositionZ], MAPMOVER_OBJECTS[Indexer][RotationX], MAPMOVER_OBJECTS[Indexer][RotationY], MAPMOVER_OBJECTS[Indexer][RotationZ]);
	        ShowPlayerDialog_A(playerid, 807, DIALOG_STYLE_LIST, "Map editor - Edit object", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	    else
	    {
	        new Indexer = GetIndexFromObjectID(SelectedObject);
			format(info, 512, "1. Texture object\n2. Text object\n3. Move object\n4. Duplicate object\n5. OriginX: %.4f\n6. OriginY: %.4f\n7. OriginZ: %.4f\n8. OriginRX: %.4f\n9. OriginRY: %.4f\n10. OriginRZ: %.4f\n11. Delete object\n12. Reset object\n13. Change modelid", MAPMOVER_OBJECTS[Indexer][PositionX], MAPMOVER_OBJECTS[Indexer][PositionY], MAPMOVER_OBJECTS[Indexer][PositionZ], MAPMOVER_OBJECTS[Indexer][RotationX], MAPMOVER_OBJECTS[Indexer][RotationY], MAPMOVER_OBJECTS[Indexer][RotationZ]);
	        ShowPlayerDialog_A(playerid, 807, DIALOG_STYLE_LIST, "Map editor - Edit object", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	}
	if(dialogid == 819)
	{
	    if(response)
	    {
	        new Float:pos;
	        if(sscanf(inputtext, "f", pos))
			{
			    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Bad format.");
			    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
			    new Float:_pos[3]; GetObjectPos(SelectedObject, _pos[0], _pos[1], _pos[2]);
				format(info, 128, "Object position Y: %f", _pos[1]);
			    ShowPlayerDialog_A(playerid, 819, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
			    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
			    return 1;
			}
			new Indexer = GetIndexFromObjectID(SelectedObject);
	        MAPMOVER_OBJECTS[Indexer][PositionY] = pos;
			SetObjectPos(SelectedObject, MAPMOVER_OBJECTS[Indexer][PositionX], MAPMOVER_OBJECTS[Indexer][PositionY], MAPMOVER_OBJECTS[Indexer][PositionZ]);
			format(info, 512, "1. Texture object\n2. Text object\n3. Move object\n4. Duplicate object\n5. OriginX: %.4f\n6. OriginY: %.4f\n7. OriginZ: %.4f\n8. OriginRX: %.4f\n9. OriginRY: %.4f\n10. OriginRZ: %.4f\n11. Delete object\n12. Reset object\n13. Change modelid", MAPMOVER_OBJECTS[Indexer][PositionX], MAPMOVER_OBJECTS[Indexer][PositionY], MAPMOVER_OBJECTS[Indexer][PositionZ], MAPMOVER_OBJECTS[Indexer][RotationX], MAPMOVER_OBJECTS[Indexer][RotationY], MAPMOVER_OBJECTS[Indexer][RotationZ]);
	        ShowPlayerDialog_A(playerid, 807, DIALOG_STYLE_LIST, "Map editor - Edit object", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	    else
	    {
	        new Indexer = GetIndexFromObjectID(SelectedObject);
			format(info, 512, "1. Texture object\n2. Text object\n3. Move object\n4. Duplicate object\n5. OriginX: %.4f\n6. OriginY: %.4f\n7. OriginZ: %.4f\n8. OriginRX: %.4f\n9. OriginRY: %.4f\n10. OriginRZ: %.4f\n11. Delete object\n12. Reset object\n13. Change modelid", MAPMOVER_OBJECTS[Indexer][PositionX], MAPMOVER_OBJECTS[Indexer][PositionY], MAPMOVER_OBJECTS[Indexer][PositionZ], MAPMOVER_OBJECTS[Indexer][RotationX], MAPMOVER_OBJECTS[Indexer][RotationY], MAPMOVER_OBJECTS[Indexer][RotationZ]);
	        ShowPlayerDialog_A(playerid, 807, DIALOG_STYLE_LIST, "Map editor - Edit object", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	}
	if(dialogid == 820)
	{
	    if(response)
	    {
	        new Float:pos;
	        if(sscanf(inputtext, "f", pos))
			{
			    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Bad format.");
			    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
			    new Float:_pos[3]; GetObjectPos(SelectedObject, _pos[0], _pos[1], _pos[2]);
				format(info, 128, "Object position Z: %f", _pos[2]);
			    ShowPlayerDialog_A(playerid, 820, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
			    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
			    return 1;
			}
			new Indexer = GetIndexFromObjectID(SelectedObject);
	        MAPMOVER_OBJECTS[Indexer][PositionZ] = pos;
			SetObjectPos(SelectedObject, MAPMOVER_OBJECTS[Indexer][PositionX], MAPMOVER_OBJECTS[Indexer][PositionY], MAPMOVER_OBJECTS[Indexer][PositionZ]);
			format(info, 512, "1. Texture object\n2. Text object\n3. Move object\n4. Duplicate object\n5. OriginX: %.4f\n6. OriginY: %.4f\n7. OriginZ: %.4f\n8. OriginRX: %.4f\n9. OriginRY: %.4f\n10. OriginRZ: %.4f\n11. Delete object\n12. Reset object\n13. Change modelid", MAPMOVER_OBJECTS[Indexer][PositionX], MAPMOVER_OBJECTS[Indexer][PositionY], MAPMOVER_OBJECTS[Indexer][PositionZ], MAPMOVER_OBJECTS[Indexer][RotationX], MAPMOVER_OBJECTS[Indexer][RotationY], MAPMOVER_OBJECTS[Indexer][RotationZ]);
	        ShowPlayerDialog_A(playerid, 807, DIALOG_STYLE_LIST, "Map editor - Edit object", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	    else
	    {
	        new Indexer = GetIndexFromObjectID(SelectedObject);
			format(info, 512, "1. Texture object\n2. Text object\n3. Move object\n4. Duplicate object\n5. OriginX: %.4f\n6. OriginY: %.4f\n7. OriginZ: %.4f\n8. OriginRX: %.4f\n9. OriginRY: %.4f\n10. OriginRZ: %.4f\n11. Delete object\n12. Reset object\n13. Change modelid", MAPMOVER_OBJECTS[Indexer][PositionX], MAPMOVER_OBJECTS[Indexer][PositionY], MAPMOVER_OBJECTS[Indexer][PositionZ], MAPMOVER_OBJECTS[Indexer][RotationX], MAPMOVER_OBJECTS[Indexer][RotationY], MAPMOVER_OBJECTS[Indexer][RotationZ]);
	        ShowPlayerDialog_A(playerid, 807, DIALOG_STYLE_LIST, "Map editor - Edit object", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	}
	if(dialogid == 821)
	{
	    if(response)
	    {
	        new Float:pos;
	        if(sscanf(inputtext, "f", pos))
			{
			    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Bad format.");
			    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
			    new Float:_pos[3]; GetObjectRot(SelectedObject, _pos[0], _pos[1], _pos[2]);
				format(info, 128, "Object rotation X: %f", _pos[0]);
			    ShowPlayerDialog_A(playerid, 821, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
			    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
			    return 1;
			}
			new Indexer = GetIndexFromObjectID(SelectedObject);
	        MAPMOVER_OBJECTS[Indexer][RotationX] = pos;
			SetObjectRot(SelectedObject, MAPMOVER_OBJECTS[Indexer][RotationX], MAPMOVER_OBJECTS[Indexer][RotationY], MAPMOVER_OBJECTS[Indexer][RotationZ]);
			format(info, 512, "1. Texture object\n2. Text object\n3. Move object\n4. Duplicate object\n5. OriginX: %.4f\n6. OriginY: %.4f\n7. OriginZ: %.4f\n8. OriginRX: %.4f\n9. OriginRY: %.4f\n10. OriginRZ: %.4f\n11. Delete object\n12. Reset object\n13. Change modelid", MAPMOVER_OBJECTS[Indexer][PositionX], MAPMOVER_OBJECTS[Indexer][PositionY], MAPMOVER_OBJECTS[Indexer][PositionZ], MAPMOVER_OBJECTS[Indexer][RotationX], MAPMOVER_OBJECTS[Indexer][RotationY], MAPMOVER_OBJECTS[Indexer][RotationZ]);
	        ShowPlayerDialog_A(playerid, 807, DIALOG_STYLE_LIST, "Map editor - Edit object", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	    else
	    {
	        new Indexer = GetIndexFromObjectID(SelectedObject);
			format(info, 512, "1. Texture object\n2. Text object\n3. Move object\n4. Duplicate object\n5. OriginX: %.4f\n6. OriginY: %.4f\n7. OriginZ: %.4f\n8. OriginRX: %.4f\n9. OriginRY: %.4f\n10. OriginRZ: %.4f\n11. Delete object\n12. Reset object\n13. Change modelid", MAPMOVER_OBJECTS[Indexer][PositionX], MAPMOVER_OBJECTS[Indexer][PositionY], MAPMOVER_OBJECTS[Indexer][PositionZ], MAPMOVER_OBJECTS[Indexer][RotationX], MAPMOVER_OBJECTS[Indexer][RotationY], MAPMOVER_OBJECTS[Indexer][RotationZ]);
	        ShowPlayerDialog_A(playerid, 807, DIALOG_STYLE_LIST, "Map editor - Edit object", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	}
	if(dialogid == 822)
	{
	    if(response)
	    {
	        new Float:pos;
	        if(sscanf(inputtext, "f", pos))
			{
			    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Bad format.");
			    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
			    new Float:_pos[3]; GetObjectRot(SelectedObject, _pos[0], _pos[1], _pos[2]);
				format(info, 128, "Object rotation Y: %f", _pos[1]);
			    ShowPlayerDialog_A(playerid, 822, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
			    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
			    return 1;
			}
			new Indexer = GetIndexFromObjectID(SelectedObject);
	        MAPMOVER_OBJECTS[Indexer][RotationY] = pos;
			SetObjectRot(SelectedObject, MAPMOVER_OBJECTS[Indexer][RotationX], MAPMOVER_OBJECTS[Indexer][RotationY], MAPMOVER_OBJECTS[Indexer][RotationZ]);
			format(info, 512, "1. Texture object\n2. Text object\n3. Move object\n4. Duplicate object\n5. OriginX: %.4f\n6. OriginY: %.4f\n7. OriginZ: %.4f\n8. OriginRX: %.4f\n9. OriginRY: %.4f\n10. OriginRZ: %.4f\n11. Delete object\n12. Reset object\n13. Change modelid", MAPMOVER_OBJECTS[Indexer][PositionX], MAPMOVER_OBJECTS[Indexer][PositionY], MAPMOVER_OBJECTS[Indexer][PositionZ], MAPMOVER_OBJECTS[Indexer][RotationX], MAPMOVER_OBJECTS[Indexer][RotationY], MAPMOVER_OBJECTS[Indexer][RotationZ]);
	        ShowPlayerDialog_A(playerid, 807, DIALOG_STYLE_LIST, "Map editor - Edit object", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	    else
	    {
	        new Indexer = GetIndexFromObjectID(SelectedObject);
			format(info, 512, "1. Texture object\n2. Text object\n3. Move object\n4. Duplicate object\n5. OriginX: %.4f\n6. OriginY: %.4f\n7. OriginZ: %.4f\n8. OriginRX: %.4f\n9. OriginRY: %.4f\n10. OriginRZ: %.4f\n11. Delete object\n12. Reset object\n13. Change modelid", MAPMOVER_OBJECTS[Indexer][PositionX], MAPMOVER_OBJECTS[Indexer][PositionY], MAPMOVER_OBJECTS[Indexer][PositionZ], MAPMOVER_OBJECTS[Indexer][RotationX], MAPMOVER_OBJECTS[Indexer][RotationY], MAPMOVER_OBJECTS[Indexer][RotationZ]);
	        ShowPlayerDialog_A(playerid, 807, DIALOG_STYLE_LIST, "Map editor - Edit object", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	}
	if(dialogid == 823)
	{
	    if(response)
	    {
	        new Float:pos;
	        if(sscanf(inputtext, "f", pos))
			{
			    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Bad format.");
			    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
			    new Float:_pos[3]; GetObjectRot(SelectedObject, _pos[0], _pos[1], _pos[2]);
				format(info, 128, "Object rotation Z: %f", _pos[2]);
			    ShowPlayerDialog_A(playerid, 823, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
			    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
			    return 1;
			}
			new Indexer = GetIndexFromObjectID(SelectedObject);
	        MAPMOVER_OBJECTS[Indexer][RotationZ] = pos;
			SetObjectRot(SelectedObject, MAPMOVER_OBJECTS[Indexer][RotationX], MAPMOVER_OBJECTS[Indexer][RotationY], MAPMOVER_OBJECTS[Indexer][RotationZ]);
			format(info, 512, "1. Texture object\n2. Text object\n3. Move object\n4. Duplicate object\n5. OriginX: %.4f\n6. OriginY: %.4f\n7. OriginZ: %.4f\n8. OriginRX: %.4f\n9. OriginRY: %.4f\n10. OriginRZ: %.4f\n11. Delete object\n12. Reset object\n13. Change modelid", MAPMOVER_OBJECTS[Indexer][PositionX], MAPMOVER_OBJECTS[Indexer][PositionY], MAPMOVER_OBJECTS[Indexer][PositionZ], MAPMOVER_OBJECTS[Indexer][RotationX], MAPMOVER_OBJECTS[Indexer][RotationY], MAPMOVER_OBJECTS[Indexer][RotationZ]);
	        ShowPlayerDialog_A(playerid, 807, DIALOG_STYLE_LIST, "Map editor - Edit object", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	    else
	    {
	        new Indexer = GetIndexFromObjectID(SelectedObject);
			format(info, 512, "1. Texture object\n2. Text object\n3. Move object\n4. Duplicate object\n5. OriginX: %.4f\n6. OriginY: %.4f\n7. OriginZ: %.4f\n8. OriginRX: %.4f\n9. OriginRY: %.4f\n10. OriginRZ: %.4f\n11. Delete object\n12. Reset object\n13. Change modelid", MAPMOVER_OBJECTS[Indexer][PositionX], MAPMOVER_OBJECTS[Indexer][PositionY], MAPMOVER_OBJECTS[Indexer][PositionZ], MAPMOVER_OBJECTS[Indexer][RotationX], MAPMOVER_OBJECTS[Indexer][RotationY], MAPMOVER_OBJECTS[Indexer][RotationZ]);
	        ShowPlayerDialog_A(playerid, 807, DIALOG_STYLE_LIST, "Map editor - Edit object", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	}
	if(dialogid == 824)
	{
	    if(response)
	    {
            DeleteMapObject(SelectedObject);
     		SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Object deleted.");
			ShowPlayerDialog_A(playerid, 803, DIALOG_STYLE_LIST, "Map editor", "1. Go to map\n2. Edit Map\n3. Edit an object\n4. Export map\n5. Exit (save first!)", ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
		}
	    else
	    {
	        if(ObjectCenter == 0) format(info, 512, "1. Add a new object\n2. Destroy an object\n3. Center position\n{999999}4. Move map\n{999999}5. PositionX: 0.0\n{999999}6. PositionY: 0.0\n{999999}7. PositionZ: 0.0\n{999999}8. RotationX: 0.0\n{999999}9. RotationY: 0.0\n{999999}10. RotationZ: 0.0");
		    else
			{
			    new Float:pos[3]; GetObjectPos(ObjectCenter, pos[0], pos[1], pos[2]);
				format(info, 512, "1. Add a new object\n2. Destroy an object\n3. Center position\n4. Move map\n5. PositionX: %f\n6. PositionY: %f\n7. PositionZ: %f\n8. OffSet RotX: %f\n9. OffSet RotY: %f\n10. OffSet RotZ: %f", pos[0], pos[1], pos[2], RRot[0], RRot[1], RRot[2]);
			}

		    ShowPlayerDialog_A(playerid, 808, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	}
	if(dialogid == 825)
	{
	    if(response)
	    {
	        new Indexe = GetIndexFromObjectID(SelectedObject);
			if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][listitem][I_IndexTextured] == 1) format(info, 512, "Copy index\nDelete index\nText: %s\nMaterialSize: %d\nFontface: %s\nFontsize: %d\nBold: %d\nFontcolor: %d\nBackcolor: %d\nAlignment: %d", 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][listitem][I_Text]),
																																																													TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][listitem][I_MaterialSize],
																																																													TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][listitem][I_FontFace],
																																																													TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][listitem][I_FontSize],
																																																													TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][listitem][I_Bold],
																																																													TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][listitem][I_FontColor],
																																																													TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][listitem][I_BackColor],
																																																													TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][listitem][I_TextAlignment]);

			else format(info, 512, "{999999}Copy index\n{999999}Delete index\nText: empty\nMaterialSize: 0\nFontface: empty\nFontsize: 0\nBold: 0\nFontcolor: 0\nBackcolor: 0\nAlignment: 0");

			Texture_EditIndex = listitem;
	        ShowPlayerDialog_A(playerid, 826, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	    else
	    {
	        new Indexer = GetIndexFromObjectID(SelectedObject);
			format(info, 512, "1. Texture object\n2. Text object\n3. Move object\n4. Duplicate object\n5. OriginX: %.4f\n6. OriginY: %.4f\n7. OriginZ: %.4f\n8. OriginRX: %.4f\n9. OriginRY: %.4f\n10. OriginRZ: %.4f\n11. Delete object\n12. Reset object\n13. Change modelid", MAPMOVER_OBJECTS[Indexer][PositionX], MAPMOVER_OBJECTS[Indexer][PositionY], MAPMOVER_OBJECTS[Indexer][PositionZ], MAPMOVER_OBJECTS[Indexer][RotationX], MAPMOVER_OBJECTS[Indexer][RotationY], MAPMOVER_OBJECTS[Indexer][RotationZ]);
	        ShowPlayerDialog_A(playerid, 807, DIALOG_STYLE_LIST, "Map editor - Edit object", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	}
	if(dialogid == 826)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0:
	            {
	                new Indexe = GetIndexFromObjectID(SelectedObject);
	                if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 0)
	                {
	                    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
						if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 1) format(info, 512, "Copy index\nDelete index\nText: %s\nMaterialSize: %d\nFontface: %s\nFontsize: %d\nBold: %d\nFontcolor: %d\nBackcolor: %d\nAlignment: %d", 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]),
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);

						else format(info, 512, "{999999}Copy index\n{999999}Delete index\nText: empty\nMaterialSize: 0\nFontface: empty\nFontsize: 0\nBold: 0\nFontcolor: 0\nBackcolor: 0\nAlignment: 0");
				        ShowPlayerDialog_A(playerid, 826, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
				        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	                    return 1;
	                }
	                #if defined DIALOG_STYLE_TABLIST_HEADERS
                        SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Select the new index.");
			            new dialog[1048];
			            format(dialog, 1048, "Index\tText\n");
						for(new i = 0; i != 16; i++)
						{
						    if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_IndexTextured] == 1) format(dialog, sizeof(dialog), "%s%d\t%s\n", dialog, i, ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_Text]));
							else format(dialog, sizeof(dialog), "%s%d\tempty\n", dialog, i);
						}
						ShowPlayerDialog_A(playerid, 827, 5, "Map editor", dialog, ">>", "<<");
					#else
						SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Select the new index.");
			            new dialog[1048];
						for(new i = 0; i != 16; i++)
						{
						    if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_IndexTextured] == 1) format(dialog, sizeof(dialog), "%s%d\t%s\n", dialog, i, ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_Text]));
							else format(dialog, sizeof(dialog), "%s%d\tempty\n", dialog, i);
						}
						ShowPlayerDialog_A(playerid, 827, DIALOG_STYLE_LIST, "Map editor", dialog, ">>", "<<");
					#endif
	            }
	            case 1:
	            {
	                new Indexe = GetIndexFromObjectID(SelectedObject);
	                if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 0)
	                {
	                    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
						if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 1) format(info, 512, "Copy index\nDelete index\nText: %s\nMaterialSize: %d\nFontface: %s\nFontsize: %d\nBold: %d\nFontcolor: %d\nBackcolor: %d\nAlignment: %d", 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]),
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);

						else format(info, 512, "{999999}Copy index\n{999999}Delete index\nText: empty\nMaterialSize: 0\nFontface: empty\nFontsize: 0\nBold: 0\nFontcolor: 0\nBackcolor: 0\nAlignment: 0");
				        ShowPlayerDialog_A(playerid, 826, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
				        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	                    return 1;
	                }
	                SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Index deleted.");
			        DeleteTextIndex(Indexe, Texture_EditIndex);
			        DestroyObject(SelectedObject);
			        SelectedObject = RecreateObjectIndex(Indexe);
			        Texture_EditIndex = 0;
					#if defined DIALOG_STYLE_TABLIST_HEADERS
		                new dialog[1048];
		                format(dialog, 1048, "Index\tText\n");
						for(new i = 0; i != 16; i++)
						{
						    if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_IndexTextured] == 1) format(dialog, sizeof(dialog), "%s%d\t%s\n", dialog, i, ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_Text]));
							else format(dialog, sizeof(dialog), "%s%d\tempty\n", dialog, i);
						}
						ShowPlayerDialog_A(playerid, 825, 5, "Map editor", dialog, ">>", "<<");
					#else
					    new dialog[1048];
		                new Indexe = GetIndexFromObjectID(SelectedObject);
						for(new i = 0; i != 16; i++)
						{
						    if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_IndexTextured] == 1) format(dialog, sizeof(dialog), "%s%d\t%s\n", dialog, i, ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_Text]));
							else format(dialog, sizeof(dialog), "%s%d\tempty\n", dialog, i);
						}
						ShowPlayerDialog_A(playerid, 825, DIALOG_STYLE_LIST, "Map editor", dialog, ">>", "<<");
					#endif
	            }
	            case 2:
	            {
	                new Indexe = GetIndexFromObjectID(SelectedObject);
					format(info, 128, "Object text: %s", ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]));
				    ShowPlayerDialog_A(playerid, 828, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
				    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	            }
	            case 3:
	            {
	                new Indexe = GetIndexFromObjectID(SelectedObject);
	                if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 0)
	                {
	                    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Apply any text first.");
	                    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
						if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 1) format(info, 512, "Copy index\nDelete index\nText: %s\nMaterialSize: %d\nFontface: %s\nFontsize: %d\nBold: %d\nFontcolor: %d\nBackcolor: %d\nAlignment: %d", 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]),
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);

						else format(info, 512, "{999999}Copy index\n{999999}Delete index\nText: empty\nMaterialSize: 0\nFontface: empty\nFontsize: 0\nBold: 0\nFontcolor: 0\nBackcolor: 0\nAlignment: 0");
				        ShowPlayerDialog_A(playerid, 826, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
				        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	                    return 1;
	                }
	                new sizes[600], stre[64];
	                #if defined DIALOG_STYLE_TABLIST_HEADERS
						format(stre, 64, "Current size: %d\n", TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize]);
		                strcat(sizes, stre);
						strcat(sizes,"{EEEA00}1. {00A7EE}32x32 {C4C4C4}(10)\
									\n{EEEA00}2. {00A7EE}64x32 {C4C4C4}(20)\
									\n{EEEA00}3. {00A7EE}64x64 {C4C4C4}(30)\
									\n{EEEA00}4. {00A7EE}128x32 {C4C4C4}(40)\
									\n{EEEA00}5. {00A7EE}128x64 {C4C4C4}(50)\
									\n{EEEA00}6. {00A7EE}128x128 {C4C4C4}(60)\
									\n{EEEA00}7. {00A7EE}256x32 {C4C4C4}(70)");
						strcat(sizes,"\n{EEEA00}8. {00A7EE}256x64 {C4C4C4}(80)\
									\n{EEEA00}9. {00A7EE}256x128 {C4C4C4}(90)\
									\n{EEEA00}10. {00A7EE}256x256 {C4C4C4}(100)\
									\n{EEEA00}11. {00A7EE}512x64 {C4C4C4}(110)\
									\n{EEEA00}12. {00A7EE}512x128 {C4C4C4}(120)\
									\n{EEEA00}13. {00A7EE}512x256 {C4C4C4}(130)\
									\n{EEEA00}14. {00A7EE}512x512 {C4C4C4}(140)");
						ShowPlayerDialog_A(playerid, 829, 5, "Map editor", sizes, ">>","<<");
					#else
						strcat(sizes,"{EEEA00}1. {00A7EE}32x32 {C4C4C4}(10)\
									\n{EEEA00}2. {00A7EE}64x32 {C4C4C4}(20)\
									\n{EEEA00}3. {00A7EE}64x64 {C4C4C4}(30)\
									\n{EEEA00}4. {00A7EE}128x32 {C4C4C4}(40)\
									\n{EEEA00}5. {00A7EE}128x64 {C4C4C4}(50)\
									\n{EEEA00}6. {00A7EE}128x128 {C4C4C4}(60)\
									\n{EEEA00}7. {00A7EE}256x32 {C4C4C4}(70)");
						strcat(sizes,"\n{EEEA00}8. {00A7EE}256x64 {C4C4C4}(80)\
									\n{EEEA00}9. {00A7EE}256x128 {C4C4C4}(90)\
									\n{EEEA00}10. {00A7EE}256x256 {C4C4C4}(100)\
									\n{EEEA00}11. {00A7EE}512x64 {C4C4C4}(110)\
									\n{EEEA00}12. {00A7EE}512x128 {C4C4C4}(120)\
									\n{EEEA00}13. {00A7EE}512x256 {C4C4C4}(130)\
									\n{EEEA00}14. {00A7EE}512x512 {C4C4C4}(140)");
						ShowPlayerDialog_A(playerid, 829, DIALOG_STYLE_LIST, "Map editor", sizes, ">>","<<");
					#endif
	            }
	            case 4:
	            {
                	new Indexe = GetIndexFromObjectID(SelectedObject);
	                if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 0)
	                {
	                    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Apply any text first.");
	                    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
						if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 1) format(info, 512, "Copy index\nDelete index\nText: %s\nMaterialSize: %d\nFontface: %s\nFontsize: %d\nBold: %d\nFontcolor: %d\nBackcolor: %d\nAlignment: %d", 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]),
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);

						else format(info, 512, "{999999}Copy index\n{999999}Delete index\nText: empty\nMaterialSize: 0\nFontface: empty\nFontsize: 0\nBold: 0\nFontcolor: 0\nBackcolor: 0\nAlignment: 0");
				        ShowPlayerDialog_A(playerid, 826, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
				        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	                    return 1;
	                }
					format(info, 128, "Object font: %s", TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace]);
				    ShowPlayerDialog_A(playerid, 830, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
				    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	            }
	            case 5:
	            {
                	new Indexe = GetIndexFromObjectID(SelectedObject);
	                if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 0)
	                {
	                    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Apply any text first.");
	                    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
						if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 1) format(info, 512, "Copy index\nDelete index\nText: %s\nMaterialSize: %d\nFontface: %s\nFontsize: %d\nBold: %d\nFontcolor: %d\nBackcolor: %d\nAlignment: %d", 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]),
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);

						else format(info, 512, "{999999}Copy index\n{999999}Delete index\nText: empty\nMaterialSize: 0\nFontface: empty\nFontsize: 0\nBold: 0\nFontcolor: 0\nBackcolor: 0\nAlignment: 0");
				        ShowPlayerDialog_A(playerid, 826, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
				        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	                    return 1;
	                }
					format(info, 128, "Object font size: %d", TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize]);
				    ShowPlayerDialog_A(playerid, 831, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
				    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	            }
	            case 6:
	            {
                	new Indexe = GetIndexFromObjectID(SelectedObject);
	                if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 0)
	                {
	                    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Apply any text first.");
	                    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
						if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 1) format(info, 512, "Copy index\nDelete index\nText: %s\nMaterialSize: %d\nFontface: %s\nFontsize: %d\nBold: %d\nFontcolor: %d\nBackcolor: %d\nAlignment: %d", 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]),
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);

						else format(info, 512, "{999999}Copy index\n{999999}Delete index\nText: empty\nMaterialSize: 0\nFontface: empty\nFontsize: 0\nBold: 0\nFontcolor: 0\nBackcolor: 0\nAlignment: 0");
				        ShowPlayerDialog_A(playerid, 826, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
				        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	                    return 1;
	                }
                    #if defined DIALOG_STYLE_TABLIST_HEADERS
						format(info, 128, "Object font bold: %d\nDISABLE BOLD\nENABLE BOLD", TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold]);
					    ShowPlayerDialog_A(playerid, 832, 5, "Map editor", info, ">>", "<<");
					    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
					#else
					    format(info, 128, "DISABLE BOLD\nENABLE BOLD", TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold]);
					    ShowPlayerDialog_A(playerid, 832, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
					    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
					#endif
	            }
	            case 7:
	            {
                	new Indexe = GetIndexFromObjectID(SelectedObject);
	                if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 0)
	                {
	                    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Apply any text first.");
	                    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
						if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 1) format(info, 512, "Copy index\nDelete index\nText: %s\nMaterialSize: %d\nFontface: %s\nFontsize: %d\nBold: %d\nFontcolor: %d\nBackcolor: %d\nAlignment: %d", 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]),
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);

						else format(info, 512, "{999999}Copy index\n{999999}Delete index\nText: empty\nMaterialSize: 0\nFontface: empty\nFontsize: 0\nBold: 0\nFontcolor: 0\nBackcolor: 0\nAlignment: 0");
				        ShowPlayerDialog_A(playerid, 826, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
				        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	                    return 1;
	                }
					format(info, 128, "Object font color: %d", TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor]);
				    ShowPlayerDialog_A(playerid, 833, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
				    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	            }
	            case 8:
	            {
                	new Indexe = GetIndexFromObjectID(SelectedObject);
	                if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 0)
	                {
	                    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Apply any text first.");
	                    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
						if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 1) format(info, 512, "Copy index\nDelete index\nText: %s\nMaterialSize: %d\nFontface: %s\nFontsize: %d\nBold: %d\nFontcolor: %d\nBackcolor: %d\nAlignment: %d", 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]),
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);

						else format(info, 512, "{999999}Copy index\n{999999}Delete index\nText: empty\nMaterialSize: 0\nFontface: empty\nFontsize: 0\nBold: 0\nFontcolor: 0\nBackcolor: 0\nAlignment: 0");
				        ShowPlayerDialog_A(playerid, 826, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
				        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	                    return 1;
	                }
					format(info, 128, "Object back color: %d", TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor]);
				    ShowPlayerDialog_A(playerid, 834, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
				    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	            }
	            case 9:
	            {
	            	new Indexe = GetIndexFromObjectID(SelectedObject);
	                if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 0)
	                {
	                    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Apply any text first.");
	                    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
						if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 1) format(info, 512, "Copy index\nDelete index\nText: %s\nMaterialSize: %d\nFontface: %s\nFontsize: %d\nBold: %d\nFontcolor: %d\nBackcolor: %d\nAlignment: %d", 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]),
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor],
																																																																		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);

						else format(info, 512, "{999999}Copy index\n{999999}Delete index\nText: empty\nMaterialSize: 0\nFontface: empty\nFontsize: 0\nBold: 0\nFontcolor: 0\nBackcolor: 0\nAlignment: 0");
				        ShowPlayerDialog_A(playerid, 826, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
				        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	                    return 1;
	                }
                	#if defined DIALOG_STYLE_TABLIST_HEADERS
						format(info, 128, "Object text alignment: %d\nLEFT\nCENTERED\nRIGHT", TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);
					    ShowPlayerDialog_A(playerid, 835, 5, "Map editor", info, ">>", "<<");
					    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
					#else
					    format(info, 128, "LEFT\nCENTERED\nRIGHT", TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);
					    ShowPlayerDialog_A(playerid, 835, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
					    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
					#endif
				}
	        }
	    }
		else
		{
		    #if defined DIALOG_STYLE_TABLIST_HEADERS
	            new dialog[1048];
	            format(dialog, 1048, "Index\tText\n");
	            new Indexe = GetIndexFromObjectID(SelectedObject);
				for(new i = 0; i != 16; i++)
				{
				    if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_IndexTextured] == 1) format(dialog, sizeof(dialog), "%s%d\t%s\n", dialog, i, ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_Text]));
					else format(dialog, sizeof(dialog), "%s%d\tempty\n", dialog, i);
				}
				ShowPlayerDialog_A(playerid, 825, 5, "Map editor", dialog, ">>", "<<");
			#else
			    new dialog[1048];
                new Indexe = GetIndexFromObjectID(SelectedObject);
				for(new i = 0; i != 16; i++)
				{
				    if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_IndexTextured] == 1) format(dialog, sizeof(dialog), "%s%d\t%s\n", dialog, i, ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_Text]));
					else format(dialog, sizeof(dialog), "%s%d\tempty\n", dialog, i);
				}
				ShowPlayerDialog_A(playerid, 825, DIALOG_STYLE_LIST, "Map editor", dialog, ">>", "<<");
			#endif
		}
	}
	if(dialogid == 827)
	{
	    if(response)
	    {
	        SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Index copied.");
	        new Indexe = GetIndexFromObjectID(SelectedObject);
	        CopyTextIndex(Indexe, Texture_EditIndex, listitem);
	        DestroyObject(SelectedObject);
	        SelectedObject = RecreateObjectIndex(Indexe);
			#if defined DIALOG_STYLE_TABLIST_HEADERS
                new dialog[1048];
                format(dialog, 1048, "Index\tText\n");
				for(new i = 0; i != 16; i++)
				{
				    if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_IndexTextured] == 1) format(dialog, sizeof(dialog), "%s%d\t%s\n", dialog, i, ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_Text]));
					else format(dialog, sizeof(dialog), "%s%d\tempty\n", dialog, i);
				}
				ShowPlayerDialog_A(playerid, 825, 5, "Map editor", dialog, ">>", "<<");
			#else
				new dialog[1048];
                new Indexe = GetIndexFromObjectID(SelectedObject);
				for(new i = 0; i != 16; i++)
				{
				    if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_IndexTextured] == 1) format(dialog, sizeof(dialog), "%s%d\t%s\n", dialog, i, ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_Text]));
					else format(dialog, sizeof(dialog), "%s%d\tempty\n", dialog, i);
				}
				ShowPlayerDialog_A(playerid, 825, DIALOG_STYLE_LIST, "Map editor", dialog, ">>", "<<");
			#endif
	    }
	    else
	    {
	        new Indexe = GetIndexFromObjectID(SelectedObject);
			if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 1) format(info, 512, "Copy index\nDelete index\nText: %s\nMaterialSize: %d\nFontface: %s\nFontsize: %d\nBold: %d\nFontcolor: %d\nBackcolor: %d\nAlignment: %d", 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]),
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);

			else format(info, 512, "{999999}Copy index\n{999999}Delete index\nText: empty\nMaterialSize: 0\nFontface: empty\nFontsize: 0\nBold: 0\nFontcolor: 0\nBackcolor: 0\nAlignment: 0");
	        ShowPlayerDialog_A(playerid, 826, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	}
	if(dialogid == 828)
	{
	    if(response)
	    {
	        new Indexe = GetIndexFromObjectID(SelectedObject);
	        if(isnull(inputtext))
			{
			    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Bad format.");
			    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				format(info, 128, "Object text: %s", ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]));
			    ShowPlayerDialog_A(playerid, 828, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
			    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
			    return 1;
			}
			if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 0)
			{
			    format(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace], 64, "Arial");
			    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize] = 24;
			    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize] = 90;
                TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor] = -1;
                TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor] = 256;
			}
			TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] = 1;
			MAPMOVER_OBJECTS[Indexe][ObjectTextTextured] = 1;
			new newline = strfind(inputtext, "\\n", true);
			if(newline != -1)
			{
			    strdel(inputtext, newline, newline+2);
			    strins(inputtext, "\n", newline, 256);
			}
	        SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Text applied.");
	        format(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text], 256, "%s", inputtext);
	        DestroyObject(SelectedObject);
	        SelectedObject = RecreateObjectIndex(Indexe);

			if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 1) format(info, 512, "Copy index\nDelete index\nText: %s\nMaterialSize: %d\nFontface: %s\nFontsize: %d\nBold: %d\nFontcolor: %d\nBackcolor: %d\nAlignment: %d", 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]),
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);

			else format(info, 512, "{999999}Copy index\n{999999}Delete index\nText: empty\nMaterialSize: 0\nFontface: empty\nFontsize: 0\nBold: 0\nFontcolor: 0\nBackcolor: 0\nAlignment: 0");
	        ShowPlayerDialog_A(playerid, 826, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	    else
	    {
	        new Indexe = GetIndexFromObjectID(SelectedObject);
			if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 1) format(info, 512, "Copy index\nDelete index\nText: %s\nMaterialSize: %d\nFontface: %s\nFontsize: %d\nBold: %d\nFontcolor: %d\nBackcolor: %d\nAlignment: %d", 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]),
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);

			else format(info, 512, "{999999}Copy index\n{999999}Delete index\nText: empty\nMaterialSize: 0\nFontface: empty\nFontsize: 0\nBold: 0\nFontcolor: 0\nBackcolor: 0\nAlignment: 0");
	        ShowPlayerDialog_A(playerid, 826, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	}
	if(dialogid == 829)
	{
	    if(response)
	    {
	        new Indexe = GetIndexFromObjectID(SelectedObject);
	        switch(listitem)
			{
	            case 0: TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize] = 10;
	            case 1:  TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize] = 20;
	            case 2:  TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize] = 30;
	            case 3:  TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize] = 40;
	            case 4:  TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize] = 50;
	            case 5:  TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize] = 60;
	            case 6:  TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize] = 70;
	            case 7:  TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize] = 80;
	            case 8:  TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize] = 90;
	            case 9:  TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize] = 100;
	            case 10:  TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize] = 110;
	            case 11:  TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize] = 120;
	            case 12:  TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize] = 130;
	            case 13:  TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize] = 140;
	            default: TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize] = 70;
			}
	        SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Material size applied.");
	        DestroyObject(SelectedObject);
	        SelectedObject = RecreateObjectIndex(Indexe);

			if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 1) format(info, 512, "Copy index\nDelete index\nText: %s\nMaterialSize: %d\nFontface: %s\nFontsize: %d\nBold: %d\nFontcolor: %d\nBackcolor: %d\nAlignment: %d", 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]),
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);

			else format(info, 512, "{999999}Copy index\n{999999}Delete index\nText: empty\nMaterialSize: 0\nFontface: empty\nFontsize: 0\nBold: 0\nFontcolor: 0\nBackcolor: 0\nAlignment: 0");
	        ShowPlayerDialog_A(playerid, 826, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	    else
	    {
	        new Indexe = GetIndexFromObjectID(SelectedObject);
			if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 1) format(info, 512, "Copy index\nDelete index\nText: %s\nMaterialSize: %d\nFontface: %s\nFontsize: %d\nBold: %d\nFontcolor: %d\nBackcolor: %d\nAlignment: %d", 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]),
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);

			else format(info, 512, "{999999}Copy index\n{999999}Delete index\nText: empty\nMaterialSize: 0\nFontface: empty\nFontsize: 0\nBold: 0\nFontcolor: 0\nBackcolor: 0\nAlignment: 0");
	        ShowPlayerDialog_A(playerid, 826, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	}
	if(dialogid == 830)
	{
	    if(response)
	    {
	        new Indexe = GetIndexFromObjectID(SelectedObject);
	        if(isnull(inputtext))
			{
			    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Bad format.");
			    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				format(info, 128, "Object font: %s", TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace]);
			    ShowPlayerDialog_A(playerid, 830, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
			    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
			    return 1;
			}
	        SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Font applied.");
	        format(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace], 64, "%s", inputtext);
	        DestroyObject(SelectedObject);
	        SelectedObject = RecreateObjectIndex(Indexe);

			if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 1) format(info, 512, "Copy index\nDelete index\nText: %s\nMaterialSize: %d\nFontface: %s\nFontsize: %d\nBold: %d\nFontcolor: %d\nBackcolor: %d\nAlignment: %d", 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]),
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);

			else format(info, 512, "{999999}Copy index\n{999999}Delete index\nText: empty\nMaterialSize: 0\nFontface: empty\nFontsize: 0\nBold: 0\nFontcolor: 0\nBackcolor: 0\nAlignment: 0");
	        ShowPlayerDialog_A(playerid, 826, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	    else
	    {
	        new Indexe = GetIndexFromObjectID(SelectedObject);
			if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 1) format(info, 512, "Copy index\nDelete index\nText: %s\nMaterialSize: %d\nFontface: %s\nFontsize: %d\nBold: %d\nFontcolor: %d\nBackcolor: %d\nAlignment: %d", 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]),
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);

			else format(info, 512, "{999999}Copy index\n{999999}Delete index\nText: empty\nMaterialSize: 0\nFontface: empty\nFontsize: 0\nBold: 0\nFontcolor: 0\nBackcolor: 0\nAlignment: 0");
	        ShowPlayerDialog_A(playerid, 826, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	}
	if(dialogid == 831)
	{
	    if(response)
	    {
	        new Indexe = GetIndexFromObjectID(SelectedObject);
	        if(sscanf(inputtext, "d", inputtext[0]))
			{
			    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Bad format.");
			    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				format(info, 128, "Object font size: %d", TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize]);
			    ShowPlayerDialog_A(playerid, 831, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
			    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
			    return 1;
			}
	        SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Font size applied.");
	        TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize] = inputtext[0];
	        DestroyObject(SelectedObject);
	        SelectedObject = RecreateObjectIndex(Indexe);

			if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 1) format(info, 512, "Copy index\nDelete index\nText: %s\nMaterialSize: %d\nFontface: %s\nFontsize: %d\nBold: %d\nFontcolor: %d\nBackcolor: %d\nAlignment: %d", 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]),
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);

			else format(info, 512, "{999999}Copy index\n{999999}Delete index\nText: empty\nMaterialSize: 0\nFontface: empty\nFontsize: 0\nBold: 0\nFontcolor: 0\nBackcolor: 0\nAlignment: 0");
	        ShowPlayerDialog_A(playerid, 826, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	    else
	    {
	        new Indexe = GetIndexFromObjectID(SelectedObject);
			if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 1) format(info, 512, "Copy index\nDelete index\nText: %s\nMaterialSize: %d\nFontface: %s\nFontsize: %d\nBold: %d\nFontcolor: %d\nBackcolor: %d\nAlignment: %d", 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]),
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);

			else format(info, 512, "{999999}Copy index\n{999999}Delete index\nText: empty\nMaterialSize: 0\nFontface: empty\nFontsize: 0\nBold: 0\nFontcolor: 0\nBackcolor: 0\nAlignment: 0");
	        ShowPlayerDialog_A(playerid, 826, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	}
	if(dialogid == 832)
	{
	    if(response)
	    {
	        new Indexe = GetIndexFromObjectID(SelectedObject);
	        
	        SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Font bold applied.");
	        TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold] = listitem;
	        DestroyObject(SelectedObject);
	        SelectedObject = RecreateObjectIndex(Indexe);

			if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 1) format(info, 512, "Copy index\nDelete index\nText: %s\nMaterialSize: %d\nFontface: %s\nFontsize: %d\nBold: %d\nFontcolor: %d\nBackcolor: %d\nAlignment: %d", 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]),
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);

			else format(info, 512, "{999999}Copy index\n{999999}Delete index\nText: empty\nMaterialSize: 0\nFontface: empty\nFontsize: 0\nBold: 0\nFontcolor: 0\nBackcolor: 0\nAlignment: 0");
	        ShowPlayerDialog_A(playerid, 826, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	    else
	    {
	        new Indexe = GetIndexFromObjectID(SelectedObject);
			if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 1) format(info, 512, "Copy index\nDelete index\nText: %s\nMaterialSize: %d\nFontface: %s\nFontsize: %d\nBold: %d\nFontcolor: %d\nBackcolor: %d\nAlignment: %d", 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]),
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);

			else format(info, 512, "{999999}Copy index\n{999999}Delete index\nText: empty\nMaterialSize: 0\nFontface: empty\nFontsize: 0\nBold: 0\nFontcolor: 0\nBackcolor: 0\nAlignment: 0");
	        ShowPlayerDialog_A(playerid, 826, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	}
	if(dialogid == 833)
	{
	    if(response)
	    {
	        new Indexe = GetIndexFromObjectID(SelectedObject);
	        if(sscanf(inputtext, "d", inputtext[0]))
			{
			    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Bad format.");
			    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				format(info, 128, "Object font color: %d", TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor]);
			    ShowPlayerDialog_A(playerid, 833, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
			    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
			    return 1;
			}
	        SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Font color applied.");
	        TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor] = inputtext[0];
	        DestroyObject(SelectedObject);
	        SelectedObject = RecreateObjectIndex(Indexe);

			if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 1) format(info, 512, "Copy index\nDelete index\nText: %s\nMaterialSize: %d\nFontface: %s\nFontsize: %d\nBold: %d\nFontcolor: %d\nBackcolor: %d\nAlignment: %d", 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]),
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);

			else format(info, 512, "{999999}Copy index\n{999999}Delete index\nText: empty\nMaterialSize: 0\nFontface: empty\nFontsize: 0\nBold: 0\nFontcolor: 0\nBackcolor: 0\nAlignment: 0");
	        ShowPlayerDialog_A(playerid, 826, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	    else
	    {
	        new Indexe = GetIndexFromObjectID(SelectedObject);
			if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 1) format(info, 512, "Copy index\nDelete index\nText: %s\nMaterialSize: %d\nFontface: %s\nFontsize: %d\nBold: %d\nFontcolor: %d\nBackcolor: %d\nAlignment: %d", 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]),
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);

			else format(info, 512, "{999999}Copy index\n{999999}Delete index\nText: empty\nMaterialSize: 0\nFontface: empty\nFontsize: 0\nBold: 0\nFontcolor: 0\nBackcolor: 0\nAlignment: 0");
	        ShowPlayerDialog_A(playerid, 826, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	}
	if(dialogid == 834)
	{
	    if(response)
	    {
	        new Indexe = GetIndexFromObjectID(SelectedObject);
	        if(sscanf(inputtext, "d", inputtext[0]))
			{
			    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Bad format.");
			    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				format(info, 128, "Object back color: %d", TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor]);
			    ShowPlayerDialog_A(playerid, 834, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
			    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
			    return 1;
			}
	        SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Font color applied.");
	        TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor] = inputtext[0];
	        DestroyObject(SelectedObject);
	        SelectedObject = RecreateObjectIndex(Indexe);

			if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 1) format(info, 512, "Copy index\nDelete index\nText: %s\nMaterialSize: %d\nFontface: %s\nFontsize: %d\nBold: %d\nFontcolor: %d\nBackcolor: %d\nAlignment: %d", 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]),
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);

			else format(info, 512, "{999999}Copy index\n{999999}Delete index\nText: empty\nMaterialSize: 0\nFontface: empty\nFontsize: 0\nBold: 0\nFontcolor: 0\nBackcolor: 0\nAlignment: 0");
	        ShowPlayerDialog_A(playerid, 826, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	    else
	    {
	        new Indexe = GetIndexFromObjectID(SelectedObject);
			if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 1) format(info, 512, "Copy index\nDelete index\nText: %s\nMaterialSize: %d\nFontface: %s\nFontsize: %d\nBold: %d\nFontcolor: %d\nBackcolor: %d\nAlignment: %d", 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]),
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);

			else format(info, 512, "{999999}Copy index\n{999999}Delete index\nText: empty\nMaterialSize: 0\nFontface: empty\nFontsize: 0\nBold: 0\nFontcolor: 0\nBackcolor: 0\nAlignment: 0");
	        ShowPlayerDialog_A(playerid, 826, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	}
	if(dialogid == 835)
	{
	    if(response)
	    {
	        new Indexe = GetIndexFromObjectID(SelectedObject);

	        SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Text alignment applied.");
	        TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment] = listitem;
	        DestroyObject(SelectedObject);
	        SelectedObject = RecreateObjectIndex(Indexe);

			if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 1) format(info, 512, "Copy index\nDelete index\nText: %s\nMaterialSize: %d\nFontface: %s\nFontsize: %d\nBold: %d\nFontcolor: %d\nBackcolor: %d\nAlignment: %d", 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]),
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);

			else format(info, 512, "{999999}Copy index\n{999999}Delete index\nText: empty\nMaterialSize: 0\nFontface: empty\nFontsize: 0\nBold: 0\nFontcolor: 0\nBackcolor: 0\nAlignment: 0");
	        ShowPlayerDialog_A(playerid, 826, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	    else
	    {
	        new Indexe = GetIndexFromObjectID(SelectedObject);
			if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_IndexTextured] == 1) format(info, 512, "Copy index\nDelete index\nText: %s\nMaterialSize: %d\nFontface: %s\nFontsize: %d\nBold: %d\nFontcolor: %d\nBackcolor: %d\nAlignment: %d", 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Text]),
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_MaterialSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontFace],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontSize],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_Bold],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_FontColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_BackColor],
																																																															TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][Texture_EditIndex][I_TextAlignment]);

			else format(info, 512, "{999999}Copy index\n{999999}Delete index\nText: empty\nMaterialSize: 0\nFontface: empty\nFontsize: 0\nBold: 0\nFontcolor: 0\nBackcolor: 0\nAlignment: 0");
	        ShowPlayerDialog_A(playerid, 826, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	}
	if(dialogid == 836)
	{
	    if(response)
	    {
	        SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Index copied.");
	        new Indexe = GetIndexFromObjectID(SelectedObject);
	        CopyMaterialIndex(Indexe, Texture_EditIndex, listitem);
	        DestroyObject(SelectedObject);
	        SelectedObject = RecreateObjectIndex(Indexe);
			#if defined DIALOG_STYLE_TABLIST_HEADERS
	        	SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Select the new index.");
	            new dialog[1048];
	            format(dialog, 1048, "Modelid\tTxd name\tTexture name\tMaterial color\n");
				for(new i = 0; i != 16; i++)
				{
				    if(MAPMOVER_TEXTURES[Indexe][i][IndexTextured] == 1) format(dialog, sizeof(dialog), "%s%d\t%s\t%s\t%d\n", dialog, MAPMOVER_TEXTURES[Indexe][i][M_Modelid], MAPMOVER_TEXTURES[Indexe][i][M_Txd], MAPMOVER_TEXTURES[Indexe][i][M_Texture], MAPMOVER_TEXTURES[Indexe][i][M_Color]);
					else format(dialog, sizeof(dialog), "%s0\tempty\tempty\t0\n", dialog);
				}
				ShowPlayerDialog_A(playerid, 816, 5, "Map editor", dialog, ">>", "<<");

			#else
				SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Select the new index.");
	            new dialog[1048];
				for(new i = 0; i != 16; i++)
				{
				    if(MAPMOVER_TEXTURES[Indexe][i][IndexTextured] == 1) format(dialog, sizeof(dialog), "%s%d\t%s\t%s\t%d\n", dialog, MAPMOVER_TEXTURES[Indexe][i][M_Modelid], MAPMOVER_TEXTURES[Indexe][i][M_Txd], MAPMOVER_TEXTURES[Indexe][i][M_Texture], MAPMOVER_TEXTURES[Indexe][i][M_Color]);
					else format(dialog, sizeof(dialog), "%s0\tempty\tempty\t0\n", dialog);
				}
				ShowPlayerDialog_A(playerid, 816, DIALOG_STYLE_LIST, "Map editor", dialog, ">>", "<<");
			#endif
	    }
	    else
	    {
        	new Indexe = GetIndexFromObjectID(SelectedObject);
			if(MAPMOVER_TEXTURES[Indexe][listitem][IndexTextured] == 1) format(info, 512, "You will edit index: %d\n\n\tUse this format:\n\t%d, %s, %s, %d\n\tIndex (from Pottus texture viewer)\n\tWrite 'DELETE' to remove this material index\n\tWrite 'COPY' to copy this index\n\n", listitem, MAPMOVER_TEXTURES[Indexe][listitem][M_Modelid], MAPMOVER_TEXTURES[Indexe][listitem][M_Txd], MAPMOVER_TEXTURES[Indexe][listitem][M_Texture], MAPMOVER_TEXTURES[Indexe][listitem][M_Color]);
			else format(info, 512, "You will edit index: %d\n\n\tUse this formats:\n\tModelID, TXDName, TextureName, MaterialColor (integer)\n\tIndex (from Pottus texture viewer)\n\tWrite 'DELETE' to remove this material index\n\tWrite 'COPY' to copy this index\n\n", listitem);
	        ShowPlayerDialog_A(playerid, 817, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	}
	if(dialogid == 837)
	{
	    new Indexer = GetIndexFromObjectID(SelectedObject);
	    if(response)
	    {
            if(sscanf(inputtext, "d", inputtext[0]))
			{
			    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Bad format.");
			    PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
				format(info, 128, "Object modelid: %d", MAPMOVER_OBJECTS[Indexer][ModelID]);
			    ShowPlayerDialog_A(playerid, 837, DIALOG_STYLE_INPUT, "Map editor", info, ">>", "<<");
			    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
				return 1;
			}
	        SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Object modelid changed.");
	        MAPMOVER_OBJECTS[Indexer][ModelID] = inputtext[0];
	        DestroyObject(SelectedObject);
	        SelectedObject = RecreateObjectIndex(Indexer);
	        
	        format(info, 512, "1. Texture object\n2. Text object\n3. Move object\n4. Duplicate object\n5. OriginX: %.4f\n6. OriginY: %.4f\n7. OriginZ: %.4f\n8. OriginRX: %.4f\n9. OriginRY: %.4f\n10. OriginRZ: %.4f\n11. Delete object\n12. Reset object\n13. Change modelid", MAPMOVER_OBJECTS[Indexer][PositionX], MAPMOVER_OBJECTS[Indexer][PositionY], MAPMOVER_OBJECTS[Indexer][PositionZ], MAPMOVER_OBJECTS[Indexer][RotationX], MAPMOVER_OBJECTS[Indexer][RotationY], MAPMOVER_OBJECTS[Indexer][RotationZ]);
	        ShowPlayerDialog_A(playerid, 807, DIALOG_STYLE_LIST, "Map editor - Edit object", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	    else
	    {
        	format(info, 512, "1. Texture object\n2. Text object\n3. Move object\n4. Duplicate object\n5. OriginX: %.4f\n6. OriginY: %.4f\n7. OriginZ: %.4f\n8. OriginRX: %.4f\n9. OriginRY: %.4f\n10. OriginRZ: %.4f\n11. Delete object\n12. Reset object\n13. Change modelid", MAPMOVER_OBJECTS[Indexer][PositionX], MAPMOVER_OBJECTS[Indexer][PositionY], MAPMOVER_OBJECTS[Indexer][PositionZ], MAPMOVER_OBJECTS[Indexer][RotationX], MAPMOVER_OBJECTS[Indexer][RotationY], MAPMOVER_OBJECTS[Indexer][RotationZ]);
	        ShowPlayerDialog_A(playerid, 807, DIALOG_STYLE_LIST, "Map editor - Edit object", info, ">>", "<<");
	        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	    }
	}
	return 0;
}

public OnPlayerSelectObject(playerid, type, objectid, modelid, Float:fX, Float:fY, Float:fZ)
{
    if(type == SELECT_OBJECT_GLOBAL_OBJECT)
    {
        new Indexe = GetIndexFromObjectID(objectid);
        if(Indexe == -1) return 1;
        if(Player_EditMode[playerid] == 1)
        {
            SelectedObject = objectid;
            Texture_EditIndex = 0;
            format(info, 512, "1. Texture object\n2. Text object\n3. Move object\n4. Duplicate object\n5. OriginX: %.4f\n6. OriginY: %.4f\n7. OriginZ: %.4f\n8. OriginRX: %.4f\n9. OriginRY: %.4f\n10. OriginRZ: %.4f\n11. Delete object\n12. Reset object\n13. Change modelid", MAPMOVER_OBJECTS[Indexe][PositionX], MAPMOVER_OBJECTS[Indexe][PositionY], MAPMOVER_OBJECTS[Indexe][PositionZ], MAPMOVER_OBJECTS[Indexe][RotationX], MAPMOVER_OBJECTS[Indexe][RotationY], MAPMOVER_OBJECTS[Indexe][RotationZ]);
            ShowPlayerDialog_A(playerid, 807, DIALOG_STYLE_LIST, "Map editor - Edit object", info, ">>", "<<");
            noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
            CancelEdit(playerid);
            return 1;
        }
        if(Player_EditMode[playerid] == 3)
        {
            CancelEdit(playerid);
            SelectedObject = objectid;
            ShowPlayerDialog_A(playerid, 824, DIALOG_STYLE_MSGBOX, "Map editor", "Are you sure?", "Delete", "<<");
            return 1;
        }
    }
    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if((newkeys & KEY_CROUCH))
	{
		if(Player_MovingObjects[playerid] == 2)
	    {
	        new Float:rPX, Float:rPY, Float:rPZ;
            GetPlayerCameraPos(playerid, rPX, rPY, rPZ);
			rPX += CamOffSetX;
	        rPY += CamOffSetY;
	        rPZ += CamOffSetZ;
			new ResolveObject = CreateObject(18765, rPX, rPY, rPZ, 0.0, 0.0, 0.0);
	        for(new i = 0; i != MAX_MAPMOVER_OBJECTS; i++)
            {
                if(MAPMOVER_OBJECTS[i][ModelID] != 0)
                {
				    new Float:PX, Float:PY, Float:PZ;
				    new Float:RX, Float:RY, Float:RZ;
				    AttachObjectToObjectEx(ResolveObject, MAPMOVER_OBJECTS[i][OffSetX], MAPMOVER_OBJECTS[i][OffSetY], MAPMOVER_OBJECTS[i][OffSetZ], MAPMOVER_OBJECTS[i][RotationX], MAPMOVER_OBJECTS[i][RotationY], MAPMOVER_OBJECTS[i][RotationZ], PX, PY, PZ, RX, RY, RZ);

					MAPMOVER_OBJECTS[i][OffSetX] = 0.0;
                    MAPMOVER_OBJECTS[i][OffSetY] = 0.0;
                    MAPMOVER_OBJECTS[i][OffSetZ] = 0.0;

                    DestroyObject(MAPMOVER_OBJECTS[i][ObjectID]);
                    MAPMOVER_OBJECTS[i][ObjectID] = CreateObject(MAPMOVER_OBJECTS[i][ModelID], PX, PY, PZ, RX, RY, RZ);
                    MAPMOVER_OBJECTS[i][PositionX] = PX;
                    MAPMOVER_OBJECTS[i][PositionY] = PY;
                    MAPMOVER_OBJECTS[i][PositionZ] = PZ;
                    MAPMOVER_OBJECTS[i][RotationX] = RX;
                    MAPMOVER_OBJECTS[i][RotationY] = RY;
                    MAPMOVER_OBJECTS[i][RotationZ] = RZ;
                    if(MAPMOVER_OBJECTS[i][ObjectTextured] == 1)
					{
                        for(new s = 0; s != sizeof(MAPMOVER_TEXTURES[]); s++)
						{
						    if(MAPMOVER_TEXTURES[i][s][IndexTextured] == 1)
						    {
						        MAPMOVER_TEXTURES[i][s][M_ObjectID] = MAPMOVER_OBJECTS[i][ObjectID];
				        		SetObjectMaterial(MAPMOVER_TEXTURES[i][s][M_ObjectID], MAPMOVER_TEXTURES[i][s][M_Index], MAPMOVER_TEXTURES[i][s][M_Modelid],  MAPMOVER_TEXTURES[i][s][M_Txd], MAPMOVER_TEXTURES[i][s][M_Texture], MAPMOVER_TEXTURES[i][s][M_Color]);
							}
						}
					}

					if(MAPMOVER_OBJECTS[i][ObjectTextTextured] == 1)
					{
                        for(new s = 0; s != sizeof(TEXT_TEXTURE_MAPMOVER_OBJECT[]); s++)
						{
						    if(TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_IndexTextured] == 1)
						    {
						        TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_ObjectID] = MAPMOVER_OBJECTS[i][ObjectID];
				        		SetObjectMaterialText(TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_ObjectID],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_Text],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_MaterialIndex],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_MaterialSize],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_FontFace],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_FontSize],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_Bold],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_FontColor],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_BackColor],
														TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_TextAlignment]);
							}
						}
					}
				}
            }
            DestroyObject(ResolveObject);
            DestroyObject(ObjectCenter);
            ObjectCenter = CreateObject(1220, rPX, rPY, rPZ, 0.0, 0.0, 0.0);
            SetObjectMaterial(ObjectCenter, 0, 0, "null", "null");
            Player_MovingObjects[playerid] = 0;
	        return 1;
	    }
	}
	return 1;
}

public OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ)
{
    if(response == EDIT_RESPONSE_FINAL || response == EDIT_RESPONSE_CANCEL)
	{
		if(objectid == ObjectCenter)
		{
  			SetObjectPos(objectid, fX, fY, fZ);
   			SetObjectRot(objectid, fRotX, fRotY, fRotZ);
   			RRot[0] += fRotX;
   			RRot[1] += fRotY;
   			RRot[2] += fRotZ;
		    if(Player_MovingObjects[playerid] == 1)
		    {
		        for(new i = 0; i != MAX_MAPMOVER_OBJECTS; i++)
                {
                    if(MAPMOVER_OBJECTS[i][ModelID] != 0)
                    {
					    new Float:PX, Float:PY, Float:PZ;
					    new Float:RX, Float:RY, Float:RZ;
					    AttachObjectToObjectEx(ObjectCenter, MAPMOVER_OBJECTS[i][OffSetX], MAPMOVER_OBJECTS[i][OffSetY], MAPMOVER_OBJECTS[i][OffSetZ], MAPMOVER_OBJECTS[i][RotationX], MAPMOVER_OBJECTS[i][RotationY], MAPMOVER_OBJECTS[i][RotationZ], PX, PY, PZ, RX, RY, RZ);

						MAPMOVER_OBJECTS[i][OffSetX] = 0.0;
                        MAPMOVER_OBJECTS[i][OffSetY] = 0.0;
                        MAPMOVER_OBJECTS[i][OffSetZ] = 0.0;

                        DestroyObject(MAPMOVER_OBJECTS[i][ObjectID]);
                        MAPMOVER_OBJECTS[i][ObjectID] = CreateObject(MAPMOVER_OBJECTS[i][ModelID], PX, PY, PZ, RX, RY, RZ);
                        MAPMOVER_OBJECTS[i][PositionX] = PX;
                        MAPMOVER_OBJECTS[i][PositionY] = PY;
                        MAPMOVER_OBJECTS[i][PositionZ] = PZ;
                        MAPMOVER_OBJECTS[i][RotationX] = RX;
                        MAPMOVER_OBJECTS[i][RotationY] = RY;
                        MAPMOVER_OBJECTS[i][RotationZ] = RZ;
                        if(MAPMOVER_OBJECTS[i][ObjectTextured] == 1)
						{
                            for(new s = 0; s != sizeof(MAPMOVER_TEXTURES[]); s++)
							{
							    if(MAPMOVER_TEXTURES[i][s][IndexTextured] == 1)
							    {
							        MAPMOVER_TEXTURES[i][s][M_ObjectID] = MAPMOVER_OBJECTS[i][ObjectID];
					        		SetObjectMaterial(MAPMOVER_TEXTURES[i][s][M_ObjectID], MAPMOVER_TEXTURES[i][s][M_Index], MAPMOVER_TEXTURES[i][s][M_Modelid],  MAPMOVER_TEXTURES[i][s][M_Txd], MAPMOVER_TEXTURES[i][s][M_Texture], MAPMOVER_TEXTURES[i][s][M_Color]);
								}
							}
						}
						
						if(MAPMOVER_OBJECTS[i][ObjectTextTextured] == 1)
						{
                            for(new s = 0; s != sizeof(TEXT_TEXTURE_MAPMOVER_OBJECT[]); s++)
							{
							    if(TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_IndexTextured] == 1)
							    {
							        TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_ObjectID] = MAPMOVER_OBJECTS[i][ObjectID];
					        		SetObjectMaterialText(TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_ObjectID],
															TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_Text],
															TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_MaterialIndex],
															TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_MaterialSize],
															TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_FontFace],
															TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_FontSize],
															TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_Bold],
															TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_FontColor],
															TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_BackColor],
															TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_TextAlignment]);
								}
							}
						}
					}
                }
                SetObjectRot(objectid, 0.0, 0.0, 0.0);
                Player_MovingObjects[playerid] = 0;
                SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Map edited.");
                new Float:pos[3]; GetObjectPos(ObjectCenter, pos[0], pos[1], pos[2]);
				format(info, 512, "1. Add a new object\n2. Destroy an object\n3. Center position\n4. Move map\n5. PositionX: %f\n6. PositionY: %f\n7. PositionZ: %f\n8. OffSet RotX: %f\n9. OffSet RotY: %f\n10. OffSet RotZ: %f", pos[0], pos[1], pos[2], RRot[0], RRot[1], RRot[2]);
		    	ShowPlayerDialog_A(playerid, 808, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
		        return 1;
		    }
	        SetObjectMaterial(ObjectCenter, 0, 0, "null", "null");
	        SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Center object edited.");
	        new Float:pos[3]; GetObjectPos(ObjectCenter, pos[0], pos[1], pos[2]);
			format(info, 512, "1. Add a new object\n2. Destroy an object\n3. Center position\n4. Move map\n5. PositionX: %f\n6. PositionY: %f\n7. PositionZ: %f\n8. OffSet RotX: %f\n9. OffSet RotY: %f\n10. OffSet RotZ: %f", pos[0], pos[1], pos[2], RRot[0], RRot[1], RRot[2]);
	    	ShowPlayerDialog_A(playerid, 808, DIALOG_STYLE_LIST, "Map editor", info, ">>", "<<"), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	        SetObjectRot(objectid, 0.0, 0.0, 0.0);
		}
		else
		{
		    new Indexe = GetIndexFromObjectID(objectid);
        	if(Indexe == -1) return 1;

			MAPMOVER_OBJECTS[Indexe][PositionX] = fX;
			MAPMOVER_OBJECTS[Indexe][PositionY] = fY;
			MAPMOVER_OBJECTS[Indexe][PositionZ] = fZ;
			MAPMOVER_OBJECTS[Indexe][RotationX] = fRotX;
			MAPMOVER_OBJECTS[Indexe][RotationY] = fRotY;
			MAPMOVER_OBJECTS[Indexe][RotationZ] = fRotZ;
   			SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Object edited.");
			format(info, 512, "1. Texture object\n2. Text object\n3. Move object\n4. Duplicate object\n5. OriginX: %.4f\n6. OriginY: %.4f\n7. OriginZ: %.4f\n8. OriginRX: %.4f\n9. OriginRY: %.4f\n10. OriginRZ: %.4f\n11. Delete object\n12. Reset object\n13. Change modelid", MAPMOVER_OBJECTS[Indexe][PositionX], MAPMOVER_OBJECTS[Indexe][PositionY], MAPMOVER_OBJECTS[Indexe][PositionZ], MAPMOVER_OBJECTS[Indexe][RotationX], MAPMOVER_OBJECTS[Indexe][RotationY], MAPMOVER_OBJECTS[Indexe][RotationZ]);
            ShowPlayerDialog_A(playerid, 807, DIALOG_STYLE_LIST, "Map editor - Edit object", info, ">>", "<<");
            noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
		}
	}
	return 1;
}

public OnPlayerKeyChange(playerid,newkeys)
{
	// Show list system textures PREVIEW_STATE_ALLTEXTURES
	if(Menu3DData[playerid][TPreviewState] == PREVIEW_STATE_ALLTEXTURES)
	{
	    if(ConfirmTexture != -1)
	    {
	        new Indexe = GetIndexFromObjectID(SelectedObject);
	    	DestroyObject(SelectedObject);
	    	SelectedObject = RecreateObjectIndex(Indexe);
			SetObjectMaterial(MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_ObjectID], MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_Index], MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_Modelid],  MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_Txd], MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_Texture], MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_Color]);
	        ConfirmTexture = -1;
		}
		
		// Scroll right
		if(newkeys == 0)
		{
			// Next 16 entries
			Menu3DData[playerid][CurrTextureIndex] += 16;

			// Too high of entries set default
			if(Menu3DData[playerid][CurrTextureIndex] >= sizeof(ObjectTextures) - 1) Menu3DData[playerid][CurrTextureIndex] = 1;

			// Were at the end of the list use the maximum index
			if(sizeof(ObjectTextures) - 1 - Menu3DData[playerid][CurrTextureIndex] - 16 < 0) Menu3DData[playerid][CurrTextureIndex] = sizeof(ObjectTextures) - 16 - 1;

			// Update the textures
			for(new i = 0; i < 16; i++)
			{
			   if(i+Menu3DData[playerid][CurrTextureIndex] >= sizeof(ObjectTextures) - 1) continue;
		       SetBoxMaterial(Menu3DData[playerid][Menus3D],i,0,ObjectTextures[i+Menu3DData[playerid][CurrTextureIndex]][TModel],ObjectTextures[i+Menu3DData[playerid][CurrTextureIndex]][TXDName],ObjectTextures[i+Menu3DData[playerid][CurrTextureIndex]][TextureName], 0, 0xFF999999);
			}

			// Update the info
			UpdateTextureInfo(playerid, SelectedBox[playerid]);
		}

		// Pressed left (Same as right almost)
		if(newkeys == 1)
		{
			Menu3DData[playerid][CurrTextureIndex] -= 16;

			if(Menu3DData[playerid][CurrTextureIndex] < 1) Menu3DData[playerid][CurrTextureIndex] = sizeof(ObjectTextures) - 1 - 16;

			if(Menu3DData[playerid][CurrTextureIndex] >= sizeof(ObjectTextures) - 1) Menu3DData[playerid][CurrTextureIndex] = 1;

			for(new i = 0; i < 16; i++)
			{
				if(i+Menu3DData[playerid][CurrTextureIndex] >= sizeof(ObjectTextures) - 1) continue;
	   		    SetBoxMaterial(Menu3DData[playerid][Menus3D],i,0,ObjectTextures[i+Menu3DData[playerid][CurrTextureIndex]][TModel],ObjectTextures[i+Menu3DData[playerid][CurrTextureIndex]][TXDName],ObjectTextures[i+Menu3DData[playerid][CurrTextureIndex]][TextureName], 0, 0xFF999999);
			}

	        UpdateTextureInfo(playerid, SelectedBox[playerid]);
		}
	}
	return 0;
}

public OnPlayerChange3DMenuBox(playerid,MenuID,boxid)
{
    if(ConfirmTexture != -1)
    {
        new Indexe = GetIndexFromObjectID(SelectedObject);
    	DestroyObject(SelectedObject);
    	SelectedObject = RecreateObjectIndex(Indexe);
		SetObjectMaterial(MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_ObjectID], MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_Index], MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_Modelid],  MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_Txd], MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_Texture], MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_Color]);
        ConfirmTexture = -1;
	}
	UpdateTextureInfo(playerid, boxid);
	return 1;
}

public OnPlayerSelect3DMenuBox(playerid,MenuID,boxid)
{
    new Indexe = GetIndexFromObjectID(SelectedObject);
    if(Player_EditMode[playerid] == 2)
    {
        if(ConfirmTexture != -1)
	    {
			format(MAPMOVER_OBJECTS[Indexe][VariableName], 32, "MAP_tmpobjid");
			MAPMOVER_OBJECTS[Indexe][ObjectTextured] = 1;
		    MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][IndexTextured] = 1;
		    MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_ObjectID] = SelectedObject;
		    MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_Index] = Texture_EditIndex;
		    MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_Modelid] = ObjectTextures[boxid+Menu3DData[playerid][CurrTextureIndex]][TModel];
		    format(MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_Txd], 64, "%s", ObjectTextures[boxid+Menu3DData[playerid][CurrTextureIndex]][TXDName]);
		    format(MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_Texture], 64, "%s", ObjectTextures[boxid+Menu3DData[playerid][CurrTextureIndex]][TextureName]);
		    MAPMOVER_TEXTURES[Indexe][Texture_EditIndex][M_Color] = 0;
		    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Texture applied.");
		    return 1;
		}
        DestroyObject(SelectedObject);
        SelectedObject = RecreateObjectIndex(Indexe);
		SetObjectMaterial(SelectedObject, Texture_EditIndex, ObjectTextures[boxid+Menu3DData[playerid][CurrTextureIndex]][TModel], ObjectTextures[boxid+Menu3DData[playerid][CurrTextureIndex]][TXDName], ObjectTextures[boxid+Menu3DData[playerid][CurrTextureIndex]][TextureName]);
        SendClientMessage(playerid, -1, " ");
		SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Press {FFFF00}Enter {FFFFFF}again to confirm texture.");
		ConfirmTexture = Texture_EditIndex;
	}
	return 1;
}

public LoadTheMap(playerid)
{
    if(!fexist("editingmap.amx")) return SetTimer("LoadTheMap", 100, 0);
    new File:Handler = fopen("editingmap.amx", io_read);
    new string[512];
    while(fread(Handler, string))
    {
        SetTimerEx("Finish", 2000, 0, "id", playerid, 1);
        fclose(Handler);
        return 1;
    }
    SetTimer("LoadTheMap", 100, 0);
	return 1;
}

public Finish(playerid, de)
{
    if(de == 1)
	{
		SendRconCommand("reloadfs ../scriptfiles/editingmap");
		SetTimerEx("Finish", 2000, 0, "id", playerid, 0);
	}
    else ShowPlayerDialog_A(playerid, 802, DIALOG_STYLE_MSGBOX, "Map editor", "\n\n\tMap loaded correctly.\n\n", ">>", ""), noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	return 1;
}


public OnObjectImported(modelid, objectid, variable[])
{
	new Float:pos[6];
	GetObjectPos(objectid, pos[0], pos[1], pos[2]);
	GetObjectRot(objectid, pos[3], pos[4], pos[5]);
	MAPMOVER_OBJECTS[Index][ObjectTextured] = 0;
	MAPMOVER_OBJECTS[Index][ObjectTextTextured] = 0;
	if(strcmp(variable, "NOT")) format(MAPMOVER_OBJECTS[Index][VariableName], 32, "%s", variable);
	MAPMOVER_OBJECTS[Index][ModelID] = modelid;
	MAPMOVER_OBJECTS[Index][PositionX] = pos[0];
	MAPMOVER_OBJECTS[Index][PositionY] = pos[1];
	MAPMOVER_OBJECTS[Index][PositionZ] = pos[2];
	MAPMOVER_OBJECTS[Index][RotationX] = pos[3];
	MAPMOVER_OBJECTS[Index][RotationY] = pos[4];
	MAPMOVER_OBJECTS[Index][RotationZ] = pos[5];
	MAPMOVER_OBJECTS[Index][ObjectID] = objectid;
	Index ++;
	return 1;
}

public OnObjectTexturedText(objectid, text[], materialindex, materialsize, fontface[], fontsize, bold, fontcolor, backcolor, textalignment)
{
	new Indexe = GetIndexFromObjectID(objectid);
    MAPMOVER_OBJECTS[Indexe][ObjectTextTextured] = 1;
	TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][materialindex][I_IndexTextured] = 1;
	TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][materialindex][I_ObjectID] = objectid;
	format(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][materialindex][I_Text], 256, "%s", text);
	TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][materialindex][I_MaterialIndex] = materialindex;
	TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][materialindex][I_MaterialSize] = materialsize;
    format(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][materialindex][I_FontFace], 64, "%s", fontface);
    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][materialindex][I_FontSize] = fontsize;
    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][materialindex][I_Bold] = bold;
    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][materialindex][I_FontColor] = fontcolor;
    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][materialindex][I_BackColor] = backcolor;
    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][materialindex][I_TextAlignment] = textalignment;
	return 1;
}

public OnObjectTextured(objectid, materialindex, modelid, txdname[], texturename[], materialcolor)
{
	new Indexe = GetIndexFromObjectID(objectid);
	MAPMOVER_OBJECTS[Indexe][ObjectTextured] = 1;
    MAPMOVER_TEXTURES[Indexe][materialindex][IndexTextured] = 1;
    MAPMOVER_TEXTURES[Indexe][materialindex][M_ObjectID] = objectid;
    MAPMOVER_TEXTURES[Indexe][materialindex][M_Index] = materialindex;
    MAPMOVER_TEXTURES[Indexe][materialindex][M_Modelid] = modelid;
    format(MAPMOVER_TEXTURES[Indexe][materialindex][M_Txd], 64, "%s", txdname);
    format(MAPMOVER_TEXTURES[Indexe][materialindex][M_Texture], 64, "%s", texturename);
    MAPMOVER_TEXTURES[Indexe][materialindex][M_Color] = materialcolor;
	return 1;
}

public OnMouseMove(X, Y)
{
	return 0;
}

public OnMouseLeftClick(X, Y, status)
{
	return 0;
}

public OnMouseWheelScroll(val)
{
	new playerid = CurrentPlayerID;
    if(Player_MovingMap[playerid] == 0) return 1;
    if(noclipdata[playerid][cameramode] == CAMERA_MODE_NONE) return 1;
    if(!IsValidObject(noclipdata[playerid][flyobject])) return 1;

	switch(val)
	{
	    case 0:
	    {
	        noclipdata[playerid][speed] += 0.5;
	        new str[64];
	        format(str, 64, "~n~~n~~n~~y~CAME MOVE SPEED: ~w~%.1f", noclipdata[playerid][speed]);
	        GameTextForPlayer(playerid, str, 500, 5);
	    }
	    case 1:
	    {
	        noclipdata[playerid][speed] -= 0.5;
	        new str[64];
	        format(str, 64, "~n~~n~~n~~y~CAME MOVE SPEED: ~w~%.1f", noclipdata[playerid][speed]);
            GameTextForPlayer(playerid, str, 500, 5);
	    }
	}

	return 1;
}

public OnAnyKeyDownRelease(status, key)
{
	new playerid = CurrentPlayerID;
    if(Player_MovingMap[playerid] == 0) return 1;

    if(key == 0x65)
    {
        if(status == TKEY_RELEASE)
        {
            if(DIALOG_showed == 1)
            {
                if(DIALOG_style == DIALOG_STYLE_INPUT) return 1;
                if(DIALOG_dialogid == 800 || DIALOG_dialogid == 801 || DIALOG_dialogid == 802) return 1;
                ShowPlayerDialog(playerid,-1,0,"close","close","close","close");
                DIALOG_showed = 2;
                noclipdata[playerid][cameramode] = CAMERA_MODE_FLY;
                SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Use {FFFF00}NUMPAD 5 key {FFFFFF}again to return to dialog.");
                return 1;
            }
            if(DIALOG_showed == 2)
            {
                noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
                ShowPlayerDialog_A(playerid, DIALOG_dialogid, DIALOG_style, DIALOG_caption, DIALOG_info, DIALOG_button1, DIALOG_button2);
                return 1;
            }
        }
	}

    if(Player_EditMode[playerid] == 2)
    {
        ID_OnAnyKeyDownRelease(status, key);
        if(key == 0xBB)
	    {
	        if(status == TKEY_DOWN)
	        {
	            if(Texture_EditIndex == 19) return 1;
	            if(ConfirmTexture != -1)
			    {
			        new Indexe = GetIndexFromObjectID(SelectedObject);
			    	DestroyObject(SelectedObject);
			    	SelectedObject = RecreateObjectIndex(Indexe);
					SetObjectMaterial(MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_ObjectID], MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_Index], MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_Modelid],  MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_Txd], MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_Texture], MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_Color]);
			        ConfirmTexture = -1;
				}
	            Texture_EditIndex += 1;
	            UpdateTextureInfo(playerid, SelectedBox[playerid]);
	            return 1;
	        }
		}
		if(key == 0xBD)
	    {
	        if(status == TKEY_DOWN)
	        {
	            if(Texture_EditIndex == 0) return 1;
	            if(ConfirmTexture != -1)
			    {
			        new Indexe = GetIndexFromObjectID(SelectedObject);
			    	DestroyObject(SelectedObject);
			    	SelectedObject = RecreateObjectIndex(Indexe);
					SetObjectMaterial(MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_ObjectID], MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_Index], MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_Modelid],  MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_Txd], MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_Texture], MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_Color]);
			        ConfirmTexture = -1;
				}
	            Texture_EditIndex -= 1;
	            UpdateTextureInfo(playerid, SelectedBox[playerid]);
	            return 1;
	        }
		}
		if(key == 0x4E)
		{
		    if(status == TKEY_RELEASE)
	        {
	            if(ConfirmTexture != -1)
			    {
			        new Indexe = GetIndexFromObjectID(SelectedObject);
			    	DestroyObject(SelectedObject);
			    	SelectedObject = RecreateObjectIndex(Indexe);
					SetObjectMaterial(MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_ObjectID], MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_Index], MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_Modelid],  MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_Txd], MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_Texture], MAPMOVER_TEXTURES[Indexe][ConfirmTexture][M_Color]);
			        ConfirmTexture = -1;
				}
	            Player_EditMode[playerid] = 0;
	            DestroyTexViewer(playerid);

	            new Indexer = GetIndexFromObjectID(SelectedObject);
				format(info, 512, "1. Texture object\n2. Text object\n3. Move object\n4. Duplicate object\n5. OriginX: %.4f\n6. OriginY: %.4f\n7. OriginZ: %.4f\n8. OriginRX: %.4f\n9. OriginRY: %.4f\n10. OriginRZ: %.4f\n11. Delete object\n12. Reset object\n13. Change modelid", MAPMOVER_OBJECTS[Indexer][PositionX], MAPMOVER_OBJECTS[Indexer][PositionY], MAPMOVER_OBJECTS[Indexer][PositionZ], MAPMOVER_OBJECTS[Indexer][RotationX], MAPMOVER_OBJECTS[Indexer][RotationY], MAPMOVER_OBJECTS[Indexer][RotationZ]);
		        ShowPlayerDialog_A(playerid, 807, DIALOG_STYLE_LIST, "Map editor - Edit object", info, ">>", "<<");
		        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	        }
		}
    }

    if(noclipdata[playerid][cameramode] == CAMERA_MODE_NONE) return 1;
    if(!IsValidObject(noclipdata[playerid][flyobject])) return 1;
    if(key == VK_KEY_W || key == VK_KEY_S || key == VK_KEY_A || key == VK_KEY_D)
    {

	    if(status == TKEY_DOWN)
	    {
		    new Float:ObjectX, Float:ObjectY, Float:ObjectZ,
			    Float:fVObjectX, Float:fVObjectY, Float:fVObjectZ;

		    GetPlayerCameraPos(playerid, ObjectX, ObjectY, ObjectZ);
			GetPlayerCameraFrontVector(playerid, fVObjectX, fVObjectY, fVObjectZ);

		    if(key == VK_KEY_W)
		    {
		        ObjectX += floatmul(fVObjectX, noclipdata[playerid][speed]);
				ObjectY += floatmul(fVObjectY, noclipdata[playerid][speed]);
				ObjectZ += floatmul(fVObjectZ, noclipdata[playerid][speed]);
				MoveObject(noclipdata[playerid][flyobject], ObjectX, ObjectY, ObjectZ, noclipdata[playerid][speed]);

		    }
		    if(key == VK_KEY_S)
		    {

		        ObjectX -= floatmul(fVObjectX, noclipdata[playerid][speed]);
				ObjectY -= floatmul(fVObjectY, noclipdata[playerid][speed]);
				ObjectZ -= floatmul(fVObjectZ, noclipdata[playerid][speed]);
				MoveObject(noclipdata[playerid][flyobject], ObjectX, ObjectY, ObjectZ, noclipdata[playerid][speed]);

		    }
		    if(key == VK_KEY_A)
		    {

		        new Float:CameraAngle = GetPlayerCameraFacingAngle(playerid);
		        CameraAngle += 90.0;
		        ObjectX += (noclipdata[playerid][speed] * floatsin(-CameraAngle,degrees));
				ObjectY += (noclipdata[playerid][speed] * floatcos(-CameraAngle,degrees));
				MoveObject(noclipdata[playerid][flyobject], ObjectX, ObjectY, ObjectZ, noclipdata[playerid][speed]);

		    }
		    if(key == VK_KEY_D)
		    {

		        new Float:CameraAngle = GetPlayerCameraFacingAngle(playerid);
		        CameraAngle -= 90.0;
		        ObjectX += (noclipdata[playerid][speed] * floatsin(-CameraAngle,degrees));
				ObjectY += (noclipdata[playerid][speed] * floatcos(-CameraAngle,degrees));
				MoveObject(noclipdata[playerid][flyobject], ObjectX, ObjectY, ObjectZ, noclipdata[playerid][speed]);

		    }
		}
		if(status == TKEY_RELEASE) StopObject(noclipdata[playerid][flyobject]);
	}

	return 1;
}





//STOCKS

Float: GetPlayerCameraFacingAngle(playerid) //BY Nero_3D
{
    new Float: vX, Float: vY;
    if(GetPlayerCameraFrontVector(playerid, vX, vY, Float: playerid))
	{
        if((vX = -atan2(vX, vY)) < 0.0) return vX + 360.0;
        return vX;
    }
    return 0.0;
}

stock GetIndexFromObjectID(objectid)
{
	if(MAPMOVER_OBJECTS[Index][ObjectID] == objectid) return Index;
	for(new i = 0; i != MAX_MAPMOVER_OBJECTS; i++)
	{
	    if(MAPMOVER_OBJECTS[i][ObjectID] == objectid)
	    {
	        return i;
	    }
	}
	return -1;
}

stock GetObjectIDFromIndexID(indexid)
{
	return MAPMOVER_OBJECTS[indexid][ObjectID];
}

stock StripNewLine(string[]) //DracoBlue (bugfix idea by Y_Less)
{
	new len = strlen(string);
	if (string[0]==0) return ;
	if ((string[len - 1] == '\n') || (string[len - 1] == '\r')) {
		string[len - 1] = 0;
		if (string[0]==0) return ;
		if ((string[len - 2] == '\n') || (string[len - 2] == '\r')) string[len - 2] = 0;
	}
}

AttachObjectToObjectEx(attachoid, Float:off_x, Float:off_y, Float:off_z, Float:rot_x, Float:rot_y, Float:rot_z, &Float:X, &Float:Y, &Float:Z, &Float:RX, &Float:RY, &Float:RZ, pobject = -1) // By Stylock - http://forum.sa-mp.com/member.php?u=114165
{
	static
		Float:sin[3],
		Float:cos[3],
		Float:pos[3],
		Float:rot[3];
	if(pobject == -1)
	{
		GetObjectPos(attachoid, pos[0], pos[1], pos[2]);
		GetObjectRot(attachoid, rot[0], rot[1], rot[2]);
	}
	else
	{
		GetPlayerObjectPos(pobject, attachoid, pos[0], pos[1], pos[2]);
		GetPlayerObjectRot(pobject, attachoid, rot[0], rot[1], rot[2]);
	}
	EDIT_FloatEulerFix(rot[0], rot[1], rot[2]);
	cos[0] = floatcos(rot[0], degrees); cos[1] = floatcos(rot[1], degrees); cos[2] = floatcos(rot[2], degrees); sin[0] = floatsin(rot[0], degrees); sin[1] = floatsin(rot[1], degrees); sin[2] = floatsin(rot[2], degrees);
	pos[0] = pos[0] + off_x * cos[1] * cos[2] - off_x * sin[0] * sin[1] * sin[2] - off_y * cos[0] * sin[2] + off_z * sin[1] * cos[2] + off_z * sin[0] * cos[1] * sin[2];
	pos[1] = pos[1] + off_x * cos[1] * sin[2] + off_x * sin[0] * sin[1] * cos[2] + off_y * cos[0] * cos[2] + off_z * sin[1] * sin[2] - off_z * sin[0] * cos[1] * cos[2];
	pos[2] = pos[2] - off_x * cos[0] * sin[1] + off_y * sin[0] + off_z * cos[0] * cos[1];
	rot[0] = asin(cos[0] * cos[1]); rot[1] = atan2(sin[0], cos[0] * sin[1]) + rot_z; rot[2] = atan2(cos[1] * cos[2] * sin[0] - sin[1] * sin[2], cos[2] * sin[1] - cos[1] * sin[0] * -sin[2]);
	cos[0] = floatcos(rot[0], degrees); cos[1] = floatcos(rot[1], degrees); cos[2] = floatcos(rot[2], degrees); sin[0] = floatsin(rot[0], degrees); sin[1] = floatsin(rot[1], degrees); sin[2] = floatsin(rot[2], degrees);
	rot[0] = asin(cos[0] * sin[1]); rot[1] = atan2(cos[0] * cos[1], sin[0]); rot[2] = atan2(cos[2] * sin[0] * sin[1] - cos[1] * sin[2], cos[1] * cos[2] + sin[0] * sin[1] * sin[2]);
	cos[0] = floatcos(rot[0], degrees); cos[1] = floatcos(rot[1], degrees); cos[2] = floatcos(rot[2], degrees); sin[0] = floatsin(rot[0], degrees); sin[1] = floatsin(rot[1], degrees); sin[2] = floatsin(rot[2], degrees);
	rot[0] = atan2(sin[0], cos[0] * cos[1]) + rot_x; rot[1] = asin(cos[0] * sin[1]); rot[2] = atan2(cos[2] * sin[0] * sin[1] + cos[1] * sin[2], cos[1] * cos[2] - sin[0] * sin[1] * sin[2]);
	cos[0] = floatcos(rot[0], degrees); cos[1] = floatcos(rot[1], degrees); cos[2] = floatcos(rot[2], degrees); sin[0] = floatsin(rot[0], degrees); sin[1] = floatsin(rot[1], degrees); sin[2] = floatsin(rot[2], degrees);
	rot[0] = asin(cos[1] * sin[0]); rot[1] = atan2(sin[1], cos[0] * cos[1]) + rot_y; rot[2] = atan2(cos[0] * sin[2] - cos[2] * sin[0] * sin[1], cos[0] * cos[2] + sin[0] * sin[1] * sin[2]);
	X = pos[0];
	Y = pos[1];
	Z = pos[2];
	RX = rot[0];
	RY = rot[1];
 	RZ = rot[2];
}

EDIT_FloatEulerFix(&Float:rot_x, &Float:rot_y, &Float:rot_z)
{
    EDIT_FloatGetRemainder(rot_x, rot_y, rot_z);
    if((!floatcmp(rot_x, 0.0) || !floatcmp(rot_x, 360.0))
    && (!floatcmp(rot_y, 0.0) || !floatcmp(rot_y, 360.0)))
    {
        rot_y = 0.0000002;
    }
    return 1;
}

EDIT_FloatGetRemainder(&Float:rot_x, &Float:rot_y, &Float:rot_z)
{
    EDIT_FloatRemainder(rot_x, 360.0);
    EDIT_FloatRemainder(rot_y, 360.0);
    EDIT_FloatRemainder(rot_z, 360.0);
    return 1;
}

EDIT_FloatRemainder(&Float:remainder, Float:value)
{
    if(remainder >= value)
    {
        while(remainder >= value)
        {
            remainder = remainder - value;
        }
    }
    else if(remainder < 0.0)
    {
        while(remainder < 0.0)
        {
            remainder = remainder + value;
        }
    }
    return 1;
}

stock CancelFlyMode(playerid)
{
	DeletePVar(playerid, "FlyMode");
	CancelEdit(playerid);
	TogglePlayerSpectating(playerid, false);

	DestroyObject(noclipdata[playerid][flyobject]);
	noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	return 1;
}

stock FlyMode(playerid)
{
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	noclipdata[playerid][flyobject] = CreateObject(19300, X, Y, Z, 0.0, 0.0, 0.0);
	TogglePlayerSpectating(playerid, true);
	AttachCameraToObject(playerid, noclipdata[playerid][flyobject]);
	SetPVarInt(playerid, "FlyMode", 1);
	noclipdata[playerid][cameramode] = CAMERA_MODE_FLY;
	return 1;
}


stock HexToInt(string[])
{
    if(!string[0]) return 0;
    new cur = 1, res = 0;
    for(new i = strlen(string); i > 0; i--)
    {
        res += cur * (string[i - 1] - ((string[i - 1] < 58) ? (48) : (55)));
        cur = cur * 16;
    }
    return res;
}

stock HexStrToRGBA( string[ ], &red, &green, &blue, &alpha )
{
	if( !strlen( string ) ) return 0;

	new
	    cur,
	    res,
	    str[ 4 ][ 3 ]
	;

	strmid( str[ 0 ], string, 2, 5, 3 );
	strmid( str[ 1 ], string, 4, 7, 3 );
	strmid( str[ 2 ], string, 6, 9, 3 );
	strmid( str[ 3 ], string, 8, 11, 3 );

	for( new j = 0; j < 4; j++ )
	{
	    cur = 1;
		res = 0;

	    for( new i = 2; i > 0; i-- )
	    {
	    	if( str[ j ][ i - 1 ] < 58 ) res = res + cur * ( str[ j ][ i - 1 ] - 48 );
			else res = res + cur * ( str[ j ][ i - 1 ] - 65 + 10 );
			cur = cur * 16;
	    }

	    switch( j )
		{
		    case 0: red = res;
		    case 1: green = res;
		    case 2: blue = res;
		    case 3: alpha = res;
		}
	}
	return 1;
}

stock ARGB( alpha, red, green, blue)
{
	return alpha + ( red * 16777216 ) + ( green * 65536 ) + ( blue * 256 );
}


InitText3DDraw(playerid)
{
	Menu3DData[playerid][Menu3D_Model_Info] = CreatePlayerTextDraw(playerid, 513.966857, 367.976654, "Object_Index:_~n~Index:_~n~Modelid:_~n~TXD:_~n~Texture:_");
	PlayerTextDrawLetterSize(playerid, Menu3DData[playerid][Menu3D_Model_Info], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid, Menu3DData[playerid][Menu3D_Model_Info], 1);
	PlayerTextDrawColor(playerid, Menu3DData[playerid][Menu3D_Model_Info], -176);
	PlayerTextDrawSetShadow(playerid, Menu3DData[playerid][Menu3D_Model_Info], 0);
	PlayerTextDrawSetOutline(playerid, Menu3DData[playerid][Menu3D_Model_Info], 0);
	PlayerTextDrawBackgroundColor(playerid, Menu3DData[playerid][Menu3D_Model_Info], 255);
	PlayerTextDrawFont(playerid, Menu3DData[playerid][Menu3D_Model_Info], 1);
	PlayerTextDrawSetProportional(playerid, Menu3DData[playerid][Menu3D_Model_Info], 1);
	PlayerTextDrawSetShadow(playerid, Menu3DData[playerid][Menu3D_Model_Info], 0);
	return 1;
}

// Update selection info text
stock UpdateTextureInfo(playerid, boxid)
{
	// Standard texture viewer
	if(Menu3DData[playerid][TPreviewState] == PREVIEW_STATE_ALLTEXTURES)
	{
		new line[145];
		format(line, sizeof(line), "Object_Index:_%d~n~Index:_%d/%d~n~Modelid:_%d~n~TXD:_%s~n~Texture:_%s", Texture_EditIndex, Menu3DData[playerid][CurrTextureIndex]+boxid, sizeof(ObjectTextures) - 1,
					ObjectTextures[boxid+Menu3DData[playerid][CurrTextureIndex]][TModel],
					ObjectTextures[boxid+Menu3DData[playerid][CurrTextureIndex]][TXDName],
					ObjectTextures[boxid+Menu3DData[playerid][CurrTextureIndex]][TextureName]);
		PlayerTextDrawSetString(playerid, Menu3DData[playerid][Menu3D_Model_Info], line);
	}

	return 1;
}

stock RecreateObjectIndex(Indexe)
{
    MAPMOVER_OBJECTS[Indexe][ObjectID] = CreateObject(MAPMOVER_OBJECTS[Indexe][ModelID], MAPMOVER_OBJECTS[Indexe][PositionX], MAPMOVER_OBJECTS[Indexe][PositionY], MAPMOVER_OBJECTS[Indexe][PositionZ], MAPMOVER_OBJECTS[Indexe][RotationX], MAPMOVER_OBJECTS[Indexe][RotationY], MAPMOVER_OBJECTS[Indexe][RotationZ]);
    if(MAPMOVER_OBJECTS[Indexe][ObjectTextured] == 1)
	{
        for(new s = 0; s != sizeof(MAPMOVER_TEXTURES[]); s++)
		{
		    if(MAPMOVER_TEXTURES[Indexe][s][IndexTextured] == 1)
		    {
		        MAPMOVER_TEXTURES[Indexe][s][M_ObjectID] = MAPMOVER_OBJECTS[Indexe][ObjectID];
        		SetObjectMaterial(MAPMOVER_TEXTURES[Indexe][s][M_ObjectID], MAPMOVER_TEXTURES[Indexe][s][M_Index], MAPMOVER_TEXTURES[Indexe][s][M_Modelid],  MAPMOVER_TEXTURES[Indexe][s][M_Txd], MAPMOVER_TEXTURES[Indexe][s][M_Texture], MAPMOVER_TEXTURES[Indexe][s][M_Color]);
			}
		}
	}

	if(MAPMOVER_OBJECTS[Indexe][ObjectTextTextured] == 1)
	{
        for(new s = 0; s != sizeof(TEXT_TEXTURE_MAPMOVER_OBJECT[]); s++)
		{
		    if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][s][I_IndexTextured] == 1)
		    {
		        TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][s][I_ObjectID] = MAPMOVER_OBJECTS[Indexe][ObjectID];
        		SetObjectMaterialText(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][s][I_ObjectID],
										TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][s][I_Text],
										TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][s][I_MaterialIndex],
										TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][s][I_MaterialSize],
										TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][s][I_FontFace],
										TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][s][I_FontSize],
										TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][s][I_Bold],
										TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][s][I_FontColor],
										TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][s][I_BackColor],
										TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][s][I_TextAlignment]);
			}
		}
	}
	return MAPMOVER_OBJECTS[Indexe][ObjectID];
}


stock GetAviableIndex()
{
	for(new i = 0; i != MAX_MAPMOVER_OBJECTS; i++)
	{
		if(MAPMOVER_OBJECTS[i][ModelID] == 0) return i;
	}
	return -1;
}

stock DuplicateObject(objectid)
{
	new playerid = CurrentPlayerID;
    new Indexer = GetIndexFromObjectID(objectid);
   	if(Indexer == -1)
   	{
   	    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Map editor can't create new objects.");
		format(info, 512, "1. Texture object\n2. Text object\n3. Move object\n4. Duplicate object\n5. OriginX: %.4f\n6. OriginY: %.4f\n7. OriginZ: %.4f\n8. OriginRX: %.4f\n9. OriginRY: %.4f\n10. OriginRZ: %.4f\n11. Delete object\n12. Reset object\n13. Change modelid", MAPMOVER_OBJECTS[Indexer][PositionX], MAPMOVER_OBJECTS[Indexer][PositionY], MAPMOVER_OBJECTS[Indexer][PositionZ], MAPMOVER_OBJECTS[Indexer][RotationX], MAPMOVER_OBJECTS[Indexer][RotationY], MAPMOVER_OBJECTS[Indexer][RotationZ]);
        ShowPlayerDialog_A(playerid, 807, DIALOG_STYLE_LIST, "Map editor - Edit object", info, ">>", "<<");
        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
   	    return 1;
   	}
        	
	new Indexe = GetAviableIndex();
	if(Indexe == -1)
	{
	    if(Index == MAX_MAPMOVER_OBJECTS-1)
		{
			SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Map editor can't create new objects.");
			format(info, 512, "1. Texture object\n2. Text object\n3. Move object\n4. Duplicate object\n5. OriginX: %.4f\n6. OriginY: %.4f\n7. OriginZ: %.4f\n8. OriginRX: %.4f\n9. OriginRY: %.4f\n10. OriginRZ: %.4f\n11. Delete object\n12. Reset object\n13. Change modelid", MAPMOVER_OBJECTS[Indexer][PositionX], MAPMOVER_OBJECTS[Indexer][PositionY], MAPMOVER_OBJECTS[Indexer][PositionZ], MAPMOVER_OBJECTS[Indexer][RotationX], MAPMOVER_OBJECTS[Indexer][RotationY], MAPMOVER_OBJECTS[Indexer][RotationZ]);
            ShowPlayerDialog_A(playerid, 807, DIALOG_STYLE_LIST, "Map editor - Edit object", info, ">>", "<<");
            noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
			return 1;
		}
		MAPMOVER_OBJECTS[Index][ObjectTextured] = MAPMOVER_OBJECTS[Indexer][ObjectTextured];
		MAPMOVER_OBJECTS[Index][ObjectTextTextured] = MAPMOVER_OBJECTS[Indexer][ObjectTextTextured];
		format(MAPMOVER_OBJECTS[Index][VariableName], 32, "%s", MAPMOVER_OBJECTS[Indexer][VariableName]);
		MAPMOVER_OBJECTS[Index][ModelID] = MAPMOVER_OBJECTS[Indexer][ModelID];
		MAPMOVER_OBJECTS[Index][PositionX] = MAPMOVER_OBJECTS[Indexer][PositionX];
		MAPMOVER_OBJECTS[Index][PositionY] = MAPMOVER_OBJECTS[Indexer][PositionY];
		MAPMOVER_OBJECTS[Index][PositionZ] = MAPMOVER_OBJECTS[Indexer][PositionZ];
		MAPMOVER_OBJECTS[Index][RotationX] = MAPMOVER_OBJECTS[Indexer][RotationX];
		MAPMOVER_OBJECTS[Index][RotationY] = MAPMOVER_OBJECTS[Indexer][RotationX];
		MAPMOVER_OBJECTS[Index][RotationZ] = MAPMOVER_OBJECTS[Indexer][RotationZ];
		MAPMOVER_OBJECTS[Index][ObjectID] = CreateObject(MAPMOVER_OBJECTS[Index][ModelID], MAPMOVER_OBJECTS[Index][PositionX], MAPMOVER_OBJECTS[Index][PositionY], MAPMOVER_OBJECTS[Index][PositionZ], MAPMOVER_OBJECTS[Index][RotationX], MAPMOVER_OBJECTS[Index][RotationY], MAPMOVER_OBJECTS[Index][RotationZ]);

		if(MAPMOVER_OBJECTS[Index][ObjectTextured] == 1)
		{
		    for(new i = 0; i != sizeof(MAPMOVER_TEXTURES[]); i++)
			{
			    if(MAPMOVER_TEXTURES[Indexer][i][IndexTextured] == 1)
			    {
					MAPMOVER_TEXTURES[Index][i][IndexTextured] = MAPMOVER_TEXTURES[Indexer][i][IndexTextured];
				    MAPMOVER_TEXTURES[Index][i][M_ObjectID] = MAPMOVER_OBJECTS[Index][ObjectID];
				    MAPMOVER_TEXTURES[Index][i][M_Index] = MAPMOVER_TEXTURES[Indexer][i][M_Index];
				    MAPMOVER_TEXTURES[Index][i][M_Modelid] = MAPMOVER_TEXTURES[Indexer][i][M_Modelid];
				    format(MAPMOVER_TEXTURES[Index][i][M_Txd], 64, "%s", MAPMOVER_TEXTURES[Indexer][i][M_Txd]);
				    format(MAPMOVER_TEXTURES[Index][i][M_Texture], 64, "%s", MAPMOVER_TEXTURES[Indexer][i][M_Texture]);
				    MAPMOVER_TEXTURES[Index][i][M_Color] = MAPMOVER_TEXTURES[Indexer][i][M_Color];
				    SetObjectMaterial(MAPMOVER_TEXTURES[Index][i][M_ObjectID], MAPMOVER_TEXTURES[Index][i][M_Index], MAPMOVER_TEXTURES[Index][i][M_Modelid],  MAPMOVER_TEXTURES[Index][i][M_Txd], MAPMOVER_TEXTURES[Index][i][M_Texture], MAPMOVER_TEXTURES[Index][i][M_Color]);
				}
			}
		}
		
		if(MAPMOVER_OBJECTS[Index][ObjectTextTextured] == 1)
		{
		    for(new i = 0; i != sizeof(TEXT_TEXTURE_MAPMOVER_OBJECT[]); i++)
			{
			    if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][i][I_IndexTextured] == 1)
			    {
				    MAPMOVER_OBJECTS[Index][ObjectTextTextured] = MAPMOVER_OBJECTS[Indexer][ObjectTextTextured];
				    format(MAPMOVER_OBJECTS[Index][VariableName], 32, "%s", MAPMOVER_OBJECTS[Indexer][VariableName]);
					TEXT_TEXTURE_MAPMOVER_OBJECT[Index][i][I_IndexTextured] = TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][i][I_IndexTextured];
					TEXT_TEXTURE_MAPMOVER_OBJECT[Index][i][I_ObjectID] = MAPMOVER_OBJECTS[Index][ObjectID];
					format(TEXT_TEXTURE_MAPMOVER_OBJECT[Index][i][I_Text], 256, "%s", TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][i][I_Text]);
					TEXT_TEXTURE_MAPMOVER_OBJECT[Index][i][I_MaterialIndex] = TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][i][I_MaterialIndex];
					TEXT_TEXTURE_MAPMOVER_OBJECT[Index][i][I_MaterialSize] = TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][i][I_MaterialSize];
				    format(TEXT_TEXTURE_MAPMOVER_OBJECT[Index][i][I_FontFace], 64, "%s", TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][i][I_FontFace]);
				    TEXT_TEXTURE_MAPMOVER_OBJECT[Index][i][I_FontSize] = TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][i][I_FontSize];
				    TEXT_TEXTURE_MAPMOVER_OBJECT[Index][i][I_Bold] = TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][i][I_Bold];
				    TEXT_TEXTURE_MAPMOVER_OBJECT[Index][i][I_FontColor] = TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][i][I_FontColor];
				    TEXT_TEXTURE_MAPMOVER_OBJECT[Index][i][I_BackColor] = TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][i][I_BackColor];
				    TEXT_TEXTURE_MAPMOVER_OBJECT[Index][i][I_TextAlignment] = TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][i][I_TextAlignment];
				    SetObjectMaterialText(TEXT_TEXTURE_MAPMOVER_OBJECT[Index][i][I_ObjectID],
														TEXT_TEXTURE_MAPMOVER_OBJECT[Index][i][I_Text],
														TEXT_TEXTURE_MAPMOVER_OBJECT[Index][i][I_MaterialIndex],
														TEXT_TEXTURE_MAPMOVER_OBJECT[Index][i][I_MaterialSize],
														TEXT_TEXTURE_MAPMOVER_OBJECT[Index][i][I_FontFace],
														TEXT_TEXTURE_MAPMOVER_OBJECT[Index][i][I_FontSize],
														TEXT_TEXTURE_MAPMOVER_OBJECT[Index][i][I_Bold],
														TEXT_TEXTURE_MAPMOVER_OBJECT[Index][i][I_FontColor],
														TEXT_TEXTURE_MAPMOVER_OBJECT[Index][i][I_BackColor],
														TEXT_TEXTURE_MAPMOVER_OBJECT[Index][i][I_TextAlignment]);
				}
			}
		}


		SelectedObject = MAPMOVER_OBJECTS[Index][ObjectID];
	    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Object duplicated, you are editing the duplicated object.");
		format(info, 512, "1. Texture object\n2. Text object\n3. Move object\n4. Duplicate object\n5. OriginX: %.4f\n6. OriginY: %.4f\n7. OriginZ: %.4f\n8. OriginRX: %.4f\n9. OriginRY: %.4f\n10. OriginRZ: %.4f\n11. Delete object\n12. Reset object\n13. Change modelid", MAPMOVER_OBJECTS[Index][PositionX], MAPMOVER_OBJECTS[Index][PositionY], MAPMOVER_OBJECTS[Index][PositionZ], MAPMOVER_OBJECTS[Index][RotationX], MAPMOVER_OBJECTS[Index][RotationY], MAPMOVER_OBJECTS[Index][RotationZ]);
        ShowPlayerDialog_A(playerid, 807, DIALOG_STYLE_LIST, "Map editor - Edit object", info, ">>", "<<");
        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
        
		Index ++;
	}
	else
	{
	    MAPMOVER_OBJECTS[Indexe][ObjectTextured] = MAPMOVER_OBJECTS[Indexer][ObjectTextured];
		MAPMOVER_OBJECTS[Indexe][ObjectTextTextured] = MAPMOVER_OBJECTS[Indexer][ObjectTextTextured];
		format(MAPMOVER_OBJECTS[Indexe][VariableName], 32, "%s", MAPMOVER_OBJECTS[Indexer][VariableName]);
		MAPMOVER_OBJECTS[Indexe][ModelID] = MAPMOVER_OBJECTS[Indexer][ModelID];
		MAPMOVER_OBJECTS[Indexe][PositionX] = MAPMOVER_OBJECTS[Indexer][PositionX];
		MAPMOVER_OBJECTS[Indexe][PositionY] = MAPMOVER_OBJECTS[Indexer][PositionY];
		MAPMOVER_OBJECTS[Indexe][PositionZ] = MAPMOVER_OBJECTS[Indexer][PositionZ];
		MAPMOVER_OBJECTS[Indexe][RotationX] = MAPMOVER_OBJECTS[Indexer][RotationX];
		MAPMOVER_OBJECTS[Indexe][RotationY] = MAPMOVER_OBJECTS[Indexer][RotationX];
		MAPMOVER_OBJECTS[Indexe][RotationZ] = MAPMOVER_OBJECTS[Indexer][RotationZ];
		MAPMOVER_OBJECTS[Indexe][ObjectID] = CreateObject(MAPMOVER_OBJECTS[Indexe][ModelID], MAPMOVER_OBJECTS[Indexe][PositionX], MAPMOVER_OBJECTS[Indexe][PositionY], MAPMOVER_OBJECTS[Indexe][PositionZ], MAPMOVER_OBJECTS[Indexe][RotationX], MAPMOVER_OBJECTS[Indexe][RotationY], MAPMOVER_OBJECTS[Indexe][RotationZ]);

    	if(MAPMOVER_OBJECTS[Indexe][ObjectTextured] == 1)
		{
		    for(new i = 0; i != sizeof(MAPMOVER_TEXTURES[]); i++)
			{
			    if(MAPMOVER_TEXTURES[Indexer][i][IndexTextured] == 1)
			    {
					MAPMOVER_TEXTURES[Indexe][i][IndexTextured] = MAPMOVER_TEXTURES[Indexer][i][IndexTextured];
				    MAPMOVER_TEXTURES[Indexe][i][M_ObjectID] = MAPMOVER_OBJECTS[Indexe][ObjectID];
				    MAPMOVER_TEXTURES[Indexe][i][M_Index] = MAPMOVER_TEXTURES[Indexer][i][M_Index];
				    MAPMOVER_TEXTURES[Indexe][i][M_Modelid] = MAPMOVER_TEXTURES[Indexer][i][M_Modelid];
				    format(MAPMOVER_TEXTURES[Indexe][i][M_Txd], 64, "%s", MAPMOVER_TEXTURES[Indexer][i][M_Txd]);
				    format(MAPMOVER_TEXTURES[Indexe][i][M_Texture], 64, "%s", MAPMOVER_TEXTURES[Indexer][i][M_Texture]);
				    MAPMOVER_TEXTURES[Indexe][i][M_Color] = MAPMOVER_TEXTURES[Indexer][i][M_Color];
				    SetObjectMaterial(MAPMOVER_TEXTURES[Indexe][i][M_ObjectID], MAPMOVER_TEXTURES[Indexe][i][M_Index], MAPMOVER_TEXTURES[Indexe][i][M_Modelid],  MAPMOVER_TEXTURES[Indexe][i][M_Txd], MAPMOVER_TEXTURES[Indexe][i][M_Texture], MAPMOVER_TEXTURES[Indexe][i][M_Color]);
				}
			}
		}

		if(MAPMOVER_OBJECTS[Indexe][ObjectTextTextured] == 1)
		{
		    for(new i = 0; i != sizeof(TEXT_TEXTURE_MAPMOVER_OBJECT[]); i++)
			{
			    if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][i][I_IndexTextured] == 1)
			    {
				    MAPMOVER_OBJECTS[Indexe][ObjectTextTextured] = MAPMOVER_OBJECTS[Indexer][ObjectTextTextured];
				    format(MAPMOVER_OBJECTS[Indexe][VariableName], 32, "%s", MAPMOVER_OBJECTS[Indexer][VariableName]);
					TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_IndexTextured] = TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][i][I_IndexTextured];
					TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_ObjectID] = MAPMOVER_OBJECTS[Indexe][ObjectID];
					format(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_Text], 256, "%s", TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][i][I_Text]);
					TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_MaterialIndex] = TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][i][I_MaterialIndex];
					TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_MaterialSize] = TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][i][I_MaterialSize];
				    format(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_FontFace], 64, "%s", TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][i][I_FontFace]);
				    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_FontSize] = TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][i][I_FontSize];
				    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_Bold] = TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][i][I_Bold];
				    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_FontColor] = TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][i][I_FontColor];
				    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_BackColor] = TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][i][I_BackColor];
				    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_TextAlignment] = TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][i][I_TextAlignment];
				    SetObjectMaterialText(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_ObjectID],
														TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_Text],
														TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_MaterialIndex],
														TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_MaterialSize],
														TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_FontFace],
														TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_FontSize],
														TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_Bold],
														TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_FontColor],
														TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_BackColor],
														TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_TextAlignment]);
				}
			}
		}

        SelectedObject = MAPMOVER_OBJECTS[Indexe][ObjectID];
	    SendClientMessage(playerid, -1, "{FFFF00}Map editor: {FFFFFF}Object duplicated, you are editing the duplicated object.");
		format(info, 512, "1. Texture object\n2. Text object\n3. Move object\n4. Duplicate object\n5. OriginX: %.4f\n6. OriginY: %.4f\n7. OriginZ: %.4f\n8. OriginRX: %.4f\n9. OriginRY: %.4f\n10. OriginRZ: %.4f\n11. Delete object\n12. Reset object\n13. Change modelid", MAPMOVER_OBJECTS[Indexe][PositionX], MAPMOVER_OBJECTS[Indexe][PositionY], MAPMOVER_OBJECTS[Indexe][PositionZ], MAPMOVER_OBJECTS[Indexe][RotationX], MAPMOVER_OBJECTS[Indexe][RotationY], MAPMOVER_OBJECTS[Indexe][RotationZ]);
        ShowPlayerDialog_A(playerid, 807, DIALOG_STYLE_LIST, "Map editor - Edit object", info, ">>", "<<");
        noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	}
	return 1;
}

stock DeleteMapObject(object)
{
    new Indexe = GetIndexFromObjectID(object);
    MAPMOVER_OBJECTS[Indexe][ObjectTextured] = 0;
	MAPMOVER_OBJECTS[Indexe][ObjectTextTextured] = 0;
	format(MAPMOVER_OBJECTS[Indexe][VariableName], 32, "");
	MAPMOVER_OBJECTS[Indexe][ModelID] = 0;
	MAPMOVER_OBJECTS[Indexe][PositionX] = 0.0;
	MAPMOVER_OBJECTS[Indexe][PositionY] = 0.0;
	MAPMOVER_OBJECTS[Indexe][PositionZ] = 0.0;
	MAPMOVER_OBJECTS[Indexe][RotationX] = 0.0;
	MAPMOVER_OBJECTS[Indexe][RotationY] = 0.0;
	MAPMOVER_OBJECTS[Indexe][RotationZ] = 0.0;
	MAPMOVER_OBJECTS[Indexe][ObjectID] = 0;


    for(new i = 0; i != sizeof(MAPMOVER_TEXTURES[]); i++)
	{
		MAPMOVER_TEXTURES[Indexe][i][IndexTextured] = 0;
	    MAPMOVER_TEXTURES[Indexe][i][M_ObjectID] = 0;
	    MAPMOVER_TEXTURES[Indexe][i][M_Index] = 0;
	    MAPMOVER_TEXTURES[Indexe][i][M_Modelid] = 0;
	    format(MAPMOVER_TEXTURES[Indexe][i][M_Txd], 64, "");
	    format(MAPMOVER_TEXTURES[Indexe][i][M_Texture], 64, "");
	    MAPMOVER_TEXTURES[Indexe][i][M_Color] = 0;
	    
	    MAPMOVER_OBJECTS[Indexe][ObjectTextTextured] = 0;
		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_IndexTextured] = 0;
		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_ObjectID] = 0;
		format(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_Text], 256, "");
		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_MaterialIndex] = 0;
		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_MaterialSize] = 0;
	    format(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_FontFace], 64, "");
	    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_FontSize] = 0;
	    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_Bold] = 0;
	    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_FontColor] = 0;
	    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_BackColor] = 0;
	    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_TextAlignment] = 0;
	}
	DestroyObject(object);
	return 1;
}

stock DeleteMapObjectIndex(Indexe)
{
    MAPMOVER_OBJECTS[Indexe][ObjectTextured] = 0;
	MAPMOVER_OBJECTS[Indexe][ObjectTextTextured] = 0;
	format(MAPMOVER_OBJECTS[Indexe][VariableName], 32, "");
	MAPMOVER_OBJECTS[Indexe][ModelID] = 0;
	MAPMOVER_OBJECTS[Indexe][PositionX] = 0.0;
	MAPMOVER_OBJECTS[Indexe][PositionY] = 0.0;
	MAPMOVER_OBJECTS[Indexe][PositionZ] = 0.0;
	MAPMOVER_OBJECTS[Indexe][RotationX] = 0.0;
	MAPMOVER_OBJECTS[Indexe][RotationY] = 0.0;
	MAPMOVER_OBJECTS[Indexe][RotationZ] = 0.0;
	MAPMOVER_OBJECTS[Indexe][ObjectID] = 0;


    for(new i = 0; i != sizeof(MAPMOVER_TEXTURES[]); i++)
	{
		MAPMOVER_TEXTURES[Indexe][i][IndexTextured] = 0;
	    MAPMOVER_TEXTURES[Indexe][i][M_ObjectID] = 0;
	    MAPMOVER_TEXTURES[Indexe][i][M_Index] = 0;
	    MAPMOVER_TEXTURES[Indexe][i][M_Modelid] = 0;
	    format(MAPMOVER_TEXTURES[Indexe][i][M_Txd], 64, "");
	    format(MAPMOVER_TEXTURES[Indexe][i][M_Texture], 64, "");
	    MAPMOVER_TEXTURES[Indexe][i][M_Color] = 0;

	    MAPMOVER_OBJECTS[Indexe][ObjectTextTextured] = 0;
		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_IndexTextured] = 0;
		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_ObjectID] = 0;
		format(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_Text], 256, "");
		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_MaterialIndex] = 0;
		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_MaterialSize] = 0;
	    format(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_FontFace], 64, "");
	    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_FontSize] = 0;
	    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_Bold] = 0;
	    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_FontColor] = 0;
	    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_BackColor] = 0;
	    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_TextAlignment] = 0;
	}
	return 1;
}


stock ResetMapObject(object)
{
    new Indexe = GetIndexFromObjectID(object);
    MAPMOVER_OBJECTS[Indexe][ObjectTextured] = 0;
	MAPMOVER_OBJECTS[Indexe][ObjectTextTextured] = 0;
	format(MAPMOVER_OBJECTS[Indexe][VariableName], 32, "");
    for(new i = 0; i != sizeof(MAPMOVER_TEXTURES[]); i++)
	{
		MAPMOVER_TEXTURES[Indexe][i][IndexTextured] = 0;
	    MAPMOVER_TEXTURES[Indexe][i][M_ObjectID] = 0;
	    MAPMOVER_TEXTURES[Indexe][i][M_Index] = 0;
	    MAPMOVER_TEXTURES[Indexe][i][M_Modelid] = 0;
	    format(MAPMOVER_TEXTURES[Indexe][i][M_Txd], 64, "");
	    format(MAPMOVER_TEXTURES[Indexe][i][M_Texture], 64, "");
	    MAPMOVER_TEXTURES[Indexe][i][M_Color] = 0;

	    MAPMOVER_OBJECTS[Indexe][ObjectTextTextured] = 0;
		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_IndexTextured] = 0;
		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_ObjectID] = 0;
		format(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_Text], 256, "");
		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_MaterialIndex] = 0;
		TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_MaterialSize] = 0;
	    format(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_FontFace], 64, "");
	    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_FontSize] = 0;
	    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_Bold] = 0;
	    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_FontColor] = 0;
	    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_BackColor] = 0;
	    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexe][i][I_TextAlignment] = 0;
	}
	DestroyObject(object);
 	SelectedObject = CreateObject(MAPMOVER_OBJECTS[Indexe][ModelID], MAPMOVER_OBJECTS[Indexe][PositionX], MAPMOVER_OBJECTS[Indexe][PositionY], MAPMOVER_OBJECTS[Indexe][PositionZ], MAPMOVER_OBJECTS[Indexe][RotationX], MAPMOVER_OBJECTS[Indexe][RotationY], MAPMOVER_OBJECTS[Indexe][RotationZ]);
    MAPMOVER_OBJECTS[Indexe][ObjectID] = SelectedObject;
	return 1;
}

stock DestroyTexViewer(playerid)
{
	CancelSelect3DMenu(playerid);
	Destroy3DMenu(Menu3DData[playerid][Menus3D]);
	Menu3DData[playerid][TPreviewState] = PREVIEW_STATE_NONE;
	PlayerTextDrawHide(playerid, Menu3DData[playerid][Menu3D_Model_Info]);
	return 1;
}

stock ShowPlayerDialog_A(playerid, dialogid, style, caption[], dinfo[], button1[], button2[])
{
    DIALOG_showed = 1;
    DIALOG_dialogid = dialogid;
    DIALOG_style = style;
    format(DIALOG_caption, 64, "%s", caption);
    format(DIALOG_info, 1048, "%s", dinfo);
    format(DIALOG_button1, 64, "%s", button1);
    format(DIALOG_button2, 64, "%s", button2);
    return ShowPlayerDialog(playerid, dialogid, style, caption, dinfo, button1, button2);
}

stock ExportMap()
{
	new f_name[64], Dfi;
	format(f_name, 64, "%s_converted.txt", mapnamefile);
	new File:codefile = fopen(f_name, io_write);
	if(codefile)
	{
	    new Year, Month, Day;
		getdate(Year, Month, Day);
		new Hour, Minute, Second;
		gettime(Hour, Minute, Second);
	    new intro[128]; format(intro, 128, "//Map editor ~ %s ~ %02d/%02d/%d ~ %02d:%02d:%02d\r\n\r\n", mapnamefile, Day, Month, Year, Hour, Minute, Second);
	    fwrite(codefile, intro);
	    for(new i = 0; i != MAX_MAPMOVER_OBJECTS; i++)
	    {
	        if(MAPMOVER_OBJECTS[i][ModelID] != 0)
	        {
	            if(MAPMOVER_OBJECTS[i][ObjectTextured] == 0)
	            {
		            new line[145];
					format(line, 145, "CreateObject(%d, %f, %f, %f, %f, %f, %f);\r\n", MAPMOVER_OBJECTS[i][ModelID], MAPMOVER_OBJECTS[i][PositionX], MAPMOVER_OBJECTS[i][PositionY], MAPMOVER_OBJECTS[i][PositionZ], MAPMOVER_OBJECTS[i][RotationX], MAPMOVER_OBJECTS[i][RotationY], MAPMOVER_OBJECTS[i][RotationZ]);
		            fwrite(codefile, line);
				}
				else if(MAPMOVER_OBJECTS[i][ObjectTextured] == 1 || MAPMOVER_OBJECTS[i][ObjectTextTextured] == 1)
				{

				    if(!strcmp(MAPMOVER_OBJECTS[i][VariableName], "MAP_tmpobjid"))
				    {
				        if(Dfi == 0)
				        {
				        	fwrite(codefile, "new MAP_tmpobjid;\r\n");
				        	Dfi = 1;
						}
				    }
				    new line[145];
					format(line, 145, "%s = CreateObject(%d, %f, %f, %f, %f, %f, %f);\r\n", MAPMOVER_OBJECTS[i][VariableName], MAPMOVER_OBJECTS[i][ModelID], MAPMOVER_OBJECTS[i][PositionX], MAPMOVER_OBJECTS[i][PositionY], MAPMOVER_OBJECTS[i][PositionZ], MAPMOVER_OBJECTS[i][RotationX], MAPMOVER_OBJECTS[i][RotationY], MAPMOVER_OBJECTS[i][RotationZ]);
		            fwrite(codefile, line);
		            
		            if(MAPMOVER_OBJECTS[i][ObjectTextured] == 1)
		            {
			            for(new s = 0; s != sizeof(MAPMOVER_TEXTURES[]); s++)
						{
						    if(MAPMOVER_TEXTURES[i][s][IndexTextured] == 1)
						    {
						        new stre[32];
						        if(strfind(MAPMOVER_OBJECTS[i][VariableName], "new ", true) != -1)
						        {
						            format(stre, 32, "%s", MAPMOVER_OBJECTS[i][VariableName]);
						            strdel(stre, 0, 4);
						        }
								else format(stre, 32, "%s", MAPMOVER_OBJECTS[i][VariableName]);
	                            format(line, 145, "SetObjectMaterial(%s, %d, %d, \"%s\", \"%s\", %d);\r\n", stre, MAPMOVER_TEXTURES[i][s][M_Index], MAPMOVER_TEXTURES[i][s][M_Modelid], MAPMOVER_TEXTURES[i][s][M_Txd], MAPMOVER_TEXTURES[i][s][M_Texture], MAPMOVER_TEXTURES[i][s][M_Color]);
	                            fwrite(codefile, line);
							}
						}
					}
					if(MAPMOVER_OBJECTS[i][ObjectTextTextured] == 1)
		            {
			            for(new s = 0; s != sizeof(MAPMOVER_TEXTURES[]); s++)
						{
						    if(MAPMOVER_TEXTURES[i][s][IndexTextured] == 1)
						    {
						        new stre[32];
						        if(strfind(MAPMOVER_OBJECTS[i][VariableName], "new ", true) != -1)
						        {
						            format(stre, 32, "%s", MAPMOVER_OBJECTS[i][VariableName]);
						            strdel(stre, 0, 4);
						        }
								else format(stre, 32, "%s", MAPMOVER_OBJECTS[i][VariableName]);

	                            format(line, 145, "SetObjectMaterialText(%s, \"%s\", %d, %d, \"%s\", %d, %d, %d, %d, %d);\r\n", stre, 	ConvertNtoNN(TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_Text]),
																																		TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_MaterialIndex],
																																		TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_MaterialSize],
																																		TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_FontFace],
																																		TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_FontSize],
																																		TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_Bold],
																																		TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_FontColor],
																																		TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_BackColor],
																																		TEXT_TEXTURE_MAPMOVER_OBJECT[i][s][I_TextAlignment]);
	                            fwrite(codefile, line);
							}
						}
					}
					
				}
			}
		}
		fwrite(codefile, "\r\n");
		fwrite(codefile, "\r\n");
		fwrite(codefile, "//Map editor V1.0 BETA by adri1.");
	    fclose(codefile);
	}
}

stock CopyTextIndex(Indexer, to, from)
{
	TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][from][I_IndexTextured] = TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][to][I_IndexTextured];
	TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][from][I_ObjectID] = MAPMOVER_OBJECTS[Indexer][ObjectID];
	format(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][from][I_Text], 256, "%s", TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][to][I_Text]);
	TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][from][I_MaterialIndex] = from;
	TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][from][I_MaterialSize] = TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][to][I_MaterialSize];
    format(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][from][I_FontFace], 64, "%s", TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][to][I_FontFace]);
    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][from][I_FontSize] = TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][to][I_FontSize];
    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][from][I_Bold] = TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][to][I_Bold];
    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][from][I_FontColor] = TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][to][I_FontColor];
    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][from][I_BackColor] = TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][to][I_BackColor];
    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][from][I_TextAlignment] = TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][to][I_TextAlignment];
	return 1;
}

stock DeleteTextIndex(Indexer, from)
{
    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][from][I_IndexTextured] = 0;
	TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][from][I_ObjectID] = 0;
	format(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][from][I_Text], 256, "");
	TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][from][I_MaterialIndex] = 0;
	TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][from][I_MaterialSize] = 0;
    format(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][from][I_FontFace], 64, "");
    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][from][I_FontSize] = 0;
    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][from][I_Bold] = 0;
    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][from][I_FontColor] = 0;
    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][from][I_BackColor] = 0;
    TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][from][I_TextAlignment] = 0;
    
    new comp;
    for(new i = 0; i != 16; i++)
	{
		if(TEXT_TEXTURE_MAPMOVER_OBJECT[Indexer][i][I_IndexTextured] == 1) comp = 1;
	}
	if(comp == 0) MAPMOVER_OBJECTS[Indexer][ObjectTextTextured] = 0;
	return 1;
}

stock CopyMaterialIndex(Indexer, to, from)
{
    MAPMOVER_TEXTURES[Indexer][from][IndexTextured] = MAPMOVER_TEXTURES[Indexer][to][IndexTextured];
    MAPMOVER_TEXTURES[Indexer][from][M_ObjectID] = MAPMOVER_OBJECTS[Indexer][ObjectID];
    MAPMOVER_TEXTURES[Indexer][from][M_Index] = from;
    MAPMOVER_TEXTURES[Indexer][from][M_Modelid] = MAPMOVER_TEXTURES[Indexer][to][M_Modelid];
	format(MAPMOVER_TEXTURES[Indexer][from][M_Txd], 64, "%s", MAPMOVER_TEXTURES[Indexer][to][M_Txd]);
	format(MAPMOVER_TEXTURES[Indexer][from][M_Texture], 64, "%s", MAPMOVER_TEXTURES[Indexer][to][M_Texture]);
 	MAPMOVER_TEXTURES[Indexer][from][M_Color] = MAPMOVER_TEXTURES[Indexer][to][M_Color];
	return 1;
}

stock ConvertNtoNN(string[])
{
	new str[256];
	format(str, 256, "%s", string);
	new newline = strfind(str, "\n", true);
	if(newline != -1)
	{
	    strdel(str, newline, newline+1);
	    strins(str, "\\n", newline, 256);
	}
	return str;
}

stock LoadMap(playerid, mapname[])
{
	if(Player_MovingMap[playerid] == 0) return 1;

    new File:Handler = fopen(mapname, io_read);
    if(!Handler) return 1;
    fremove("editingmap.amx");
    fremove("editingmap.pwn");
    new File:filer = fopen("editingmap.pwn", io_append);
	if(filer)
	{
  		fwrite(filer, "//temp_script\r\n");
    	fwrite(filer, "#include <a_samp>\r\n");
		fwrite(filer, "public OnFilterScriptInit()\r\n");
		fwrite(filer, "{\r\n\t");
	}
	new variablename[128];
    while(fread(Handler, Object_String))
    {
        StripNewLine(Object_String);
        new Ob = strfind(Object_String, "CreateDynamicObject(", true);
		if(Ob != -1)
		{
			strdel(Object_String, Ob, Ob+20);
			strins(Object_String, "CreateObjectT(", Ob);
		}
		Ob = strfind(Object_String, "CreateObject(", true);
		if(Ob != -1)
		{
			strdel(Object_String, Ob, Ob+13);
			strins(Object_String, "CreateObjectT(", Ob);
		}
		Ob = strfind(Object_String, "= CreateObjectT(", true);
		if(Ob != -1)
		{
			format(variablename, 128, "%s", Object_String);
			if(variablename[Ob-1] == ' ') strdel(variablename, Ob-1, 999);
			else strdel(variablename, Ob, 999);
            strdel(Object_String, 0, Ob+16);
            new stre[128];
            format(stre, 128, "%s = CreateObjectED(\"%s\", ", variablename, variablename);
			strins(Object_String, stre, 0);
		}
		Ob = strfind(Object_String, "RemoveBuildingForPlayer(playerid", true);
		if(Ob != -1)
		{
		    strdel(Object_String, Ob, Ob+32);
		    new stre[45]; format(stre, 45, "RemoveBuildingForPlayer(%d", playerid);
		    strins(Object_String, stre, Ob);
		}
		Ob = strfind(Object_String, "SetDynamicObjectMaterial(", true);
		if(Ob != -1)
		{
		    strdel(Object_String, Ob, Ob+25);
			strins(Object_String, "SetObjectMaterialE(", Ob);
		}
		Ob = strfind(Object_String, "SetObjectMaterial(", true);
		if(Ob != -1)
		{
		    strdel(Object_String, Ob, Ob+18);
			strins(Object_String, "SetObjectMaterialE(", Ob);
		}
		Ob = strfind(Object_String, "SetDynamicObjectMaterialText(", true);
		if(Ob != -1)
		{
			strdel(Object_String, Ob, Ob+29);
			strins(Object_String, "SetObjectMaterialTextT(", Ob);
		}
    	Ob = strfind(Object_String, "SetObjectMaterialText(", true);
		if(Ob != -1)
		{
			strdel(Object_String, Ob, Ob+22);
			strins(Object_String, "SetObjectMaterialTextE(", Ob);
		}
		format(Object_String, 512, "%s\r\n", Object_String);
        fwrite(filer, Object_String);

    }
    fwrite(filer, "\r\n}\r\n\r\n");
    fwrite(filer, "stock CreateObjectT(modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, Float:drawdistance = 0.0)\r\n");
    fwrite(filer, "{\r\n");
    fwrite(filer, "\tnew objectid = CreateObject(modelid, x, y, z, rx, ry, rz, drawdistance);\r\n");
    fwrite(filer, "\tCallRemoteFunction(\"OnObjectImported\", \"dds\", modelid, objectid, \"NOT\");\r\n");
    fwrite(filer, "\treturn objectid;\r\n");
    fwrite(filer, "}\r\n\r\n");
    fwrite(filer, "stock CreateObjectED(var[], modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, Float:drawdistance = 0.0)\r\n");
    fwrite(filer, "{\r\n");
    fwrite(filer, "\tnew objectid = CreateObject(modelid, x, y, z, rx, ry, rz, drawdistance);\r\n");
    fwrite(filer, "\tCallRemoteFunction(\"OnObjectImported\", \"dds\", modelid, objectid, var);\r\n");
    fwrite(filer, "\treturn objectid;\r\n");
    fwrite(filer, "}\r\n\r\n");
    fwrite(filer, "stock SetObjectMaterialTextT(objectid, materialindex = 0, text[], materialsize = OBJECT_MATERIAL_SIZE_256x128, fontface[] = \"Arial\", fontsize = 24, bold = 1, fontcolor = 0xFFFFFFFF, backcolor = 0, textalignment = 0)\r\n");
    fwrite(filer, "{\r\n");
    fwrite(filer, "\treturn SetObjectMaterialTextE(objectid, text, materialindex, materialsize, fontface, fontsize, bold, fontcolor, backcolor, textalignment);\r\n");
    fwrite(filer, "}\r\n\r\n");
    fwrite(filer, "stock SetObjectMaterialTextE(objectid, text[], materialindex = 0, materialsize = OBJECT_MATERIAL_SIZE_256x128, fontface[] = \"Arial\", fontsize = 24, bold = 1, fontcolor = 0xFFFFFFFF, backcolor = 0, textalignment = 0)\r\n");
    fwrite(filer, "{\r\n");
    fwrite(filer, "\tCallRemoteFunction(\"OnObjectTexturedText\", \"dsddsdddddd\", objectid, text, materialindex, materialsize, fontface, fontsize, bold, fontcolor, backcolor, textalignment);\r\n");
    fwrite(filer, "\treturn SetObjectMaterialText(objectid, text, materialindex, materialsize, fontface, fontsize, bold, fontcolor, backcolor, textalignment);\r\n");
    fwrite(filer, "}\r\n\r\n");
    fwrite(filer, "stock SetObjectMaterialE(objectid, materialindex, modelid, txdname[], texturename[], materialcolor = 0)\r\n");
    fwrite(filer, "{\r\n");
    fwrite(filer, "\tCallRemoteFunction(\"OnObjectTextured\", \"dddssd\", objectid, materialindex, modelid, txdname, texturename, materialcolor);\r\n");
    fwrite(filer, "\treturn SetObjectMaterial(objectid, materialindex, modelid, txdname, texturename, materialcolor);\r\n");
    fwrite(filer, "}\r\n\r\n");
    fclose(filer);
    fclose(Handler);

	_winexec("pawno\\pawncc.exe ./scriptfiles/editingmap.pwn");
	SetTimerEx("LoadTheMap", 100, 0, "i", playerid);
	format(mapnamefile, 24, "%s", mapname);

	return true;
}

/*

  __  __          _____
 |  \/  |   /\   |  __ \
 | \  / |  /  \  | |__) |
 | |\/| | / /\ \ |  ___/
 | |  | |/ ____ \| |
 |_|  |_/_/    \_\_|
  ______ _____ _____ _______ ____  _____
 |  ____|  __ \_   _|__   __/ __ \|  __ \
 | |__  | |  | || |    | | | |  | | |__) |
 |  __| | |  | || |    | | | |  | |  _  /
 | |____| |__| || |_   | | | |__| | | \ \
 |______|_____/_____|  |_|  \____/|_|  \_|


    http://forum.sa-mp.com/index.php
    http://forum.sa-mp.com/member.php?u=106967
	BETA VERSION! (Probably unoptimized version)
*/

