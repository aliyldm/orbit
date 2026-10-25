package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UIWindowDestroyCommand implements IModule
   {
      
      private static var _instance:UIWindowDestroyCommand;
      
      public var windowId:int = 0;
      
      public function UIWindowDestroyCommand(param1:int = 0)
      {
         super();
         this.windowId = param1;
      }
      
      public static function get instance() : UIWindowDestroyCommand
      {
         return _instance || (_instance = new UIWindowDestroyCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 118;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.windowId = param1.readInt();
         this.windowId = this.windowId << 12 % 32 | this.windowId >>> 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(118);
         param1.writeInt(this.windowId >>> 12 % 32 | this.windowId << 32 - 12 % 32);
      }
   }
}

