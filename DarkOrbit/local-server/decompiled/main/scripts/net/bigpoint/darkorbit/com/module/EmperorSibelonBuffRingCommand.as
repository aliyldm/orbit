package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EmperorSibelonBuffRingCommand implements IModule
   {
      
      private static var _instance:EmperorSibelonBuffRingCommand;
      
      public static const BUFFTYPE_DAMAGE:int = 0;
      
      public static const BUFFTYPE_SHIELD:int = 1;
      
      public static const BUFFTYPE_HEALTH:int = 2;
      
      public static const BUFFTYPE__MAX:int = 3;
      
      public var y:int = 0;
      
      public var x:int = 0;
      
      public var radius:int = 0;
      
      public var type:int = 0;
      
      public var avatarId:int = 0;
      
      public function EmperorSibelonBuffRingCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0)
      {
         super();
         this.y = param3;
         this.x = param2;
         this.radius = param5;
         this.type = param1;
         this.avatarId = param4;
      }
      
      public static function get instance() : EmperorSibelonBuffRingCommand
      {
         return _instance || (_instance = new EmperorSibelonBuffRingCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 16790;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.y = param1.readInt();
         this.y = this.y << 14 % 32 | this.y >>> 32 - 14 % 32;
         this.x = param1.readInt();
         this.x = this.x >>> 7 % 32 | this.x << 32 - 7 % 32;
         this.radius = param1.readInt();
         this.radius = this.radius << 1 % 32 | this.radius >>> 32 - 1 % 32;
         this.type = param1.readShort();
         this.avatarId = param1.readInt();
         this.avatarId = this.avatarId >>> 10 % 32 | this.avatarId << 32 - 10 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(16790);
         param1.writeInt(this.y >>> 14 % 32 | this.y << 32 - 14 % 32);
         param1.writeInt(this.x << 7 % 32 | this.x >>> 32 - 7 % 32);
         param1.writeInt(this.radius >>> 1 % 32 | this.radius << 32 - 1 % 32);
         param1.writeShort(this.type);
         param1.writeInt(this.avatarId << 10 % 32 | this.avatarId >>> 32 - 10 % 32);
      }
   }
}

