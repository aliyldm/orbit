package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class FrozenLabyrinthRankModule implements IModule
   {
      
      private static var _instance:FrozenLabyrinthRankModule;
      
      public var kills:int = 0;
      
      public var name:String = "";
      
      public var rank:int = 0;
      
      public var lastKillTime:String = "";
      
      public function FrozenLabyrinthRankModule(param1:int = 0, param2:String = "", param3:String = "", param4:int = 0)
      {
         super();
         this.kills = param4;
         this.name = param2;
         this.rank = param1;
         this.lastKillTime = param3;
      }
      
      public static function get instance() : FrozenLabyrinthRankModule
      {
         return _instance || (_instance = new FrozenLabyrinthRankModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 24113;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.kills = param1.readInt();
         this.kills = this.kills << 9 % 32 | this.kills >>> 32 - 9 % 32;
         this.name = param1.readUTF();
         this.rank = param1.readInt();
         this.rank = this.rank >>> 6 % 32 | this.rank << 32 - 6 % 32;
         this.lastKillTime = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(24113);
         param1.writeInt(this.kills >>> 9 % 32 | this.kills << 32 - 9 % 32);
         param1.writeUTF(this.name);
         param1.writeInt(this.rank << 6 % 32 | this.rank >>> 32 - 6 % 32);
         param1.writeUTF(this.lastKillTime);
      }
   }
}

