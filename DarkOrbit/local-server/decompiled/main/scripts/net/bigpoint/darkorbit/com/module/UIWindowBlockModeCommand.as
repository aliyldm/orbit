package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UIWindowBlockModeCommand implements IModule
   {
      
      private static var _instance:UIWindowBlockModeCommand;
      
      public var windowId:WindowIDModule;
      
      public var blockWindow:Boolean = false;
      
      public function UIWindowBlockModeCommand(param1:WindowIDModule = null, param2:Boolean = false)
      {
         super();
         if(param1 == null)
         {
            this.windowId = new WindowIDModule();
         }
         else
         {
            this.windowId = param1;
         }
         this.blockWindow = param2;
      }
      
      public static function get instance() : UIWindowBlockModeCommand
      {
         return _instance || (_instance = new UIWindowBlockModeCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 240;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.windowId = WindowIDModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.windowId)
         {
            this.windowId.read(param1);
         }
         this.blockWindow = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(240);
         if(null != this.windowId)
         {
            this.windowId.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeBoolean(this.blockWindow);
      }
   }
}

