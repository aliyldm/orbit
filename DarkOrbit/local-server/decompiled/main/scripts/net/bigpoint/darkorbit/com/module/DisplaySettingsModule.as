package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DisplaySettingsModule implements IModule
   {
      
      private static var _instance:DisplaySettingsModule;
      
      public var notSet:Boolean = false;
      
      public var displayPlayerName:Boolean = false;
      
      public var displayResources:Boolean = false;
      
      public var displayBoxes:Boolean = false;
      
      public var displayHitpointBubbles:Boolean = false;
      
      public var displayChat:Boolean = false;
      
      public var displayDrones:Boolean = false;
      
      public var displayCargoboxes:Boolean = false;
      
      public var displayPenaltyCargoboxes:Boolean = false;
      
      public var showNotOwnedItems:Boolean = false;
      
      public var displayWindowBackground:Boolean = false;
      
      public var displayMinimapBackground:Boolean = false;
      
      public var displayNotifications:Boolean = false;
      
      public var preloadUserShips:Boolean = false;
      
      public var alwaysDraggableWindows:Boolean = false;
      
      public var shipHovering:Boolean = false;
      
      public var showSecondQuickslotBar:Boolean = false;
      
      public var useAutoQuality:Boolean = false;
      
      public var displayUse2d:Boolean = false;
      
      public var displaySetting3DqualityAntialias:int = 0;
      
      public var displaySetting3DqualityBackground:int = 0;
      
      public var displaySetting3DqualityEffects:int = 0;
      
      public var displaySetting3DqualityLights:int = 0;
      
      public var displaySetting3DqualityTextures:int = 0;
      
      public var displaySetting3DqualityZones:int = 0;
      
      public var displaySetting3DsizeTextures:int = 0;
      
      public var displaySetting3DtextureFiltering:int = 0;
      
      public var proActionBarEnabled:Boolean = false;
      
      public var proActionBarKeyboardInputEnabled:Boolean = false;
      
      public var proActionBarAutohideEnabled:Boolean = false;
      
      public var displayMyDrones:Boolean = false;
      
      public var pixelatedRenderingEnabled:Boolean = false;
      
      public function DisplaySettingsModule(param1:Boolean = false, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false, param7:Boolean = false, param8:Boolean = false, param9:Boolean = false, param10:Boolean = false, param11:Boolean = false, param12:Boolean = false, param13:Boolean = false, param14:Boolean = false, param15:Boolean = false, param16:Boolean = false, param17:Boolean = false, param18:Boolean = false, param19:Boolean = false, param20:int = 0, param21:int = 0, param22:int = 0, param23:int = 0, param24:int = 0, param25:int = 0, param26:int = 0, param27:int = 0, param28:Boolean = false, param29:Boolean = false, param30:Boolean = false, param31:Boolean = false, param32:Boolean = false)
      {
         super();
         this.notSet = param1;
         this.displayPlayerName = param2;
         this.displayResources = param3;
         this.displayBoxes = param4;
         this.displayHitpointBubbles = param5;
         this.displayChat = param6;
         this.displayDrones = param7;
         this.displayCargoboxes = param8;
         this.displayPenaltyCargoboxes = param9;
         this.showNotOwnedItems = param10;
         this.displayWindowBackground = param11;
         this.displayMinimapBackground = param12;
         this.displayNotifications = param13;
         this.preloadUserShips = param14;
         this.alwaysDraggableWindows = param15;
         this.shipHovering = param16;
         this.showSecondQuickslotBar = param17;
         this.useAutoQuality = param18;
         this.displayUse2d = param19;
         this.displaySetting3DqualityAntialias = param20;
         this.displaySetting3DqualityBackground = param21;
         this.displaySetting3DqualityEffects = param22;
         this.displaySetting3DqualityLights = param23;
         this.displaySetting3DqualityTextures = param24;
         this.displaySetting3DqualityZones = param25;
         this.displaySetting3DsizeTextures = param26;
         this.displaySetting3DtextureFiltering = param27;
         this.proActionBarEnabled = param28;
         this.proActionBarKeyboardInputEnabled = param29;
         this.proActionBarAutohideEnabled = param30;
         this.displayMyDrones = param31;
         this.pixelatedRenderingEnabled = param32;
      }
      
      public static function get instance() : DisplaySettingsModule
      {
         return _instance || (_instance = new DisplaySettingsModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 270;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 56;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.notSet = param1.readBoolean();
         this.displayPlayerName = param1.readBoolean();
         this.displayResources = param1.readBoolean();
         this.displayBoxes = param1.readBoolean();
         this.displayHitpointBubbles = param1.readBoolean();
         this.displayChat = param1.readBoolean();
         this.displayDrones = param1.readBoolean();
         this.displayCargoboxes = param1.readBoolean();
         this.displayPenaltyCargoboxes = param1.readBoolean();
         this.showNotOwnedItems = param1.readBoolean();
         this.displayWindowBackground = param1.readBoolean();
         this.displayMinimapBackground = param1.readBoolean();
         this.displayNotifications = param1.readBoolean();
         this.preloadUserShips = param1.readBoolean();
         this.alwaysDraggableWindows = param1.readBoolean();
         this.shipHovering = param1.readBoolean();
         this.showSecondQuickslotBar = param1.readBoolean();
         this.useAutoQuality = param1.readBoolean();
         this.displayUse2d = param1.readBoolean();
         this.displaySetting3DqualityAntialias = param1.readInt();
         this.displaySetting3DqualityAntialias = this.displaySetting3DqualityAntialias << 1 % 32 | this.displaySetting3DqualityAntialias >>> 32 - 1 % 32;
         this.displaySetting3DqualityBackground = param1.readInt();
         this.displaySetting3DqualityBackground = this.displaySetting3DqualityBackground >>> 8 % 32 | this.displaySetting3DqualityBackground << 32 - 8 % 32;
         this.displaySetting3DqualityEffects = param1.readInt();
         this.displaySetting3DqualityEffects = this.displaySetting3DqualityEffects >>> 11 % 32 | this.displaySetting3DqualityEffects << 32 - 11 % 32;
         this.displaySetting3DqualityLights = param1.readInt();
         this.displaySetting3DqualityLights = this.displaySetting3DqualityLights << 7 % 32 | this.displaySetting3DqualityLights >>> 32 - 7 % 32;
         this.displaySetting3DqualityTextures = param1.readInt();
         this.displaySetting3DqualityTextures = this.displaySetting3DqualityTextures >>> 12 % 32 | this.displaySetting3DqualityTextures << 32 - 12 % 32;
         this.displaySetting3DqualityZones = param1.readInt();
         this.displaySetting3DqualityZones = this.displaySetting3DqualityZones << 2 % 32 | this.displaySetting3DqualityZones >>> 32 - 2 % 32;
         this.displaySetting3DsizeTextures = param1.readInt();
         this.displaySetting3DsizeTextures = this.displaySetting3DsizeTextures >>> 4 % 32 | this.displaySetting3DsizeTextures << 32 - 4 % 32;
         this.displaySetting3DtextureFiltering = param1.readInt();
         this.displaySetting3DtextureFiltering = this.displaySetting3DtextureFiltering >>> 10 % 32 | this.displaySetting3DtextureFiltering << 32 - 10 % 32;
         this.proActionBarEnabled = param1.readBoolean();
         this.proActionBarKeyboardInputEnabled = param1.readBoolean();
         this.proActionBarAutohideEnabled = param1.readBoolean();
         this.displayMyDrones = param1.readBoolean();
         this.pixelatedRenderingEnabled = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(270);
         param1.writeBoolean(this.notSet);
         param1.writeBoolean(this.displayPlayerName);
         param1.writeBoolean(this.displayResources);
         param1.writeBoolean(this.displayBoxes);
         param1.writeBoolean(this.displayHitpointBubbles);
         param1.writeBoolean(this.displayChat);
         param1.writeBoolean(this.displayDrones);
         param1.writeBoolean(this.displayCargoboxes);
         param1.writeBoolean(this.displayPenaltyCargoboxes);
         param1.writeBoolean(this.showNotOwnedItems);
         param1.writeBoolean(this.displayWindowBackground);
         param1.writeBoolean(this.displayMinimapBackground);
         param1.writeBoolean(this.displayNotifications);
         param1.writeBoolean(this.preloadUserShips);
         param1.writeBoolean(this.alwaysDraggableWindows);
         param1.writeBoolean(this.shipHovering);
         param1.writeBoolean(this.showSecondQuickslotBar);
         param1.writeBoolean(this.useAutoQuality);
         param1.writeBoolean(this.displayUse2d);
         param1.writeInt(this.displaySetting3DqualityAntialias >>> 1 % 32 | this.displaySetting3DqualityAntialias << 32 - 1 % 32);
         param1.writeInt(this.displaySetting3DqualityBackground << 8 % 32 | this.displaySetting3DqualityBackground >>> 32 - 8 % 32);
         param1.writeInt(this.displaySetting3DqualityEffects << 11 % 32 | this.displaySetting3DqualityEffects >>> 32 - 11 % 32);
         param1.writeInt(this.displaySetting3DqualityLights >>> 7 % 32 | this.displaySetting3DqualityLights << 32 - 7 % 32);
         param1.writeInt(this.displaySetting3DqualityTextures << 12 % 32 | this.displaySetting3DqualityTextures >>> 32 - 12 % 32);
         param1.writeInt(this.displaySetting3DqualityZones >>> 2 % 32 | this.displaySetting3DqualityZones << 32 - 2 % 32);
         param1.writeInt(this.displaySetting3DsizeTextures << 4 % 32 | this.displaySetting3DsizeTextures >>> 32 - 4 % 32);
         param1.writeInt(this.displaySetting3DtextureFiltering << 10 % 32 | this.displaySetting3DtextureFiltering >>> 32 - 10 % 32);
         param1.writeBoolean(this.proActionBarEnabled);
         param1.writeBoolean(this.proActionBarKeyboardInputEnabled);
         param1.writeBoolean(this.proActionBarAutohideEnabled);
         param1.writeBoolean(this.displayMyDrones);
         param1.writeBoolean(this.pixelatedRenderingEnabled);
      }
   }
}

