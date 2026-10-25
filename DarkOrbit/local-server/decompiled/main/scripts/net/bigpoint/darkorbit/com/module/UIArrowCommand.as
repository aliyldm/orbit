package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UIArrowCommand implements IModule
   {
      
      private static var _instance:UIArrowCommand;
      
      public var x:int = 0;
      
      public var y:int = 0;
      
      public var show:Boolean = false;
      
      public function UIArrowCommand(param1:int = 0, param2:int = 0, param3:Boolean = false)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.show = param3;
      }
      
      public static function get instance() : UIArrowCommand
      {
         return _instance || (_instance = new UIArrowCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 120;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 9;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.x = param1.readInt();
         this.x = this.x << 16 % 32 | this.x >>> 32 - 16 % 32;
         this.y = param1.readInt();
         this.y = this.y << 2 % 32 | this.y >>> 32 - 2 % 32;
         this.show = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(120);
         param1.writeInt(this.x >>> 16 % 32 | this.x << 32 - 16 % 32);
         param1.writeInt(this.y >>> 2 % 32 | this.y << 32 - 2 % 32);
         param1.writeBoolean(this.show);
      }
   }
}

