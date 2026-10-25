package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UIWindowSettingModule implements IModule
   {
      
      private static var _instance:UIWindowSettingModule;
      
      public var windowID:WindowIDModule;
      
      public var x:int = 0;
      
      public var y:int = 0;
      
      public var maximized:Boolean = false;
      
      public function UIWindowSettingModule(param1:WindowIDModule = null, param2:int = 0, param3:int = 0, param4:Boolean = false)
      {
         super();
         if(param1 == null)
         {
            this.windowID = new WindowIDModule();
         }
         else
         {
            this.windowID = param1;
         }
         this.x = param2;
         this.y = param3;
         this.maximized = param4;
      }
      
      public static function get instance() : UIWindowSettingModule
      {
         return _instance || (_instance = new UIWindowSettingModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 342;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 9;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.windowID = WindowIDModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.windowID)
         {
            this.windowID.read(param1);
         }
         this.x = param1.readInt();
         this.x = this.x << 1 % 32 | this.x >>> 32 - 1 % 32;
         this.y = param1.readInt();
         this.y = this.y << 6 % 32 | this.y >>> 32 - 6 % 32;
         this.maximized = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(342);
         if(null != this.windowID)
         {
            this.windowID.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.x >>> 1 % 32 | this.x << 32 - 1 % 32);
         param1.writeInt(this.y >>> 6 % 32 | this.y << 32 - 6 % 32);
         param1.writeBoolean(this.maximized);
      }
   }
}

