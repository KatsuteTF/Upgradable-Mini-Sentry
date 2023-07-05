// Copyright (C) 2023 Katsute | Licensed under CC BY-NC-SA 4.0

#pragma semicolon 1

#include <sourcemod>
#include <sdkhooks>
#include <tf2_stocks>

float size;

ConVar sizeCV;

public Plugin myinfo = {
    name        = "Upgradable Mini Sentry",
    author      = "Katsute",
    description = "Upgrade mini sentries to level 3",
    version     = "1.0",
    url         = "https://github.com/KatsuteTF/Upgradable-Mini-Sentry"
}

public OnPluginStart(){
    sizeCV = CreateConVar("sm_mini_scale", "0.75", "Building scale for mini sentries");
    sizeCV.AddChangeHook(OnConvarChanged);

    size = sizeCV.FloatValue;

    HookEvent("player_builtobject", OnBuilt);
}

public void OnConvarChanged(const ConVar convar, const char[] oldValue, const char[] newValue){
	if(convar == sizeCV)
        size = StringToFloat(newValue);
}

public void OnBuilt(const Event event, const char[] name, const bool dontBroadcast){
    int client = GetClientOfUserId(GetEventInt(event, "userid"));
    if(TF2_GetPlayerClass(client) == TFClass_Engineer && GetEntProp(GetPlayerWeaponSlot(client, 2), Prop_Send, "m_iItemDefinitionIndex") == 142){
        int ent = GetEventInt(event, "index");
        char entname[20];
        GetEntityClassname(ent, entname, 20);
        if(strcmp(entname, "obj_sentrygun") == 0){
            SetEntProp(ent, Prop_Send, "m_bMiniBuilding", 0);
            SetEntPropFloat(ent, Prop_Send, "m_flModelScale", size);
        }
    }
}