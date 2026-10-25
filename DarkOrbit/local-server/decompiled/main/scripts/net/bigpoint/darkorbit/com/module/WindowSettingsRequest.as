package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class WindowSettingsRequest implements IModule
   {
      
      private static var _instance:WindowSettingsRequest;
      
      public var minimapScale:int = 0;
      
      public var mainmenuPosition:String = "";
      
      public var barStatus:String = "";
      
      public var genericFeatureMenuPosition:String = "";
      
      public var genericFeatureMenuOrder:String = "";
      
      public var gameFeatureMenuPosition:String = "";
      
      public var gameFeatureMenuOrder:String = "";
      
      public var slotmenuPosition:String = "";
      
      public var slotMenuOrder:String = "";
      
      public var slotmenuPremiumPosition:String = "";
      
      public var slotMenuPremiumOrder:String = "";
      
      public var slotmenuProActionPosition:String = "";
      
      public var slotMenuProActionOrder:String = "";
      
      public var stageSize:String = "";
      
      public var hideAllWindows:Boolean = false;
      
      public function WindowSettingsRequest(param1:int = 0, param2:String = "", param3:String = "", param4:String = "", param5:String = "", param6:String = "", param7:String = "", param8:String = "", param9:String = "", param10:String = "", param11:String = "", param12:String = "", param13:String = "", param14:String = "", param15:Boolean = false)
      {
         super();
         this.minimapScale = param1;
         this.mainmenuPosition = param2;
         this.barStatus = param3;
         this.genericFeatureMenuPosition = param4;
         this.genericFeatureMenuOrder = param5;
         this.gameFeatureMenuPosition = param6;
         this.gameFeatureMenuOrder = param7;
         this.slotmenuPosition = param8;
         this.slotMenuOrder = param9;
         this.slotmenuPremiumPosition = param10;
         this.slotMenuPremiumOrder = param11;
         this.slotmenuProActionPosition = param12;
         this.slotMenuProActionOrder = param13;
         this.stageSize = param14;
         this.hideAllWindows = param15;
      }
      
      public static function get instance() : WindowSettingsRequest
      {
         return _instance || (_instance = new WindowSettingsRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 268;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 31;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.minimapScale = param1.readInt();
         this.minimapScale = this.minimapScale << 14 % 32 | this.minimapScale >>> 32 - 14 % 32;
         this.mainmenuPosition = param1.readUTF();
         this.barStatus = param1.readUTF();
         this.genericFeatureMenuPosition = param1.readUTF();
         this.genericFeatureMenuOrder = param1.readUTF();
         this.gameFeatureMenuPosition = param1.readUTF();
         this.gameFeatureMenuOrder = param1.readUTF();
         this.slotmenuPosition = param1.readUTF();
         this.slotMenuOrder = param1.readUTF();
         this.slotmenuPremiumPosition = param1.readUTF();
         this.slotMenuPremiumOrder = param1.readUTF();
         this.slotmenuProActionPosition = param1.readUTF();
         this.slotMenuProActionOrder = param1.readUTF();
         this.stageSize = param1.readUTF();
         this.hideAllWindows = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(268);
         param1.writeInt(this.minimapScale >>> 14 % 32 | this.minimapScale << 32 - 14 % 32);
         param1.writeUTF(this.mainmenuPosition);
         param1.writeUTF(this.barStatus);
         param1.writeUTF(this.genericFeatureMenuPosition);
         param1.writeUTF(this.genericFeatureMenuOrder);
         param1.writeUTF(this.gameFeatureMenuPosition);
         param1.writeUTF(this.gameFeatureMenuOrder);
         param1.writeUTF(this.slotmenuPosition);
         param1.writeUTF(this.slotMenuOrder);
         param1.writeUTF(this.slotmenuPremiumPosition);
         param1.writeUTF(this.slotMenuPremiumOrder);
         param1.writeUTF(this.slotmenuProActionPosition);
         param1.writeUTF(this.slotMenuProActionOrder);
         param1.writeUTF(this.stageSize);
         param1.writeBoolean(this.hideAllWindows);
      }
   }
}

