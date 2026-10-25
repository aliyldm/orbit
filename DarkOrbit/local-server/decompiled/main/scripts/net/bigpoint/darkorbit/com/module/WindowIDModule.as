package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class WindowIDModule implements IModule
   {
      
      private static var _instance:WindowIDModule;
      
      public static const WINDOWID_USER_INFO:int = 0;
      
      public static const WINDOWID_SHIP_INFO:int = 1;
      
      public static const WINDOWID_QUEST:int = 2;
      
      public static const WINDOWID_LOG:int = 3;
      
      public static const WINDOWID_MINIMAP:int = 4;
      
      public static const WINDOWID_SETTINGS:int = 5;
      
      public static const WINDOWID_HELP:int = 6;
      
      public static const WINDOWID_TRADE:int = 7;
      
      public static const WINDOWID_SPACEMAP:int = 8;
      
      public static const WINDOWID_BOOSTER:int = 9;
      
      public static const WINDOWID_SPACEBALL:int = 10;
      
      public static const WINDOWID_INVASION:int = 11;
      
      public static const WINDOWID_CTB:int = 12;
      
      public static const WINDOWID_TDM:int = 13;
      
      public static const WINDOWID_CHAT:int = 14;
      
      public static const WINDOWID_CLI:int = 15;
      
      public static const WINDOWID_GROUP:int = 16;
      
      public static const WINDOWID_REFINEMENT:int = 17;
      
      public static const WINDOWID_ACHIEVEMENTS:int = 18;
      
      public static const WINDOWID_PET:int = 19;
      
      public static const WINDOWID_VIDEO_WINDOW:int = 20;
      
      public static const WINDOWID_ASSIST_WINDOW:int = 21;
      
      public static const WINDOWID_MINIMAP_WINDOW:int = 22;
      
      public static const WINDOWID_ADVERTISEMENT:int = 23;
      
      public static const WINDOWID_MENU_MAIN:int = 24;
      
      public static const WINDOWID_MENU_QUICK:int = 25;
      
      public static const WINDOWID_MENU_TOP:int = 26;
      
      public static const WINDOWID__MAX:int = 27;
      
      public var idValue:int = 0;
      
      public function WindowIDModule(param1:int = 0)
      {
         super();
         this.idValue = param1;
      }
      
      public static function get instance() : WindowIDModule
      {
         return _instance || (_instance = new WindowIDModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 121;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.idValue = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(121);
         param1.writeShort(this.idValue);
      }
   }
}

