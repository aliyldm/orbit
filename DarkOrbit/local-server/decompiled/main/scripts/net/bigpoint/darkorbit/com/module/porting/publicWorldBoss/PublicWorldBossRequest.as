package net.bigpoint.darkorbit.com.module.porting.publicWorldBoss
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PublicWorldBossRequest implements IModule
   {
      
      private static var _instance:PublicWorldBossRequest;
      
      public var action:int = 0;
      
      public function PublicWorldBossRequest(param1:int = 0)
      {
         super();
         this.action = param1;
      }
      
      public static function get instance() : PublicWorldBossRequest
      {
         return _instance || (_instance = new PublicWorldBossRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -23921;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.action = param1.readInt();
         this.action = this.action >>> 7 % 32 | this.action << 32 - 7 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-23921);
         param1.writeInt(this.action << 7 % 32 | this.action >>> 32 - 7 % 32);
      }
   }
}

