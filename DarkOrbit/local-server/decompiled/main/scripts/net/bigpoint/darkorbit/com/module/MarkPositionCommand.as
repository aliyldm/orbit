package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MarkPositionCommand implements IModule
   {
      
      private static var _instance:MarkPositionCommand;
      
      public var color:int = 0;
      
      public var x:int = 0;
      
      public var y:int = 0;
      
      public var durationMillis:int = 0;
      
      public function MarkPositionCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0)
      {
         super();
         this.color = param3;
         this.x = param1;
         this.y = param2;
         this.durationMillis = param4;
      }
      
      public static function get instance() : MarkPositionCommand
      {
         return _instance || (_instance = new MarkPositionCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 18323;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.color = param1.readInt();
         this.color = this.color >>> 8 % 32 | this.color << 32 - 8 % 32;
         this.x = param1.readInt();
         this.x = this.x << 12 % 32 | this.x >>> 32 - 12 % 32;
         this.y = param1.readInt();
         this.y = this.y << 14 % 32 | this.y >>> 32 - 14 % 32;
         this.durationMillis = param1.readInt();
         this.durationMillis = this.durationMillis >>> 8 % 32 | this.durationMillis << 32 - 8 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(18323);
         param1.writeInt(this.color << 8 % 32 | this.color >>> 32 - 8 % 32);
         param1.writeInt(this.x >>> 12 % 32 | this.x << 32 - 12 % 32);
         param1.writeInt(this.y >>> 14 % 32 | this.y << 32 - 14 % 32);
         param1.writeInt(this.durationMillis << 8 % 32 | this.durationMillis >>> 32 - 8 % 32);
      }
   }
}

