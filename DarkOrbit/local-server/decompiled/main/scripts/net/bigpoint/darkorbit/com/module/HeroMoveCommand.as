package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HeroMoveCommand implements IModule
   {
      
      private static var _instance:HeroMoveCommand;
      
      public var x:int = 0;
      
      public var y:int = 0;
      
      public function HeroMoveCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.x = param1;
         this.y = param2;
      }
      
      public static function get instance() : HeroMoveCommand
      {
         return _instance || (_instance = new HeroMoveCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 29;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.x = param1.readInt();
         this.x = this.x >>> 9 % 32 | this.x << 32 - 9 % 32;
         this.y = param1.readInt();
         this.y = this.y << 7 % 32 | this.y >>> 32 - 7 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(29);
         param1.writeInt(this.x << 9 % 32 | this.x >>> 32 - 9 % 32);
         param1.writeInt(this.y >>> 7 % 32 | this.y << 32 - 7 % 32);
      }
   }
}

