package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EternalGateRankModule implements IModule
   {
      
      private static var _instance:EternalGateRankModule;
      
      public var name:String = "";
      
      public var lastUpdateTime:String = "";
      
      public var rank:int = 0;
      
      public var waves:int = 0;
      
      public function EternalGateRankModule(param1:int = 0, param2:String = "", param3:String = "", param4:int = 0)
      {
         super();
         this.name = param2;
         this.lastUpdateTime = param3;
         this.rank = param1;
         this.waves = param4;
      }
      
      public static function get instance() : EternalGateRankModule
      {
         return _instance || (_instance = new EternalGateRankModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 25218;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.name = param1.readUTF();
         this.lastUpdateTime = param1.readUTF();
         this.rank = param1.readInt();
         this.rank = this.rank >>> 14 % 32 | this.rank << 32 - 14 % 32;
         this.waves = param1.readInt();
         this.waves = this.waves >>> 2 % 32 | this.waves << 32 - 2 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(25218);
         param1.writeUTF(this.name);
         param1.writeUTF(this.lastUpdateTime);
         param1.writeInt(this.rank << 14 % 32 | this.rank >>> 32 - 14 % 32);
         param1.writeInt(this.waves << 2 % 32 | this.waves >>> 32 - 2 % 32);
      }
   }
}

