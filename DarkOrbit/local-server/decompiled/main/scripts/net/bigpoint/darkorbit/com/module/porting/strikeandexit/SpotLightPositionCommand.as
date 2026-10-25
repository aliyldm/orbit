package net.bigpoint.darkorbit.com.module.porting.strikeandexit
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SpotLightPositionCommand implements IModule
   {
      
      private static var _instance:SpotLightPositionCommand;
      
      public var y:int = 0;
      
      public var x:int = 0;
      
      public var id:int = 0;
      
      public function SpotLightPositionCommand(param1:int = 0, param2:int = 0, param3:int = 0)
      {
         super();
         this.y = param3;
         this.x = param2;
         this.id = param1;
      }
      
      public static function get instance() : SpotLightPositionCommand
      {
         return _instance || (_instance = new SpotLightPositionCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -8380;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.y = param1.readInt();
         this.y = this.y << 6 % 32 | this.y >>> 32 - 6 % 32;
         this.x = param1.readInt();
         this.x = this.x << 15 % 32 | this.x >>> 32 - 15 % 32;
         this.id = param1.readInt();
         this.id = this.id << 7 % 32 | this.id >>> 32 - 7 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-8380);
         param1.writeInt(this.y >>> 6 % 32 | this.y << 32 - 6 % 32);
         param1.writeInt(this.x >>> 15 % 32 | this.x << 32 - 15 % 32);
         param1.writeInt(this.id >>> 7 % 32 | this.id << 32 - 7 % 32);
      }
   }
}

