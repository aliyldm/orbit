package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DisplaySettingsRequest implements IModule
   {
      
      private static var _instance:DisplaySettingsRequest;
      
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
      
      public function DisplaySettingsRequest(param1:Boolean = false, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false, param7:Boolean = false, param8:Boolean = false, param9:Boolean = false, param10:Boolean = false, param11:Boolean = false, param12:Boolean = false, param13:Boolean = false, param14:Boolean = false, param15:Boolean = false, param16:Boolean = false, param17:Boolean = false, param18:Boolean = false, param19:int = 0, param20:int = 0, param21:int = 0, param22:int = 0, param23:int = 0, param24:int = 0, param25:int = 0, param26:int = 0, param27:Boolean = false, param28:Boolean = false, param29:Boolean = false, param30:Boolean = false, param31:Boolean = false)
      {
         super();
         this.displayPlayerName = param1;
         this.displayResources = param2;
         this.displayBoxes = param3;
         this.displayHitpointBubbles = param4;
         this.displayChat = param5;
         this.displayDrones = param6;
         this.displayCargoboxes = param7;
         this.displayPenaltyCargoboxes = param8;
         this.showNotOwnedItems = param9;
         this.displayWindowBackground = param10;
         this.displayMinimapBackground = param11;
         this.displayNotifications = param12;
         this.preloadUserShips = param13;
         this.alwaysDraggableWindows = param14;
         this.shipHovering = param15;
         this.showSecondQuickslotBar = param16;
         this.useAutoQuality = param17;
         this.displayUse2d = param18;
         this.displaySetting3DqualityAntialias = param19;
         this.displaySetting3DqualityBackground = param20;
         this.displaySetting3DqualityEffects = param21;
         this.displaySetting3DqualityLights = param22;
         this.displaySetting3DqualityTextures = param23;
         this.displaySetting3DqualityZones = param24;
         this.displaySetting3DsizeTextures = param25;
         this.displaySetting3DtextureFiltering = param26;
         this.proActionBarEnabled = param27;
         this.proActionBarKeyboardInputEnabled = param28;
         this.proActionBarAutohideEnabled = param29;
         this.displayMyDrones = param30;
         this.pixelatedRenderingEnabled = param31;
      }
      
      public static function get instance() : DisplaySettingsRequest
      {
         return _instance || (_instance = new DisplaySettingsRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 266;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 55;
      }
      
      public function read(param1:IDataInput) : void
      {
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
         this.displaySetting3DqualityAntialias = this.displaySetting3DqualityAntialias >>> 11 % 32 | this.displaySetting3DqualityAntialias << 32 - 11 % 32;
         this.displaySetting3DqualityBackground = param1.readInt();
         this.displaySetting3DqualityBackground = this.displaySetting3DqualityBackground >>> 7 % 32 | this.displaySetting3DqualityBackground << 32 - 7 % 32;
         this.displaySetting3DqualityEffects = param1.readInt();
         this.displaySetting3DqualityEffects = this.displaySetting3DqualityEffects << 6 % 32 | this.displaySetting3DqualityEffects >>> 32 - 6 % 32;
         this.displaySetting3DqualityLights = param1.readInt();
         this.displaySetting3DqualityLights = this.displaySetting3DqualityLights >>> 15 % 32 | this.displaySetting3DqualityLights << 32 - 15 % 32;
         this.displaySetting3DqualityTextures = param1.readInt();
         this.displaySetting3DqualityTextures = this.displaySetting3DqualityTextures << 2 % 32 | this.displaySetting3DqualityTextures >>> 32 - 2 % 32;
         this.displaySetting3DqualityZones = param1.readInt();
         this.displaySetting3DqualityZones = this.displaySetting3DqualityZones << 4 % 32 | this.displaySetting3DqualityZones >>> 32 - 4 % 32;
         this.displaySetting3DsizeTextures = param1.readInt();
         this.displaySetting3DsizeTextures = this.displaySetting3DsizeTextures >>> 1 % 32 | this.displaySetting3DsizeTextures << 32 - 1 % 32;
         this.displaySetting3DtextureFiltering = param1.readInt();
         this.displaySetting3DtextureFiltering = this.displaySetting3DtextureFiltering >>> 8 % 32 | this.displaySetting3DtextureFiltering << 32 - 8 % 32;
         this.proActionBarEnabled = param1.readBoolean();
         this.proActionBarKeyboardInputEnabled = param1.readBoolean();
         this.proActionBarAutohideEnabled = param1.readBoolean();
         this.displayMyDrones = param1.readBoolean();
         this.pixelatedRenderingEnabled = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(266);
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
         param1.writeInt(this.displaySetting3DqualityAntialias << 11 % 32 | this.displaySetting3DqualityAntialias >>> 32 - 11 % 32);
         param1.writeInt(this.displaySetting3DqualityBackground << 7 % 32 | this.displaySetting3DqualityBackground >>> 32 - 7 % 32);
         param1.writeInt(this.displaySetting3DqualityEffects >>> 6 % 32 | this.displaySetting3DqualityEffects << 32 - 6 % 32);
         param1.writeInt(this.displaySetting3DqualityLights << 15 % 32 | this.displaySetting3DqualityLights >>> 32 - 15 % 32);
         param1.writeInt(this.displaySetting3DqualityTextures >>> 2 % 32 | this.displaySetting3DqualityTextures << 32 - 2 % 32);
         param1.writeInt(this.displaySetting3DqualityZones >>> 4 % 32 | this.displaySetting3DqualityZones << 32 - 4 % 32);
         param1.writeInt(this.displaySetting3DsizeTextures << 1 % 32 | this.displaySetting3DsizeTextures >>> 32 - 1 % 32);
         param1.writeInt(this.displaySetting3DtextureFiltering << 8 % 32 | this.displaySetting3DtextureFiltering >>> 32 - 8 % 32);
         param1.writeBoolean(this.proActionBarEnabled);
         param1.writeBoolean(this.proActionBarKeyboardInputEnabled);
         param1.writeBoolean(this.proActionBarAutohideEnabled);
         param1.writeBoolean(this.displayMyDrones);
         param1.writeBoolean(this.pixelatedRenderingEnabled);
      }
   }
}

