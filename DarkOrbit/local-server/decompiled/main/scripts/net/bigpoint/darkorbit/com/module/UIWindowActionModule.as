package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UIWindowActionModule implements IModule
   {
      
      private static var _instance:UIWindowActionModule;
      
      public static const WINDOWACTION_SHOW_WINDOW:int = 0;
      
      public static const WINDOWACTION_HIDE_WINDOW:int = 1;
      
      public static const WINDOWACTION_MINIMIZE_WINDOW:int = 2;
      
      public static const WINDOWACTION_MAXIMIZE_WINDOW:int = 3;
      
      public static const WINDOWACTION_SHOW_WINDOW_FLASH:int = 4;
      
      public static const WINDOWACTION_HIDE_WINDOW_FLASH:int = 5;
      
      public static const WINDOWACTION_SHOW_MENU:int = 6;
      
      public static const WINDOWACTION_HIDE_MENU:int = 7;
      
      public static const WINDOWACTION__MAX:int = 8;
      
      public var windowAction:int = 0;
      
      public var windowID:WindowIDModule;
      
      public var maxFlashes:int = 0;
      
      public var showArrow:Boolean = false;
      
      public function UIWindowActionModule(param1:int = 0, param2:WindowIDModule = null, param3:int = 0, param4:Boolean = false)
      {
         super();
         this.windowAction = param1;
         if(param2 == null)
         {
            this.windowID = new WindowIDModule();
         }
         else
         {
            this.windowID = param2;
         }
         this.maxFlashes = param3;
         this.showArrow = param4;
      }
      
      public static function get instance() : UIWindowActionModule
      {
         return _instance || (_instance = new UIWindowActionModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 123;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.windowAction = param1.readShort();
         this.windowID = WindowIDModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.windowID)
         {
            this.windowID.read(param1);
         }
         this.maxFlashes = param1.readInt();
         this.maxFlashes = this.maxFlashes >>> 6 % 32 | this.maxFlashes << 32 - 6 % 32;
         this.showArrow = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(123);
         param1.writeShort(this.windowAction);
         if(null != this.windowID)
         {
            this.windowID.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.maxFlashes << 6 % 32 | this.maxFlashes >>> 32 - 6 % 32);
         param1.writeBoolean(this.showArrow);
      }
   }
}

