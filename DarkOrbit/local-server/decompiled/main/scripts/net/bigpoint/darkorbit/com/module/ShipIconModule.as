package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class ShipIconModule extends PlayerAttributeModule
   {
      
      private static var _instance:ShipIconModule;
      
      public static const SHIPICON_NONE:int = 0;
      
      public static const SHIPICON_DEFAULT:int = 1;
      
      public static const SHIPICON_PHOENIX:int = 2;
      
      public static const SHIPICON_YAMATO:int = 3;
      
      public static const SHIPICON_LEONOV:int = 4;
      
      public static const SHIPICON_DEFCOM:int = 5;
      
      public static const SHIPICON_LIBERATOR:int = 6;
      
      public static const SHIPICON_PIRANHA:int = 7;
      
      public static const SHIPICON_NOSTROMO:int = 8;
      
      public static const SHIPICON_VENGEANCE:int = 9;
      
      public static const SHIPICON_BIGBOY:int = 10;
      
      public static const SHIPICON_GOLIATH:int = 11;
      
      public static const SHIPICON_ADEPT:int = 12;
      
      public static const SHIPICON_CORSAIR:int = 13;
      
      public static const SHIPICON_LIGHTNING:int = 14;
      
      public static const SHIPICON_JADE:int = 15;
      
      public static const SHIPICON_ADMIN_SHIP:int = 16;
      
      public static const SHIPICON_LEONOV_ENHANCED:int = 17;
      
      public static const SHIPICON_AEGIS:int = 18;
      
      public static const SHIPICON_MAMBA:int = 19;
      
      public static const SHIPICON_GIGA_BIGBOY:int = 20;
      
      public static const SHIPICON_AMBER:int = 21;
      
      public static const SHIPICON_CRIMSON:int = 22;
      
      public static const SHIPICON_SAPPHIRE:int = 23;
      
      public static const SHIPICON_ENFORCER:int = 24;
      
      public static const SHIPICON_INDEPENDANCE:int = 25;
      
      public static const SHIPICON_REVENGE:int = 26;
      
      public static const SHIPICON_BASTION:int = 27;
      
      public static const SHIPICON_AVENGER:int = 28;
      
      public static const SHIPICON_VETERAN:int = 29;
      
      public static const SHIPICON_EXALTED:int = 30;
      
      public static const SHIPICON_SOLACE:int = 31;
      
      public static const SHIPICON_DIMINISHER:int = 32;
      
      public static const SHIPICON_SPECTRUM:int = 33;
      
      public static const SHIPICON_SENTINEL:int = 34;
      
      public static const SHIPICON_VENOM:int = 35;
      
      public static const SHIPICON_QUAL0R:int = 36;
      
      public static const SHIPICON_CRAWLER:int = 37;
      
      public static const SHIPICON_MOTHERSHIP:int = 38;
      
      public static const SHIPICON_POLICE_SHIP:int = 39;
      
      public static const SHIPICON_IGNITE:int = 40;
      
      public static const SHIPICON_CITADEL:int = 41;
      
      public static const SHIPICON_SPEARHEAD:int = 42;
      
      public static const SHIPICON_KICK:int = 43;
      
      public static const SHIPICON_REFEREE:int = 44;
      
      public static const SHIPICON_GOAL:int = 45;
      
      public static const SHIPICON_SATURN:int = 46;
      
      public static const SHIPICON_CENTAUR:int = 47;
      
      public static const SHIPICON_STREUNER:int = 48;
      
      public static const SHIPICON_LORDAKIA:int = 49;
      
      public static const SHIPICON_DEVOLARIUM:int = 50;
      
      public static const SHIPICON_MORDON:int = 51;
      
      public static const SHIPICON_SIBELON:int = 52;
      
      public static const SHIPICON_SAIMON:int = 53;
      
      public static const SHIPICON_SIBELONIT:int = 54;
      
      public static const SHIPICON_LORDAKIUM:int = 55;
      
      public static const SHIPICON_KRISTALLIN:int = 56;
      
      public static const SHIPICON_KRISTALLON:int = 57;
      
      public static const SHIPICON_StreuneR:int = 58;
      
      public static const SHIPICON_SMALL_KUBIKON:int = 59;
      
      public static const SHIPICON_BIG_KUBIKON:int = 60;
      
      public static const SHIPICON_BOSS_STREUNER:int = 61;
      
      public static const SHIPICON_BOSS_LORDAKIA:int = 62;
      
      public static const SHIPICON_BOSS_MORDON:int = 63;
      
      public static const SHIPICON_BOSS_SAIMON:int = 64;
      
      public static const SHIPICON_BOSS_DEVOLARIUM:int = 65;
      
      public static const SHIPICON_BOSS_SIBELONIT:int = 66;
      
      public static const SHIPICON_BOSS_SIBELON:int = 67;
      
      public static const SHIPICON_BOSS_LORDAKIUM:int = 68;
      
      public static const SHIPICON_BOSS_KRISTALLIN:int = 69;
      
      public static const SHIPICON_BOSS_KRISTALLON:int = 70;
      
      public static const SHIPICON_BOSS_StreuneR:int = 71;
      
      public static const SHIPICON_UFONIT:int = 72;
      
      public static const SHIPICON_UFO:int = 73;
      
      public static const SHIPICON_AGGRO_STREUNER:int = 74;
      
      public static const SHIPICON_UBER_STREUNER:int = 75;
      
      public static const SHIPICON_UBER_LORDAKIA:int = 76;
      
      public static const SHIPICON_UBER_MORDON:int = 77;
      
      public static const SHIPICON_UBER_SAIMON:int = 78;
      
      public static const SHIPICON_UBER_DEVOLARIUM:int = 79;
      
      public static const SHIPICON_UBER_SIBELONIT:int = 80;
      
      public static const SHIPICON_UBER_SIBELON:int = 81;
      
      public static const SHIPICON_UBER_LORDAKIUM:int = 82;
      
      public static const SHIPICON_UBER_KRISTALLIN:int = 83;
      
      public static const SHIPICON_UBER_KRISTALLON:int = 84;
      
      public static const SHIPICON_UBER_StreuneR:int = 85;
      
      public static const SHIPICON_DEMANER:int = 86;
      
      public static const SHIPICON_KUCURBIUM:int = 87;
      
      public static const SHIPICON_BOSS_KUCURBIUM:int = 88;
      
      public static const SHIPICON_HENCHMAN:int = 89;
      
      public static const SHIPICON_MARAUDER:int = 90;
      
      public static const SHIPICON_OUTCAST:int = 91;
      
      public static const SHIPICON_HOOLIGAN:int = 92;
      
      public static const SHIPICON_RAVAGER:int = 93;
      
      public static const SHIPICON_CONVICT:int = 94;
      
      public static const SHIPICON_BOSS:int = 95;
      
      public static const SHIPICON_UNIDENTIFIED_DESTROYER:int = 96;
      
      public static const SHIPICON_UNIDENTIFIED_DREADNOUGHT:int = 97;
      
      public static const SHIPICON_QQQ_CUBKION:int = 98;
      
      public static const SHIPICON_QQQ_PROTEGIT:int = 99;
      
      public static const SHIPICON_SNOWY:int = 100;
      
      public static const SHIPICON_ICE_METEROID:int = 101;
      
      public static const SHIPICON_SUPER_METEROID:int = 102;
      
      public static const SHIPICON_CRAZY_ROBOT_1100101:int = 103;
      
      public static const SHIPICON_INTERCEPTOR:int = 104;
      
      public static const SHIPICON_BARRACUDA:int = 105;
      
      public static const SHIPICON_SABOTEUR:int = 106;
      
      public static const SHIPICON_ANNIHILATOR:int = 107;
      
      public static const SHIPICON_BATTLERAY:int = 108;
      
      public static const SHIPICON_IFREET_INFERNAL:int = 109;
      
      public static const SHIPICON_IFREET_SCORCHER:int = 110;
      
      public static const SHIPICON_IFREET_MELTER:int = 111;
      
      public static const SHIPICON_IFREET_DEVOURER:int = 112;
      
      public static const SHIPICON_GG_HENCHMAN:int = 113;
      
      public static const SHIPICON_GG_MARAUDER:int = 114;
      
      public static const SHIPICON_GG_OUTCAST:int = 115;
      
      public static const SHIPICON_GG_CORSAIR:int = 116;
      
      public static const SHIPICON_GG_HOOLIGAN:int = 117;
      
      public static const SHIPICON_GG_RAVAGER:int = 118;
      
      public static const SHIPICON_GG_CONVICT:int = 119;
      
      public static const SHIPICON_CRAZY_SANTA_ROBOT:int = 120;
      
      public static const SHIPICON_CRAZY_REFEREE_ROBOT:int = 121;
      
      public static const SHIPICON_CRAZY_SOLAR_ROBOT:int = 122;
      
      public static const SHIPICON_SATURN_PHOENX:int = 123;
      
      public static const SHIPICON_SATURN_YAMATO:int = 124;
      
      public static const SHIPICON_SATURN_DEFCOM:int = 125;
      
      public static const SHIPICON_SATURN_LIBERATOR:int = 126;
      
      public static const SHIPICON_SATURN_NOSTROMO:int = 127;
      
      public static const SHIPICON_SATURN_PIRANHA:int = 128;
      
      public static const SHIPICON_SATURN_BIGBOY:int = 129;
      
      public static const SHIPICON_SATURN_VENGEANCE:int = 130;
      
      public static const SHIPICON_SATURN_GOLIATH:int = 131;
      
      public static const SHIPICON_SATURN_LEONOV:int = 132;
      
      public static const SHIPICON_SATURN_VENOM:int = 133;
      
      public static const SHIPICON_SATURN_SENTINEL:int = 134;
      
      public static const SHIPICON_SATURN_SPECTRUM:int = 135;
      
      public static const SHIPICON_SATURN_DIMINISHER:int = 136;
      
      public static const SHIPICON_SATURN_SOLACE:int = 137;
      
      public static const SHIPICON_SATURN_REVENGE:int = 138;
      
      public static const SHIPICON_SATURN_LIGHTNING:int = 139;
      
      public static const SHIPICON_SATURN_AVENGER:int = 140;
      
      public static const SHIPICON_SATURN_BASTION:int = 141;
      
      public static const SHIPICON_SATURN_ENFORCER:int = 142;
      
      public static const SHIPICON_SATURN_SPEARHEAD:int = 143;
      
      public static const SHIPICON_SATURN_CITADEL:int = 144;
      
      public static const SHIPICON_SATURN_AEGIS:int = 145;
      
      public static const SHIPICON_SATURN_CRIMSON:int = 146;
      
      public static const SHIPICON_SATURN_JADE:int = 147;
      
      public static const SHIPICON_SATURN_SAPPHIRE:int = 148;
      
      public static const SHIPICON_SATURN_EVIL_YOU:int = 149;
      
      public static const SHIPICON_IRIS_MINION:int = 150;
      
      public static const SHIPICON_HITAC_MINION:int = 151;
      
      public static const SHIPICON_HITAC:int = 152;
      
      public static const SHIPICON_CRAZY_UFO:int = 153;
      
      public static const SHIPICON_BOSS_CURCUBITOR:int = 154;
      
      public static const SHIPICON_CURCUBITOR:int = 155;
      
      public static const SHIPICON_ASTEROID:int = 156;
      
      public static const SHIPICON_BATTLE_STATION_HUB:int = 157;
      
      public static const SHIPICON_BATTLE_STATION_SATELLITE:int = 158;
      
      public static const SHIPICON_BILLBOARD_ASTEROID:int = 159;
      
      public static const SHIPICON_BOOSTER_ZONE:int = 160;
      
      public static const SHIPICON_HEALING_POD:int = 161;
      
      public static const SHIPICON_PET:int = 162;
      
      public static const SHIPICON_RELAY_STATION:int = 163;
      
      public static const SHIPICON_SPACEBALL:int = 164;
      
      public static const SHIPICON_WRECK:int = 165;
      
      public static const SHIPICON_PROTEKID:int = 166;
      
      public static const SHIPICON_CUBIKID:int = 167;
      
      public static const SHIPICON_EMPEROR_SIBELON:int = 168;
      
      public static const SHIPICON_EMPEROR_LORDAKIUM:int = 169;
      
      public static const SHIPICON_EMPEROR_KRISTALLON:int = 170;
      
      public static const SHIPICON_BUFF_CAPSULE:int = 171;
      
      public static const SHIPICON_BOLLERWAGEN:int = 172;
      
      public static const SHIPICON_CITADEL_ELITE:int = 173;
      
      public static const SHIPICON_AEGIS_ELITE:int = 174;
      
      public static const SHIPICON_SPEARHEAD_ELITE:int = 175;
      
      public static const SHIPICON_SOLEMN:int = 176;
      
      public static const SHIPICON_CITADEL_SUPERELITE:int = 177;
      
      public static const SHIPICON_AEGIS_SUPERELITE:int = 178;
      
      public static const SHIPICON_SPEARHEAD_SUPERELITE:int = 179;
      
      public static const SHIPICON_NOSTROMO_DIPLOMAT:int = 180;
      
      public static const SHIPICON_NOSTROMO_ENVOY:int = 181;
      
      public static const SHIPICON_NOSTROMO_AMBASSADOR:int = 182;
      
      public static const SHIPICON_VANQUISHER:int = 183;
      
      public static const SHIPICON_SOVEREIGN:int = 184;
      
      public static const SHIPICON_PEACEMAKER:int = 185;
      
      public static const SHIPICON_GOLIATH_RAZER:int = 186;
      
      public static const SHIPICON_NOSTROMO_RAZER:int = 187;
      
      public static const SHIPICON_TURKISH_GOLIATH:int = 188;
      
      public static const SHIPICON_DEMANER_FREIGHTER:int = 189;
      
      public static const SHIPICON_SKOLL:int = 190;
      
      public static const SHIPICON_PUSAT:int = 191;
      
      public static const SHIPICON_PLAGUE_BOSS:int = 192;
      
      public static const SHIPICON_PLAGUE_MINION:int = 193;
      
      public static const SHIPICON_GOLD:int = 194;
      
      public static const SHIPICON_SILVER:int = 195;
      
      public static const SHIPICON_BRONZE:int = 196;
      
      public static const SHIPICON_IRON:int = 197;
      
      public static const SHIPICON_DEMON_DRONE:int = 198;
      
      public static const SHIPICON_STREUNER_TURRET:int = 199;
      
      public static const SHIPICON_STREUNER_SOLDIER:int = 200;
      
      public static const SHIPICON_STREUNER_SPECIALIST:int = 201;
      
      public static const SHIPICON_STREUNER_EMPEROR:int = 202;
      
      public static const SHIPICON_STREUNER_RECRUIT:int = 203;
      
      public static const SHIPICON_STREUNER_AIDER:int = 204;
      
      public static const SHIPICON_STREUNER_ROCKETEER:int = 205;
      
      public static const SHIPICON_SEEKER_ROCKET:int = 206;
      
      public static const SHIPICON_GOLIATH_FROST:int = 207;
      
      public static const SHIPICON_AEGIS_FROST:int = 208;
      
      public static const SHIPICON_SPEARHEAD_FROST:int = 209;
      
      public static const SHIPICON_CITADEL_FROST:int = 210;
      
      public static const SHIPICON_PUSAT_FROST:int = 211;
      
      public static const SHIPICON_NOSTROMO_AMBASSADOR_FROST:int = 212;
      
      public static const SHIPICON_LIGHTNING_FROST:int = 213;
      
      public static const SHIPICON_SPECTRUM_FROST:int = 214;
      
      public static const SHIPICON_SENTINEL_FROST:int = 215;
      
      public static const SHIPICON_VENOM_FROST:int = 216;
      
      public static const SHIPICON_MIMESIS:int = 217;
      
      public static const SHIPICON_TARTARUS:int = 218;
      
      public static const SHIPICON_G_CHAMPION_ALBANIA:int = 219;
      
      public static const SHIPICON_G_CHAMPION_AUSTRIA:int = 220;
      
      public static const SHIPICON_G_CHAMPION_BELGIUM:int = 221;
      
      public static const SHIPICON_G_CHAMPION_TURKEY:int = 222;
      
      public static const SHIPICON_G_CHAMPION_CROATIA:int = 223;
      
      public static const SHIPICON_G_CHAMPION_CZECH_REPUBLIC:int = 224;
      
      public static const SHIPICON_G_CHAMPION_ENGLAND:int = 225;
      
      public static const SHIPICON_G_CHAMPION_FRANCE:int = 226;
      
      public static const SHIPICON_G_CHAMPION_GERMANY:int = 227;
      
      public static const SHIPICON_G_CHAMPION_HUNGARY:int = 228;
      
      public static const SHIPICON_G_CHAMPION_ICELAND:int = 229;
      
      public static const SHIPICON_G_CHAMPION_ITALY:int = 230;
      
      public static const SHIPICON_G_CHAMPION_NORTHERN_IRELAND:int = 231;
      
      public static const SHIPICON_G_CHAMPION_POLAND:int = 232;
      
      public static const SHIPICON_G_CHAMPION_PORTUGAL:int = 233;
      
      public static const SHIPICON_G_CHAMPION_REPUBLIC_OF_IRELAND:int = 234;
      
      public static const SHIPICON_G_CHAMPION_ROMANIA:int = 235;
      
      public static const SHIPICON_G_CHAMPION_RUSSIA:int = 236;
      
      public static const SHIPICON_G_CHAMPION_SLOVAKIA:int = 237;
      
      public static const SHIPICON_G_CHAMPION_SPAIN:int = 238;
      
      public static const SHIPICON_G_CHAMPION_SWEDEN:int = 239;
      
      public static const SHIPICON_G_CHAMPION_SWITZERLAND:int = 240;
      
      public static const SHIPICON_G_CHAMPION_UKRAINE:int = 241;
      
      public static const SHIPICON_G_CHAMPION_WALES:int = 242;
      
      public static const SHIPICON_SPECTRUM_LAVA:int = 243;
      
      public static const SHIPICON_SPECTRUM_POISON:int = 244;
      
      public static const SHIPICON_SPECTRUM_SANDSTORM:int = 245;
      
      public static const SHIPICON_PUSAT_LAVA:int = 246;
      
      public static const SHIPICON_PUSAT_POISON:int = 247;
      
      public static const SHIPICON_PUSAT_SANDSTORM:int = 248;
      
      public static const SHIPICON_A_ELITE_BLAZE:int = 249;
      
      public static const SHIPICON_A_ELITE_LAVA:int = 250;
      
      public static const SHIPICON_A_ELITE_LEGEND:int = 251;
      
      public static const SHIPICON_A_ELITE_OCEAN:int = 252;
      
      public static const SHIPICON_A_ELITE_POISON:int = 253;
      
      public static const SHIPICON_A_ELITE_SANDSTORM:int = 254;
      
      public static const SHIPICON_PUSAT_BLAZE:int = 255;
      
      public static const SHIPICON_PUSAT_OCEAN:int = 256;
      
      public static const SHIPICON_PUSAT_LEGEND:int = 257;
      
      public static const SHIPICON_SPECTRUM_BLAZE:int = 258;
      
      public static const SHIPICON_SPECTRUM_OCEAN:int = 259;
      
      public static const SHIPICON_SPECTRUM_LEGEND:int = 260;
      
      public static const SHIPICON_GOLIATH_X:int = 261;
      
      public static const SHIPICON_GOLIATH_X_SANDSTORM:int = 262;
      
      public static const SHIPICON_GOLIATH_X_BOREALIS:int = 263;
      
      public static const SHIPICON_GOLIATH_X_OCEAN:int = 264;
      
      public static const SHIPICON_YAMATO_RONIN:int = 265;
      
      public static const SHIPICON_DEFCOM_RAVEN:int = 266;
      
      public static const SHIPICON_HITAC_HATCHINGOUT:int = 267;
      
      public static const SHIPICON_EGG:int = 268;
      
      public static const SHIPICON_I_GYGERTHALL:int = 269;
      
      public static const SHIPICON_CYBORG:int = 270;
      
      public static const SHIPICON_HAMMERCLAW:int = 271;
      
      public static const SHIPICON_UBER_INTERCEPTOR:int = 272;
      
      public static const SHIPICON_UBER_BARRACUDA:int = 273;
      
      public static const SHIPICON_UBER_SABOTEUR:int = 274;
      
      public static const SHIPICON_UBER_ANNIHILATOR:int = 275;
      
      public static const SHIPICON_UBER_BATTLERAY:int = 276;
      
      public static const SHIPICON_REVENANT_SLENDER:int = 277;
      
      public static const SHIPICON_BLACK_LIGHT:int = 278;
      
      public static const SHIPICON_CENTURION:int = 279;
      
      public static const SHIPICON_PURPOSE_XXI:int = 280;
      
      public static const SHIPICON_IMPULSE_II:int = 281;
      
      public static const SHIPICON_ATTEND_IX:int = 282;
      
      public static const SHIPICON_INVOKE_XVI:int = 283;
      
      public static const SHIPICON_MINDFIRE_BEHEMOTH:int = 284;
      
      public static const SHIPICON_URGE_IV:int = 285;
      
      public static const SHIPICON_ATTEND_XIII:int = 286;
      
      public static const SHIPICON_CAPITAL_I:int = 287;
      
      public static const SHIPICON_REGARD_CXI:int = 288;
      
      public static const SHIPICON_OBSERVE_X:int = 289;
      
      public static const SHIPICON_FIND_VII:int = 290;
      
      public static const SHIPICON_SANCTION_XXXIII:int = 291;
      
      public static const SHIPICON_DEMAND_VII:int = 292;
      
      public static const SHIPICON_RESERVE_VIII:int = 293;
      
      public static const SHIPICON_SUBJUGATE_XXVII:int = 294;
      
      public static const SHIPICON_DISCTATE_XCIC:int = 295;
      
      public static const SHIPICON_PARAGON_XX:int = 296;
      
      public static const SHIPICON_HECATE:int = 297;
      
      public static const SHIPICON_COTE_LO:int = 298;
      
      public static const SHIPICON_KODKOD:int = 299;
      
      public static const SHIPICON_AURA_DUN_JIG:int = 300;
      
      public static const SHIPICON_LAC_LION:int = 301;
      
      public static const SHIPICON_NATAL_NAP:int = 302;
      
      public static const SHIPICON_PLUTUS:int = 303;
      
      public static const SHIPICON_WARHEAD:int = 304;
      
      public static const SHIPICON_PLUTUS_TURRET:int = 305;
      
      public static const SHIPICON_DISRUPTOR:int = 306;
      
      public static const SHIPICON_BERSERKER:int = 307;
      
      public static const SHIPICON_ZEPHYR:int = 308;
      
      public static const SHIPICON_SYNK:int = 309;
      
      public static const SHIPICON_LANATUM:int = 310;
      
      public static const SHIPICON_STYXUS:int = 311;
      
      public static const SHIPICON_CHAROPOS:int = 312;
      
      public static const SHIPICON_SOLARIS:int = 313;
      
      public static const SHIPICON_EM_FREIGHTER:int = 314;
      
      public static const SHIPICON_MIMESIS_AI_ASSAILANT:int = 315;
      
      public static const SHIPICON_MIMESIS_AI_CLONED:int = 316;
      
      public static const SHIPICON_MIMESIS_AI_CLONING:int = 317;
      
      public static const SHIPICON_MIMESIS_AI_HARDY:int = 318;
      
      public static const SHIPICON_MIMESIS_AI_HEXOR:int = 319;
      
      public static const SHIPICON_MIMESIS_AI_HOUNDING:int = 320;
      
      public static const SHIPICON_MIMESIS_AI_KAMIKAZE:int = 321;
      
      public static const SHIPICON_MIMESIS_AI_MARKER:int = 322;
      
      public static const SHIPICON_MIMESIS_AI_MEDIC:int = 323;
      
      public static const SHIPICON_MIMESIS_AI_MIRROR:int = 324;
      
      public static const SHIPICON_MIMESIS_AI_MIRROR_CLONE:int = 325;
      
      public static const SHIPICON_MIMESIS_AI_OBSCURED:int = 326;
      
      public static const SHIPICON_MIMESIS_AI_PIERCING:int = 327;
      
      public static const SHIPICON_MIMESIS_AI_RAGING:int = 328;
      
      public static const SHIPICON_MIMESIS_AI_RAIDER:int = 329;
      
      public static const SHIPICON_MIMESIS_AI_REFLECTOR:int = 330;
      
      public static const SHIPICON_MIMESIS_AI_SNIPER:int = 331;
      
      public static const SHIPICON_MIMESIS_AI_TERROR:int = 332;
      
      public static const SHIPICON_CYBORG_AI_COWERING:int = 333;
      
      public static const SHIPICON_CYBORG_AI_DEMOLITION:int = 334;
      
      public static const SHIPICON_CYBORG_AI_PHASING:int = 335;
      
      public static const SHIPICON_CYBORG_AI_SHIELDED:int = 336;
      
      public static const SHIPICON_CYBORG_AI_SINGULARITY:int = 337;
      
      public static const SHIPICON_CYBORG_AI_TROUBLEMAKER:int = 338;
      
      public static const SHIPICON_KERES:int = 339;
      
      public static const SHIPICON_AGATUS:int = 340;
      
      public static const SHIPICON_SPINEL:int = 341;
      
      public static const SHIPICON_SPINELUS:int = 342;
      
      public static const SHIPICON_RETIARUS:int = 343;
      
      public static const SHIPICON_BOSS_FRIGHTFUL_CURCUBITOR:int = 344;
      
      public static const SHIPICON_ORCUS:int = 345;
      
      public static const SHIPICON_STROKELIGHT_BARRAGE:int = 346;
      
      public static const SHIPICON_BARRAGE_SEEKER_ROCKET:int = 347;
      
      public static const SHIPICON_ICEMINOS:int = 348;
      
      public static const SHIPICON_HOLO:int = 349;
      
      public static const SHIPICON_THE_STINGER:int = 350;
      
      public static const SHIPICON_PIKE:int = 351;
      
      public static const SHIPICON_BARB:int = 352;
      
      public static const SHIPICON_LANTERNFISH:int = 353;
      
      public static const SHIPICON_SPOOKFISH:int = 354;
      
      public static const SHIPICON_GOLIATH_PLUS:int = 355;
      
      public static const SHIPICON_CITADEL_PLUS:int = 356;
      
      public static const SHIPICON_LIBERATOR_PLUS:int = 357;
      
      public static const SHIPICON_SOLACE_PLUS:int = 358;
      
      public static const SHIPICON_SOLARIS_PLUS:int = 359;
      
      public static const SHIPICON_PUSAT_PLUS:int = 360;
      
      public static const SHIPICON_HECATE_PLUS:int = 361;
      
      public static const SHIPICON_HAMMERCLAW_PLUS:int = 362;
      
      public static const SHIPICON_SPEARHEAD_PLUS:int = 363;
      
      public static const SHIPICON_TEMPEST:int = 364;
      
      public static const SHIPICON_TARTARUS_PLUS:int = 365;
      
      public static const SHIPICON_MIMESIS_AI_INSPIRIT:int = 366;
      
      public static const SHIPICON_MIMESIS_AI_TURRET:int = 367;
      
      public static const SHIPICON_ENDLESS_ARMADA_DUPLICANT:int = 368;
      
      public static const SHIPICON_HITAC_UNDERLING:int = 369;
      
      public static const SHIPICON_HITAC_UNDERBOSS:int = 370;
      
      public static const SHIPICON_BASILISK:int = 371;
      
      public static const SHIPICON_SPECTRUM_PLUS:int = 372;
      
      public static const SHIPICON_RABBIT:int = 373;
      
      public static const SHIPICON_ENDLESS_COLOSSUS_DUPLICANT:int = 374;
      
      public static const SHIPICON_PLAYER_CAMP_NPC:int = 375;
      
      public static const SHIPICON_MISSILE_STORM:int = 376;
      
      public static const SHIPICON_PALADIN:int = 377;
      
      public static const SHIPICON_DREADFYRE_HARBINGER:int = 378;
      
      public static const SHIPICON_DREADFYRE_GUARDIAN:int = 379;
      
      public static const SHIPICON_DREADFYRE_FORTRESS:int = 380;
      
      public static const SHIPICON_BARRACUDA_SAE:int = 381;
      
      public static const SHIPICON_DEADLY_BATTLERAY_SAE:int = 382;
      
      public static const SHIPICON_INTERCEPTOR_SAE:int = 383;
      
      public static const SHIPICON_SABOTEUR_SAE:int = 384;
      
      public static const SHIPICON_CHRONOSPIRE:int = 385;
      
      public static const SHIPICON_MAGMA_STALKER:int = 386;
      
      public static const SHIPICON_PYROSPIRE:int = 387;
      
      public static const SHIPICON_SPORE_STALKER:int = 388;
      
      public static const SHIPICON_VEIL_STALKER:int = 389;
      
      public static const SHIPICON_VINESPIRE:int = 390;
      
      public static const SHIPICON_RETIARUS_PLUS:int = 391;
      
      public static const SHIPICON_BOSS_VOIDMARE:int = 392;
      
      public static const SHIPICON_VOYAGERS_WHISPER:int = 393;
      
      public static const SHIPICON_HYPERION:int = 394;
      
      public static const SHIPICON__MAX:int = 395;
      
      public var shipIcon:int = 0;
      
      public function ShipIconModule(param1:int = 0)
      {
         super();
         this.shipIcon = param1;
      }
      
      public static function get instance() : ShipIconModule
      {
         return _instance || (_instance = new ShipIconModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 27538;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.shipIcon = param1.readShort();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(27538);
         super.write(param1);
         param1.writeShort(this.shipIcon);
      }
   }
}

