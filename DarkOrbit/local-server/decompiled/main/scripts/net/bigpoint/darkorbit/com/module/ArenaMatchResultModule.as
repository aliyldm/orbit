package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ArenaMatchResultModule implements IModule
   {
      
      private static var _instance:ArenaMatchResultModule;
      
      public var damageDealt:int = 0;
      
      public var damageRecieved:int = 0;
      
      public var durationInSeconds:int = 0;
      
      public var peakDamage:int = 0;
      
      public var playerName:String = "";
      
      public function ArenaMatchResultModule(param1:String = "", param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0)
      {
         super();
         this.damageDealt = param3;
         this.damageRecieved = param4;
         this.durationInSeconds = param2;
         this.peakDamage = param5;
         this.playerName = param1;
      }
      
      public static function get instance() : ArenaMatchResultModule
      {
         return _instance || (_instance = new ArenaMatchResultModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -18251;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 18;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.damageDealt = param1.readInt();
         this.damageDealt = this.damageDealt >>> 12 % 32 | this.damageDealt << 32 - 12 % 32;
         this.damageRecieved = param1.readInt();
         this.damageRecieved = this.damageRecieved << 10 % 32 | this.damageRecieved >>> 32 - 10 % 32;
         this.durationInSeconds = param1.readInt();
         this.durationInSeconds = this.durationInSeconds << 7 % 32 | this.durationInSeconds >>> 32 - 7 % 32;
         this.peakDamage = param1.readInt();
         this.peakDamage = this.peakDamage << 13 % 32 | this.peakDamage >>> 32 - 13 % 32;
         this.playerName = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-18251);
         param1.writeInt(this.damageDealt << 12 % 32 | this.damageDealt >>> 32 - 12 % 32);
         param1.writeInt(this.damageRecieved >>> 10 % 32 | this.damageRecieved << 32 - 10 % 32);
         param1.writeInt(this.durationInSeconds >>> 7 % 32 | this.durationInSeconds << 32 - 7 % 32);
         param1.writeInt(this.peakDamage >>> 13 % 32 | this.peakDamage << 32 - 13 % 32);
         param1.writeUTF(this.playerName);
      }
   }
}

