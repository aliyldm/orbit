package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UIButtonActionModule implements IModule
   {
      
      private static var _instance:UIButtonActionModule;
      
      public static const BUTTONACTION_SHOW_BUTTON:int = 0;
      
      public static const BUTTONACTION_HIDE_BUTTON:int = 1;
      
      public static const BUTTONACTION_SHOW_BUTTON_FLASH:int = 2;
      
      public static const BUTTONACTION_HIDE_BUTTON_FLASH:int = 3;
      
      public static const BUTTONACTION_ENABLE_MENU_BUTTON:int = 4;
      
      public static const BUTTONACTION_DISABLE_MENU_BUTTON:int = 5;
      
      public static const BUTTONACTION__MAX:int = 6;
      
      public var buttonAction:int = 0;
      
      public var buttonID:ButtonIDModule;
      
      public var maxFlashes:int = 0;
      
      public var showArrow:Boolean = false;
      
      public function UIButtonActionModule(param1:int = 0, param2:ButtonIDModule = null, param3:int = 0, param4:Boolean = false)
      {
         super();
         this.buttonAction = param1;
         if(param2 == null)
         {
            this.buttonID = new ButtonIDModule();
         }
         else
         {
            this.buttonID = param2;
         }
         this.maxFlashes = param3;
         this.showArrow = param4;
      }
      
      public static function get instance() : UIButtonActionModule
      {
         return _instance || (_instance = new UIButtonActionModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 125;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.buttonAction = param1.readShort();
         this.buttonID = ButtonIDModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.buttonID)
         {
            this.buttonID.read(param1);
         }
         this.maxFlashes = param1.readInt();
         this.maxFlashes = this.maxFlashes >>> 5 % 32 | this.maxFlashes << 32 - 5 % 32;
         this.showArrow = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(125);
         param1.writeShort(this.buttonAction);
         if(null != this.buttonID)
         {
            this.buttonID.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.maxFlashes << 5 % 32 | this.maxFlashes >>> 32 - 5 % 32);
         param1.writeBoolean(this.showArrow);
      }
   }
}

