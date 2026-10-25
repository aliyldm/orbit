package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SectorControlMatchJoinRequest implements IModule
   {
      
      private static var _instance:SectorControlMatchJoinRequest;
      
      public var matchId:int = 0;
      
      public function SectorControlMatchJoinRequest(param1:int = 0)
      {
         super();
         this.matchId = param1;
      }
      
      public static function get instance() : SectorControlMatchJoinRequest
      {
         return _instance || (_instance = new SectorControlMatchJoinRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 525;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.matchId = param1.readInt();
         this.matchId = this.matchId << 10 % 32 | this.matchId >>> 32 - 10 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(525);
         param1.writeInt(this.matchId >>> 10 % 32 | this.matchId << 32 - 10 % 32);
      }
   }
}

